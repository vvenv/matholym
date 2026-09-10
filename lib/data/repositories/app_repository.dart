import 'package:drift/drift.dart';

import '../../domain/generators/catalog.dart';
import '../../domain/generators/question.dart';
import '../../domain/knowledge/models.dart';
import '../../domain/mastery.dart';
import '../../domain/wrong_book.dart';
import '../db/app_database.dart';
import '../seeds/seed_store.dart';

class WrongItemView {
  const WrongItemView({
    required this.id,
    required this.nodeId,
    required this.attributedNodeId,
    required this.cause,
    required this.stem,
    required this.answer,
    required this.templateId,
    required this.seed,
    required this.digested,
    required this.createdAt,
  });

  final int id;
  final String nodeId;
  final String attributedNodeId;
  final ErrorCause cause;
  final String stem;
  final String answer;
  final String templateId;
  final int seed;
  final bool digested;
  final DateTime createdAt;
}

class RecordedAttempt {
  const RecordedAttempt({
    required this.attemptId,
    required this.wrongItemId,
    required this.attribution,
  });

  final int attemptId;
  final int? wrongItemId;
  final AttributionResult attribution;
}

class AppRepository {
  AppRepository(this.db, this.seeds);

  final AppDatabase db;
  final SeedStore seeds;

  KnowledgeGraph get graph => seeds.graph;

  Future<Profile?> currentProfile() {
    return (db.select(db.profiles)..limit(1)).getSingleOrNull();
  }

