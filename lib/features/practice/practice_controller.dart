import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/generators/catalog.dart';
import '../../domain/generators/question.dart';
import '../../domain/knowledge/models.dart';
import '../../domain/mastery.dart';
import '../../domain/wrong_book.dart';
import '../../providers.dart';

enum PracticePhase { answering, wrong, solution, finished }

class PracticeArgs {
  const PracticeArgs({
    required this.mode,
    this.nodeId,
    this.difficulty,
  });

  final PracticeMode mode;
  final String? nodeId;
  final Difficulty? difficulty;
}

class PracticeItem {
  PracticeItem({
    required this.question,
    this.wrongItemId,
  });

  final GeneratedQuestion question;
  final int? wrongItemId;
}

class PracticeSession {
  PracticeSession({
    required this.args,
    required this.sessionId,
    required this.items,
    this.index = 0,
    this.correctCount = 0,
    this.consecutiveCorrect = 0,
    this.showFluentTip = false,
    this.phase = PracticePhase.answering,
    this.hintsShown = 0,
    this.lastAnswer = '',
    this.lastCorrect = false,
    this.lastAttemptId,
    this.lastWrongItemId,
    this.lastAttribution,
    this.newlyUnlocked = const [],
    this.newlyMastered = false,
    this.selectedCause,
  });

  final PracticeArgs args;
  final String sessionId;
  final List<PracticeItem> items;
  final int index;
  final int correctCount;
  final int consecutiveCorrect;
  final bool showFluentTip;
  final PracticePhase phase;
  final int hintsShown;
  final String lastAnswer;
  final bool lastCorrect;
  final int? lastAttemptId;
  final int? lastWrongItemId;
  final AttributionResult? lastAttribution;
  final List<KnowledgeNode> newlyUnlocked;
  final bool newlyMastered;
  final ErrorCause? selectedCause;

  GeneratedQuestion get current => items[index].question;
  int get total => items.length;
  bool get isLast => index >= items.length - 1;
  double get accuracy => total == 0 ? 0 : correctCount / (index + (phase == PracticePhase.answering ? 0 : 1)).clamp(1, 999);

  PracticeSession copyWith({
    int? index,
    int? correctCount,
    int? consecutiveCorrect,
    bool? showFluentTip,
    PracticePhase? phase,
    int? hintsShown,
    String? lastAnswer,
    bool? lastCorrect,
    int? lastAttemptId,
    int? lastWrongItemId,
    AttributionResult? lastAttribution,
    List<KnowledgeNode>? newlyUnlocked,
    bool? newlyMastered,
    ErrorCause? selectedCause,
    bool clearCause = false,
  }) {
    return PracticeSession(
      args: args,
      sessionId: sessionId,
      items: items,
      index: index ?? this.index,
      correctCount: correctCount ?? this.correctCount,
      consecutiveCorrect: consecutiveCorrect ?? this.consecutiveCorrect,
      showFluentTip: showFluentTip ?? this.showFluentTip,
      phase: phase ?? this.phase,
      hintsShown: hintsShown ?? this.hintsShown,
      lastAnswer: lastAnswer ?? this.lastAnswer,
      lastCorrect: lastCorrect ?? this.lastCorrect,
      lastAttemptId: lastAttemptId ?? this.lastAttemptId,
      lastWrongItemId: lastWrongItemId ?? this.lastWrongItemId,
      lastAttribution: lastAttribution ?? this.lastAttribution,
      newlyUnlocked: newlyUnlocked ?? this.newlyUnlocked,
      newlyMastered: newlyMastered ?? this.newlyMastered,
      selectedCause: clearCause ? null : (selectedCause ?? this.selectedCause),
    );
  }
}

class PracticeNotifier extends Notifier<PracticeSession?> {
  @override
  PracticeSession? build() => null;

  Future<String?> start(PracticeArgs args) async {
    final repo = await ref.read(repositoryProvider.future);
    final profile = await ref.read(profileProvider.future);
    if (profile == null) return '请先创建档案';

    final sessionId = DateTime.now().microsecondsSinceEpoch.toString();
    final rng = Random(DateTime.now().millisecondsSinceEpoch);
    final items = <PracticeItem>[];

    if (args.mode == PracticeMode.redo) {
      final wrongs = await repo.listWrongItems(profileId: profile.id);
      if (wrongs.isEmpty) return '错题本是空的';
      wrongs.shuffle(rng);
      for (final item in wrongs.take(5)) {
        items.add(PracticeItem(question: repo.reproduce(item), wrongItemId: item.id));
      }
    } else {
      final nodeId = args.nodeId;
      if (nodeId == null) return '未指定知识节点';
      final node = repo.graph.nodeById(nodeId);
      if (!node.practiceReady) return '该节点本期尚未开放练习';
      if (args.mode == PracticeMode.challenge) {
        for (final q in questionEngine.challengeSet(
          nodeId: nodeId,
          count: MasteryRules.challengeSize,
          rng: rng,
        )) {
          items.add(PracticeItem(question: q));
        }
      } else {
        final difficulty = args.difficulty ?? Difficulty.basic;
        for (var i = 0; i < 10; i++) {
          items.add(
            PracticeItem(
              question: questionEngine.randomForNode(
                nodeId: nodeId,
                difficulty: difficulty,
                rng: rng,
              ),
            ),
          );
        }
      }
    }

    state = PracticeSession(args: args, sessionId: sessionId, items: items);
    return null;
  }

