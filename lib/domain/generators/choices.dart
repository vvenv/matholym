import 'dart:math';

import '../calculation.dart';
import '../number_theory.dart';
import 'question.dart';

/// Multiple-choice options for a generated question.
///
/// Distractors come from the answer's *value*, never from its spelling: a
/// fraction answer yields fractions, a factorization yields factorizations,
/// a negative answer keeps the sign flip in the bank. Nothing is ever padded
/// with a suffixed copy of the answer — `4/3` next to `4/31` gives the game
/// away. Each bank leads with the mistake a student actually makes.
class QuestionOptions {
  static List<String> of(GeneratedQuestion q) {
    if (q.kind == QuestionKind.judge) return const ['是', '否'];
    final answer = q.answer.trim();
    final bank = q.choices.isNotEmpty
        ? q.choices
        : bankFor(answer, range: q.answerRange);
    return _assemble(answer, bank, q.seed);
  }

  /// The distractor pool for [answer], richest plausible error first. Empty
  /// when the answer has a shape no bank understands; `choices_test` keeps the
  /// catalogue clear of those.
  static List<String> bankFor(String answer, {({int min, int max})? range}) {
    final n = int.tryParse(answer);
    if (n != null) return _ints(n, range);
    final frac = _parseFrac(answer);
    if (frac != null) return _fracs(frac.n, frac.d);
    final list = _parseList(answer);
    if (list != null) return list.length == 2 ? _pair(list) : _list(list);
    final factors = _parseFactored(answer);
    if (factors != null) return _factored(factors);
    return const [];
  }

  static List<String> _assemble(String answer, List<String> bank, int seed) {
    final rest = <String>[];
    final seen = <String>{answer};
    for (final raw in bank) {
      final item = raw.trim();
      if (item.isEmpty || !seen.add(item)) continue;
      if (_sameValue(item, answer)) continue;
      if (rest.any((e) => _sameValue(e, item))) continue;
      rest.add(item);
    }
    rest.shuffle(Random(seed));
    final out = [answer, ...rest.take(3)]..shuffle(Random(seed + 1));
    return out;
  }

  // --- integers -------------------------------------------------------------

  static List<String> _ints(int n, [({int min, int max})? range]) {
    final out = <int>[
      n + 1,
      n - 1,
      n + 2,
      n - 2,
      if (n < 0) -n,
      if (n != 0 && n.abs() > 3) n * 2,
      if (n != 0 && n.isEven) n ~/ 2,
      n + 3,
      n - 3,
      n + 10,
      n + 4,
      n - 4,
      n + 5,
    ];
    // A count, a length or an area is never negative: a negative option there
    // reads as a typo rather than a wrong answer.
    var keep = n >= 0 ? out.where((e) => e >= 0).toList() : out;
    if (range != null) {
      keep = keep.where((e) => e >= range.min && e <= range.max).toList();
      // A tight range can leave too few neighbours; walk outwards from the
      // answer to fill the bank with values that are at least admissible.
      for (var step = 1; keep.length < 6; step++) {
        final lo = n - step;
        final hi = n + step;
        if (lo < range.min && hi > range.max) break;
        if (lo >= range.min) keep.add(lo);
        if (hi <= range.max) keep.add(hi);
      }
    }
    return keep.map((e) => '$e').toList();
  }

  // --- fractions ------------------------------------------------------------

  static List<String> _fracs(int p, int q) {
    final raw = <({int n, int d})>[
      (n: p + 1, d: q),
      (n: p - 1, d: q),
      (n: p, d: q + 1),
      (n: p, d: q - 1),
      (n: q, d: p), // flipped
      (n: p + 1, d: q + 1),
      (n: p * 2, d: q),
      (n: p, d: q * 2),
      (n: p + q, d: q),
      (n: p * 2, d: q * 2 + 1),
      (n: p + 2, d: q),
      (n: p, d: q + 2),
    ];
    final out = <String>[];
    for (final f in raw) {
      if (f.d <= 0 || f.n <= 0) continue;
      final r = Calculation.reduce(f.n, f.d);
      // Keep every option a proper fraction; an integer among fractions is
      // recognisable without doing the arithmetic.
      if (r.d == 1) continue;
      out.add('${r.n}/${r.d}');
    }
    return out;
  }

