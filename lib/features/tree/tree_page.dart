import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/math_text.dart';
import '../../core/widgets/quiet_tap.dart';
import '../../core/widgets/study_bar.dart';
import '../../domain/knowledge/models.dart';
import '../../domain/mastery.dart';
import '../../providers.dart';
import 'edge_router.dart';
import 'tree_layout.dart';

/// Hover inset for list rows; the list pads less so text stays on the column.
const _rowInset = 12.0;

class TreePage extends ConsumerWidget {
  const TreePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graph = ref.watch(graphViewProvider);
    final mode = ref.watch(treeLayoutModeProvider);
    return graph.when(
      loading: () => const QuietProgress(),
      error: (e, _) => Center(child: Text('$e', style: AppType.body)),
      data: (view) => mode == TreeLayoutMode.list
          ? _TreeList(view: view)
          : _TreeCanvas(view: view),
    );
  }
}

double _treeChrome(BuildContext context) {
  return MediaQuery.paddingOf(context).top + StudyBar.height;
}

class _TreeCanvas extends StatefulWidget {
  const _TreeCanvas({required this.view});

  final GraphView view;

  @override
  State<_TreeCanvas> createState() => _TreeCanvasState();
}

class _TreeCanvasState extends State<_TreeCanvas> {
  /// Hovered or focused node; its links light up and the rest step back.
  String? _focusId;

  late List<RoutedTreeEdge> _routes = routeKnowledgeEdges(widget.view.graph);

  @override
  void didUpdateWidget(covariant _TreeCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.view.graph != widget.view.graph) {
      _routes = routeKnowledgeEdges(widget.view.graph);
    }
  }

  void _highlight(String id, bool on) {
    if (on) {
      if (_focusId != id) setState(() => _focusId = id);
    } else if (_focusId == id) {
      setState(() => _focusId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final view = widget.view;
    final size = TreeLayout.sizeOf(view.graph);
    final featured = view.recommended()?.id;
    final viewSize = MediaQuery.sizeOf(context);
    final margin = max(viewSize.width, viewSize.height);
    final chrome = _treeChrome(context);
    // Center on wide screens; narrow ones pan from the left edge.
    final width = max(viewSize.width, size.width);
    final focus = _focusId;
    final related = focus == null
        ? const <String>{}
        : {
            focus,
            ...view.graph.nodeById(focus).prerequisites,
            for (final n in view.graph.dependentsOf(focus)) n.id,
          };
    return InteractiveViewer(
      constrained: false,
      alignment: Alignment.topCenter,
      boundaryMargin: EdgeInsets.all(margin),
      minScale: 0.4,
      maxScale: 2.5,
      panEnabled: true,
      scaleEnabled: true,
      child: Padding(
        padding: EdgeInsets.only(top: chrome),
        child: SizedBox(
          width: width,
          height: size.height,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _EdgePainter(routes: _routes, focusId: focus),
                    ),
                  ),
                  for (final node in view.graph.nodes)
                    _NodeCard(
                      node: node,
                      status: view.statusOf(node.id),
                      featured: node.id == featured,
                      faded: focus != null && !related.contains(node.id),
                      offset: TreeLayout.topLeft(view.graph, node.id),
                      onTap: () => context.push('/card/${node.id}'),
                      onHighlight: (on) => _highlight(node.id, on),
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

class _TreeList extends StatelessWidget {
  const _TreeList({required this.view});

  final GraphView view;

  @override
  Widget build(BuildContext context) {
    final chrome = _treeChrome(context);
    final featured = view.recommended()?.id;
    final children = <Widget>[];
    var first = true;
    for (final level in KnowledgeLevel.values) {
      final nodes = view.graph.byLevel(level);
      if (nodes.isEmpty) continue;
      final ready = nodes.where((n) => n.practiceReady).toList();
      final done = ready
          .where((n) => view.statusOf(n.id) == NodeStatus.mastered)
          .length;
      children.add(
        Padding(
          padding: EdgeInsets.fromLTRB(
            _rowInset,
            first ? 0 : AppSpace.lg,
            _rowInset,
            AppSpace.sm,
          ),
          child: Semantics(
            header: true,
            child: Row(
              children: [
                Text(view.graph.levelLabel(level), style: AppType.meta),
                const Spacer(),
                Text(
                  ready.isEmpty ? '未开放' : '$done / ${ready.length}',
                  style: AppType.tabular.copyWith(
                    fontSize: 12,
                    letterSpacing: 0.4,
                    color: ready.isNotEmpty && done == ready.length
                        ? AppColors.mastered
                        : AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      first = false;
      for (final node in nodes) {
        children.add(
          _ListNode(
            node: node,
            status: view.statusOf(node.id),
            featured: node.id == featured,
            progress: view.progress[node.id],
            onTap: () => context.push('/card/${node.id}'),
          ),
        );
      }
    }
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpace.column),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpace.page - _rowInset,
            chrome + AppSpace.md,
            AppSpace.page - _rowInset,
            48,
          ),
          children: children,
        ),
      ),
    );
  }
}

class _ListNode extends StatelessWidget {
  const _ListNode({
    required this.node,
    required this.status,
    required this.featured,
    required this.progress,
    required this.onTap,
  });

  final KnowledgeNode node;
  final NodeStatus status;
  final bool featured;
  final NodeProgressSnapshot? progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = progress;
    final (mark, markColor) = featured
        ? ('下一步', AppColors.accent)
        : status == NodeStatus.mastered
        ? ('已掌握', AppColors.mastered)
        : p != null && p.attempts > 0
        ? ('正确率 ${(p.accuracy * 100).round()}%', AppColors.muted)
        : ('', AppColors.muted);
    return QuietTap(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: _rowInset, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            // Centred on the title's first line (16 × 1.75).
            padding: const EdgeInsets.only(top: 11),
            child: _StatusMark(
              featured: featured,
              mastered: status == NodeStatus.mastered,
              started: p != null && p.attempts > 0,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  node.title,
                  style: AppType.body.copyWith(
                    fontWeight: featured ? FontWeight.w500 : FontWeight.w400,
                    // Not yet drillable: still readable, one step back.
                    color: node.practiceReady
                        ? AppColors.text
                        : AppColors.muted,
                  ),
                ),
                if (node.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  MathText(node.subtitle, style: AppType.meta),
                ],
              ],
            ),
          ),
          if (mark.isNotEmpty) ...[
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(mark, style: AppType.meta.copyWith(color: markColor)),
            ),
          ],
        ],
      ),
    );
  }
}

