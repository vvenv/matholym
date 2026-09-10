import 'dart:math';

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
    this.answerHint = '',
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
  final String answerHint;

  bool check(String user) {
    if (kind == QuestionKind.choice) {
      final normalized = user.trim().toUpperCase();
      if (normalized == answer.toUpperCase()) return true;
    }
    return NumberTheory.answersEqual(answer, user);
  }
}

typedef QuestionBuilder =
    GeneratedQuestion Function(int seed, Difficulty difficulty);

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
    var pool = forNode(nodeId, difficulty: difficulty);
    if (pool.isEmpty) {
      pool = forNode(nodeId);
    }
    if (pool.isEmpty) {
      throw StateError('no templates for $nodeId');
    }
    final template = pool[rng.nextInt(pool.length)];
    final seed = rng.nextInt(1 << 30);
    return template.build(seed, difficulty);
  }

  List<GeneratedQuestion> challengeSet({
    required String nodeId,
    required int count,
    required Random rng,
  }) {
    final questions = <GeneratedQuestion>[];
    for (var i = 0; i < count; i++) {
      final d = i < count - 1 ? Difficulty.basic : Difficulty.medium;
      questions.add(
        randomForNode(nodeId: nodeId, difficulty: d, rng: rng),
      );
    }
    return questions;
  }

  static Difficulty tDifficultiesPrefer(Set<Difficulty> set) {
    if (set.contains(Difficulty.basic)) return Difficulty.basic;
    if (set.contains(Difficulty.medium)) return Difficulty.medium;
    return Difficulty.contest;
  }
}
