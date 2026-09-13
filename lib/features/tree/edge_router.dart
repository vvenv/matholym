import 'dart:math';
import 'dart:ui';

import '../../domain/knowledge/models.dart';
import 'tree_layout.dart';

class RoutedTreeEdge {
  const RoutedTreeEdge({
    required this.fromId,
    required this.toId,
    required this.points,
    required this.dots,
  });

  final String fromId;
  final String toId;
  final List<Offset> points;
  final bool dots;

  Offset get attachFrom => points.first;
  Offset get attachTo => points.last;
}

class TreeHSeg {
  const TreeHSeg({required this.y, required this.x1, required this.x2});
  final double y;
  final double x1;
  final double x2;
}

List<RoutedTreeEdge> routeKnowledgeEdges(KnowledgeGraph graph) {
  return _Router(graph).route();
}

List<TreeHSeg> horizontalSegmentsOf(List<RoutedTreeEdge> routes) {
  const eps = 0.6;
  final raw = <TreeHSeg>[];
  for (final e in routes) {
    for (var i = 1; i < e.points.length; i++) {
      final a = e.points[i - 1];
      final b = e.points[i];
      if ((a.dy - b.dy).abs() <= eps && (a.dx - b.dx).abs() > eps) {
        raw.add(TreeHSeg(y: a.dy, x1: min(a.dx, b.dx), x2: max(a.dx, b.dx)));
      }
    }
  }
  raw.sort((a, b) => a.y != b.y ? a.y.compareTo(b.y) : a.x1.compareTo(b.x1));
  final out = <TreeHSeg>[];
  for (final s in raw) {
    if (out.isNotEmpty &&
        (out.last.y - s.y).abs() < 1 &&
        s.x1 <= out.last.x2 + 1) {
      out[out.length - 1] = TreeHSeg(
        y: out.last.y,
        x1: out.last.x1,
        x2: max(out.last.x2, s.x2),
      );
    } else {
      out.add(s);
    }
  }
  return out;
}

class TreeRouteAudit {
  const TreeRouteAudit(this.problems);
  final List<String> problems;
  bool get ok => problems.isEmpty;
}

TreeRouteAudit auditTreeRoutes(
  KnowledgeGraph graph,
  List<RoutedTreeEdge> routes,
) {
  final problems = <String>[];
  for (final e in routes) {
    final from = graph.nodeById(e.fromId);
    final to = graph.nodeById(e.toId);
    if (from.level == to.level) {
      final rect = TreeLayout.rectOf(graph, e.toId);
      if ((e.attachTo.dy - rect.top).abs() < 4) {
        problems.add('${to.title} 同层边不应接到顶边');
      }
    }
    for (var i = 1; i < e.points.length; i++) {
      final a = e.points[i - 1];
      final b = e.points[i];
      for (final node in graph.nodes) {
        if (node.id == e.fromId || node.id == e.toId) continue;
        if (_hits(a, b, TreeLayout.rectOf(graph, node.id))) {
          problems.add('${e.fromId}→${e.toId} 穿过 ${node.title}');
        }
      }
    }
  }
  return TreeRouteAudit(problems);
}

bool _hits(Offset a, Offset b, Rect rect) {
  final r = rect.deflate(2);
  if (r.isEmpty) return false;
  if ((a.dx - b.dx).abs() <= 0.6) {
    if (a.dx <= r.left || a.dx >= r.right) return false;
    return max(a.dy, b.dy) > r.top && min(a.dy, b.dy) < r.bottom;
  }
  if ((a.dy - b.dy).abs() <= 0.6) {
    if (a.dy <= r.top || a.dy >= r.bottom) return false;
    return max(a.dx, b.dx) > r.left && min(a.dx, b.dx) < r.right;
  }
  return false;
}

class _Link {
  _Link({
    required this.fromId,
    required this.toId,
    required this.sameLevel,
    required this.adjacent,
  });

