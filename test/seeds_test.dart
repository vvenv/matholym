import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/knowledge/graph.dart';
import 'package:matholym/domain/knowledge/models.dart';

void main() {
  test('seed json matches compiled graphs', () {
    _expectSame(
      File('assets/seeds/nodes.json'),
      knowledgeGraph,
    );
    _expectSame(
      File('assets/seeds/calculation_nodes.json'),
      calculationGraph,
    );
    _expectSame(
      File('assets/seeds/algebra_nodes.json'),
      algebraGraph,
    );
    _expectSame(
      File('assets/seeds/combinatorics_nodes.json'),
      combinatoricsGraph,
    );
    _expectSame(
      File('assets/seeds/geometry_nodes.json'),
      geometryGraph,
    );
    _expectSame(
      File('assets/seeds/logic_nodes.json'),
      logicGraph,
    );
  });
}

void _expectSame(File file, KnowledgeGraph graph) {
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final seeded = KnowledgeGraph.fromJson(json);
  expect(seeded.area.id, graph.area.id);
  expect(seeded.rootId, graph.rootId);
  expect(
    seeded.nodes.map((n) => n.id).toList(),
    graph.nodes.map((n) => n.id).toList(),
  );
  for (final node in graph.nodes) {
    final other = seeded.nodeById(node.id);
    expect(other.title, node.title, reason: node.id);
    expect(other.practiceReady, node.practiceReady, reason: node.id);
    expect(other.prerequisites, node.prerequisites, reason: node.id);
  }
}
