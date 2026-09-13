import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../domain/figure.dart';
import '../../domain/figure_geom.dart';
import '../theme/app_theme.dart';

/// Textbook-style line figure. Hairline ink on the study background, gold
/// only on the asked mark.
class MathFigureView extends StatelessWidget {
  const MathFigureView({super.key, required this.figure, this.height = 176});

  final MathFigure figure;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: figure.semantics,
      image: true,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border.fromBorderSide(BorderSide(color: AppColors.line)),
        ),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(painter: MathFigurePainter(figure)),
        ),
      ),
    );
  }
}

class MathFigurePainter extends CustomPainter {
  MathFigurePainter(this.figure);

  final MathFigure figure;

  static const _ink = AppColors.text;
  static const _mute = AppColors.muted;
  static const _faint = AppColors.faint;
  static const _gold = AppColors.accent;

  late Size _size;
  late Canvas _c;

  @override
  void paint(Canvas canvas, Size size) {
    _c = canvas;
    _size = size;
    switch (figure) {
      case AnglePairFigure f:
        _anglePair(f);
      case TriangleFigure f:
        _triangle(f);
      case RectFigure f:
        _rect(f);
      case TrapezoidFigure f:
        _trap(f);
      case ParallelFigure f:
        _parallel(f);
      case CircleMeasureFigure f:
        _circleMeasure(f);
      case CircleAngleFigure f:
        _circleAngle(f);
      case CyclicQuadFigure f:
        _cyclic(f);
      case ChordsFigure f:
        _chords(f);
      case TangentFigure f:
        _tangent(f);
      case SimilarPairFigure f:
        _similar(f);
      case FrameFigure f:
        _frame(f);
      case BoxFigure f:
        _box(f);
      case GridFigure f:
        _grid(f);
      case CrossFigure f:
        _cross(f);
      case AxesFigure f:
        _axes(f);
      case LightsFigure f:
        _lights(f);
      case LatticeFigure f:
        _lattice(f);
      case RevolutionFigure f:
        _revolution(f);
      case SphereFigure f:
        _sphere(f);
      case PolygonFigure f:
        _polygon(f);
      case SectorFigure f:
        _sector(f);
      case SymmetryFigure f:
        _symmetry(f);
      case NetFigure f:
        _net(f);
      case ReflectPathFigure f:
        _reflect(f);
      case InterceptFigure f:
        _intercept(f);
    }
  }

  Offset p(double x, double y) {
    const pad = 22.0;
    return Offset(
      pad + x * (_size.width - 2 * pad),
      pad + y * (_size.height - 2 * pad),
    );
  }

  Paint get _line => Paint()
    ..color = _ink
    ..strokeWidth = 1.15
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true;

  Paint get _thin => Paint()
    ..color = _mute
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true;

  Paint get _goldLine => Paint()
    ..color = _gold
    ..strokeWidth = 1.35
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true;

  void _seg(Offset a, Offset b, {Paint? paint}) =>
      _c.drawLine(a, b, paint ?? _line);

