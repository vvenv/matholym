import 'package:drift/drift.dart';

import '../../domain/generators/catalog.dart';
import '../../domain/generators/question.dart';
import '../../domain/knowledge/models.dart';
import '../../domain/mastery.dart';
import '../../domain/wrong_book.dart';
import '../db/app_database.dart';
import '../seeds/seed_store.dart';

/// One open wrong item, as the wrong book shows it. The row keeps more (the
/// cause it was filed under, whether it is digested); this is what is read.
class WrongItemView {
  const WrongItemView({
    required this.id,
    required this.nodeId,
    required this.attributedNodeId,
    required this.stem,
    required this.answer,
    required this.templateId,
    required this.seed,
    required this.createdAt,
  });

  final int id;
  final String nodeId;

  /// The node to review: the prerequisite blamed for the miss, or the node
  /// itself when the miss was in the work rather than the idea.
  final String attributedNodeId;
  final String stem;
  final String answer;
  final String templateId;
  final int seed;
  final DateTime createdAt;
}

class AppRepository {
  AppRepository(this.db, this.seeds);

  final AppDatabase db;
  final SeedStore seeds;

  KnowledgeGraph get graph => seeds.graph;

  KnowledgeGraph graphFor(String areaId) => seeds.graphFor(areaId);

  KnowledgeNode nodeById(String id) => seeds.nodeById(id);

  Future<Profile?> currentProfile() {
    return (db.select(db.profiles)..limit(1)).getSingleOrNull();
  }

  Future<Profile> createProfile({
    required String nickname,
    required StudentStage stage,
  }) async {
    final id = await db
        .into(db.profiles)
        .insert(
          ProfilesCompanion.insert(
            nickname: nickname.trim(),
            stage: stage.name,
            createdAt: DateTime.now(),
          ),
        );
    await _seedProgress(id);
    return (db.select(db.profiles)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> _seedProgress(int profileId) => _ensureProgress(profileId);

  Future<void> _ensureProgress(int profileId) async {
    final rows = await (db.select(
      db.nodeProgressRows,
    )..where((t) => t.profileId.equals(profileId))).get();
    final have = {for (final row in rows) row.nodeId};
    final now = DateTime.now();
    final missing = <NodeProgressRowsCompanion>[];
    for (final graph in seeds.graphs.values) {
      for (final node in graph.nodes) {
        if (have.contains(node.id)) continue;
        missing.add(
          NodeProgressRowsCompanion.insert(
            profileId: profileId,
            nodeId: node.id,
            // Schema v1 columns. Every node is open, so nothing reads them.
            unlocked: true,
            unlockedAt: Value(now),
          ),
        );
      }
    }
    if (missing.isEmpty) return;
    await db.batch((batch) {
      for (final row in missing) {
        batch.insert(db.nodeProgressRows, row);
      }
    });
  }

  Future<void> resetProgress(int profileId) async {
    await (db.delete(
      db.attempts,
    )..where((t) => t.profileId.equals(profileId))).go();
    await (db.delete(
      db.wrongItems,
    )..where((t) => t.profileId.equals(profileId))).go();
    await (db.delete(
      db.nodeProgressRows,
    )..where((t) => t.profileId.equals(profileId))).go();
    await _seedProgress(profileId);
  }

  Future<void> deleteProfile() async {
    await db.delete(db.wrongItems).go();
    await db.delete(db.attempts).go();
    await db.delete(db.nodeProgressRows).go();
    await db.delete(db.profiles).go();
  }

  Future<GraphView> loadGraph(int profileId, {String? areaId}) async {
    await _ensureProgress(profileId);
    final rows = await (db.select(
      db.nodeProgressRows,
    )..where((t) => t.profileId.equals(profileId))).get();
    final current = areaId == null ? graph : graphFor(areaId);
    final nodeIds = {for (final node in current.nodes) node.id};
    final progress = <String, NodeProgressSnapshot>{};
    final mastered = <String>{};
    for (final row in rows) {
      if (!nodeIds.contains(row.nodeId)) continue;
      progress[row.nodeId] = NodeProgressSnapshot(
        nodeId: row.nodeId,
        mastered: row.mastered,
        attempts: row.attempts,
        correct: row.correctCount,
        consecutive: row.consecutive,
      );
      if (row.mastered) mastered.add(row.nodeId);
    }
    return GraphView(graph: current, mastered: mastered, progress: progress);
  }

  Future<void> recordAttempt({
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
    final node = nodeById(question.nodeId);
    final accMap = await _accuracyMap(profileId);
    final attribution = isCorrect
        ? AttributionResult(
            cause: ErrorCause.calculation,
            attributedNodeId: question.nodeId,
          )
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

    final attemptId = await db
        .into(db.attempts)
        .insert(
          AttemptsCompanion.insert(
            profileId: profileId,
            nodeId: question.nodeId,
            templateId: question.templateId,
            seed: question.seed,
            userAnswer: userAnswer,
            isCorrect: isCorrect,
            hintsUsed: hintsUsed,
            errorCause: Value(isCorrect ? null : attribution.cause.name),
            attributedNodeId: Value(
              isCorrect ? null : attribution.attributedNodeId,
            ),
            sessionId: sessionId,
            mode: mode.name,
            createdAt: DateTime.now(),
          ),
        );

    final row =
        await (db.select(db.nodeProgressRows)..where(
              (t) =>
                  t.profileId.equals(profileId) &
                  t.nodeId.equals(question.nodeId),
            ))
            .getSingle();
    final consecutive = isCorrect ? row.consecutive + 1 : 0;
    await (db.update(db.nodeProgressRows)..where(
          (t) =>
              t.profileId.equals(profileId) & t.nodeId.equals(question.nodeId),
        ))
        .write(
          NodeProgressRowsCompanion(
            attempts: Value(row.attempts + 1),
            correctCount: Value(row.correctCount + (isCorrect ? 1 : 0)),
            consecutive: Value(consecutive),
          ),
        );

    if (!isCorrect) {
      await db
          .into(db.wrongItems)
          .insert(
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
  }

  Future<void> _markMastered(int profileId, String nodeId) async {
    await (db.update(db.nodeProgressRows)..where(
          (t) => t.profileId.equals(profileId) & t.nodeId.equals(nodeId),
        ))
        .write(
          NodeProgressRowsCompanion(
            mastered: const Value(true),
            masteredAt: Value(DateTime.now()),
          ),
        );
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
      query.where(
        (t) => t.nodeId.equals(nodeId) | t.attributedNodeId.equals(nodeId),
      );
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
          stem: row.snapshotStem,
          answer: row.snapshotAnswer,
          templateId: row.templateId,
          seed: row.seed,
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
    final rows = await (db.select(
      db.nodeProgressRows,
    )..where((t) => t.profileId.equals(profileId))).get();
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
