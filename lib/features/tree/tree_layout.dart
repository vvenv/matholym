import 'dart:math';
import 'dart:ui';

import '../../domain/knowledge/models.dart';

class TreeLayout {
  static const nodeW = 128.0;
  static const nodeH = 48.0;
  static const hGap = 20.0;
  static const vGap = 76.0;
  static const pad = 32.0;

  static Size sizeOf(KnowledgeGraph graph) {
    var cols = 1;
    for (final level in KnowledgeLevel.values) {
      cols = max(cols, graph.byLevel(level).length);
    }
    return Size(
      pad * 2 + cols * nodeW + (cols - 1) * hGap,
      pad * 2 +
          KnowledgeLevel.values.length * nodeH +
          (KnowledgeLevel.values.length - 1) * vGap,
    );
  }

  static Offset centerOf(KnowledgeGraph graph, String id) {
    final topLeft = TreeLayout.topLeft(graph, id);
    return topLeft + const Offset(nodeW / 2, nodeH / 2);
  }

  static Offset topLeft(KnowledgeGraph graph, String id) {
    final node = graph.nodeById(id);
    final row = graph.byLevel(node.level);
    final index = row.indexWhere((n) => n.id == id);
    final canvas = sizeOf(graph);
    final rowWidth = row.length * nodeW + (row.length - 1) * hGap;
    final left = (canvas.width - rowWidth) / 2;
    final x = left + index * (nodeW + hGap);
    final y = pad + node.level.index * (nodeH + vGap);
    return Offset(x, y);
  }

  static Rect rectOf(KnowledgeGraph graph, String id) {
    final origin = topLeft(graph, id);
    return Rect.fromLTWH(origin.dx, origin.dy, nodeW, nodeH);
  }

  static double rowTop(KnowledgeGraph graph, KnowledgeLevel level) {
    return pad + level.index * (nodeH + vGap);
  }

  static double rowBottom(KnowledgeGraph graph, KnowledgeLevel level) {
    return rowTop(graph, level) + nodeH;
  }

  static double gapCenter(int belowLevelIndex) {
    final bottom = pad + belowLevelIndex * (nodeH + vGap) + nodeH;
    final top = pad + (belowLevelIndex + 1) * (nodeH + vGap);
    return (bottom + top) / 2;
  }
}