  Future<void> submit(String raw) async {
    final session = state;
    if (session == null || session.phase != PracticePhase.answering) return;
    final answer = raw.trim();
    if (answer.isEmpty) return;
    final question = session.current;
    final ok = question.check(answer);
    final repo = await ref.read(repositoryProvider.future);
    final profile = await ref.read(profileProvider.future);
    if (profile == null) return;

    final isLast = session.isLast;
    final correctCount = session.correctCount + (ok ? 1 : 0);
    final shouldMaster = session.args.mode == PracticeMode.challenge && isLast;

    final recorded = await repo.recordAttempt(
      profileId: profile.id,
      question: question,
      userAnswer: answer,
      isCorrect: ok,
      hintsUsed: session.hintsShown,
      mode: session.args.mode,
      sessionId: session.sessionId,
      markChallengeMastered: shouldMaster,
      challengeCorrect: correctCount,
      challengeTotal: session.total,
    );

    if (ok && session.args.mode == PracticeMode.redo) {
      final redoId = session.items[session.index].wrongItemId;
      if (redoId != null) await repo.digestWrong(redoId);
    }

    var newlyUnlocked = <KnowledgeNode>[];
    var newlyMastered = false;
    if (shouldMaster &&
        MasteryRules.challengePassed(correct: correctCount, total: session.total)) {
      newlyMastered = true;
      final before = await ref.read(graphViewProvider.future);
      ref.invalidate(graphViewProvider);
      final after = await ref.read(graphViewProvider.future);
      newlyUnlocked = after.graph.nodes
          .where((n) => after.unlocked.contains(n.id) && !before.unlocked.contains(n.id))
          .toList();
    }

    ref.invalidate(wrongOpenCountProvider);
    ref.invalidate(totalAttemptsProvider);

    final consecutive = ok ? session.consecutiveCorrect + 1 : 0;
    state = session.copyWith(
      correctCount: correctCount,
      consecutiveCorrect: consecutive,
      showFluentTip:
          session.args.mode == PracticeMode.special &&
          consecutive >= MasteryRules.consecutiveFluent,
      phase: ok
          ? (isLast ? PracticePhase.finished : PracticePhase.answering)
          : PracticePhase.wrong,
      hintsShown: ok ? 0 : 1,
      lastAnswer: answer,
      lastCorrect: ok,
      lastAttemptId: recorded.attemptId,
      lastWrongItemId: recorded.wrongItemId,
      lastAttribution: recorded.attribution,
      newlyUnlocked: newlyUnlocked,
      newlyMastered: newlyMastered,
      clearCause: true,
      index: ok && !isLast ? session.index + 1 : session.index,
    );
  }

  void moreHint() {
    final session = state;
    if (session == null) return;
    final max = session.current.hints.length;
    if (session.hintsShown >= max) {
      state = session.copyWith(phase: PracticePhase.solution);
      return;
    }
    state = session.copyWith(hintsShown: session.hintsShown + 1);
  }

  void showSolution() {
    final session = state;
    if (session == null) return;
    state = session.copyWith(
      phase: PracticePhase.solution,
      hintsShown: session.current.hints.length,
    );
  }

  Future<void> chooseCause(ErrorCause cause) async {
    final session = state;
    if (session == null || session.lastAttemptId == null) return;
    final repo = await ref.read(repositoryProvider.future);
    final node = repo.graph.nodeById(session.current.nodeId);
    final acc = (await ref.read(graphViewProvider.future)).progress;
    final attribution = WrongBookRules.attribute(
      AttributionInput(
        nodeId: session.current.nodeId,
        prerequisites: node.prerequisites,
        correctAnswer: session.current.answer,
        userAnswer: session.lastAnswer,
        nodeAccuracy: acc[session.current.nodeId]?.accuracy ?? 0,
        prereqAccuracy: {
          for (final p in node.prerequisites) p: acc[p]?.accuracy ?? 1,
        },
        userCause: cause,
      ),
    );
    await repo.updateWrongCause(
      attemptId: session.lastAttemptId!,
      wrongItemId: session.lastWrongItemId,
      attribution: attribution,
    );
    state = session.copyWith(selectedCause: cause, lastAttribution: attribution);
    ref.invalidate(wrongOpenCountProvider);
  }

  Future<void> nextAfterWrong() async {
    final session = state;
    if (session == null) return;
    if (session.isLast) {
      var newlyUnlocked = <KnowledgeNode>[];
      var newlyMastered = false;
      if (session.args.mode == PracticeMode.challenge) {
        final repo = await ref.read(repositoryProvider.future);
        final profile = await ref.read(profileProvider.future);
        if (profile != null) {
          final before = await repo.loadGraph(profile.id);
          final passed = MasteryRules.challengePassed(
            correct: session.correctCount,
            total: session.total,
          );
          if (passed && !before.mastered.contains(session.current.nodeId)) {
            // already marked in submit if last was correct; if last was wrong,
            // recordAttempt on last item already evaluated shouldMaster.
          }
          ref.invalidate(graphViewProvider);
          final after = await ref.read(graphViewProvider.future);
          newlyUnlocked = after.graph.nodes
              .where((n) => after.unlocked.contains(n.id) && !before.unlocked.contains(n.id))
              .toList();
          newlyMastered = after.mastered.contains(session.args.nodeId);
        }
      }
      state = session.copyWith(
        phase: PracticePhase.finished,
        newlyUnlocked: newlyUnlocked,
        newlyMastered: newlyMastered,
      );
      return;
    }
    state = session.copyWith(
      index: session.index + 1,
      phase: PracticePhase.answering,
      hintsShown: 0,
      lastAnswer: '',
      lastCorrect: false,
      clearCause: true,
    );
  }
}

final practiceProvider = NotifierProvider<PracticeNotifier, PracticeSession?>(
  PracticeNotifier.new,
);