  final String fromId;
  final String toId;
  final bool sameLevel;
  final bool adjacent;
  double startX = 0;
  double endX = 0;
}

class _Router {
  _Router(this.graph);

  final KnowledgeGraph graph;

  static const _eps = 0.8;

  List<RoutedTreeEdge> route() {
    final links = <_Link>[];
    for (final node in graph.nodes) {
      final row = graph.byLevel(node.level);
      final ti = row.indexWhere((n) => n.id == node.id);
      for (final pre in node.prerequisites) {
        final from = graph.nodeById(pre);
        final fi = graph.byLevel(from.level).indexWhere((n) => n.id == pre);
        links.add(
          _Link(
            fromId: pre,
            toId: node.id,
            sameLevel: from.level == node.level,
            adjacent: from.level == node.level && (fi - ti).abs() == 1,
          ),
        );
      }
    }
    _ports(links);
    return [for (final e in links) _edge(e)];
  }

  void _ports(List<_Link> links) {
    final downs = links.where((e) => !e.sameLevel).toList();
    final byFrom = <String, List<_Link>>{};
    for (final e in downs) {
      byFrom.putIfAbsent(e.fromId, () => []).add(e);
    }
    for (final entry in byFrom.entries) {
      final groups = <int, List<_Link>>{};
      for (final e in entry.value) {
        groups.putIfAbsent(graph.nodeById(e.toId).level.index, () => []).add(e);
      }
      final keys = groups.keys.toList()..sort();
      final xs = _spread(
        TreeLayout.centerOf(graph, entry.key).dx,
        keys.length,
        8,
      );
      for (var i = 0; i < keys.length; i++) {
        for (final e in groups[keys[i]]!) {
          e.startX = xs[i];
        }
      }
    }
    final byTo = <String, List<_Link>>{};
    for (final e in downs) {
      byTo.putIfAbsent(e.toId, () => []).add(e);
    }
    for (final entry in byTo.entries) {
      final group = entry.value
        ..sort(
          (a, b) => TreeLayout.centerOf(
            graph,
            a.fromId,
          ).dx.compareTo(TreeLayout.centerOf(graph, b.fromId).dx),
        );
      final xs = _spread(
        TreeLayout.centerOf(graph, entry.key).dx,
        group.length,
        8,
      );
      for (var i = 0; i < group.length; i++) {
        group[i].endX = xs[i];
      }
    }
  }

  RoutedTreeEdge _edge(_Link e) {
    if (e.sameLevel) {
      return RoutedTreeEdge(
        fromId: e.fromId,
        toId: e.toId,
        points: _collapse(_sameLevel(e)),
        dots: false,
      );
    }
    return RoutedTreeEdge(
      fromId: e.fromId,
      toId: e.toId,
      points: _collapse(_down(e)),
      dots: true,
    );
  }

  List<Offset> _sameLevel(_Link e) {
    final a = TreeLayout.rectOf(graph, e.fromId);
    final b = TreeLayout.rectOf(graph, e.toId);
    final rightward = a.center.dx < b.center.dx;
    final start = Offset(rightward ? a.right : a.left, a.center.dy);
    final end = Offset(rightward ? b.left : b.right, b.center.dy);
    if (e.adjacent) return [start, end];
    final y = a.bottom + 16;
    return [start, Offset(start.dx, y), Offset(end.dx, y), end];
  }

