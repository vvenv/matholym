import 'knowledge/models.dart';

class MasteryRules {
  static const challengeSize = 5;

  /// A drill is the same length as a challenge; it just does not judge.
  static const drillSize = 5;
  static const passRate = 0.8;

  /// Fewest correct answers that pass a full challenge.
  static int get passCount => (challengeSize * passRate - 1e-9).ceil();

  static bool challengePassed({required int correct, required int total}) {
    if (total < challengeSize) return false;
    return correct / total >= passRate;
  }

  static double accuracy(int correct, int attempts) {
    if (attempts <= 0) return 0;
    return correct / attempts;
  }

  /// Every node is open, so a node is either being learnt or done.
  /// Prerequisites are navigation, not a gate.
  static NodeStatus status({
    required String nodeId,
    required Set<String> masteredIds,
  }) {
    return masteredIds.contains(nodeId)
        ? NodeStatus.mastered
        : NodeStatus.learning;
  }
}

class NodeProgressSnapshot {
  const NodeProgressSnapshot({
    required this.nodeId,
    required this.mastered,
    required this.attempts,
    required this.correct,
    required this.consecutive,
  });

  final String nodeId;
  final bool mastered;
  final int attempts;
  final int correct;
  final int consecutive;

  double get accuracy => MasteryRules.accuracy(correct, attempts);
}

class GraphView {
  const GraphView({
    required this.graph,
    required this.mastered,
    required this.progress,
  });

  final KnowledgeGraph graph;
  final Set<String> mastered;
  final Map<String, NodeProgressSnapshot> progress;

  NodeStatus statusOf(String id) =>
      MasteryRules.status(nodeId: id, masteredIds: mastered);

  /// Where to pick up: the first node still being learnt, in tree order.
  KnowledgeNode? recommended() {
    for (final node in graph.nodes) {
      if (!node.practiceReady) continue;
      if (statusOf(node.id) == NodeStatus.learning) return node;
    }
    return graph.nodeOrNull(graph.rootId);
  }
}
