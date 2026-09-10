import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/generators/catalog.dart';
import 'package:matholym/domain/knowledge/graph.dart';
import 'package:matholym/domain/mastery.dart';

void main() {
  test('each L1–L3 node has at least two templates', () {
    final ready = knowledgeGraph.nodes.where((n) => n.practiceReady);
    for (final node in ready) {
      final pool = questionEngine.forNode(node.id);
      expect(pool.length, greaterThanOrEqualTo(2), reason: node.id);
    }
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
}
