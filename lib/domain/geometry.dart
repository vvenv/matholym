/// Elementary / junior-high geometry helpers used by generators.
class Geometry {
  const Geometry._();

  static int complement(int a) => 90 - a;

  static int supplement(int a) => 180 - a;

  static int rectArea(int length, int width) => length * width;

  static int rectPerimeter(int length, int width) => 2 * (length + width);

  static int triangleArea(int base, int height) {
    assert(base * height % 2 == 0, '底乘高必须是偶数，面积才是整数');
    return base * height ~/ 2;
  }

  static int trapArea(int a, int b, int h) {
    assert((a + b) * h % 2 == 0, '上下底之和乘高必须是偶数');
    return (a + b) * h ~/ 2;
  }

  /// Circumference with π = 22/7. [r] should be a multiple of 7.
  static int circleCirc22(int r) {
    assert(r % 7 == 0, 'π 取 22/7 时半径要是 7 的倍数');
    return 2 * 22 * r ~/ 7;
  }

  static int circleArea22(int r) {
    assert(r % 7 == 0, 'π 取 22/7 时半径要是 7 的倍数');
    return 22 * r * r ~/ 7;
  }

  static int hypot3_4_5(int scale) => 5 * scale;

  static int boxVolume(int l, int w, int h) => l * w * h;

  static bool canTriangle(int a, int b, int c) {
    final x = [a, b, c]..sort();
    return x[0] + x[1] > x[2] && x[0] > 0;
  }

  static int similarSide({
    required int known,
    required int knownRatio,
    required int askRatio,
  }) {
    return known * askRatio ~/ knownRatio;
  }

  static int correspondingAngle(int given) => given;

  static int boxSurface(int l, int w, int h) => 2 * (l * w + l * h + w * h);

  static int cutSquare(int big, int cut) => big * big - cut * cut;

  static int inscribedFromCentral(int central) {
    assert(central % 2 == 0, '圆心角要是偶数，圆周角才是整数');
    return central ~/ 2;
  }

  static int cylinderVol22(int r, int h) => circleArea22(r) * h;

  static int coneVol22(int r, int h) {
    assert(cylinderVol22(r, h) % 3 == 0, '圆锥体积要能被 3 整除');
    return cylinderVol22(r, h) ~/ 3;
  }

  static int cylinderSide22(int r, int h) => circleCirc22(r) * h;

  static int polygonInterior(int n) => (n - 2) * 180;

  static int regularExterior(int n) {
    assert(360 % n == 0, '正多边形外角要整除 360');
    return 360 ~/ n;
  }

  static int sectorArc22(int r, int deg) {
    assert(circleCirc22(r) * deg % 360 == 0, '扇形弧长要是整数');
    return circleCirc22(r) * deg ~/ 360;
  }

  static int sectorArea22(int r, int deg) {
    assert(circleArea22(r) * deg % 360 == 0, '扇形面积要是整数');
    return circleArea22(r) * deg ~/ 360;
  }

  /// Sphere volume coefficient of π: (4/3)r³.
  static int sphereVolPi(int r) {
    assert(4 * r * r * r % 3 == 0, '球体积系数要能被 3 整除');
    return 4 * r * r * r ~/ 3;
  }

  /// Sphere surface coefficient of π: 4r².
  static int sphereSurfPi(int r) => 4 * r * r;

  /// Unfold opposite walls: straight-line length of a 3-4-5 path.
  static int unfoldHypot(int width, int rise) {
    return _hypotInt(width, rise);
  }

  static int hypotInt(int a, int b) => _hypotInt(a, b);

  /// Unfolded sector angle of a cone, in degrees.
  static int coneUnfoldDeg(int r, int l) {
    assert(360 * r % l == 0, '展开扇形圆心角要是整数');
    return 360 * r ~/ l;
  }

  /// Tangent length from the vertex opposite [a] to the incircle.
  static int incircleTangent(int a, int b, int c) {
    assert((b + c - a) % 2 == 0, '切线长要是整数');
    return (b + c - a) ~/ 2;
  }

  static int trapMidline(int a, int b) {
    assert((a + b) % 2 == 0, '中位线要是整数');
    return (a + b) ~/ 2;
  }

  static int similarArea({
    required int knownArea,
    required int knownRatio,
    required int askRatio,
  }) => knownArea * askRatio * askRatio ~/ (knownRatio * knownRatio);

  static int chordMate({required int a, required int b, required int c}) =>
      a * b ~/ c;

  static int tanSecant({required int external, required int whole}) {
    final prod = external * whole;
    var r = 1;
    while (r * r < prod) {
      r++;
    }
    return r;
  }

  static int interceptFourth({
    required int a,
    required int b,
    required int c,
  }) => b * c ~/ a;

  /// Angle bisector splits the opposite side in the ratio of the adjacent sides.
  static int bisectSegment({
    required int side,
    required int adjLeft,
    required int adjRight,
  }) => side * adjLeft ~/ (adjLeft + adjRight);

  static int altitudeArea({
    required int knownArea,
    required int knownBase,
    required int askBase,
  }) => knownArea * askBase ~/ knownBase;

  /// Tangential quadrilateral: a+c = b+d.
  static int tangentialFourth(int a, int b, int c) => a + c - b;

  static int exteriorAngle(int remote1, int remote2) => remote1 + remote2;

  static int isoBaseAngle(int vertex) {
    assert((180 - vertex) % 2 == 0, '等腰三角形底角要是整数');
    return (180 - vertex) ~/ 2;
  }

  static int isoVertex(int base) => 180 - 2 * base;

  /// Cyclic quad: exterior equals opposite interior.
  static int cyclicExterior(int oppositeInterior) => oppositeInterior;

  static int _hypotInt(int a, int b) {
    final s = a * a + b * b;
    var r = 1;
    while (r * r < s) {
      r++;
    }
    return r;
  }
}
