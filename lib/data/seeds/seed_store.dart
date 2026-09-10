import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/knowledge/graph.dart';
import '../../domain/knowledge/models.dart';

class SeedStore {
  SeedStore({
    required this.graph,
    required this.cards,
  });

  final KnowledgeGraph graph;
  final Map<String, KnowledgeCard> cards;

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
      final nodesRaw = await rootBundle.loadString('assets/seeds/nodes.json');
      final cardsRaw = await rootBundle.loadString('assets/seeds/cards.json');
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
      return SeedStore(graph: graph, cards: cardMap);
    } catch (_) {
      return SeedStore(graph: knowledgeGraph, cards: const {});
    }
  }
}