  Future<Profile> createProfile({
    required String nickname,
    required StudentStage stage,
  }) async {
    final id = await db.into(db.profiles).insert(
      ProfilesCompanion.insert(
        nickname: nickname.trim(),
        stage: stage.name,
        createdAt: DateTime.now(),
      ),
    );
    await _seedProgress(id);
    return (db.select(db.profiles)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> _seedProgress(int profileId) async {
    final now = DateTime.now();
    await db.batch((batch) {
      for (final node in graph.nodes) {
        final unlocked = node.id == graph.rootId;
        batch.insert(
          db.nodeProgressRows,
          NodeProgressRowsCompanion.insert(
            profileId: profileId,
            nodeId: node.id,
            unlocked: unlocked,
            unlockedAt: unlocked ? Value(now) : const Value.absent(),
          ),
        );
      }
    });
  }

  Future<void> resetProgress(int profileId) async {
    await (db.delete(db.attempts)..where((t) => t.profileId.equals(profileId))).go();
    await (db.delete(db.wrongItems)..where((t) => t.profileId.equals(profileId))).go();
    await (db.delete(db.nodeProgressRows)..where((t) => t.profileId.equals(profileId))).go();
    await _seedProgress(profileId);
  }

  Future<void> deleteProfile() async {
    await db.delete(db.wrongItems).go();
    await db.delete(db.attempts).go();
    await db.delete(db.nodeProgressRows).go();
    await db.delete(db.profiles).go();
  }

  Future<GraphView> loadGraph(int profileId) async {
    await _recomputeUnlocks(profileId);
    final rows = await (db.select(db.nodeProgressRows)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
    final progress = <String, NodeProgressSnapshot>{};
    final mastered = <String>{};
    final unlocked = <String>{};
    for (final row in rows) {
      progress[row.nodeId] = NodeProgressSnapshot(
        nodeId: row.nodeId,
        unlocked: row.unlocked,
        mastered: row.mastered,
        attempts: row.attempts,
        correct: row.correctCount,
        consecutive: row.consecutive,
      );
      if (row.mastered) mastered.add(row.nodeId);
      if (row.unlocked) unlocked.add(row.nodeId);
    }
    return GraphView(
      graph: graph,
      unlocked: unlocked,
      mastered: mastered,
      progress: progress,
    );
  }

  Future<Set<String>> _recomputeUnlocks(int profileId) async {
    final rows = await (db.select(db.nodeProgressRows)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
    final mastered = {
      for (final row in rows)
        if (row.mastered) row.nodeId,
    };
    final unlocked = MasteryRules.unlockedIds(graph: graph, masteredIds: mastered);
    final now = DateTime.now();
    for (final row in rows) {
      final should = unlocked.contains(row.nodeId);
      if (row.unlocked != should) {
        await (db.update(db.nodeProgressRows)..where(
          (t) => t.profileId.equals(profileId) & t.nodeId.equals(row.nodeId),
        )).write(
          NodeProgressRowsCompanion(
            unlocked: Value(should),
            unlockedAt: should ? Value(now) : const Value(null),
          ),
        );
      }
    }
    return unlocked;
  }

  Future<RecordedAttempt> recordAttempt({
    required int profileId,
    required GeneratedQuestion question,
    required String userAnswer,
    required bool isCorrect,
    required int hintsUsed,
    required PracticeMode mode,
    required String sessionId,
    ErrorCause? userCause,
    bool markChallengeMastered = false,
    int challengeCorrect = 0,
    int challengeTotal = 0,
  }) async {
    final node = graph.nodeById(question.nodeId);
    final accMap = await _accuracyMap(profileId);
    final attribution = isCorrect
        ? AttributionResult(cause: ErrorCause.calculation, attributedNodeId: question.nodeId)
        : WrongBookRules.attribute(
            AttributionInput(
              nodeId: question.nodeId,
              prerequisites: node.prerequisites,
              correctAnswer: question.answer,
              userAnswer: userAnswer,
              nodeAccuracy: accMap[question.nodeId] ?? 0,
              prereqAccuracy: {
                for (final p in node.prerequisites) p: accMap[p] ?? 1,
              },
              userCause: userCause,
            ),
          );

    final attemptId = await db.into(db.attempts).insert(
      AttemptsCompanion.insert(
        profileId: profileId,
        nodeId: question.nodeId,
        templateId: question.templateId,
        seed: question.seed,
        userAnswer: userAnswer,
        isCorrect: isCorrect,
        hintsUsed: hintsUsed,
        errorCause: Value(isCorrect ? null : attribution.cause.name),
        attributedNodeId: Value(isCorrect ? null : attribution.attributedNodeId),
        sessionId: sessionId,
        mode: mode.name,
        createdAt: DateTime.now(),
      ),
    );

    final row = await (db.select(db.nodeProgressRows)..where(
      (t) => t.profileId.equals(profileId) & t.nodeId.equals(question.nodeId),
    )).getSingle();
    final consecutive = isCorrect ? row.consecutive + 1 : 0;
    await (db.update(db.nodeProgressRows)..where(
      (t) => t.profileId.equals(profileId) & t.nodeId.equals(question.nodeId),
    )).write(
      NodeProgressRowsCompanion(
        attempts: Value(row.attempts + 1),
        correctCount: Value(row.correctCount + (isCorrect ? 1 : 0)),
        consecutive: Value(consecutive),
      ),
    );

    int? wrongId;
    if (!isCorrect) {
      wrongId = await db.into(db.wrongItems).insert(
        WrongItemsCompanion.insert(
          attemptId: attemptId,
          profileId: profileId,
          nodeId: question.nodeId,
          attributedNodeId: attribution.attributedNodeId,
          errorCause: attribution.cause.name,
          snapshotStem: question.stem,
          snapshotAnswer: question.answer,
          templateId: question.templateId,
          seed: question.seed,
          createdAt: DateTime.now(),
        ),
      );
    }

    if (markChallengeMastered &&
        MasteryRules.challengePassed(
          correct: challengeCorrect,
          total: challengeTotal,
        )) {
      await _markMastered(profileId, question.nodeId);
    }

    return RecordedAttempt(
      attemptId: attemptId,
      wrongItemId: wrongId,
      attribution: attribution,
    );
  }

  Future<void> _markMastered(int profileId, String nodeId) async {
    await (db.update(db.nodeProgressRows)..where(
      (t) => t.profileId.equals(profileId) & t.nodeId.equals(nodeId),
    )).write(
      NodeProgressRowsCompanion(
        mastered: const Value(true),
        masteredAt: Value(DateTime.now()),
      ),
    );
    await _recomputeUnlocks(profileId);
  }

  Future<void> updateWrongCause({
    required int attemptId,
    required int? wrongItemId,
    required AttributionResult attribution,
  }) async {
    await (db.update(db.attempts)..where((t) => t.id.equals(attemptId))).write(
      AttemptsCompanion(
        errorCause: Value(attribution.cause.name),
        attributedNodeId: Value(attribution.attributedNodeId),
      ),
    );
    if (wrongItemId != null) {
      await (db.update(db.wrongItems)..where((t) => t.id.equals(wrongItemId))).write(
        WrongItemsCompanion(
          errorCause: Value(attribution.cause.name),
          attributedNodeId: Value(attribution.attributedNodeId),
        ),
      );
    }
  }

  Future<void> digestWrong(int id) async {
    await (db.update(db.wrongItems)..where((t) => t.id.equals(id))).write(
      const WrongItemsCompanion(digested: Value(true)),
    );
  }

  Future<List<WrongItemView>> listWrongItems({
    required int profileId,
    String? nodeId,
    ErrorCause? cause,
    bool onlyOpen = true,
  }) async {
    final query = db.select(db.wrongItems)
      ..where((t) => t.profileId.equals(profileId))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    if (onlyOpen) {
      query.where((t) => t.digested.equals(false));
    }
    if (nodeId != null) {
      query.where((t) => t.nodeId.equals(nodeId) | t.attributedNodeId.equals(nodeId));
    }
    if (cause != null) {
      query.where((t) => t.errorCause.equals(cause.name));
    }
    final rows = await query.get();
    return [
      for (final row in rows)
        WrongItemView(
          id: row.id,
          nodeId: row.nodeId,
          attributedNodeId: row.attributedNodeId,
          cause: ErrorCause.parse(row.errorCause),
          stem: row.snapshotStem,
          answer: row.snapshotAnswer,
          templateId: row.templateId,
          seed: row.seed,
          digested: row.digested,
          createdAt: row.createdAt,
        ),
    ];
  }

  Future<int> openWrongCount(int profileId) async {
    final count = db.wrongItems.id.count();
    final query = db.selectOnly(db.wrongItems)
      ..addColumns([count])
      ..where(
        db.wrongItems.profileId.equals(profileId) &
            db.wrongItems.digested.equals(false),
      );
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<int> totalAttempts(int profileId) async {
    final count = db.attempts.id.count();
    final query = db.selectOnly(db.attempts)
      ..addColumns([count])
      ..where(db.attempts.profileId.equals(profileId));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<Map<String, double>> _accuracyMap(int profileId) async {
    final rows = await (db.select(db.nodeProgressRows)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
    return {
      for (final row in rows)
        row.nodeId: MasteryRules.accuracy(row.correctCount, row.attempts),
    };
  }

  GeneratedQuestion reproduce(WrongItemView item) {
    return questionEngine.generate(
      templateId: item.templateId,
      seed: item.seed,
    );
  }
}
