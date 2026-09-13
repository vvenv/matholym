import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/knowledge/graph.dart';
import 'package:matholym/features/tree/edge_router.dart';
import 'package:matholym/features/tree/tree_layout.dart';

void main() {
  late List<RoutedTreeEdge> routes;

  setUpAll(() {
    routes = routeKnowledgeEdges(knowledgeGraph);
  });

  test('same-level cards do not get a top-edge attach dot', () {
    const sameLevelOnly = {
      'division_algorithm',
      'divisibility_rules',
      'fta',
      'sieve',
      'lcm',
      'coprime',
      'congruence_ops',
      'complete_residue',
    };
    for (final id in sameLevelOnly) {
      final incoming = routes.where((e) => e.toId == id);
      final rect = TreeLayout.rectOf(knowledgeGraph, id);
      for (final e in incoming) {
        final onSide = min(
              (e.attachTo.dx - rect.left).abs(),
              (e.attachTo.dx - rect.right).abs(),
            ) <
            2;
        expect(onSide, isTrue, reason: '$id should attach on a side port');
        expect(
          (e.attachTo.dy - rect.top).abs(),
          greaterThan(4),
          reason: '$id should not attach on the top edge',
        );
      }
    }
  });

  test('routes stay off foreign cards and do not overlap', () {
    final audit = auditTreeRoutes(knowledgeGraph, routes);
    expect(audit.problems, isEmpty, reason: audit.problems.join('\n'));
  });
}
