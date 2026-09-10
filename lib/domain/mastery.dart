import 'knowledge/models.dart';

class MasteryRules {
  static const challengeSize = 5;
  static const passRate = 0.8;
  static const recentWindow = 20;
  static const consecutiveFluent = 5;

  static bool challengePassed({required int correct, required int total}) {
    if (total < challengeSize) return false;
    return correct / total >= passRate;
  }

  static double accuracy(int correct, int attempts) {
    if (attempts <= 0) return 0;
    return correct / attempts;
  }

  static double recentAccuracy(List<bool> chronological) {
    if (chronological.isEmpty) return 0;
    final slice = chronological.length > recentWindow
        ? chronological.sublist(chronological.length - recentWindow)
        : chronological;
    final hits = slice.where((e) => e).length;
    return hits / slice.length;
  }

  /// Root is always unlocked. A node unlocks when every direct prereq is mastered.
  static Set<String> unlockedIds({
    required KnowledgeGraph graph,
    required Set<String> masteredIds,
  }) {
    final unlocked = <String>{graph.rootId};
    var changed = true;
    while (changed) {
      changed = false;
      for (final node in graph.nodes) {
        if (unlocked.contains(node.id)) continue;
        if (node.prerequisites.isEmpty) continue;
        if (node.prerequisites.every(masteredIds.contains)) {
          unlocked.add(node.id);
          changed = true;
        }
      }
    }
    return unlocked;
  }

  static NodeStatus status({
    required String nodeId,
    required Set<String> unlockedIds,
    required Set<String> masteredIds,
  }) {
    if (masteredIds.contains(nodeId)) return NodeStatus.mastered;
    if (unlockedIds.contains(nodeId)) return NodeStatus.learning;
    return NodeStatus.locked;
  }
}

class NodeProgressSnapshot {
  const NodeProgressSnapshot({
    required this.nodeId,
    required this.unlocked,
    required this.mastered,
    required this.attempts,
    required this.correct,
    required this.consecutive,
  });

  final String nodeId;
  final bool unlocked;
  final bool mastered;
  final int attempts;
  final int correct;
  final int consecutive;

  double get accuracy => MasteryRules.accuracy(correct, attempts);
}

class GraphView {
  const GraphView({
    required this.graph,
    required this.unlocked,
    required this.mastered,
    required this.progress,
  });

  final KnowledgeGraph graph;
  final Set<String> unlocked;
  final Set<String> mastered;
  final Map<String, NodeProgressSnapshot> progress;

  NodeStatus statusOf(String id) =>
      MasteryRules.status(nodeId: id, unlockedIds: unlocked, masteredIds: mastered);

  List<KnowledgeNode> lockedBecause(String id) {
    final node = graph.nodeById(id);
    return node.prerequisites
        .where((p) => !mastered.contains(p))
        .map(graph.nodeById)
        .toList();
  }

  KnowledgeNode? recommended({bool practiceOnly = true}) {
    for (final node in graph.nodes) {
      if (practiceOnly && !node.practiceReady) continue;
      if (statusOf(node.id) == NodeStatus.learning) return node;
    }
    for (final node in graph.nodes) {
      if (practiceOnly && !node.practiceReady) continue;
      if (statusOf(node.id) == NodeStatus.mastered) continue;
      if (unlocked.contains(node.id)) return node;
    }
    return graph.nodeById(graph.rootId);
  }
}
