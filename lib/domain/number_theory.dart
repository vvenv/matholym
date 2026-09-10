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
    final q = dividend ~/ b;
    final r = dividend - b * q;
    return (q: q, r: r);
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
      if (!allowLeadingZero && digits.isNotEmpty && digits.first == null && d == 0) {
        continue;
      }
      final filled = [
        for (var i = 0; i < digits.length; i++) digits[i] ?? d,
      ];
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

  static bool answersEqual(String expected, String actual) {
    final a = normalizeAnswer(expected);
    final b = normalizeAnswer(actual);
    if (a == b) return true;
    final aYes = _truthy(a);
    final bYes = _truthy(b);
    if (aYes != null && bYes != null) return aYes == bYes;
    return false;
  }

  static bool? _truthy(String s) {
    const yes = {'是', '对', '能', '可以', 'yes', 'y', 'true', '1'};
    const no = {'否', '错', '不能', '不可以', 'no', 'n', 'false', '0'};
    if (yes.contains(s)) return true;
    if (no.contains(s)) return false;
    return null;
  }

  static bool numericallyClose(String expected, String actual) {
    final e = int.tryParse(normalizeAnswer(expected));
    final a = int.tryParse(normalizeAnswer(actual));
    if (e == null || a == null) return false;
    if (e == 0) return a == 0;
    return (e - a).abs() <= 2 || (e - a).abs() / e.abs() <= 0.08;
  }
}
