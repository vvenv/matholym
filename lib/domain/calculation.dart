import 'number_theory.dart';

/// Elementary calculation helpers used by generators.
class Calculation {
  const Calculation._();

  static ({int n, int d}) reduce(int n, int d) {
    if (d == 0) {
      throw ArgumentError('denominator must be non-zero');
    }
    if (d < 0) {
      n = -n;
      d = -d;
    }
    final g = NumberTheory.gcd(n.abs(), d);
    return (n: n ~/ g, d: d ~/ g);
  }

  static ({int n, int d}) addFrac(int a, int b, int c, int d) =>
      reduce(a * d + c * b, b * d);

  static ({int n, int d}) mulFrac(int a, int b, int c, int d) =>
      reduce(a * c, b * d);

  /// Sign of a/b − c/d.
  static int compareFrac(int a, int b, int c, int d) => a * d - c * b;

  /// 0.\dot{[digit]} = [digit]/9.
  static ({int n, int d}) repeatingOne(int digit) => reduce(digit, 9);

  /// 0.\overline{[ab]} = [ab]/99.
  static ({int n, int d}) repeatingTwo(int ab) => reduce(ab, 99);

  /// a ⊕ b = a + b + ab = (a+1)(b+1) − 1.
  static int star(int a, int b) => a + b + a * b;

  /// Σ_{k=a}^{b−1} 1/(k(k+1)) = 1/a − 1/b.
  static ({int n, int d}) telescoping(int a, int b) => reduce(b - a, a * b);

  static int mean(List<int> xs) {
    assert(xs.reduce((a, b) => a + b) % xs.length == 0, '平均数要是整数');
    return xs.reduce((a, b) => a + b) ~/ xs.length;
  }

  /// Digits used to number pages 1 through [n].
  static int pageDigits(int n) {
    var count = 0;
    var start = 1;
    var width = 1;
    while (start <= n) {
      final end = start * 10 - 1;
      final last = end < n ? end : n;
      count += (last - start + 1) * width;
      start *= 10;
      width++;
    }
    return count;
  }

  /// (a/b) / (c/d) = ad / bc.
  static ({int n, int d}) complexFrac(int a, int b, int c, int d) =>
      reduce(a * d, b * c);

  static int fracOf({required int total, required int num, required int den}) =>
      total * num ~/ den;

  static int fromFracOf({
    required int part,
    required int num,
    required int den,
  }) => part * den ~/ num;

  static int gaussSum(int n) => n * (n + 1) ~/ 2;

  static int oddSum(int n) => n * n;

  static int powInt(int base, int exp) {
    var r = 1;
    for (var i = 0; i < exp; i++) {
      r *= base;
    }
    return r;
  }

  static int roundTo({required int value, required int place}) {
    final half = place ~/ 2;
    return ((value + half) ~/ place) * place;
  }

  static int weightedMean(List<int> xs, List<int> ws) {
    var num = 0;
    var den = 0;
    for (var i = 0; i < xs.length; i++) {
      num += xs[i] * ws[i];
      den += ws[i];
    }
    assert(num % den == 0, '加权平均数要是整数');
    return num ~/ den;
  }

  static int sqDiff(int a, int b) => a * a - b * b;

  static int completeSq(int a, int b) => a * a + 2 * a * b + b * b;

  /// First [n] terms of a repeating [period].
  static int periodSum(List<int> period, int n) {
    final cycle = period.reduce((a, b) => a + b);
    final q = n ~/ period.length;
    final r = n % period.length;
    var extra = 0;
    for (var i = 0; i < r; i++) {
      extra += period[i];
    }
    return q * cycle + extra;
  }

  /// 1² + … + n².
  static int squareSum(int n) => n * (n + 1) * (2 * n + 1) ~/ 6;

  /// Line sum of an n×n magic square using 1…n².
  static int magicLine(int n) => n * (n * n + 1) ~/ 2;

  /// 1/n = 1/(n+1) + 1/(n(n+1)).
  static int egyptMate(int n) => n * (n + 1);

  /// Equal-distance round trip: 2ab/(a+b).
  static int harmonicSpeed(int a, int b) {
    assert(2 * a * b % (a + b) == 0, '往返平均速度要是整数');
    return 2 * a * b ~/ (a + b);
  }

  static int toMinutes(int hours, int minutes) => hours * 60 + minutes;

  static int kmToM(int km) => km * 1000;

  /// | (10a+b) − (10b+a) | = 9|a−b|.
  static int digitSwapDiff(int a, int b) => 9 * (a - b).abs();

  static int digitSwapSum(int a, int b) => 11 * (a + b);

  static const _loShu = [
    [2, 7, 6],
    [9, 5, 1],
    [4, 3, 8],
  ];

  /// One of the 8 Lo Shu orientations.
  static List<List<int>> magic3(int variant) {
    var g = [for (final row in _loShu) List<int>.from(row)];
    var v = variant % 8;
    if (v >= 4) {
      g = [for (final row in g) row.reversed.toList()];
      v -= 4;
    }
    for (var i = 0; i < v; i++) {
      g = [
        [g[2][0], g[1][0], g[0][0]],
        [g[2][1], g[1][1], g[0][1]],
        [g[2][2], g[1][2], g[0][2]],
      ];
    }
    return g;
  }

  /// 1³ + … + n³ = (1+…+n)².
  static int cubeSum(int n) {
    final s = gaussSum(n);
    return s * s;
  }

  /// Move the decimal point of tenths [tenths] by [shift] places right.
  /// e.g. 35 tenths (3.5) shift 2 → 350.
  static int shiftTenths(int tenths, int shift) {
    var r = tenths;
    for (var i = 1; i < shift; i++) {
      r *= 10;
    }
    return r;
  }

  static int timesTenPow(int n, int exp) => n * powInt(10, exp);
}
