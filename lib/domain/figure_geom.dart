import 'dart:math' as math;

/// Canvas points: x right, y down. Angles in degrees, counterclockwise from +x
/// (90° is up, so the y component is −sin).
class FigPt {
  const FigPt(this.x, this.y);

  final double x;
  final double y;

  FigPt operator -() => FigPt(-x, -y);
  FigPt operator +(FigPt o) => FigPt(x + o.x, y + o.y);
  FigPt operator -(FigPt o) => FigPt(x - o.x, y - o.y);
  FigPt operator *(double s) => FigPt(x * s, y * s);

  double get len => math.sqrt(x * x + y * y);

  double dist(FigPt o) => (this - o).len;

  double dot(FigPt o) => x * o.x + y * o.y;

  FigPt get unit {
    final n = len;
    return n < 1e-9 ? const FigPt(0, 0) : FigPt(x / n, y / n);
  }
}

FigPt figPolar(FigPt o, double r, double deg) {
  final t = deg * math.pi / 180;
  return FigPt(o.x + math.cos(t) * r, o.y - math.sin(t) * r);
}

/// Outward unit normal of the tangent at [deg].
FigPt figNormal(double deg) {
  final t = deg * math.pi / 180;
  return FigPt(math.cos(t), -math.sin(t));
}

/// Intersection of tangents that touch the circle at [degA] and [degB].
FigPt figTangentVertex(FigPt o, double r, double degA, double degB) {
  final n1 = figNormal(degA);
  final n2 = figNormal(degB);
  final det = n1.x * n2.y - n1.y * n2.x;
  return FigPt(o.x + r * (n2.y - n1.y) / det, o.y + r * (n1.x - n2.x) / det);
}

/// Vertices of a tangential quadrilateral, in order. [touchDegs] are the
/// four contact points going around the circle.
List<FigPt> figTangentialQuad(FigPt o, double r, List<double> touchDegs) {
  return [
    for (var i = 0; i < 4; i++)
      figTangentVertex(o, r, touchDegs[i], touchDegs[(i + 1) % 4]),
  ];
}

double figPointLineDist(FigPt p, FigPt a, FigPt b) {
  final ab = b - a;
  final n = ab.len;
  if (n < 1e-9) return p.dist(a);
  return ((b.x - a.x) * (a.y - p.y) - (a.x - p.x) * (b.y - a.y)).abs() / n;
}

/// The two contact points of tangents from [p] to circle (o, r).
(FigPt, FigPt) figTangentsFrom(FigPt o, double r, FigPt p) {
  final v = p - o;
  final d2 = v.dot(v);
  final mid = o + v * (r * r / d2);
  final h = r * math.sqrt(d2 - r * r) / d2;
  final perp = FigPt(-v.y, v.x) * h;
  return (mid + perp, mid - perp);
}

/// Intersections of the ray/line through [p] with direction [dir], nearer first.
List<FigPt> figLineCircle(FigPt p, FigPt dir, FigPt o, double r) {
  final u = dir.unit;
  final f = p - o;
  final b = 2 * f.dot(u);
  final c = f.dot(f) - r * r;
  final disc = b * b - 4 * c;
  final s = math.sqrt(math.max(0, disc));
  final t1 = (-b - s) / 2;
  final t2 = (-b + s) / 2;
  final a = p + u * t1;
  final bpt = p + u * t2;
  return a.dist(p) <= bpt.dist(p) ? [a, bpt] : [bpt, a];
}

FigPt figIncenter(FigPt a, FigPt b, FigPt c) {
  final la = b.dist(c);
  final lb = c.dist(a);
  final lc = a.dist(b);
  final p = la + lb + lc;
  return FigPt(
    (la * a.x + lb * b.x + lc * c.x) / p,
    (la * a.y + lb * b.y + lc * c.y) / p,
  );
}

double figInradius(FigPt a, FigPt b, FigPt c) {
  final la = b.dist(c);
  final lb = c.dist(a);
  final lc = a.dist(b);
  final s = (la + lb + lc) / 2;
  final area =
      0.5 * ((b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)).abs();
  return area / s;
}

bool figCollinear(FigPt a, FigPt b, FigPt c, {double eps = 1e-6}) {
  final area = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
  return area.abs() <= eps * (1 + a.dist(b) + a.dist(c));
}

bool figOnCircle(FigPt p, FigPt o, double r, {double eps = 1e-6}) =>
    (p.dist(o) - r).abs() <= eps;