  List<Offset> _down(_Link e) {
    final from = graph.nodeById(e.fromId);
    final to = graph.nodeById(e.toId);
    final fromL = from.level.index;
    final toL = to.level.index;
    final start = Offset(e.startX, TreeLayout.rectOf(graph, e.fromId).bottom);
    final end = Offset(e.endX, TreeLayout.rectOf(graph, e.toId).top);
    final yLast = TreeLayout.gapCenter(toL - 1);

    if (toL - fromL == 1) {
      return [start, Offset(start.dx, yLast), Offset(end.dx, yLast), end];
    }

    final yFirst = TreeLayout.gapCenter(fromL);
    if (_clearSpan(fromL, toL, e.endX)) {
      return [
        start,
        Offset(start.dx, yFirst),
        Offset(end.dx, yFirst),
        Offset(end.dx, yLast),
        end,
      ];
    }
    if (_clearSpan(fromL, toL, e.startX)) {
      return [start, Offset(start.dx, yLast), Offset(end.dx, yLast), end];
    }
    final streets = _streets(fromL, toL, e.startX, e.endX);
    final pts = <Offset>[start, Offset(start.dx, yFirst)];
    if ((streets.first - start.dx).abs() > _eps) {
      pts.add(Offset(streets.first, yFirst));
    }
    if (streets.length == 2) {
      final yJog = TreeLayout.gapCenter(2);
      pts
        ..add(Offset(streets[0], yJog))
        ..add(Offset(streets[1], yJog))
        ..add(Offset(streets[1], yLast));
    } else {
      pts.add(Offset(streets.first, yLast));
    }
    if ((pts.last.dx - end.dx).abs() > _eps) {
      pts.add(Offset(end.dx, yLast));
    }
    pts.add(end);
    return pts;
  }

  bool _clearOn(int row, double x) {
    for (final node in graph.byLevel(KnowledgeLevel.values[row])) {
      final r = TreeLayout.rectOf(graph, node.id).inflate(4);
      if (x > r.left && x < r.right) return false;
    }
    return true;
  }

  bool _clearSpan(int fromL, int toL, double x) {
    for (var row = fromL + 1; row < toL; row++) {
      if (!_clearOn(row, x)) return false;
    }
    return true;
  }

  List<double> _gutters(KnowledgeLevel sample) {
    final row = graph.byLevel(sample);
    return [
      for (var i = 0; i < row.length - 1; i++)
        (TreeLayout.rectOf(graph, row[i].id).right +
                TreeLayout.rectOf(graph, row[i + 1].id).left) /
            2,
    ];
  }

  List<double> _streets(int fromL, int toL, double startX, double endX) {
    var throughUpper = false;
    var throughLower = false;
    for (var row = fromL + 1; row < toL; row++) {
      if (row <= 2) throughUpper = true;
      if (row >= 3) throughLower = true;
    }
    final g3 = _gutters(KnowledgeLevel.l2);
    final g4 = _gutters(KnowledgeLevel.l5);
    if (throughUpper && throughLower) {
      return [_nearest(g3, startX), _nearest(g4, endX)];
    }
    if (throughUpper) return [_nearest(g3, (startX + endX) / 2)];
    return [_nearest(g4, (startX + endX) / 2)];
  }

  double _nearest(List<double> xs, double prefer) {
    return xs.reduce(
      (a, b) => (a - prefer).abs() <= (b - prefer).abs() ? a : b,
    );
  }

  List<double> _spread(double center, int n, double pitch) {
    if (n <= 1) return [center];
    final start = center - (n - 1) * pitch / 2;
    return [for (var i = 0; i < n; i++) start + i * pitch];
  }

  List<Offset> _collapse(List<Offset> pts) {
    final out = <Offset>[];
    for (final p in pts) {
      if (out.isEmpty) {
        out.add(p);
        continue;
      }
      if ((out.last - p).distance < 0.5) continue;
      if (out.length >= 2 && _colinear(out[out.length - 2], out.last, p)) {
        out[out.length - 1] = p;
      } else {
        out.add(p);
      }
    }
    return out.length >= 2 ? out : pts;
  }

  bool _colinear(Offset a, Offset b, Offset c) {
    final h = (a.dy - b.dy).abs() < _eps && (b.dy - c.dy).abs() < _eps;
    final v = (a.dx - b.dx).abs() < _eps && (b.dx - c.dx).abs() < _eps;
    return h || v;
  }
}
