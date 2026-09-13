import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/generators/catalog.dart';
import '../../domain/generators/choices.dart';
import '../../domain/generators/question.dart';
import '../../domain/mastery.dart';
import '../../providers.dart';

enum PracticePhase { answering, wrong, solution, finished }

/// Wrong items drawn into one redo session.
const kRedoBatch = 5;

class PracticeArgs {
  const PracticeArgs({required this.mode, this.nodeId, this.difficulty});

  final PracticeMode mode;
  final String? nodeId;
  final Difficulty? difficulty;
}

class PracticeItem {
  PracticeItem({required this.question, this.wrongItemId});

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
    this.phase = PracticePhase.answering,
    this.hintsShown = 0,
    this.results = const [],
    this.tried = const [],
    this.recovered = false,
  });

  final PracticeArgs args;
  final String sessionId;
  final List<PracticeItem> items;
  final int index;
  final int correctCount;
  final PracticePhase phase;
  final int hintsShown;

  /// First-pick correctness of each question answered so far.
  final List<bool> results;

  /// Wrong picks on the current question, first attempt included.
  final List<String> tried;

  /// The retry after a miss landed on the answer.
  final bool recovered;

  GeneratedQuestion get current => items[index].question;
  int get total => items.length;
  bool get isLast => index >= items.length - 1;

  PracticeSession copyWith({
    int? index,
    int? correctCount,
    PracticePhase? phase,
    int? hintsShown,
    List<bool>? results,
    List<String>? tried,
    bool? recovered,
  }) {
    return PracticeSession(
      args: args,
      sessionId: sessionId,
      items: items,
      index: index ?? this.index,
      correctCount: correctCount ?? this.correctCount,
      phase: phase ?? this.phase,
      hintsShown: hintsShown ?? this.hintsShown,
      results: results ?? this.results,
      tried: tried ?? this.tried,
      recovered: recovered ?? this.recovered,
    );
  }
}

class PracticeNotifier extends Notifier<PracticeSession?> {
  /// Submit and advance await the database; a second tap or keypress in that
  /// window would record the same question twice or skip one.
  var _busy = false;

  @override
  PracticeSession? build() => null;

  Future<void> _guard(Future<void> Function() body) async {
    if (_busy) return;
    _busy = true;
    try {
      await body();
    } finally {
      _busy = false;
    }
  }

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
      for (final item in wrongs.take(kRedoBatch)) {
        items.add(
          PracticeItem(question: repo.reproduce(item), wrongItemId: item.id),
        );
      }
    } else {
      final nodeId = args.nodeId;
      if (nodeId == null) return '未指定知识节点';
      final node = repo.nodeById(nodeId);
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
        for (final q in questionEngine.drillSet(
          nodeId: nodeId,
          count: MasteryRules.drillSize,
          difficulty: args.difficulty ?? Difficulty.basic,
          rng: rng,
        )) {
          items.add(PracticeItem(question: q));
        }
      }
    }

    state = PracticeSession(args: args, sessionId: sessionId, items: items);
    return null;
  }

  Future<void> submit(String raw) => _guard(() => _submit(raw));

  Future<void> _submit(String raw) async {
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

    await repo.recordAttempt(
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

    // The mastery mark and per-node accuracy both live on the tree.
    if (shouldMaster || (ok && isLast)) ref.invalidate(areaViewProvider);
    ref.invalidate(wrongOpenCountProvider);

    final canRetry = QuestionOptions.of(question).length > 2;
    state = session.copyWith(
      correctCount: correctCount,
      // With one option left (是/否) a retry is a giveaway; open the solution.
      phase: ok
          ? (isLast ? PracticePhase.finished : PracticePhase.answering)
          : canRetry
          ? PracticePhase.wrong
          : PracticePhase.solution,
      hintsShown: ok ? 0 : (canRetry ? 1 : question.hints.length),
      index: ok && !isLast ? session.index + 1 : session.index,
      results: [...session.results, ok],
      tried: ok ? const [] : [answer],
      recovered: false,
    );
  }

  /// A second pick after a miss. The first pick already counted; this one
  /// only tells the learner whether they found it before the solution opens.
  void retry(String raw) {
    final session = state;
    if (session == null || session.phase != PracticePhase.wrong) return;
    final answer = raw.trim();
    if (answer.isEmpty || session.tried.contains(answer)) return;
    final ok = session.current.check(answer);
    state = session.copyWith(
      phase: PracticePhase.solution,
      hintsShown: session.current.hints.length,
      tried: ok ? session.tried : [...session.tried, answer],
      recovered: ok,
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

  Future<void> nextAfterWrong() => _guard(_nextAfterWrong);

  Future<void> _nextAfterWrong() async {
    final session = state;
    if (session == null) return;
    if (session.phase != PracticePhase.wrong &&
        session.phase != PracticePhase.solution) {
      return;
    }
    if (session.isLast) {
      // The last answer was already recorded, mastery mark included; the
      // result screen reads the tree, so refresh it before showing it.
      ref.invalidate(areaViewProvider);
      state = session.copyWith(phase: PracticePhase.finished);
      return;
    }
    state = session.copyWith(
      index: session.index + 1,
      phase: PracticePhase.answering,
      hintsShown: 0,
      tried: const [],
      recovered: false,
    );
  }
}

final practiceProvider = NotifierProvider<PracticeNotifier, PracticeSession?>(
  PracticeNotifier.new,
);
