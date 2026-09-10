import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/info_tip.dart';
import '../../domain/knowledge/models.dart';
import '../../domain/mastery.dart';
import '../../providers.dart';

class TreePage extends ConsumerWidget {
  const TreePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graph = ref.watch(graphViewProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          graph.valueOrNull?.graph.area.treeTitle ?? KnowledgeArea.numberTheory.treeTitle,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: InfoTip('完成闯关（正确率 ≥ 80%）后解锁后继节点。锁定节点需先掌握前置。'),
          ),
        ],
      ),
      body: graph.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (view) => _TreeCanvas(view: view),
      ),
    );
  }
}

class _TreeCanvas extends StatelessWidget {
  const _TreeCanvas({required this.view});

  final GraphView view;

  @override
  Widget build(BuildContext context) {
    final size = TreeLayout.sizeOf(view.graph);
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(80),
      minScale: 0.55,
      maxScale: 2.4,
      child: SizedBox(
        width: max(size.width, MediaQuery.sizeOf(context).width),
        height: size.height + 24,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _EdgePainter(view)),
            ),
            for (final node in view.graph.nodes)
              _NodeCard(
                node: node,
                status: view.statusOf(node.id),
                offset: TreeLayout.topLeft(view.graph, node.id),
                onTap: () => _onTap(context, view, node),
              ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, GraphView view, KnowledgeNode node) {
    final status = view.statusOf(node.id);
    if (status == NodeStatus.locked) {
      final reasons = view.lockedBecause(node.id).map((e) => e.title).join('、');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('先掌握前置：$reasons')),
      );
      return;
    }
    context.push('/card/${node.id}');
  }
}

class TreeLayout {
  static const nodeW = 148.0;
  static const nodeH = 86.0;
  static const hGap = 18.0;
  static const vGap = 92.0;
  static const pad = 28.0;

  static Size sizeOf(KnowledgeGraph graph) {
    var cols = 1;
    for (final level in KnowledgeLevel.values) {
      cols = max(cols, graph.byLevel(level).length);
    }
    return Size(
      pad * 2 + cols * nodeW + (cols - 1) * hGap,
      pad * 2 + KnowledgeLevel.values.length * nodeH +
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
}

class _EdgePainter extends CustomPainter {
  _EdgePainter(this.view);

  final GraphView view;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    for (final node in view.graph.nodes) {
      final to = TreeLayout.centerOf(view.graph, node.id);
      for (final pre in node.prerequisites) {
        final from = TreeLayout.centerOf(view.graph, pre);
        final start = Offset(from.dx, from.dy + TreeLayout.nodeH / 2);
        final end = Offset(to.dx, to.dy - TreeLayout.nodeH / 2);
        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..cubicTo(start.dx, start.dy + 24, end.dx, end.dy - 24, end.dx, end.dy);
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EdgePainter oldDelegate) => oldDelegate.view != view;
}

class _NodeCard extends StatelessWidget {
  const _NodeCard({
    required this.node,
    required this.status,
    required this.offset,
    required this.onTap,
  });

  final KnowledgeNode node;
  final NodeStatus status;
  final Offset offset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      NodeStatus.locked => AppColors.locked,
      NodeStatus.learning => AppColors.info,
      NodeStatus.mastered => AppColors.accent,
    };
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      width: TreeLayout.nodeW,
      height: TreeLayout.nodeH,
      child: Tooltip(
        message: node.subtitle.isEmpty ? node.title : '${node.title} · ${node.subtitle}',
        waitDuration: const Duration(milliseconds: 250),
        child: Material(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withValues(alpha: 0.7)),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        node.level.shortLabel,
                        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      if (status == NodeStatus.locked)
                        const Icon(Icons.lock_outline, size: 14, color: AppColors.locked)
                      else if (status == NodeStatus.mastered)
                        const Icon(Icons.check_circle, size: 14, color: AppColors.accent)
                      else
                        const Icon(Icons.auto_stories, size: 14, color: AppColors.info),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    node.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: status == NodeStatus.locked ? AppColors.muted : AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