bool figPerp(FigPt a, FigPt b, {double eps = 1e-5}) {
  final na = a.len;
  final nb = b.len;
  if (na < 1e-9 || nb < 1e-9) return false;
  return a.dot(b).abs() <= eps * na * nb;
}

FigPt? figIntersect(FigPt a, FigPt b, FigPt c, FigPt d) {
  final den = (a.x - b.x) * (c.y - d.y) - (a.y - b.y) * (c.x - d.x);
  if (den.abs() < 1e-9) return null;
  final t = ((a.x - c.x) * (c.y - d.y) - (a.y - c.y) * (c.x - d.x)) / den;
  return FigPt(a.x + t * (b.x - a.x), a.y + t * (b.y - a.y));
}

/// Angle bisector from [c] meets [a]–[b] at this point.
FigPt figBisectorFoot(FigPt a, FigPt b, FigPt c) {
  final ac = c.dist(a);
  final bc = c.dist(b);
  return FigPt(
    (bc * a.x + ac * b.x) / (ac + bc),
    (bc * a.y + ac * b.y) / (ac + bc),
  );
}

/// Prototype triangle in the unit square: base on y=1, apex near the top.
const figSimilarShape = [FigPt(0, 1), FigPt(1, 1), FigPt(0.38, 0)];

/// Contact angles for the standard tangential-quad illustration.
/// Uneven gaps so the figure is a general tangential quad, not a rhombus.
const figTouchDegs = [18.0, 108.0, 168.0, 292.0];

/// Endpoints of two chords that cross inside the circle: A,B then C,D.
const figChordDegs = [128.0, 338.0, 52.0, 218.0];

List<FigPt> figPlace(List<FigPt> shape, FigPt origin, double scale) => [
  for (final q in shape) origin + q * scale,
];

List<FigPt> figCircleBox(FigPt o, double r) => [
  FigPt(o.x - r, o.y),
  FigPt(o.x + r, o.y),
  FigPt(o.x, o.y - r),
  FigPt(o.x, o.y + r),
];

class FigTangentialQuadLayout {
  const FigTangentialQuadLayout({
    required this.o,
    required this.r,
    required this.touch,
    required this.vertices,
  });

  final FigPt o;
  final double r;
  final List<FigPt> touch;
  final List<FigPt> vertices;
}

FigTangentialQuadLayout figStandardTangentialQuad() {
  const o = FigPt(0, 0);
  const r = 1.0;
  return FigTangentialQuadLayout(
    o: o,
    r: r,
    touch: [for (final d in figTouchDegs) figPolar(o, r, d)],
    vertices: figTangentialQuad(o, r, figTouchDegs),
  );
}

class FigTwoTangentsLayout {
  const FigTwoTangentsLayout({
    required this.o,
    required this.r,
    required this.p,
    required this.a,
    required this.b,
  });

  final FigPt o;
  final double r;
  final FigPt p;
  final FigPt a;
  final FigPt b;
}

FigTwoTangentsLayout figStandardTwoTangents() {
  const o = FigPt(0, 0);
  const r = 1.0;
  const p = FigPt(-2.15, 0);
  final t = figTangentsFrom(o, r, p);
  return FigTwoTangentsLayout(o: o, r: r, p: p, a: t.$1, b: t.$2);
}

class FigSecantLayout {
  const FigSecantLayout({
    required this.o,
    required this.r,
    required this.p,
    required this.a,
    required this.b,
    required this.t,
  });

  final FigPt o;
  final double r;
  final FigPt p;
  final FigPt a;
  final FigPt b;
  final FigPt t;
}

FigSecantLayout figStandardSecant() {
  const o = FigPt(0, 0);
  const r = 1.0;
  const p = FigPt(-2.4, 0.78);
  final hits = figLineCircle(p, const FigPt(1, -0.28), o, r);
  final ts = figTangentsFrom(o, r, p);
  final t = ts.$1.y < ts.$2.y ? ts.$1 : ts.$2;
  return FigSecantLayout(o: o, r: r, p: p, a: hits[0], b: hits[1], t: t);
}

List<FigPt> figStandardChords(FigPt o, double r) => [
  for (final d in figChordDegs) figPolar(o, r, d),
];

List<FigPt> figRegularPolygon(
  FigPt o,
  double r,
  int n, {
  double startDeg = 90,
}) {
  final k = math.max(3, n);
  return [for (var i = 0; i < k; i++) figPolar(o, r, startDeg + 360.0 * i / k)];
}
