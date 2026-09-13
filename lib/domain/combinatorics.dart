import 'number_theory.dart';

/// Counting helpers used by combinatorics generators.
class Counting {
  const Counting._();

  static int factorial(int n) => NumberTheory.factorial(n);

  static int perm(int n, int k) {
    if (k < 0 || n < 0 || k > n) return 0;
    var r = 1;
    for (var i = 0; i < k; i++) {
      r *= n - i;
    }
    return r;
  }

  static int comb(int n, int k) {
    if (k < 0 || n < 0 || k > n) return 0;
    k = k < n - k ? k : n - k;
    var r = 1;
    for (var i = 1; i <= k; i++) {
      r = r * (n - k + i) ~/ i;
    }
    return r;
  }

  /// Lattice paths from (0,0) to ([right],[up]) using only right and up steps.
  static int latticePaths(int right, int up) => comb(right + up, right);

  static int pigeonholeGuarantee({required int holes, required int perHole}) {
    if (holes <= 0 || perHole <= 0) return 0;
    return holes * (perHole - 1) + 1;
  }

  /// Ways to climb [n] stairs taking 1 or 2 steps.
  static int stairWays(int n) {
    if (n <= 2) return n < 0 ? 0 : n;
    var a = 1;
    var b = 2;
    for (var i = 3; i <= n; i++) {
      final c = a + b;
      a = b;
      b = c;
    }
    return b;
  }

  static int handshake(int n) => comb(n, 2);

  static int colorings(int objects, int colors) {
    var r = 1;
    for (var i = 0; i < objects; i++) {
      r *= colors;
    }
    return r;
  }

  static int chessBlack(int rows, int cols) => (rows * cols + 1) ~/ 2;

  static int circlePerm(int n) => n <= 0 ? 0 : factorial(n - 1);

  static int starsBars({required int items, required int bins}) =>
      comb(items + bins - 1, bins - 1);

  static int starsBarsPositive({required int items, required int bins}) =>
      comb(items - 1, bins - 1);

  static int inclusion3({
    required int a,
    required int b,
    required int c,
    required int ab,
    required int ac,
    required int bc,
    required int abc,
  }) => a + b + c - ab - ac - bc + abc;

  static int derange(int n) {
    const table = [1, 0, 1, 2, 9, 44, 265];
    if (n < 0 || n >= table.length) {
      throw ArgumentError('derange supports 0–6');
    }
    return table[n];
  }

  static int permWithRepeat(int n, int repeats) =>
      factorial(n) ~/ factorial(repeats);

  /// Choose [k] of [n] positions with no two adjacent.
  static int nonAdjacent(int n, int k) => comb(n - k + 1, k);

  /// n people in a line, two named people not adjacent.
  static int lineTwoApart(int n) => (n - 2) * factorial(n - 1);

  /// 2n distinct people into two unlabeled groups of n.
  static int unlabeledHalves(int n) => comb(2 * n, n) ~/ 2;

  static int adjColor(int n, int colors) {
    var r = colors;
    for (var i = 1; i < n; i++) {
      r *= colors - 1;
    }
    return r;
  }

  static int binomRow(int n) => 1 << n;

  static int catalan(int n) => comb(2 * n, n) ~/ (n + 1);

  /// n beads in a fixed circle, [colors] colors, adjacent different.
  static int cycleColor(int n, int colors) {
    var p = 1;
    for (var i = 0; i < n; i++) {
      p *= colors - 1;
    }
    return p + (n.isEven ? 1 : -1) * (colors - 1);
  }

  static int atLeastOne(int n) => (1 << n) - 1;

  static int latticeAvoid({
    required int right,
    required int up,
    required int blockR,
    required int blockU,
  }) {
    final total = latticePaths(right, up);
    if (blockR < 0 || blockU < 0 || blockR > right || blockU > up) {
      return total;
    }
    if ((blockR == 0 && blockU == 0) || (blockR == right && blockU == up)) {
      return 0;
    }
    return total -
        latticePaths(blockR, blockU) *
            latticePaths(right - blockR, up - blockU);
  }

  static int partition(int n) {
    const table = [1, 1, 2, 3, 5, 7, 11, 15, 22, 30];
    if (n < 0 || n >= table.length) {
      throw ArgumentError('partition supports 0–9');
    }
    return table[n];
  }

  static int splitTwo(int n) => n ~/ 2;

  static int hockeyRight(int n, int k) => comb(n + 1, k + 1);

  static int atLeast(int n, int k) {
    var s = 0;
    for (var i = k; i <= n; i++) {
      s += comb(n, i);
    }
    return s;
  }
}
