import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
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
        title: _AreaStrip(
          currentId: graph.valueOrNull?.graph.area.id ?? KnowledgeArea.numberTheoryId,
        ),
        actions: [
          IconButton(
            tooltip: '重置',
            onPressed: () => _confirmReset(context, ref),
            icon: const Icon(Icons.restart_alt, size: 18),
          ),
        ],
      ),
      body: graph.when(
        loading: () => const QuietProgress(),
        error: (e, _) => Center(child: Text('$e', style: AppType.body)),
        data: (view) => _TreeCanvas(view: view),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('重置？', style: AppType.title),
        content: const Text('进度和错题都会清空。', style: AppType.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('重置')),
        ],
      ),
    );
    if (ok != true) return;
    final repo = await ref.read(repositoryProvider.future);
    final profile = await ref.read(profileProvider.future);
    if (profile == null) return;
    await repo.resetProgress(profile.id);
    ref.invalidate(graphViewProvider);
    ref.invalidate(wrongOpenCountProvider);
    ref.invalidate(totalAttemptsProvider);
  }
}

class _AreaStrip extends StatelessWidget {
  const _AreaStrip({required this.currentId});

  final String currentId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final area in KnowledgeArea.planned) ...[
          if (area != KnowledgeArea.planned.first) const SizedBox(width: 22),
          Tooltip(
            message: area.available ? area.blurb : '即将开放',
            waitDuration: const Duration(milliseconds: 250),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  area.title,
                  style: AppType.mark.copyWith(
                    fontSize: 14,
                    letterSpacing: 0,
                    color: area.id == currentId
                        ? AppColors.text
                        : area.available
                        ? AppColors.text
                        : AppColors.muted,
                    fontWeight: area.id == currentId ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 5),
                ColoredBox(
                  color: area.id == currentId ? AppColors.accent : Colors.transparent,
                  child: const SizedBox(width: 14, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _TreeCanvas extends StatelessWidget {
  const _TreeCanvas({required this.view});

  final GraphView view;

  @override
  Widget build(BuildContext context) {
    final size = TreeLayout.sizeOf(view.graph);
    final featured = view.recommended()?.id;
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
                featured: node.id == featured,
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
    if (status == NodeStatus.locked) return;
    context.push('/card/${node.id}');
  }
}

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
    for (final node in view.graph.nodes) {
      final toStatus = view.statusOf(node.id);
      final to = TreeLayout.centerOf(view.graph, node.id);
      for (final pre in node.prerequisites) {
        final fromStatus = view.statusOf(pre);
        final open = fromStatus != NodeStatus.locked && toStatus != NodeStatus.locked;
        final paint = Paint()
          ..color = open
              ? AppColors.muted.withValues(alpha: 0.72)
              : AppColors.muted.withValues(alpha: 0.4)
          ..strokeWidth = open ? 1.25 : 1.0
          ..style = PaintingStyle.stroke;
        final from = TreeLayout.centerOf(view.graph, pre);
        final start = Offset(from.dx, from.dy + TreeLayout.nodeH / 2);
        final end = Offset(to.dx, to.dy - TreeLayout.nodeH / 2);
        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..cubicTo(start.dx, start.dy + 22, end.dx, end.dy - 22, end.dx, end.dy);
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
    required this.featured,
    required this.offset,
    required this.onTap,
  });

  final KnowledgeNode node;
  final NodeStatus status;
  final bool featured;
  final Offset offset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locked = status == NodeStatus.locked;
    final border = switch (status) {
      NodeStatus.locked => AppColors.locked.withValues(alpha: 0.55),
      NodeStatus.learning => featured ? AppColors.accent : AppColors.line,
      NodeStatus.mastered => AppColors.mastered.withValues(alpha: 0.55),
    };
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      width: TreeLayout.nodeW,
      height: TreeLayout.nodeH,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              left: BorderSide(
                color: featured ? AppColors.accent : border,
                width: featured ? 2 : 1,
              ),
              top: BorderSide(color: border),
              right: BorderSide(color: border),
              bottom: BorderSide(color: border),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                node.title,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  letterSpacing: 0,
                  fontWeight: featured ? FontWeight.w500 : FontWeight.w400,
                  color: locked ? AppColors.locked : AppColors.text,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
