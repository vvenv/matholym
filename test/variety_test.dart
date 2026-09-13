import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/generators/catalog.dart';
import 'package:matholym/domain/generators/question.dart';
import 'package:matholym/domain/knowledge/graph.dart';
import 'package:matholym/domain/knowledge/models.dart';
import 'package:matholym/domain/mastery.dart';

/// Every subject tree, so a thin node in any of them shows up here.
final _graphs = <KnowledgeGraph>[
  knowledgeGraph,
  calculationGraph,
  algebraGraph,
  geometryGraph,
  combinatoricsGraph,
  logicGraph,
];

Iterable<KnowledgeNode> get _allNodes =>
    _graphs.expand((graph) => graph.nodes);

void main() {
  test('a challenge never asks the same question twice', () {
    // Most nodes carry two templates, so drawing each slot on its own repeats
    // a question in roughly two runs out of five. This holds the engine to
    // five distinct stems and, with it, every node to five distinct questions.
    final repeats = <String>[];
    for (final node in _allNodes) {
      for (var trial = 0; trial < 8; trial++) {
        final set = questionEngine.challengeSet(
          nodeId: node.id,
          count: MasteryRules.challengeSize,
          rng: Random(trial * 7919 + 13),
        );
        final stems = set.map((q) => q.stem).toSet();
        if (stems.length < set.length) {
          repeats.add('${node.id} rng=$trial: ${set.map((q) => q.stem).join(" / ")}');
        }
      }
    }
    expect(repeats, isEmpty, reason: repeats.take(5).join('\n'));
  });

  test('a drill is as long as asked and stays on its node', () {
    for (final node in _allNodes.take(20)) {
      for (final difficulty in Difficulty.values) {
        final set = questionEngine.drillSet(
          nodeId: node.id,
          count: MasteryRules.drillSize,
          difficulty: difficulty,
          rng: Random(5),
        );
        expect(set, hasLength(MasteryRules.drillSize));
        expect(set.every((q) => q.nodeId == node.id), isTrue, reason: node.id);
      }
    }
  });

  test('a run reaches for a second template before repeating the first', () {
    for (final node in _allNodes) {
      expect(
        questionEngine.forNode(node.id).length,
        greaterThanOrEqualTo(2),
        reason: '${node.id} has only one template',
      );
      for (final difficulty in Difficulty.values) {
        // Only the bands the node has two templates for can alternate.
        if (questionEngine.forNode(node.id, difficulty: difficulty).length < 2) {
          continue;
        }
        final set = questionEngine.runForNode(
          nodeId: node.id,
          ladder: [difficulty, difficulty],
          rng: Random(3),
        );
        expect(
          set.map((q) => q.templateId).toSet(),
          hasLength(2),
          reason: '${node.id} asked one template twice at ${difficulty.name}',
        );
      }
    }
  });

  test('a drill on a node with one usable template still fills up', () {
    // `_poolFor` falls back to every template on the node, and a thin node is
    // allowed to repeat rather than loop forever looking for a fresh stem.
    final set = questionEngine.drillSet(
      nodeId: 'wolf_goat',
      count: 8,
      difficulty: Difficulty.contest,
      rng: Random(1),
    );
    expect(set, hasLength(8));
  });
}