/// A six-pixel square read down the list at a glance: hollow before any
/// attempt, filled once started, green when mastered, gold for next.
class _StatusMark extends StatelessWidget {
  const _StatusMark({
    required this.featured,
    required this.mastered,
    required this.started,
  });

  final bool featured;
  final bool mastered;
  final bool started;

  @override
  Widget build(BuildContext context) {
    final fill = featured
        ? AppColors.accent
        : mastered
        ? AppColors.mastered
        : started
        ? AppColors.muted
        : null;
    return SizedBox.square(
      dimension: 6,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          border: fill == null ? Border.all(color: AppColors.faint) : null,
        ),
      ),
    );
  }
}

class _EdgePainter extends CustomPainter {
  _EdgePainter({required this.routes, required this.focusId});

  final List<RoutedTreeEdge> routes;
  final String? focusId;

  static const _hopR = 6.0;
  static const _eps = 1.2;

  @override
  void paint(Canvas canvas, Size size) {
    final horizontals = horizontalSegmentsOf(routes);
    final focus = focusId;
    bool hot(RoutedTreeEdge e) => e.fromId == focus || e.toId == focus;

    // Quiet edges first so lit ones draw over every crossing.
    final ordered = focus == null
        ? routes
        : [...routes.where((e) => !hot(e)), ...routes.where(hot)];
    final dots = <Offset, Color>{};

    for (final e in ordered) {
      if (e.points.length < 2) continue;
      final lit = focus != null && hot(e);
      final alpha = focus == null
          ? 0.8
          : lit
          ? 1.0
          : 0.18;
      final color = (lit ? AppColors.accent : AppColors.muted).withValues(
        alpha: alpha,
      );
      final stroke = Paint()
        ..color = color
        ..strokeWidth = lit ? 1.6 : 1.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      final path = Path()..moveTo(e.points.first.dx, e.points.first.dy);
      for (var i = 1; i < e.points.length; i++) {
        final a = e.points[i - 1];
        final b = e.points[i];
        if ((a.dx - b.dx).abs() <= _eps) {
          _vertical(path, a.dx, a.dy, b.dy, horizontals);
        } else {
          path.lineTo(b.dx, b.dy);
        }
      }
      canvas.drawPath(path, stroke);
      if (e.dots) {
        // Later (lit) edges win a shared attach point.
        dots[_dotKey(e.attachFrom)] = color;
        dots[_dotKey(e.attachTo)] = color;
      }
    }
    for (final entry in dots.entries) {
      canvas.drawCircle(
        entry.key,
        2.2,
        Paint()
          ..color = entry.value
          ..style = PaintingStyle.fill,
      );
    }
  }

