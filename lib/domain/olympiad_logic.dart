import 'dart:math';

/// Parameterized logic / olympiad-reasoning helpers.
class OlympiadLogic {
  const OlympiadLogic._();

  static bool isEven(int n) => n.isEven;

  /// Ternary balance: lightest number of weighings that can isolate 1 among [n].
  static int weighings(int n) {
    if (n <= 1) return 0;
    var cap = 1;
    var w = 0;
    while (cap < n) {
      cap *= 3;
      w++;
    }
    return w;
  }

  /// 0 = Sunday … 6 = Saturday.
  static int weekdayShift(int start, int days) => ((start + days) % 7 + 7) % 7;

  /// Acute-or-straight angle between hour and minute hands, in degrees.
  /// [minute] must be even so the hour hand lands on an integer degree.
  static int clockAngle(int hour, int minute) {
    final ha = 30 * (hour % 12) + minute ~/ 2;
    final ma = 6 * minute;
    var diff = (ha - ma).abs();
    if (diff > 180) diff = 360 - diff;
    return diff;
  }

  static int smallestWithDigitSum({required int digits, required int sum}) {
    final buf = List<int>.filled(digits, 0);
    buf[0] = 1;
    var left = sum - 1;
    for (var i = digits - 1; i >= 0 && left > 0; i--) {
      final room = i == 0 ? 8 : 9;
      final add = min(room, left);
      buf[i] += add;
      left -= add;
    }
    return buf.fold(0, (a, b) => a * 10 + b);
  }

  static int largestWithDigitSum({required int digits, required int sum}) {
    final buf = List<int>.filled(digits, 0);
    var left = sum;
    for (var i = 0; i < digits && left > 0; i++) {
      final add = min(9, left);
      buf[i] = add;
      left -= add;
    }
    return buf.fold(0, (a, b) => a * 10 + b);
  }

  /// Cycle report: the [n]-th person says a number in 1…[mod].
  static int cycleReport(int n, int mod) => ((n - 1) % mod) + 1;

  /// Flip two coins at a time. Tails-count parity is invariant.
  static bool canClearTails(int tails) => tails.isEven;

  /// First-player winning take in subtraction game (1…[takeMax]).
  /// 0 means the position is losing if both play optimally.
  static int nimFirstTake(int n, int takeMax) => n % (takeMax + 1);

  static int twoWorkerMin(int a, int b, int c) {
    final opts = [max(a + b, c), max(a + c, b), max(b + c, a)];
    return opts.reduce(min);
  }

  static int queueWait({required int ahead, required int minutes}) =>
      ahead * minutes;

  static int ropePieces(int cuts) => cuts + 1;

  static int ropeCuts(int pieces) => pieces - 1;

  static int maxLoad({required int cap, required int each}) => cap ~/ each;

  /// Capacity-2 boat, one rower returns. Trips for [n] people, n ≥ 2.
  static int boatTrips(int n) => 2 * n - 3;

  static int boatReturns(int n) => n - 2;

  static int knockoutMatches(int n) => n - 1;

  static int roundRobin(int n) => n * (n - 1) ~/ 2;

  /// 1-based seats on an even circle.
  static int oppositeSeat(int n, int k) {
    assert(n % 2 == 0, '只有偶数人时才有正对面的人');
    return (k - 1 + n ~/ 2) % n + 1;
  }

  static int clockwiseSeat(int n, int start, int steps) =>
      (start - 1 + steps) % n + 1;

  static int fromRight(int n, int k) => n - k + 1;

  static int weighIfBalance(int total) {
    assert(total % 3 == 0, '三等分称重要能整除 3');
    return total ~/ 3;
  }

  static int weighIfTilt(int total) {
    assert(total % 3 == 0, '三等分称重要能整除 3');
    return 2 * (total ~/ 3);
  }

  /// {x, x+1, x+2}; A says “is x”, B says “is not x+1”; exactly one true.
  static int liarTriple(int x) => x + 2;

  /// n odd; A says even, B says greater than n; exactly one true.
  static int liarAroundOdd(int n) => n - 1;

  /// Candidates x,x+1,x+2; A says “is x+1”, B says “> x”; both false → x.
  static int bothFalse(int x) => x;

  /// The canonical crossing: goat over, back empty, wolf over, goat back,
  /// cabbage over, back empty, goat over.
  static const wolfTrips = 7;

  /// Crossings with nobody but the farmer aboard (2nd and 6th).
  static const wolfEmptyTrips = 2;

  /// Crossings that go left to right (1st, 3rd, 5th, 7th).
  static const wolfForwardTrips = 4;

  static const goatOnBoat = 3;
  static const wolfOnBoat = 1;
  static const cabbageOnBoat = 1;

  /// A: is x; B: > x; C: < x+2. Exactly one true → x+2.
  static int threeSay(int x) => x + 2;

  static int lightsOn(int n) {
    var r = 1;
    while (r * r <= n) {
      r++;
    }
    return r - 1;
  }

  /// The only consistent “exactly k are true” is k = 1.
  static int exactlyKTrueIndex() => 1;
}
