import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/generators/catalog.dart';
import 'package:matholym/domain/generators/choices.dart';
import 'package:matholym/domain/generators/question.dart';
import 'package:matholym/domain/geometry.dart';
import 'package:matholym/domain/knowledge/graph.dart';
import 'package:matholym/domain/mastery.dart';

void main() {
  test('each practice-ready node has at least two templates', () {
    for (final graph in [
      knowledgeGraph,
      calculationGraph,
      algebraGraph,
      combinatoricsGraph,
      geometryGraph,
      logicGraph,
    ]) {
      for (final node in graph.nodes.where((n) => n.practiceReady)) {
        final pool = questionEngine.forNode(node.id);
        expect(pool.length, greaterThanOrEqualTo(2), reason: node.id);
      }
    }
  });

  test('no template rounds an answer or breaks a helper precondition', () {
    // The domain helpers assert that their divisions come out exact, so a
    // generator that draws numbers giving 11.11% or 2.4 days throws here
    // rather than shipping a rounded answer as the key. Asserts are on under
    // `flutter test`, which is what makes this sweep worth running.
    final broken = <String>[];
    for (final template in questionTemplates) {
      for (final d in template.difficulties) {
        for (var seed = 1; seed <= 150; seed++) {
          try {
            template.build(seed, d);
          } catch (e) {
            broken.add('${template.id} ${d.name} seed=$seed :: $e');
          }
        }
      }
    }
    expect(broken, isEmpty);
  });

  test('same seed reproduces the same question', () {
    for (final template in questionTemplates) {
      final difficulty = template.difficulties.first;
      final a = questionEngine.generate(
        templateId: template.id,
        seed: 42,
        difficulty: difficulty,
      );
      final b = questionEngine.generate(
        templateId: template.id,
        seed: 42,
        difficulty: difficulty,
      );
      expect(a.stem, b.stem, reason: template.id);
      expect(a.answer, b.answer, reason: template.id);
      expect(a.seed, 42);
    }
  });

  test('different seeds usually change parameters', () {
    var changed = 0;
    for (final template in questionTemplates) {
      final d = template.difficulties.first;
      final a = questionEngine.generate(
        templateId: template.id,
        seed: 1,
        difficulty: d,
      );
      final b = questionEngine.generate(
        templateId: template.id,
        seed: 2,
        difficulty: d,
      );
      if (a.stem != b.stem || a.answer != b.answer) changed++;
    }
    expect(changed, greaterThan(questionTemplates.length ~/ 2));
  });

  test('generated answers are accepted by the checker', () {
    for (final template in questionTemplates) {
      for (final d in template.difficulties) {
        final q = questionEngine.generate(
          templateId: template.id,
          seed: 99,
          difficulty: d,
        );
        expect(q.check(q.answer), isTrue, reason: '${template.id} $d');
        expect(q.stem, isNotEmpty);
        expect(q.hints, isNotEmpty);
        expect(q.steps, isNotEmpty);
      }
    }
  });

  test('challenge set has five questions on one node', () {
    final set = questionEngine.challengeSet(
      nodeId: 'gcd',
      count: MasteryRules.challengeSize,
      rng: Random(7),
    );
    expect(set, hasLength(5));
    expect(set.every((q) => q.nodeId == 'gcd'), isTrue);
  });

  test('frame area subtracts the border on both sides', () {
    expect(Geometry.cutSquare(12, 8), 80);
    for (var seed = 1; seed <= 40; seed++) {
      final q = questionEngine.generate(
        templateId: 'cut.frame',
        seed: seed,
        difficulty: Difficulty.basic,
      );
      final opts = QuestionOptions.of(q);
      expect(opts, contains(q.answer), reason: 'seed $seed');
      expect(opts.toSet(), hasLength(4), reason: 'seed $seed $opts');
      expect(q.stem.contains('内边长'), isFalse, reason: 'seed $seed');
    }
  });
}
