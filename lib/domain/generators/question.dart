import 'dart:math';

import '../figure.dart';
import '../number_theory.dart';

enum Difficulty {
  basic,
  medium,
  contest;

  String get label => switch (this) {
    Difficulty.basic => '基础',
    Difficulty.medium => '中等',
    Difficulty.contest => '竞赛',
  };

  static Difficulty parse(String raw) => Difficulty.values.firstWhere(
    (e) => e.name == raw,
    orElse: () => Difficulty.basic,
  );
}

enum QuestionKind { fill, choice, judge }

enum PracticeMode {
  special,
  challenge,
  redo;

  String get label => switch (this) {
    PracticeMode.special => '专项练习',
    PracticeMode.challenge => '闯关练习',
    PracticeMode.redo => '错题重练',
  };
}

class GeneratedQuestion {
  const GeneratedQuestion({
    required this.templateId,
    required this.seed,
    required this.nodeId,
    required this.difficulty,
    required this.kind,
    required this.stem,
    required this.answer,
    required this.hints,
    required this.steps,
    required this.nodeRefs,
    this.choices = const [],
    this.figure,
    this.answerRange,
  });

  final String templateId;
  final int seed;
  final String nodeId;
  final Difficulty difficulty;
  final QuestionKind kind;
  final String stem;
  final String answer;
  final List<String> hints;
  final List<String> steps;
  final List<String> nodeRefs;
  final List<String> choices;
  final MathFigure? figure;

  /// The interval the answer has to live in — a residue mod m is in `0..m-1`,
  /// a single digit in `0..9`. Options outside it are eliminable without
  /// doing the mathematics, so the choice bank stays inside.
  final ({int min, int max})? answerRange;

  bool check(String user) {
    if (kind == QuestionKind.choice) {
      final normalized = user.trim().toUpperCase();
      if (normalized == answer.toUpperCase()) return true;
    }
    return NumberTheory.answersEqual(answer, user);
  }
}

typedef QuestionBuilder = GeneratedQuestion Function(
  int seed,
  Difficulty difficulty,
);

class QuestionTemplate {
  const QuestionTemplate({
    required this.id,
    required this.nodeId,
    required this.difficulties,
    required this.build,
  });

  final String id;
  final String nodeId;
  final Set<Difficulty> difficulties;
  final QuestionBuilder build;
}

class QuestionEngine {
  const QuestionEngine(this.templates);

  final List<QuestionTemplate> templates;

  List<QuestionTemplate> forNode(String nodeId, {Difficulty? difficulty}) {
    return templates.where((t) {
      if (t.nodeId != nodeId) return false;
      if (difficulty == null) return true;
      return t.difficulties.contains(difficulty);
    }).toList();
  }

  GeneratedQuestion generate({
    required String templateId,
    required int seed,
    Difficulty? difficulty,
  }) {
    final template = templates.firstWhere((t) => t.id == templateId);
    final d = difficulty ?? tDifficultiesPrefer(template.difficulties);
    return template.build(seed, d);
  }

  GeneratedQuestion randomForNode({
    required String nodeId,
    required Difficulty difficulty,
    required Random rng,
  }) {
    final pool = _poolFor(nodeId, difficulty);
    final template = pool[rng.nextInt(pool.length)];
    return template.build(rng.nextInt(1 << 30), difficulty);
  }

  /// One practice run on a node, one difficulty per slot.
  ///
  /// A node usually carries two templates, so drawing each slot on its own
  /// asks the same question twice in a five-question run more often than not.
  /// Each slot therefore prefers a template the run has not used yet, and
  /// redraws while the stem repeats one already on the paper. Nodes with
  /// fewer distinct questions than the run is long still repeat — see
  /// `test/variety_test.dart`, which holds every node to a full challenge.
  List<GeneratedQuestion> runForNode({
    required String nodeId,
    required List<Difficulty> ladder,
    required Random rng,
  }) {
    final out = <GeneratedQuestion>[];
    final stems = <String>{};
    for (final difficulty in ladder) {
      final pool = _poolFor(nodeId, difficulty);
      final used = {for (final q in out) q.templateId};
      final unused = pool.where((t) => !used.contains(t.id)).toList();
      GeneratedQuestion? pick;
      for (final from in [if (unused.isNotEmpty) unused, pool]) {
        for (var i = 0; i < _redraws && pick == null; i++) {
          final q = from[rng.nextInt(from.length)].build(
            rng.nextInt(1 << 30),
            difficulty,
          );
          if (!stems.contains(q.stem)) pick = q;
        }
        if (pick != null) break;
      }
      pick ??= pool[rng.nextInt(pool.length)].build(
        rng.nextInt(1 << 30),
        difficulty,
      );
      stems.add(pick.stem);
      out.add(pick);
    }
    return out;
  }

  /// Basic all the way, one medium to close: passing means the node holds up.
  List<GeneratedQuestion> challengeSet({
    required String nodeId,
    required int count,
    required Random rng,
  }) {
    return runForNode(
      nodeId: nodeId,
      rng: rng,
      ladder: [
        for (var i = 0; i < count; i++)
          i < count - 1 ? Difficulty.basic : Difficulty.medium,
      ],
    );
  }

  /// A drill: one difficulty, no pass mark.
  List<GeneratedQuestion> drillSet({
    required String nodeId,
    required int count,
    required Difficulty difficulty,
    required Random rng,
  }) {
    return runForNode(
      nodeId: nodeId,
      rng: rng,
      ladder: List.filled(count, difficulty),
    );
  }

  /// Templates for the difficulty, or every template on the node when it has
  /// none at that difficulty.
  List<QuestionTemplate> _poolFor(String nodeId, Difficulty difficulty) {
    final pool = forNode(nodeId, difficulty: difficulty);
    if (pool.isNotEmpty) return pool;
    final all = forNode(nodeId);
    if (all.isEmpty) throw StateError('no templates for $nodeId');
    return all;
  }

  /// Draws per slot before a repeated stem is accepted.
  static const _redraws = 24;

  static Difficulty tDifficultiesPrefer(Set<Difficulty> set) {
    if (set.contains(Difficulty.basic)) return Difficulty.basic;
    if (set.contains(Difficulty.medium)) return Difficulty.medium;
    return Difficulty.contest;
  }
}
