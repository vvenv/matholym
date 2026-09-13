/// Pure number-theory helpers used by generators and tests.
class NumberTheory {
  const NumberTheory._();

  static int gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final t = a % b;
      a = b;
      b = t;
    }
    return a;
  }

  static int lcm(int a, int b) {
    if (a == 0 || b == 0) return 0;
    return (a.abs() ~/ gcd(a, b)) * b.abs();
  }

  static bool isCoprime(int a, int b) => gcd(a, b) == 1;

  static bool divides(int a, int b) {
    if (a == 0) return false;
    return b % a == 0;
  }

  static ({int q, int r}) divMod(int dividend, int divisor) {
    final b = divisor.abs();
    if (b == 0) {
      throw ArgumentError('divisor must be non-zero');
    }
    var q = dividend ~/ b;
    var r = dividend - b * q;
    if (r < 0) {
      q -= 1;
      r += b;
    }
    return (q: q, r: r);
  }

  /// Least non-negative residue of [a] modulo [m], [m] > 0.
  static int mod(int a, int m) {
    if (m <= 0) {
      throw ArgumentError('modulus must be positive');
    }
    return a % m;
  }

  static bool congruent(int a, int b, int m) => mod(a - b, m) == 0;

  static int powMod(int base, int exp, int m) {
    if (m <= 0) {
      throw ArgumentError('modulus must be positive');
    }
    if (m == 1) return 0;
    if (exp < 0) {
      throw ArgumentError('exponent must be non-negative');
    }
    var b = mod(base, m);
    var e = exp;
    var r = 1;
    while (e > 0) {
      if (e.isOdd) r = (r * b) % m;
      b = (b * b) % m;
      e ~/= 2;
    }
    return r;
  }

  static ({int g, int x, int y}) egcd(int a, int b) {
    var oldR = a;
    var r = b;
    var oldS = 1;
    var s = 0;
    var oldT = 0;
    var t = 1;
    while (r != 0) {
      final q = oldR ~/ r;
      final nextR = oldR - q * r;
      oldR = r;
      r = nextR;
      final nextS = oldS - q * s;
      oldS = s;
      s = nextS;
      final nextT = oldT - q * t;
      oldT = t;
      t = nextT;
    }
    if (oldR < 0) {
      return (g: -oldR, x: -oldS, y: -oldT);
    }
    return (g: oldR, x: oldS, y: oldT);
  }

  static int? inverseMod(int a, int m) {
    final e = egcd(mod(a, m), m);
    if (e.g != 1) return null;
    return mod(e.x, m);
  }

  static int phi(int n) {
    if (n <= 0) return 0;
    var result = n;
    var x = n;
    for (var p = 2; p * p <= x; p++) {
      if (x % p != 0) continue;
      while (x % p == 0) {
        x ~/= p;
      }
      result = result ~/ p * (p - 1);
    }
    if (x > 1) result = result ~/ x * (x - 1);
    return result;
  }

  /// Chinese remainder for two congruences. Null if inconsistent.
  static int? crt2(int a1, int m1, int a2, int m2) {
    if (m1 <= 0 || m2 <= 0) {
      throw ArgumentError('moduli must be positive');
    }
    final g = gcd(m1, m2);
    if ((a1 - a2) % g != 0) return null;
    final e = egcd(m1, m2);
    final l = (m1 ~/ g) * m2;
    final x = a1 + (m1 ~/ g) * (e.x * ((a2 - a1) ~/ g));
    return mod(x, l);
  }

  static ({int x, int y})? particular(int a, int b, int c) {
    final e = egcd(a, b);
    if (e.g == 0 || c % e.g != 0) return null;
    final k = c ~/ e.g;
    return (x: e.x * k, y: e.y * k);
  }

  static int _ceilDiv(int n, int d) {
    if (d <= 0) {
      throw ArgumentError('divisor must be positive');
    }
    if (n >= 0) return (n + d - 1) ~/ d;
    return n ~/ d;
  }

  /// Number of pairs with x > 0, y > 0 and [a]x + [b]y = [c].
  static int positiveSolutionCount(int a, int b, int c) {
    final p = particular(a, b, c);
    if (p == null) return 0;
    final g = gcd(a, b);
    final dx = b ~/ g;
    final dy = a ~/ g;
    // x = x0 + dx t > 0, y = y0 - dy t > 0  (when a,b > 0)
    if (a <= 0 || b <= 0) return 0;
    final minT = _ceilDiv(1 - p.x, dx);
    final maxT = floorDiv(p.y - 1, dy);
    if (maxT < minT) return 0;
    return maxT - minT + 1;
  }

  /// Floor division ⌊a/b⌋ for b > 0.
  static int floorDiv(int a, int b) {
    if (b <= 0) {
      throw ArgumentError('divisor must be positive');
    }
    final q = a ~/ b;
    if (a < 0 && a % b != 0) return q - 1;
    return q;
  }

  static int factorial(int n) {
    if (n < 0) {
      throw ArgumentError('factorial of a negative integer');
    }
    var r = 1;
    for (var i = 2; i <= n; i++) {
      r *= i;
    }
    return r;
  }

  /// Exponent of prime [p] in n!.
  static int factorialValuation(int n, int p) {
    if (p < 2 || !isPrime(p) || n < 0) return 0;
    var e = 0;
    var pk = p;
    while (pk <= n) {
      e += n ~/ pk;
      if (pk > n ~/ p) break;
      pk *= p;
    }
    return e;
  }

  static int residueInRange({
    required int modulus,
    required int residue,
    required int low,
    required int high,
  }) {
    var count = 0;
    final r = mod(residue, modulus);
    for (var k = low; k <= high; k++) {
      if (mod(k, modulus) == r) count++;
    }
    return count;
  }

  static bool isPrime(int n) {
    if (n <= 1) return false;
    if (n <= 3) return true;
    if (n.isEven || n % 3 == 0) return false;
    for (var i = 5; i * i <= n; i += 6) {
      if (n % i == 0 || n % (i + 2) == 0) return false;
    }
    return true;
  }

  static List<int> primesUpTo(int n) {
    if (n < 2) return const [];
    final sieve = List<bool>.filled(n + 1, true);
    sieve[0] = false;
    sieve[1] = false;
    for (var i = 2; i * i <= n; i++) {
      if (!sieve[i]) continue;
      for (var j = i * i; j <= n; j += i) {
        sieve[j] = false;
      }
    }
    final out = <int>[];
    for (var i = 2; i <= n; i++) {
      if (sieve[i]) out.add(i);
    }
    return out;
  }

  static int primeCountInRange(int low, int high) {
    if (high < 2 || high < low) return 0;
    final start = low < 2 ? 2 : low;
    var count = 0;
    for (var n = start; n <= high; n++) {
      if (isPrime(n)) count++;
    }
    return count;
  }

  static int nextPrime(int n) {
    var x = n + 1;
    while (!isPrime(x)) {
      x++;
    }
    return x;
  }

  static int smallestPrimeFactor(int n) {
    n = n.abs();
    if (n <= 1) return n;
    if (n.isEven) return 2;
    for (var i = 3; i * i <= n; i += 2) {
      if (n % i == 0) return i;
    }
    return n;
  }

  static List<int> positiveDivisors(int n) {
    n = n.abs();
    if (n == 0) return const [];
    final small = <int>[];
    final large = <int>[];
    for (var i = 1; i * i <= n; i++) {
      if (n % i != 0) continue;
      small.add(i);
      final pair = n ~/ i;
      if (pair != i) large.add(pair);
    }
    return [...small, ...large.reversed];
  }

  static Map<int, int> factorize(int n) {
    n = n.abs();
    final map = <int, int>{};
    if (n <= 1) return map;
    for (var p = 2; p * p <= n; p++) {
      var e = 0;
      while (n % p == 0) {
        n ~/= p;
        e++;
      }
      if (e > 0) map[p] = e;
    }
    if (n > 1) map[n] = 1;
    return map;
  }

  static int divisorCount(int n) {
    if (n.abs() <= 1) return n.abs() == 1 ? 1 : 0;
    return factorize(n).values.fold<int>(1, (p, e) => p * (e + 1));
  }

  static String formatFactorization(Map<int, int> factors) {
    if (factors.isEmpty) return '1';
    final keys = factors.keys.toList()..sort();
    return keys
        .map((p) {
          final e = factors[p]!;
          return e == 1 ? '$p' : '$p^$e';
        })
        .join('*');
  }

  static int digitSum(int n) {
    n = n.abs();
    var s = 0;
    while (n > 0) {
      s += n % 10;
      n ~/= 10;
    }
    return s;
  }

  /// Alternating digit sum from the right: d0 - d1 + d2 - ...
  static int alternatingDigitSum(int n) {
    n = n.abs();
    var s = 0;
    var sign = 1;
    while (n > 0) {
      s += sign * (n % 10);
      n ~/= 10;
      sign = -sign;
    }
    return s;
  }

  static bool divisibleBy2(int n) => n.abs().isEven;

  static bool divisibleBy3(int n) => digitSum(n) % 3 == 0;

  static bool divisibleBy5(int n) {
    final d = n.abs() % 10;
    return d == 0 || d == 5;
  }

  static bool divisibleBy9(int n) => digitSum(n) % 9 == 0;

  static bool divisibleBy11(int n) => alternatingDigitSum(n) % 11 == 0;

  static bool hasDivisibilityRule(int divisor, int n) {
    return switch (divisor) {
      2 => divisibleBy2(n),
      3 => divisibleBy3(n),
      5 => divisibleBy5(n),
      9 => divisibleBy9(n),
      11 => divisibleBy11(n),
      _ => divides(divisor, n),
    };
  }

  static int composeDigits(List<int> digits) {
    var n = 0;
    for (final d in digits) {
      n = n * 10 + d;
    }
    return n;
  }

  static int replaceDigit(int n, int indexFromLeft, int digit) {
    final s = n.abs().toString();
    if (indexFromLeft < 0 || indexFromLeft >= s.length) {
      throw RangeError('digit index out of range');
    }
    final chars = s.split('');
    chars[indexFromLeft] = '$digit';
    final value = int.parse(chars.join());
    return n < 0 ? -value : value;
  }

  /// Digits `d` (0–9) that make `digits` (null = blank) divisible by [divisor].
  static List<int> missingDigitCandidates({
    required List<int?> digits,
    required int divisor,
    bool allowLeadingZero = false,
  }) {
    final hits = <int>[];
    for (var d = 0; d <= 9; d++) {
      if (!allowLeadingZero &&
          digits.isNotEmpty &&
          digits.first == null &&
          d == 0) {
        continue;
      }
      final filled = [for (var i = 0; i < digits.length; i++) digits[i] ?? d];
      final n = composeDigits(filled);
      if (n % divisor == 0) hits.add(d);
    }
    return hits;
  }

  static String normalizeAnswer(String raw) {
    return raw
        .trim()
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll('×', '*')
        .replaceAll('⋅', '*')
        .replaceAll('·', '*')
        .replaceAll('，', ',')
        .replaceAll('、', ',')
        .toLowerCase();
  }

  static bool isPerfectSquare(int n) {
    if (n < 0) return false;
    var r = 0;
    while (r * r < n) {
      r++;
    }
    return r * r == n;
  }

  static int powerLast(int base, int exp) => powMod(base, exp, 10);

  static bool canBeSquareEnding(int digit) =>
      const {0, 1, 4, 5, 6, 9}.contains(digit % 10);

  static int divisorSum(int n) {
    n = n.abs();
    if (n == 0) return 0;
    var s = 0;
    for (var i = 1; i * i <= n; i++) {
      if (n % i != 0) continue;
      s += i;
      final pair = n ~/ i;
      if (pair != i) s += pair;
    }
    return s;
  }

  static int digitRoot(int n) {
    n = n.abs();
    if (n == 0) return 0;
    return 1 + (n - 1) % 9;
  }

  static int countMultiples(int n, int d) {
    if (d <= 0) {
      throw ArgumentError('d must be positive');
    }
    return n ~/ d;
  }

  static int oddDivisorCount(int n) {
    n = n.abs();
    if (n == 0) return 0;
    while (n.isEven) {
      n ~/= 2;
    }
    return divisorCount(n);
  }

  static int powerLastTwo(int base, int exp) => powMod(base, exp, 100);

  static int fromBase(List<int> digits, int base) {
    var n = 0;
    for (final d in digits) {
      n = n * base + d;
    }
    return n;
  }

  static int parseShown(int shown, int base) =>
      fromBase(shown.toString().split('').map(int.parse).toList(), base);

  /// Period of 1/n after stripping factors 2 and 5. 0 if terminating.
  static int recipPeriod(int n) {
    n = n.abs();
    if (n <= 1) return 0;
    while (n.isEven) {
      n ~/= 2;
    }
    while (n % 5 == 0) {
      n ~/= 5;
    }
    if (n == 1) return 0;
    var rem = 10 % n;
    var k = 1;
    while (rem != 1 && k <= n) {
      rem = (rem * 10) % n;
      k++;
    }
    return k;
  }

  static int nextMultipleAbove(int n, int d) => n + (d - n % d);

  static int consecProductDivisor(int k) => factorial(k);

  static int mulShown(int a, int b, int base) =>
      parseShown(a, base) * parseShown(b, base);

  static int repunit(int n) {
    var r = 0;
    for (var i = 0; i < n; i++) {
      r = r * 10 + 1;
    }
    return r;
  }

  static int trailingZeros(int n) => factorialValuation(n, 5);

  /// Marks [actual] against [expected]. Equal values written differently are
  /// equal answers: `2/4` for `1/2`, `0.5` for `1/2`, `2*2*7` for `2^2*7`.
  /// Formatting instructions in a stem ask for a tidy answer; they are not a
  /// second question, so a right value is never marked wrong on spelling.
  static bool answersEqual(String expected, String actual) {
    final a = normalizeAnswer(expected);
    final b = normalizeAnswer(actual);
    if (a == b) return true;
    // Only a judge question grades 是/否, and only there does a typed 1 or 0
    // mean yes or no — otherwise `1` is the number one.
    final wanted = _judgeWord(a);
    if (wanted != null) return _judgeInput(b) == wanted;
    final ra = _rational(a);
    if (ra != null) {
      final rb = _rational(b);
      if (rb != null) return ra.n * rb.d == rb.n * ra.d;
      return false;
    }
    final fa = _factorProduct(a);
    if (fa != null) return fa == _factorProduct(b);
    return false;
  }

  /// A written yes/no, as an answer is allowed to be spelled.
  static bool? _judgeWord(String s) {
    const yes = {'是', '对', '能', '可以', 'yes', 'y', 'true'};
    const no = {'否', '错', '不能', '不可以', 'no', 'n', 'false'};
    if (yes.contains(s)) return true;
    if (no.contains(s)) return false;
    return null;
  }

  /// What a student may type for yes/no, including 1 and 0.
  static bool? _judgeInput(String s) =>
      s == '1' ? true : (s == '0' ? false : _judgeWord(s));

  /// `-3`, `7/2` or `0.25` as an exact fraction. Null for anything else.
  static ({int n, int d})? _rational(String s) {
    final frac = RegExp(r'^(-?\d+)/(-?\d+)$').firstMatch(s);
    if (frac != null) {
      final d = int.parse(frac.group(2)!);
      if (d == 0) return null;
      return _signed(int.parse(frac.group(1)!), d);
    }
    final dec = RegExp(r'^(-?)(\d+)\.(\d+)$').firstMatch(s);
    if (dec != null) {
      var scale = 1;
      for (var i = 0; i < dec.group(3)!.length; i++) {
        scale *= 10;
      }
      final whole = int.parse(dec.group(2)!) * scale + int.parse(dec.group(3)!);
      return _signed(dec.group(1)! == '-' ? -whole : whole, scale);
    }
    final n = int.tryParse(s);
    return n == null ? null : (n: n, d: 1);
  }

  static ({int n, int d}) _signed(int n, int d) =>
      d < 0 ? (n: -n, d: -d) : (n: n, d: d);

  /// The number a factorisation spells out, so `2*2*7`, `7*2^2` and `2^2*7`
  /// all mark the same. Null when the string is not a product of powers.
  static int? _factorProduct(String s) {
    if (!s.contains('*') && !s.contains('^')) return null;
    var product = 1;
    for (final part in s.split('*')) {
      final m = RegExp(r'^(\d+)(?:\^(\d+))?$').firstMatch(part.trim());
      if (m == null) return null;
      final base = int.parse(m.group(1)!);
      final exp = int.parse(m.group(2) ?? '1');
      if (base < 2 || exp < 1 || exp > 40) return null;
      for (var i = 0; i < exp; i++) {
        product *= base;
        if (product > 1 << 52) return null;
      }
    }
    return product;
  }

  static bool numericallyClose(String expected, String actual) {
    final e = int.tryParse(normalizeAnswer(expected));
    final a = int.tryParse(normalizeAnswer(actual));
    if (e == null || a == null) return false;
    if (e == 0) return a == 0;
    return (e - a).abs() <= 2 || (e - a).abs() / e.abs() <= 0.08;
  }
}