  static ({int n, int d})? _parseFrac(String s) {
    final m = RegExp(r'^(-?\d+)/(\d+)$').firstMatch(s);
    if (m == null) return null;
    final d = int.parse(m.group(2)!);
    if (d == 0) return null;
    return (n: int.parse(m.group(1)!), d: d);
  }

  // --- comma-separated answers ---------------------------------------------

  /// `商,余数`: perturb each part, and offer the swap.
  static List<String> _pair(List<int> xs) {
    final a = xs[0];
    final b = xs[1];
    return <List<int>>[
      [a + 1, b],
      [a, b + 1],
      [a - 1, b],
      [a, b - 1],
      [b, a],
      [a + 1, b - 1],
      [a - 1, b + 1],
      [a + 2, b],
      [a, b + 2],
    ].where((e) => e.every((v) => v >= 0)).map((e) => e.join(',')).toList();
  }

  /// An increasing list, typically primes: the classic slips are counting 1
  /// in, letting one composite through, and stopping a term early or late.
  static List<String> _list(List<int> xs) {
    final last = xs.last;
    final out = <List<int>>[];
    if (xs.first != 1) out.add([1, ...xs]);
    for (final composite in const [9, 15, 21, 25, 27, 33, 35, 49]) {
      if (composite < last && !xs.contains(composite)) {
        out.add([...xs, composite]..sort());
        break;
      }
    }
    out
      ..add(xs.sublist(0, xs.length - 1))
      ..add([...xs, last + 2])
      ..add([...xs.sublist(0, xs.length - 1), last + 2])
      ..add(xs.sublist(1))
      ..add([...xs, last + 4]);
    return out.where((e) => e.length > 1).map((e) => e.join(',')).toList();
  }

  static List<int>? _parseList(String s) {
    if (!s.contains(',')) return null;
    final parts = s.split(',');
    final out = <int>[];
    for (final part in parts) {
      final v = int.tryParse(part.trim());
      if (v == null) return null;
      out.add(v);
    }
    return out;
  }

  // --- prime factorisations -------------------------------------------------

  /// Wrong exponents, a missing factor, a prime swapped for its neighbour —
  /// each rendered in the same canonical ascending form as the answer.
  static List<String> _factored(List<({int p, int e})> factors) {
    final out = <String>[];
    void add(List<({int p, int e})> f) {
      final kept = f.where((e) => e.e > 0).toList()
        ..sort((x, y) => x.p.compareTo(y.p));
      if (kept.isEmpty) return;
      out.add(_renderFactored(kept));
    }

    for (var i = 0; i < factors.length; i++) {
      add([
        for (var j = 0; j < factors.length; j++)
          j == i ? (p: factors[j].p, e: factors[j].e + 1) : factors[j],
      ]);
      add([
        for (var j = 0; j < factors.length; j++)
          j == i ? (p: factors[j].p, e: factors[j].e - 1) : factors[j],
      ]);
    }
    final used = factors.map((e) => e.p).toSet();
    for (final p in const [2, 3, 5, 7, 11, 13]) {
      if (used.contains(p)) continue;
      add([...factors, (p: p, e: 1)]);
      add([
        for (var j = 0; j < factors.length; j++)
          j == factors.length - 1 ? (p: p, e: factors[j].e) : factors[j],
      ]);
      break;
    }
    return out;
  }

  static String _renderFactored(List<({int p, int e})> f) =>
      f.map((e) => e.e == 1 ? '${e.p}' : '${e.p}^${e.e}').join('*');

  static List<({int p, int e})>? _parseFactored(String s) {
    if (!s.contains('*') && !s.contains('^')) return null;
    final out = <({int p, int e})>[];
    for (final part in s.split('*')) {
      final m = RegExp(r'^(\d+)(?:\^(\d+))?$').firstMatch(part.trim());
      if (m == null) return null;
      final p = int.parse(m.group(1)!);
      final e = int.parse(m.group(2) ?? '1');
      if (p < 2 || e < 1) return null;
      out.add((p: p, e: e));
    }
    return out.isEmpty ? null : out;
  }

  /// Two option strings that a marker would accept as the same answer, so the
  /// bank never shows `1/2` and `2/4` side by side.
  static bool _sameValue(String a, String b) => NumberTheory.answersEqual(a, b);
}
