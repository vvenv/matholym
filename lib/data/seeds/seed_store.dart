import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/knowledge/graph.dart';
import '../../domain/knowledge/models.dart';

class SeedStore {
  factory SeedStore({
    KnowledgeGraph? graph,
    Map<String, KnowledgeGraph>? graphs,
    required Map<String, KnowledgeCard> cards,
  }) {
    final trees = Map<String, KnowledgeGraph>.unmodifiable(
      graphs ?? {(graph ?? knowledgeGraph).area.id: graph ?? knowledgeGraph},
    );
    return SeedStore._(
      {
        for (final entry in trees.entries)
          for (final node in entry.value.nodes) node.id: entry.key,
      },
      graphs: trees,
      cards: cards,
    );
  }

  const SeedStore._(
    this._areaOfNode, {
    required this.graphs,
    required this.cards,
  });

  final Map<String, KnowledgeGraph> graphs;
  final Map<String, KnowledgeCard> cards;

  /// Node id to the id of the tree that carries it. Node ids are unique across
  /// trees (see `test/widget_test.dart`), so one map covers every subject.
  final Map<String, String> _areaOfNode;

  KnowledgeGraph get graph =>
      graphs[KnowledgeArea.numberTheoryId] ?? graphs.values.first;

  KnowledgeGraph graphFor(String areaId) => graphs[areaId] ?? graph;

  /// The tree a node belongs to, or null when no loaded tree claims it — a
  /// stale link, or a node whose subject is not in this build.
  String? areaIdOf(String nodeId) => _areaOfNode[nodeId];

  KnowledgeNode? nodeOrNull(String id) {
    final areaId = _areaOfNode[id];
    if (areaId == null) return null;
    return graphs[areaId]!.nodeById(id);
  }

  KnowledgeNode nodeById(String id) {
    final node = nodeOrNull(id);
    if (node == null) throw StateError('unknown node $id');
    return node;
  }

  KnowledgeCard cardFor(String nodeId) {
    return cards[nodeId] ??
        KnowledgeCard(
          nodeId: nodeId,
          definition: '该节点的知识卡片尚未填写。',
          theorems: const [],
          examples: const [],
          commonMistakes: const [],
        );
  }

  static Future<SeedStore> load() async {
    try {
      final numberTheory = await _loadPair(
        nodesAsset: 'assets/seeds/nodes.json',
        cardsAsset: 'assets/seeds/cards.json',
        fallback: knowledgeGraph,
      );
      final calculation = await _loadPair(
        nodesAsset: 'assets/seeds/calculation_nodes.json',
        cardsAsset: 'assets/seeds/calculation_cards.json',
        fallback: calculationGraph,
      );
      final algebra = await _loadPair(
        nodesAsset: 'assets/seeds/algebra_nodes.json',
        cardsAsset: 'assets/seeds/algebra_cards.json',
        fallback: algebraGraph,
      );
      final combinatorics = await _loadPair(
        nodesAsset: 'assets/seeds/combinatorics_nodes.json',
        cardsAsset: 'assets/seeds/combinatorics_cards.json',
        fallback: combinatoricsGraph,
      );
      final geometry = await _loadPair(
        nodesAsset: 'assets/seeds/geometry_nodes.json',
        cardsAsset: 'assets/seeds/geometry_cards.json',
        fallback: geometryGraph,
      );
      final logic = await _loadPair(
        nodesAsset: 'assets/seeds/logic_nodes.json',
        cardsAsset: 'assets/seeds/logic_cards.json',
        fallback: logicGraph,
      );
      return SeedStore(
        graphs: {
          calculation.graph.area.id: calculation.graph,
          algebra.graph.area.id: algebra.graph,
          geometry.graph.area.id: geometry.graph,
          numberTheory.graph.area.id: numberTheory.graph,
          combinatorics.graph.area.id: combinatorics.graph,
          logic.graph.area.id: logic.graph,
        },
        cards: {
          ...calculation.cards,
          ...algebra.cards,
          ...geometry.cards,
          ...numberTheory.cards,
          ...combinatorics.cards,
          ...logic.cards,
        },
      );
    } catch (_) {
      return SeedStore(
        graphs: {
          calculationGraph.area.id: calculationGraph,
          algebraGraph.area.id: algebraGraph,
          geometryGraph.area.id: geometryGraph,
          knowledgeGraph.area.id: knowledgeGraph,
          combinatoricsGraph.area.id: combinatoricsGraph,
          logicGraph.area.id: logicGraph,
        },
        cards: const {},
      );
    }
  }

  static Future<({KnowledgeGraph graph, Map<String, KnowledgeCard> cards})>
  _loadPair({
    required String nodesAsset,
    required String cardsAsset,
    required KnowledgeGraph fallback,
  }) async {
    try {
      final nodesRaw = await rootBundle.loadString(nodesAsset);
      final cardsRaw = await rootBundle.loadString(cardsAsset);
      final graph = KnowledgeGraph.fromJson(
        jsonDecode(nodesRaw) as Map<String, dynamic>,
      );
      final cardMap = <String, KnowledgeCard>{};
      final decoded = jsonDecode(cardsRaw) as Map<String, dynamic>;
      for (final entry in decoded.entries) {
        cardMap[entry.key] = KnowledgeCard.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
      return (graph: graph, cards: cardMap);
    } catch (_) {
      return (graph: fallback, cards: const <String, KnowledgeCard>{});
    }
  }
}
