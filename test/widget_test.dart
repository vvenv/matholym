import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/knowledge/area.dart';
import 'package:matholym/domain/knowledge/graph.dart';
import 'package:matholym/domain/mastery.dart';

void main() {
  test('knowledge graph has a single root and all nodes practice-ready', () {
    expect(knowledgeGraph.nodes, hasLength(34));
    expect(knowledgeGraph.rootId, kRootNodeId);
    expect(
      knowledgeGraph.nodes.where((n) => n.prerequisites.isEmpty),
      hasLength(1),
    );
    expect(knowledgeGraph.nodes.every((n) => n.practiceReady), isTrue);
    expect(MasteryRules.passRate, 0.8);
  });

  test('six junior/elementary areas are available', () {
    expect(knowledgeGraph.area, KnowledgeArea.numberTheory);
    expect(calculationGraph.nodes, hasLength(32));
    expect(algebraGraph.nodes, hasLength(40));
    expect(geometryGraph.nodes, hasLength(38));
    expect(combinatoricsGraph.nodes, hasLength(31));
    expect(logicGraph.nodes, hasLength(29));
    expect(calculationGraph.nodes.every((n) => n.practiceReady), isTrue);
    expect(algebraGraph.nodes.every((n) => n.practiceReady), isTrue);
    expect(geometryGraph.nodes.every((n) => n.practiceReady), isTrue);
    expect(combinatoricsGraph.nodes.every((n) => n.practiceReady), isTrue);
    expect(logicGraph.nodes.every((n) => n.practiceReady), isTrue);
    expect(
      KnowledgeArea.planned.where((area) => area.available).map((a) => a.id),
      [
        'calculation',
        'algebra',
        'geometry',
        'number_theory',
        'combinatorics',
        'logic',
      ],
    );
  });

  test('node ids are unique across all subject trees', () {
    final ids = <String>[];
    for (final graph in [
      knowledgeGraph,
      calculationGraph,
      algebraGraph,
      combinatoricsGraph,
      geometryGraph,
      logicGraph,
    ]) {
      ids.addAll(graph.nodes.map((n) => n.id));
    }
    expect(ids.toSet(), hasLength(ids.length));
  });
}