  Offset _dotKey(Offset o) =>
      Offset((o.dx * 2).roundToDouble() / 2, (o.dy * 2).roundToDouble() / 2);

  void _vertical(
    Path path,
    double x,
    double fromY,
    double toY,
    List<TreeHSeg> horizontals,
  ) {
    if ((fromY - toY).abs() <= _eps) {
      path.lineTo(x, toY);
      return;
    }
    final down = toY > fromY;
    final hops = <double>[];
    for (final h in horizontals) {
      if (x <= h.x1 + _eps || x >= h.x2 - _eps) continue;
      if (!_between(h.y, fromY, toY)) continue;
      hops.add(h.y);
    }
    hops.sort();
    final spaced = <double>[];
    for (final hop in hops) {
      if (spaced.isEmpty || (hop - spaced.last).abs() >= 4) {
        spaced.add(hop);
      }
    }
    if (!down) spaced.sort((a, b) => b.compareTo(a));

    for (var i = 0; i < spaced.length; i++) {
      final hop = spaced[i];
      final prev = i == 0 ? min(fromY, toY) : spaced[i - 1];
      final next = i == spaced.length - 1 ? max(fromY, toY) : spaced[i + 1];
      final room = min((hop - prev).abs(), (next - hop).abs()) / 2 - 1;
      final r = min(_hopR, max(3.0, room));
      if (down) {
        path.lineTo(x, hop - r);
        path.arcTo(
          Rect.fromCircle(center: Offset(x, hop), radius: r),
          -pi / 2,
          pi,
          false,
        );
      } else {
        path.lineTo(x, hop + r);
        path.arcTo(
          Rect.fromCircle(center: Offset(x, hop), radius: r),
          pi / 2,
          -pi,
          false,
        );
      }
    }
    path.lineTo(x, toY);
  }

  bool _between(double v, double a, double b) {
    final lo = min(a, b) + _eps;
    final hi = max(a, b) - _eps;
    return v > lo && v < hi;
  }

  @override
  bool shouldRepaint(covariant _EdgePainter oldDelegate) =>
      oldDelegate.routes != routes || oldDelegate.focusId != focusId;
}

class _NodeCard extends StatelessWidget {
  const _NodeCard({
    required this.node,
    required this.status,
    required this.featured,
    required this.faded,
    required this.offset,
    required this.onTap,
    required this.onHighlight,
  });

  final KnowledgeNode node;
  final NodeStatus status;
  final bool featured;
  final bool faded;
  final Offset offset;
  final VoidCallback onTap;
  final ValueChanged<bool> onHighlight;

  @override
  Widget build(BuildContext context) {
    final mastered = status == NodeStatus.mastered;
    final border = switch (status) {
      NodeStatus.learning => featured ? AppColors.accent : AppColors.line,
      NodeStatus.mastered => AppColors.mastered.withValues(alpha: 0.7),
    };
    final textColor = node.practiceReady ? AppColors.text : AppColors.muted;
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      width: TreeLayout.nodeW,
      height: TreeLayout.nodeH,
      child: AnimatedOpacity(
        opacity: faded ? 0.35 : 1,
        duration: reduce ? Duration.zero : const Duration(milliseconds: 160),
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
          child: QuietTap(
            onTap: onTap,
            onHighlight: onHighlight,
            child: Stack(
              children: [
                Center(
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
                        fontWeight: featured
                            ? FontWeight.w500
                            : FontWeight.w400,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                if (mastered)
                  const Positioned(
                    top: 6,
                    right: 6,
                    child: ColoredBox(
                      color: AppColors.mastered,
                      child: SizedBox(width: 5, height: 5),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
