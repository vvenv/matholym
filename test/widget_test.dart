import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/knowledge/area.dart';
import 'package:matholym/domain/knowledge/graph.dart';
import 'package:matholym/domain/mastery.dart';

void main() {
  test('knowledge graph has twenty nodes and a single root', () {
    expect(knowledgeGraph.nodes, hasLength(20));
    expect(knowledgeGraph.rootId, kRootNodeId);
    expect(
      knowledgeGraph.nodes.where((n) => n.prerequisites.isEmpty),
      hasLength(1),
    );
    expect(MasteryRules.passRate, 0.8);
  });

  test('number theory is the first available knowledge area', () {
    expect(knowledgeGraph.area, KnowledgeArea.numberTheory);
    expect(KnowledgeArea.planned.where((area) => area.available), hasLength(1));
    expect(KnowledgeArea.byId('geometry').available, isFalse);
  });
}