  void _poly(List<Offset> pts, {bool close = true, Paint? paint}) {
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final q in pts.skip(1)) {
      path.lineTo(q.dx, q.dy);
    }
    if (close) path.close();
    _c.drawPath(path, paint ?? _line);
  }

  void _dash(Offset a, Offset b, {Paint? paint}) {
    const dash = 5.0;
    const gap = 3.5;
    final d = b - a;
    final len = d.distance;
    if (len < 1) return;
    final dir = d / len;
    var t = 0.0;
    final pnt = paint ?? _thin;
    while (t < len) {
      final n = math.min(dash, len - t);
      _c.drawLine(a + dir * t, a + dir * (t + n), pnt);
      t += dash + gap;
    }
  }

  void _dot(Offset o, {Color color = _ink, double r = 2.2}) {
    _c.drawCircle(o, r, Paint()..color = color);
  }

  void _label(String text, Offset o, {Color? color, double size = 12}) {
    if (text.isEmpty) return;
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color ?? _mute,
          fontSize: size,
          height: 1,
          fontFeatures: const [ui.FontFeature.tabularFigures()],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(_c, o - Offset(tp.width / 2, tp.height / 2));
  }

  void _ask(String? text, Offset o) {
    if (text == null) return;
    _label(text == '?' ? '?' : _deg(text), o, color: text == '?' ? _gold : _mute);
  }

  String _deg(String raw) {
    if (raw == '?' || raw == 'α') return raw;
    if (raw.endsWith('°')) return raw;
    if (int.tryParse(raw) != null) return '$raw°';
    return raw;
  }

  Offset _unit(Offset from, Offset to) {
    final d = to - from;
    final n = d.distance;
    return n < 1e-6 ? Offset.zero : d / n;
  }

  void _rightMark(Offset v, Offset along1, Offset along2) {
    const s = 9.0;
    final u = _unit(v, along1) * s;
    final w = _unit(v, along2) * s;
    _poly([v + u, v + u + w, v + w], close: false, paint: _thin);
  }

  void _ticks(Offset a, Offset b, {int n = 1}) {
    final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
    final u = _unit(a, b);
    final perp = Offset(-u.dy, u.dx);
    const len = 5.0;
    for (var i = 0; i < n; i++) {
      final c = mid + u * ((i - (n - 1) / 2) * 4);
      _seg(c - perp * len, c + perp * len, paint: _thin);
    }
  }

  Offset _in(Offset v, Offset p, Offset q, double dist) {
    final u = _unit(v, p) + _unit(v, q);
    final n = u.distance;
    if (n < 1e-6) return v;
    return v + u / n * dist;
  }

  FigPt _fp(Offset o) => FigPt(o.dx, o.dy);

  Offset Function(FigPt) _fitMap(List<FigPt> pts, {double pad = 24}) {
    var minX = pts.first.x, maxX = pts.first.x;
    var minY = pts.first.y, maxY = pts.first.y;
    for (final q in pts.skip(1)) {
      minX = math.min(minX, q.x);
      maxX = math.max(maxX, q.x);
      minY = math.min(minY, q.y);
      maxY = math.max(maxY, q.y);
    }
    final w = math.max(maxX - minX, 1e-6);
    final h = math.max(maxY - minY, 1e-6);
    final availW = _size.width - 2 * pad;
    final availH = _size.height - 2 * pad;
    final s = math.min(availW / w, availH / h);
    final ox = pad + (availW - w * s) / 2;
    final oy = pad + (availH - h * s) / 2;
    return (q) => Offset(ox + (q.x - minX) * s, oy + (q.y - minY) * s);
  }

  Offset _project(Offset p, Offset a, Offset b) {
    final ab = b - a;
    final den = ab.distanceSquared;
    if (den < 1e-9) return a;
    final t = ((p - a).dx * ab.dx + (p - a).dy * ab.dy) / den;
    return a + ab * t;
  }

  void _touchRadius(Offset center, Offset touch, Offset along) {
    _dash(center, touch);
    _rightMark(touch, center, along);
    _dot(touch, r: 1.8, color: _mute);
  }

  void _mark(String? text, Offset o, {Offset shift = Offset.zero}) {
    if (text == null || text.isEmpty) return;
    _label(
      text,
      o + shift,
      color: text == '?' ? _gold : _mute,
    );
  }

  void _anglePair(AnglePairFigure f) {
    if (f.kind == AnglePairKind.complement) {
      final o = p(0.28, 0.78);
      final r = p(0.82, 0.78);
      final u = p(0.28, 0.16);
      _seg(o, r);
      _seg(o, u);
      _rightMark(o, r, u);
      final t = f.given * math.pi / 180;
      final ray = Offset(o.dx + math.cos(t) * 70, o.dy - math.sin(t) * 70);
      _seg(o, ray, paint: _goldLine);
      _ask('${f.given}', p(0.52, 0.68));
      _ask('?', p(0.38, 0.42));
    } else {
      final a = p(0.08, 0.55);
      final o = p(0.42, 0.55);
      final b = p(0.92, 0.55);
      _seg(a, b);
      final t = (180 - f.given) * math.pi / 180;
      final ray = Offset(o.dx + math.cos(t) * 80, o.dy - math.sin(t) * 80);
      _seg(o, ray, paint: _goldLine);
      _ask('${f.given}', p(0.62, 0.68));
      _ask('?', p(0.32, 0.38));
    }
  }

  void _triangle(TriangleFigure f) {
    late Offset A, B, C;
    final sss = _sssVertices(f);
    final right = f.rightAt?.toUpperCase();
    final iso = f.isoVertex?.toUpperCase();
    if (sss != null) {
      A = sss[0];
      B = sss[1];
      C = sss[2];
    } else if (right == 'C') {
      C = p(0.18, 0.82);
      A = p(0.18, 0.18);
      B = p(0.84, 0.82);
    } else if (right == 'A') {
      A = p(0.18, 0.82);
      C = p(0.18, 0.18);
      B = p(0.84, 0.82);
    } else if (right == 'B') {
      B = p(0.84, 0.82);
      C = p(0.84, 0.18);
      A = p(0.16, 0.82);
    } else if (iso == 'C') {
      C = p(0.50, 0.14);
      A = p(0.16, 0.84);
      B = p(0.84, 0.84);
    } else {
      C = p(0.40, 0.14);
      A = p(0.12, 0.84);
      B = p(0.88, 0.84);
    }
    _poly([A, B, C]);
    _label(f.a, A + const Offset(-11, 10));
    _label(f.b, B + const Offset(11, 10));
    _label(f.c, C + const Offset(0, -12));
    if (right == 'C') _rightMark(C, A, B);
    if (right == 'A') _rightMark(A, C, B);
    if (right == 'B') _rightMark(B, A, C);
    if (iso == 'C') {
      _ticks(C, A);
      _ticks(C, B);
    }
    _ask(f.angleA, _in(A, B, C, 22));
    _ask(f.angleB, _in(B, A, C, 22));
    _ask(f.angleC, _in(C, A, B, 22));
    if (f.sideAB != null) {
      _label(f.sideAB!, Offset((A.dx + B.dx) / 2, (A.dy + B.dy) / 2 + 12));
    }
    if (f.sideBC != null) {
      _label(f.sideBC!, Offset((B.dx + C.dx) / 2 + 12, (B.dy + C.dy) / 2));
    }
    if (f.sideCA != null) {
      _label(f.sideCA!, Offset((C.dx + A.dx) / 2 - 12, (C.dy + A.dy) / 2));
    }
    if (f.heightLabel != null) {
      final foot = _project(C, A, B);
      _dash(C, foot);
      _rightMark(foot, C, B);
      _label(f.heightLabel!, Offset(foot.dx + 12, (C.dy + foot.dy) / 2));
    }
    if (f.midline) {
      final m = Offset((C.dx + A.dx) / 2, (C.dy + A.dy) / 2);
      final n = Offset((C.dx + B.dx) / 2, (C.dy + B.dy) / 2);
      _seg(m, n, paint: _goldLine);
      _label('m', Offset((m.dx + n.dx) / 2, (m.dy + n.dy) / 2 - 10));
    }
    if (f.bisector) {
      final foot = figBisectorFoot(_fp(A), _fp(B), _fp(C));
      _dash(C, Offset(foot.x, foot.y), paint: _goldLine);
    }
    if (f.incircle) {
      _incircleAt(A, B, C);
    }
    if (f.exteriorAt?.toUpperCase() == 'C') {
      final ext = C + _unit(B, C) * 46;
      _seg(C, ext);
      _ask(f.exteriorLabel ?? '?', _in(C, A, ext, 22));
    }
  }

  List<Offset>? _sssVertices(TriangleFigure f) {
    double? parse(String? s) => s == null ? null : double.tryParse(s);
    final ab = parse(f.sideAB);
    final bc = parse(f.sideBC);
    final ca = parse(f.sideCA);
    if (ab == null || bc == null || ca == null) return null;
    if (ab + bc <= ca || bc + ca <= ab || ca + ab <= bc) return null;
    const a = FigPt(0, 0);
    final b = FigPt(ab, 0);
    final x = (ca * ca + ab * ab - bc * bc) / (2 * ab);
    final y = math.sqrt(math.max(0, ca * ca - x * x));
    final c = FigPt(x, -y);
    final map = _fitMap([a, b, c], pad: 36);
    return [map(a), map(b), map(c)];
  }

  void _incircleAt(Offset a, Offset b, Offset c) {
    final ia = _fp(a), ib = _fp(b), ic = _fp(c);
    final i = figIncenter(ia, ib, ic);
    final rho = figInradius(ia, ib, ic);
    final o = Offset(i.x, i.y);
    _c.drawCircle(o, rho, _thin);
    _dot(o, r: 1.6, color: _mute);
    final tAb = _project(o, a, b);
    final tBc = _project(o, b, c);
    final tCa = _project(o, c, a);
    _touchRadius(o, tAb, b);
    _touchRadius(o, tBc, c);
    _touchRadius(o, tCa, a);
  }

  void _rect(RectFigure f) {
    final left = f.square ? 0.28 : 0.16;
    final right = f.square ? 0.72 : 0.84;
    final tl = p(left, 0.22);
    final tr = p(right, 0.22);
    final br = p(right, 0.82);
    final bl = p(left, 0.82);
    _poly([tl, tr, br, bl]);
    _rightMark(bl, br, tl);
    if (f.length != null) {
      _label(f.length!, Offset((bl.dx + br.dx) / 2, bl.dy + 12));
    }
    if (f.width != null) {
      _label(f.width!, Offset(bl.dx - 12, (bl.dy + tl.dy) / 2));
    }
    if (f.diagonal) _dash(bl, tr);
  }

  void _trap(TrapezoidFigure f) {
    if (f.parallelogram) {
      final a = p(0.22, 0.78);
      final b = p(0.78, 0.78);
      final c = p(0.88, 0.28);
      final d = p(0.32, 0.28);
      _poly([a, b, c, d]);
      if (f.bottom != null) {
        _label(f.bottom!, Offset((a.dx + b.dx) / 2, a.dy + 12));
      }
      if (f.height != null) {
        final foot = Offset(d.dx, a.dy);
        _dash(d, foot);
        _label(f.height!, Offset(d.dx + 12, (d.dy + foot.dy) / 2));
      }
      return;
    }
    final a = p(0.28, 0.32);
    final b = p(0.72, 0.32);
    final c = p(0.88, 0.82);
    final d = p(0.12, 0.82);
    _poly([a, b, c, d]);
    if (f.top != null) _label(f.top!, Offset((a.dx + b.dx) / 2, a.dy - 12));
    if (f.bottom != null) {
      _label(f.bottom!, Offset((d.dx + c.dx) / 2, d.dy + 12));
    }
    if (f.height != null) {
      final foot = Offset(a.dx, d.dy);
      _dash(a, foot);
      _rightMark(foot, a, c);
      _label(f.height!, Offset(a.dx + 12, (a.dy + foot.dy) / 2));
    }
    if (f.midline != null) {
      final m = Offset((a.dx + d.dx) / 2, (a.dy + d.dy) / 2);
      final n = Offset((b.dx + c.dx) / 2, (b.dy + c.dy) / 2);
      _seg(m, n, paint: _goldLine);
      _label(f.midline!, Offset((m.dx + n.dx) / 2, (m.dy + n.dy) / 2 - 10));
    }
  }

  void _parallel(ParallelFigure f) {
    final l1a = p(0.08, 0.32);
    final l1b = p(0.92, 0.32);
    final l2a = p(0.08, 0.72);
    final l2b = p(0.92, 0.72);
    _seg(l1a, l1b);
    _seg(l2a, l2b);
    _ticks(p(0.18, 0.32), p(0.28, 0.32), n: 2);
    _ticks(p(0.18, 0.72), p(0.28, 0.72), n: 2);
    final t1 = p(0.28, 0.12);
    final t2 = p(0.72, 0.90);
    _seg(t1, t2);
    if (f.mark == ParallelMark.corresponding) {
      _ask(f.angle ?? 'α', p(0.40, 0.24));
      _ask(f.angle == null ? 'α' : '?', p(0.54, 0.64));
    } else {
      _ask(f.angle ?? 'α', p(0.46, 0.42));
      _ask('?', p(0.58, 0.62));
    }
  }

  void _circleMeasure(CircleMeasureFigure f) {
    final o = p(0.50, 0.50);
    final r = math.min(_size.width, _size.height) * 0.32;
    _c.drawCircle(o, r, _line);
    _seg(o, o + Offset(r, 0));
    _dot(o, r: 2);
    _label('O', o + const Offset(-10, -8));
    _label(f.radius, o + Offset(r / 2, -10));
  }

  void _circleAngle(CircleAngleFigure f) {
    final o = p(0.50, 0.56);
    final r = math.min(_size.width, _size.height) * 0.34;
    _c.drawCircle(o, r, _line);
    Offset polar(double deg) {
      final t = deg * math.pi / 180;
      return o + Offset(math.cos(t) * r, -math.sin(t) * r);
    }

    if (f.diameter) {
      final A = polar(180);
      final B = polar(0);
      final C = polar(110);
      _seg(A, B);
      _poly([A, B, C]);
      _rightMark(C, A, B);
      _label('A', A + const Offset(-12, 4));
      _label('B', B + const Offset(12, 4));
      _label('C', C + const Offset(0, -12));
      _dot(o, r: 2);
      if (f.acuteAtA != null) _ask(f.acuteAtA, _in(A, B, C, 20));
      return;
    }
    final A = polar(150);
    final B = polar(30);
    final C = polar(250);
    _poly([A, B, C]);
    _seg(o, A, paint: _thin);
    _seg(o, B, paint: _thin);
    _dot(o, r: 2);
    _label('O', o + const Offset(8, 12));
    _label('A', A + const Offset(-10, -8));
    _label('B', B + const Offset(10, -8));
    _label('C', C + const Offset(0, 14));
    _ask(f.central, _in(o, A, B, 28));
    _ask(f.inscribed, _in(C, A, B, 22));
    if (f.secondInscribed != null) {
      final D = polar(200);
      _seg(A, D, paint: _thin);
      _seg(B, D, paint: _thin);
      _label('D', D + const Offset(-12, 0));
      _ask(f.secondInscribed, _in(D, A, B, 20));
    }
  }

  void _cyclic(CyclicQuadFigure f) {
    final o = p(0.46, 0.52);
    final r = math.min(_size.width, _size.height) * 0.34;
    _c.drawCircle(o, r, _thin);
    Offset polar(double deg) {
      final t = deg * math.pi / 180;
      return o + Offset(math.cos(t) * r, -math.sin(t) * r);
    }

    final A = polar(130);
    final B = polar(40);
    final C = polar(320);
    final D = polar(210);
    _poly([A, B, C, D]);
    _label('A', A + const Offset(-12, -6));
    _label('B', B + const Offset(12, -6));
    _label('C', C + const Offset(10, 12));
    _label('D', D + const Offset(-12, 10));
    if (f.showExterior) {
      final ext = D + _unit(C, D) * 40;
      _seg(D, ext);
      _ask(f.exterior ?? '?', _in(D, A, ext, 22));
      _ask(f.interior, _in(B, A, C, 18));
    } else if (f.interior != null) {
      _ask(f.interior, _in(A, B, D, 20));
      _ask('?', _in(C, B, D, 20));
    }
  }

  void _chords(ChordsFigure f) {
    const localO = FigPt(0, 0);
    const localR = 1.0;
    final pts = figStandardChords(localO, localR);
    final map = _fitMap([...pts, ...figCircleBox(localO, localR)]);
    final o = map(localO);
    final r = (map(FigPt(localO.x + localR, localO.y)) - o).distance;
    final A = map(pts[0]);
    final B = map(pts[1]);
    final C = map(pts[2]);
    final D = map(pts[3]);
    _c.drawCircle(o, r, _thin);
    _seg(A, B);
    _seg(C, D);
    final hit = figIntersect(pts[0], pts[1], pts[2], pts[3])!;
    final P = map(hit);
    _dot(P, r: 2);
    _label('P', P + const Offset(10, -8));
    _mark(f.a, Offset((A.dx + P.dx) / 2, (A.dy + P.dy) / 2), shift: const Offset(0, -8));
    _mark(f.b, Offset((P.dx + B.dx) / 2, (P.dy + B.dy) / 2), shift: const Offset(0, 10));
    _mark(f.c, Offset((C.dx + P.dx) / 2, (C.dy + P.dy) / 2), shift: const Offset(0, -8));
    _mark(f.d, Offset((P.dx + D.dx) / 2, (P.dy + D.dy) / 2), shift: const Offset(8, 0));
  }

  void _tangent(TangentFigure f) {
    if (f.twoTangents) {
      _twoTangents(f);
      return;
    }
    if (f.tangentialQuad) {
      _tangentialQuad(f);
      return;
    }
    _tangentSecant(f);
  }

  void _twoTangents(TangentFigure f) {
    final g = figStandardTwoTangents();
    final map = _fitMap([g.p, g.a, g.b, ...figCircleBox(g.o, g.r)]);
    final o = map(g.o);
    final r = (map(FigPt(g.o.x + g.r, g.o.y)) - o).distance;
    final P = map(g.p);
    final A = map(g.a);
    final B = map(g.b);
    _c.drawCircle(o, r, _thin);
    _dot(o, r: 1.8, color: _mute);
    _label('O', o + const Offset(8, 10));
    _seg(P, A);
    _seg(P, B);
    _ticks(P, A);
    _ticks(P, B);
    _touchRadius(o, A, P);
    _touchRadius(o, B, P);
    _dot(P, r: 2);
    _label('P', P + const Offset(-12, 0));
    if (f.length != null) {
      _mark(f.length, Offset((P.dx + A.dx) / 2, (P.dy + A.dy) / 2), shift: const Offset(-10, 0));
      _mark(f.length, Offset((P.dx + B.dx) / 2, (P.dy + B.dy) / 2), shift: const Offset(-10, 0));
    }
  }

  void _tangentialQuad(TangentFigure f) {
    final g = figStandardTangentialQuad();
    final map = _fitMap([...g.vertices, ...figCircleBox(g.o, g.r)]);
    final o = map(g.o);
    final r = (map(FigPt(g.o.x + g.r, g.o.y)) - o).distance;
    final verts = [for (final v in g.vertices) map(v)];
    final touch = [for (final t in g.touch) map(t)];
    _c.drawCircle(o, r, _thin);
    _dot(o, r: 1.8, color: _mute);
    _poly(verts);
    for (var i = 0; i < 4; i++) {
      _touchRadius(o, touch[i], verts[i]);
    }
    const names = ['A', 'B', 'C', 'D'];
    for (var i = 0; i < 4; i++) {
      _label(names[i], verts[i] + _unit(o, verts[i]) * 14);
    }
    final labels = f.sides.length == 4
        ? f.sides
        : const <String?>['a', 'b', 'c', 'd'];
    for (var i = 0; i < 4; i++) {
      final a = verts[i];
      final b = verts[(i + 1) % 4];
      final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
      final away = _unit(o, mid) * 12;
      _mark(labels[i], mid + away);
    }
  }

  void _tangentSecant(TangentFigure f) {
    final g = figStandardSecant();
    final map = _fitMap([g.p, g.a, g.b, g.t, ...figCircleBox(g.o, g.r)]);
    final o = map(g.o);
    final r = (map(FigPt(g.o.x + g.r, g.o.y)) - o).distance;
    final P = map(g.p);
    final A = map(g.a);
    final B = map(g.b);
    final T = map(g.t);
    _c.drawCircle(o, r, _thin);
    _dot(o, r: 1.8, color: _mute);
    _seg(P, T, paint: _goldLine);
    _seg(P, B);
    _touchRadius(o, T, P);
    _dot(P, r: 2);
    _dot(A, r: 1.8);
    _dot(B, r: 1.8);
    _label('P', P + const Offset(-10, 8));
    _label('T', T + const Offset(10, -8));
    _label('A', A + const Offset(-10, -8));
    _label('B', B + const Offset(10, -8));
    _mark(f.length, Offset((P.dx + T.dx) / 2, (P.dy + T.dy) / 2), shift: const Offset(0, 12));
    _mark(f.external, Offset((P.dx + A.dx) / 2, (P.dy + A.dy) / 2), shift: const Offset(-10, 0));
    _mark(f.whole, Offset((P.dx + B.dx) / 2, (P.dy + B.dy) / 2), shift: const Offset(0, -10));
  }

  void _similar(SimilarPairFigure f) {
    final u = math.min(_size.width, _size.height);
    final s1 = u * (f.congruent ? 0.38 : 0.32);
    final s2 = u * (f.congruent ? 0.38 : 0.48);
    final o1 = p(0.06, 0.16);
    final o2 = p(f.congruent ? 0.52 : 0.46, f.congruent ? 0.16 : 0.06);
    Offset at(FigPt origin, FigPt q, double s) =>
        Offset(origin.x + q.x * s, origin.y + q.y * s);
    final a1 = at(_fp(o1), figSimilarShape[0], s1);
    final b1 = at(_fp(o1), figSimilarShape[1], s1);
    final c1 = at(_fp(o1), figSimilarShape[2], s1);
    final a2 = at(_fp(o2), figSimilarShape[0], s2);
    final b2 = at(_fp(o2), figSimilarShape[1], s2);
    final c2 = at(_fp(o2), figSimilarShape[2], s2);
    _poly([a1, b1, c1]);
    _poly([a2, b2, c2]);
    _ticks(a1, b1);
    _ticks(a2, b2);
    _ticks(a1, c1, n: 2);
    _ticks(a2, c2, n: 2);
    _label(f.congruent ? '△ABC' : '小', Offset((a1.dx + b1.dx) / 2, a1.dy + 12));
    _label(f.congruent ? '△DEF' : '大', Offset((a2.dx + b2.dx) / 2, a2.dy + 12));
    if (f.smallSide != null) {
      _mark(f.smallSide, Offset((a1.dx + b1.dx) / 2, a1.dy - 10));
      if (f.congruent) {
        _mark(f.smallSide, Offset((a2.dx + b2.dx) / 2, a2.dy - 10));
      }
    }
    if (!f.congruent) {
      final gap = Offset((b1.dx + a2.dx) / 2, (c1.dy + a1.dy) / 2);
      _label(f.ratio, gap, color: _gold);
    }
  }

  void _frame(FrameFigure f) {
    final outer = p(0.22, 0.14);
    final outerBr = p(0.78, 0.86);
    _c.drawRect(Rect.fromPoints(outer, outerBr), _line);
    final inset = 0.14;
    final inner = p(0.22 + inset, 0.14 + inset * 1.15);
    final innerBr = p(0.78 - inset, 0.86 - inset * 1.15);
    _c.drawRect(Rect.fromPoints(inner, innerBr), _thin);
    _label(f.outer, Offset((outer.dx + outerBr.dx) / 2, outer.dy - 12));
    _label(
      f.cutInner ?? f.border,
      Offset((inner.dx + innerBr.dx) / 2, (inner.dy + innerBr.dy) / 2),
    );
  }

  void _box(BoxFigure f) {
    final origin = p(0.22, 0.62);
    final dx = f.cube ? 70.0 : 90.0;
    final dy = f.cube ? 70.0 : 52.0;
    final dz = Offset(28, -22);
    Offset q(double x, double y, double z) =>
        origin + Offset(x * dx, -y * dy) + dz * z;
    final a = q(0, 0, 0);
    final b = q(1, 0, 0);
    final c = q(1, 1, 0);
    final d = q(0, 1, 0);
    final e = q(0, 0, 1);
    final g = q(1, 0, 1);
    final h = q(1, 1, 1);
    final i = q(0, 1, 1);
    _poly([a, b, c, d]);
    _poly([d, c, h, i]);
    _poly([b, g, h, c]);
    _dash(a, e);
    _dash(e, g);
    _dash(e, i);
    if (f.length != null) {
      _label(f.length!, Offset((a.dx + b.dx) / 2, a.dy + 12));
    }
    if (f.height != null) {
      _label(f.height!, Offset(a.dx - 12, (a.dy + d.dy) / 2));
    }
    if (f.width != null) {
      _label(f.width!, Offset((b.dx + g.dx) / 2 + 10, (b.dy + g.dy) / 2));
    }
  }

  void _grid(GridFigure f) {
    final cols = math.max(1, f.cols);
    final rows = math.max(1, f.rows);
    const left = 0.18;
    const top = 0.12;
    const right = 0.82;
    const bot = 0.88;
    final cw = (right - left) / cols;
    final rh = (bot - top) / rows;
    for (var i = 0; i <= cols; i++) {
      _seg(p(left + i * cw, top), p(left + i * cw, bot), paint: _thin);
    }
    for (var i = 0; i <= rows; i++) {
      _seg(p(left, top + i * rh), p(right, top + i * rh), paint: _thin);
    }
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final i = r * cols + c;
        if (i >= f.cells.length) continue;
        final v = f.cells[i];
        if (v == null || v.isEmpty) continue;
        final o = p(left + (c + 0.5) * cw, top + (r + 0.5) * rh);
        _label(v, o, color: v == '?' || v == '□' ? _gold : _ink, size: 14);
      }
    }
  }

  void _cross(CrossFigure f) {
    void cell(double x, double y, String? v) {
      final tl = p(x - 0.09, y - 0.16);
      final br = p(x + 0.09, y + 0.16);
      _c.drawRect(Rect.fromPoints(tl, br), _thin);
      if (v != null) {
        _label(v, p(x, y), color: v == '?' ? _gold : _ink, size: 14);
      }
    }

    cell(0.50, 0.50, f.center);
    cell(0.50, 0.18, f.up);
    cell(0.50, 0.82, f.down);
    cell(0.28, 0.50, f.left);
    cell(0.72, 0.50, f.right);
  }

  void _axes(AxesFigure f) {
    final o = p(0.50, 0.55);
    _seg(p(0.08, 0.55), p(0.92, 0.55), paint: _thin);
    _seg(p(0.50, 0.92), p(0.50, 0.10), paint: _thin);
    _label('x', p(0.92, 0.62));
    _label('y', p(0.56, 0.10));
    final path = Path();
    var started = false;
    void add(double nx, double ny) {
      final q = Offset(o.dx + nx * 18, o.dy - ny * 16);
      if (!started) {
        path.moveTo(q.dx, q.dy);
        started = true;
      } else {
        path.lineTo(q.dx, q.dy);
      }
    }

    switch (f.kind) {
      case AxesKind.line:
        final k = (f.k ?? 1).toDouble();
        final b = (f.b ?? 0).toDouble();
        add(-6, k * -6 + b);
        add(6, k * 6 + b);
      case AxesKind.inverse:
        final k = (f.k ?? 6).toDouble();
        for (var x = -6.0; x <= -0.4; x += 0.15) {
          add(x, k / x);
        }
        started = false;
        final path2 = Path();
        var s2 = false;
        for (var x = 0.4; x <= 6; x += 0.15) {
          final q = Offset(o.dx + x * 18, o.dy - (k / x) * 16);
          if (!s2) {
            path2.moveTo(q.dx, q.dy);
            s2 = true;
          } else {
            path2.lineTo(q.dx, q.dy);
          }
        }
        _c.drawPath(path2, _goldLine);
      case AxesKind.parabola:
        final h = (f.h ?? 0).toDouble();
        final m = (f.m ?? 0).toDouble();
        for (var x = -5.0; x <= 5; x += 0.12) {
          add(x, (x - h) * (x - h) * 0.35 + m);
        }
    }
    _c.drawPath(path, _goldLine);
    if (f.point != null) {
      final q = Offset(o.dx + f.point!.$1 * 18, o.dy - f.point!.$2 * 16);
      _dot(q, color: _gold, r: 3);
    }
  }

  void _lights(LightsFigure f) {
    final n = math.min(f.count, 12);
    for (var i = 0; i < n; i++) {
      final x = 0.08 + (i + 0.5) / n * 0.84;
      final o = p(x, 0.50);
      final sq = f.onSquares && _isSquare(i + 1);
      final hi = f.highlight == i + 1;
      _c.drawCircle(
        o,
        9,
        Paint()
          ..color = sq || hi ? _gold : _faint
          ..style = sq || hi ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      _label('${i + 1}', o + const Offset(0, 18), size: 10);
    }
  }

  bool _isSquare(int n) {
    final r = math.sqrt(n).round();
    return r * r == n;
  }

  void _lattice(LatticeFigure f) {
    final rx = math.max(1, f.right);
    final uy = math.max(1, f.up);
    const left = 0.16;
    const bot = 0.86;
    const right = 0.86;
    const top = 0.16;
    Offset at(int x, int y) => p(
          left + x / rx * (right - left),
          bot - y / uy * (bot - top),
        );
    for (var y = 0; y <= uy; y++) {
      _seg(at(0, y), at(rx, y), paint: _thin);
    }
    for (var x = 0; x <= rx; x++) {
      _seg(at(x, 0), at(x, uy), paint: _thin);
    }
    for (var y = 0; y <= uy; y++) {
      for (var x = 0; x <= rx; x++) {
        _dot(at(x, y), r: 2.4, color: _mute);
      }
    }
    _dot(at(0, 0), color: _gold, r: 3.2);
    _dot(at(rx, uy), color: _gold, r: 3.2);
    _label('S', at(0, 0) + const Offset(-12, 10));
    _label('T', at(rx, uy) + const Offset(12, -10));
    if (f.blockRight != null && f.blockUp != null) {
      final b = at(f.blockRight!, f.blockUp!);
      _c.drawCircle(b, 7, _goldLine);
      _label('×', b, color: _gold, size: 14);
    }
  }

  void _revolution(RevolutionFigure f) {
    final bot = p(0.50, 0.82);
    final rx = math.min(_size.width, _size.height) * 0.22;
    final ry = rx * 0.34;
    if (f.kind == RevolutionKind.cylinder) {
      final top = p(0.50, 0.20);
      _c.drawOval(Rect.fromCenter(center: top, width: rx * 2, height: ry * 2), _line);
      _c.drawOval(Rect.fromCenter(center: bot, width: rx * 2, height: ry * 2), _thin);
      _seg(top + Offset(-rx, 0), bot + Offset(-rx, 0));
      _seg(top + Offset(rx, 0), bot + Offset(rx, 0));
      _dash(top, bot);
      _mark(f.height, Offset(top.dx + rx + 16, (top.dy + bot.dy) / 2));
      _seg(bot, bot + Offset(rx, 0), paint: _thin);
      _mark(f.radius, Offset(bot.dx + rx / 2, bot.dy + 12));
      return;
    }
    final apex = p(0.50, 0.10);
    _c.drawOval(Rect.fromCenter(center: bot, width: rx * 2, height: ry * 2), _thin);
    final left = bot + Offset(-rx, 0);
    final right = bot + Offset(rx, 0);
    _seg(apex, left);
    _seg(apex, right);
    _dash(apex, bot);
    _rightMark(bot, apex, right);
    _seg(bot, right, paint: _thin);
    _mark(f.height, Offset(apex.dx - 14, (apex.dy + bot.dy) / 2));
    _mark(f.radius, Offset(bot.dx + rx / 2, bot.dy + 12));
    if (f.slant != null) {
      _mark(f.slant, Offset((apex.dx + right.dx) / 2 + 12, (apex.dy + right.dy) / 2));
    }
  }

  void _sphere(SphereFigure f) {
    final o = p(0.50, 0.50);
    final r = math.min(_size.width, _size.height) * 0.34;
    _c.drawCircle(o, r, _line);
    _c.drawOval(
      Rect.fromCenter(center: o, width: r * 2, height: r * 0.72),
      _thin,
    );
    _seg(o, o + Offset(r, 0), paint: _thin);
    _dot(o, r: 2);
    _label('O', o + const Offset(-10, -8));
    _mark(f.radius, Offset(o.dx + r / 2, o.dy - 12));
  }

  void _polygon(PolygonFigure f) {
    const o = FigPt(0, 0);
    const r = 1.0;
    final pts = figRegularPolygon(o, r, f.sides);
    final map = _fitMap([...pts, ...figCircleBox(o, r * 0.15)]);
    final verts = [for (final q in pts) map(q)];
    _poly(verts);
    if (f.fan && verts.length >= 4) {
      for (var i = 2; i < verts.length - 1; i++) {
        _dash(verts[0], verts[i]);
      }
    }
    if (f.exterior) {
      final ext = verts[0] + _unit(verts.last, verts[0]) * 40;
      _seg(verts[0], ext);
      _ask(f.angle ?? '?', _in(verts[0], verts[1], ext, 22));
    } else if (f.angle != null) {
      _ask(f.angle, _in(verts[0], verts[1], verts.last, 22));
    }
  }

  void _sector(SectorFigure f) {
    final o = p(0.46, 0.58);
    final r = math.min(_size.width, _size.height) * 0.36;
    _c.drawCircle(o, r, _thin);
    final start = 20.0;
    Offset polar(double deg) {
      final t = deg * math.pi / 180;
      return o + Offset(math.cos(t) * r, -math.sin(t) * r);
    }

    final a = polar(start);
    final b = polar(start + f.degrees);
    _seg(o, a);
    _seg(o, b);
    _c.drawArc(
      Rect.fromCircle(center: o, radius: r),
      -start * math.pi / 180,
      -f.degrees * math.pi / 180,
      false,
      f.arc == '?' ? _goldLine : _line,
    );
    _dot(o, r: 2);
    _label('O', o + const Offset(-12, 10));
    _mark(f.radius, Offset((o.dx + a.dx) / 2, (o.dy + a.dy) / 2), shift: const Offset(12, 0));
    _ask(f.angle ?? '${f.degrees}', _in(o, a, b, 28));
    if (f.arc != null) {
      final mid = polar(start + f.degrees / 2);
      _mark(f.arc, mid + _unit(o, mid) * 14);
    }
  }

  void _symmetry(SymmetryFigure f) {
    final px = f.x.toDouble();
    final py = f.y.toDouble();
    final p0 = FigPt(px, -py);
    final p1 = f.kind == SymmetryKind.xAxis ? FigPt(px, py) : FigPt(-px, py);
    final span = math.max(px, py) + 1.4;
    final map = _fitMap([
      p0,
      p1,
      FigPt(-span, 0),
      FigPt(span, 0),
      FigPt(0, -span),
      FigPt(0, span),
    ]);
    final o = map(const FigPt(0, 0));
    final a = map(p0);
    final b = map(p1);
    _seg(map(FigPt(-span, 0)), map(FigPt(span, 0)), paint: _thin);
    _seg(map(FigPt(0, span)), map(FigPt(0, -span)), paint: _thin);
    _label('x', map(FigPt(span, 0)) + const Offset(0, 12));
    _label('y', map(FigPt(0, -span)) + const Offset(12, 0));
    _dash(a, b);
    _dot(o, r: 1.8, color: _mute);
    _dot(a, r: 3);
    _dot(b, color: _gold, r: 3);
    _label('P', a + const Offset(10, -10));
    _label("P'", b + const Offset(10, 10), color: _gold);
  }

  void _net(NetFigure f) {
    final s = math.min(_size.width, _size.height) * (f.cube ? 0.20 : 0.18);
    final origin = Offset(
      _size.width / 2 - 2 * s,
      _size.height / 2 - 1.5 * s,
    );
    void cell(int col, int row) {
      final tl = origin + Offset(col * s, row * s);
      _c.drawRect(Rect.fromLTWH(tl.dx, tl.dy, s, s), _thin);
    }

    cell(1, 0);
    cell(0, 1);
    cell(1, 1);
    cell(2, 1);
    cell(3, 1);
    cell(1, 2);
    _label('6', origin + Offset(1.5 * s, 1.5 * s), color: _ink, size: 13);
  }

  void _reflect(ReflectPathFigure f) {
    final wallL = p(0.16, 0.12);
    final wallR = p(0.84, 0.12);
    final floorY = p(0.16, 0.48).dy;
    final floorL = Offset(wallL.dx, floorY);
    final floorR = Offset(wallR.dx, floorY);
    _seg(Offset(wallL.dx, p(0.16, 0.12).dy), Offset(wallL.dx, p(0.16, 0.88).dy), paint: _thin);
    _seg(Offset(wallR.dx, p(0.84, 0.12).dy), Offset(wallR.dx, p(0.84, 0.88).dy), paint: _thin);
    _seg(floorL, floorR);
    final a = Offset(wallL.dx, p(0.16, 0.28).dy);
    final b = Offset(wallR.dx, p(0.84, 0.22).dy);
    final bPrime = Offset(b.dx, floorY + (floorY - b.dy));
    final hit = Offset(
      a.dx + (bPrime.dx - a.dx) * (floorY - a.dy) / (bPrime.dy - a.dy),
      floorY,
    );
    _dash(b, bPrime);
    _dash(a, bPrime);
    _seg(a, hit, paint: _goldLine);
    _seg(hit, b, paint: _goldLine);
    _dot(a, r: 2);
    _dot(b, r: 2);
    _dot(bPrime, r: 2, color: _mute);
    _dot(hit, r: 2, color: _gold);
    _label('A', a + const Offset(-12, 0));
    _label('B', b + const Offset(12, 0));
    _label("B'", bPrime + const Offset(14, 0));
    _mark(f.width, Offset((floorL.dx + floorR.dx) / 2, floorY + 12));
    _mark(f.rise, Offset(wallR.dx + 16, (b.dy + bPrime.dy) / 2));
    _mark(
      f.path,
      Offset((hit.dx + bPrime.dx) / 2 - 14, (hit.dy + bPrime.dy) / 2),
    );
  }

  void _intercept(InterceptFigure f) {
    final a = p(0.50, 0.12);
    final b = p(0.12, 0.86);
    final c = p(0.88, 0.86);
    final den = math.max(1, f.ratioLeft + f.ratioRight);
    final t = f.ratioLeft / den;
    final d = Offset(a.dx + (b.dx - a.dx) * t, a.dy + (b.dy - a.dy) * t);
    final e = Offset(a.dx + (c.dx - a.dx) * t, a.dy + (c.dy - a.dy) * t);
    _poly([a, b, c]);
    _seg(d, e, paint: _goldLine);
    _ticks(d, e, n: 2);
    _ticks(b, c, n: 2);
    _label('A', a + const Offset(0, -12));
    _label('B', b + const Offset(-12, 10));
    _label('C', c + const Offset(12, 10));
    _label('D', d + const Offset(-12, 0));
    _label('E', e + const Offset(12, 0));
    _mark(f.ad, Offset((a.dx + d.dx) / 2, (a.dy + d.dy) / 2), shift: const Offset(-12, 0));
    _mark(f.db, Offset((d.dx + b.dx) / 2, (d.dy + b.dy) / 2), shift: const Offset(-12, 0));
    _mark(f.ae, Offset((a.dx + e.dx) / 2, (a.dy + e.dy) / 2), shift: const Offset(12, 0));
    _mark(f.ec, Offset((e.dx + c.dx) / 2, (e.dy + c.dy) / 2), shift: const Offset(12, 0));
  }

  @override
  bool shouldRepaint(covariant MathFigurePainter oldDelegate) =>
      oldDelegate.figure != figure;
}
