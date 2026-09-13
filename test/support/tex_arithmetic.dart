/// Checks the arithmetic the app prints.
///
/// A stem or a solution step is allowed to be terse, but it is never allowed
/// to be wrong: if a step says `$54 = 9 \times 6 + 0$`, that has to hold. This
/// evaluates the inline TeX spans it fully understands over exact rationals
/// and reports the ones whose sides disagree. Anything it cannot read — a
/// variable, a congruence, a binomial — it skips, so a false claim is a
/// finding and an unknown form is silence.
library;

/// An exact rational; integer division inside a step has to stay exact.
class Ratio {
  factory Ratio(int n, int d) {
    if (d == 0) throw const FormatException('divide by zero');
    return Ratio._(n, d);
  }

  const Ratio._(this.n, this.d);

  const Ratio.of(int n) : this._(n, 1);

  final int n;
  final int d;

  static int _gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final t = a % b;
      a = b;
      b = t;
    }
    return a == 0 ? 1 : a;
  }

  Ratio _norm() {
    var nn = n;
    var dd = d;
    if (dd < 0) {
      nn = -nn;
      dd = -dd;
    }
    final g = _gcd(nn, dd);
    return Ratio._(nn ~/ g, dd ~/ g);
  }

  Ratio operator +(Ratio o) => Ratio._(n * o.d + o.n * d, d * o.d)._norm();
  Ratio operator -(Ratio o) => Ratio._(n * o.d - o.n * d, d * o.d)._norm();
  Ratio operator *(Ratio o) => Ratio._(n * o.n, d * o.d)._norm();
  Ratio operator /(Ratio o) {
    if (o.n == 0) throw const FormatException('divide by zero');
    return Ratio._(n * o.d, d * o.n)._norm();
  }

  bool same(Ratio o) => n * o.d == o.n * d;

  @override
  String toString() => d == 1 ? '$n' : '$n/$d';
}

/// One equation that did not hold, with the span it came from.
typedef ArithmeticFault = ({String span, String left, String right});

/// Every `$…$` span in [text] whose equality is false.
List<ArithmeticFault> faultsIn(String text) {
  final out = <ArithmeticFault>[];
  for (final span in _mathSpans(text)) {
    final sides = _splitTop(span, '=');
    if (sides.length < 2) continue;
    final values = <Ratio>[];
    for (final side in sides) {
      final v = _eval(side);
      if (v == null) {
        values.clear();
        break;
      }
      values.add(v);
    }
    if (values.length < 2) continue;
    for (final v in values.skip(1)) {
      if (!values.first.same(v)) {
        out.add((
          span: span,
          left: values.first.toString(),
          right: v.toString(),
        ));
        break;
      }
    }
  }
  return out;
}

List<String> _mathSpans(String text) {
  final out = <String>[];
  var i = 0;
  while (i < text.length) {
    if (text[i] != r'$') {
      i++;
      continue;
    }
    var j = i + 1;
    if (j < text.length && text[j] == r'$') j++; // display math
    final start = j;
    while (j < text.length && text[j] != r'$') {
      j++;
    }
    if (j >= text.length) break;
    out.add(text.substring(start, j));
    while (j < text.length && text[j] == r'$') {
      j++;
    }
    i = j;
  }
  return out;
}

/// Splits on [sep] at bracket depth zero.
List<String> _splitTop(String s, String sep) {
  final out = <String>[];
  var depth = 0;
  var last = 0;
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if (c == '(' || c == '{' || c == '[') depth++;
    if (c == ')' || c == '}' || c == ']') depth--;
    if (depth == 0 && c == sep) {
      out.add(s.substring(last, i));
      last = i + 1;
    }
  }
  out.add(s.substring(last));
  return out;
}

/// The evaluator: null whenever the span uses something it cannot vouch for.
Ratio? _eval(String raw) {
  var s = raw
      .replaceAll(r'\left', '')
      .replaceAll(r'\right', '')
      .replaceAll(r'\,', '')
      .replaceAll(r'\;', '')
      .replaceAll(r'\!', '')
      .replaceAll(' ', '');
  if (s.isEmpty) return null;
  // Anything outside plain arithmetic is not ours to judge.
  if (RegExp(r'[A-Za-z]').hasMatch(
    s
        .replaceAll(r'\times', '*')
        .replaceAll(r'\cdot', '*')
        .replaceAll(r'\div', '/')
        .replaceAll(r'\frac', '#')
        .replaceAll(r'\dfrac', '#')
        .replaceAll(r'\lfloor', '[')
        .replaceAll(r'\rfloor', ']'),
  )) {
    return null;
  }
  s = s
      .replaceAll(r'\times', '*')
      .replaceAll(r'\cdot', '*')
      .replaceAll(r'\div', '/')
      .replaceAll(r'\dfrac', r'\frac')
      .replaceAll(r'\lfloor', '[')
      .replaceAll(r'\rfloor', ']');
  if (RegExp(r'[^\d+\-*/^(){}\[\]!\\frac.]').hasMatch(s)) return null;
  try {
    final p = _Parser(s);
    final v = p.expression();
    if (!p.done) return null;
    return v;
  } on FormatException {
    return null;
  }
}

class _Parser {
  _Parser(this.s);

  final String s;
  int i = 0;

  bool get done => i >= s.length;

  String? get peek => i < s.length ? s[i] : null;

  Ratio expression() {
    var v = term();
    while (peek == '+' || peek == '-') {
      final op = s[i++];
      final r = term();
      v = op == '+' ? v + r : v - r;
    }
    return v;
  }

  Ratio term() {
    var v = power();
    while (peek == '*' || peek == '/') {
      final op = s[i++];
      final r = power();
      v = op == '*' ? v * r : v / r;
    }
    return v;
  }

  Ratio power() {
    final base = postfix();
    if (peek != '^') return base;
    i++;
    final exp = postfix();
    if (exp.d != 1 || exp.n < 0 || exp.n > 24) {
      throw const FormatException('exponent');
    }
    var v = Ratio.of(1);
    for (var k = 0; k < exp.n; k++) {
      v = v * base;
      if (v.n.abs() > 1 << 50) throw const FormatException('overflow');
    }
    return v;
  }

  Ratio postfix() {
    var v = atom();
    while (peek == '!') {
      i++;
      if (v.d != 1 || v.n < 0 || v.n > 18) throw const FormatException('!');
      var f = 1;
      for (var k = 2; k <= v.n; k++) {
        f *= k;
      }
      v = Ratio.of(f);
    }
    return v;
  }

  Ratio atom() {
    final c = peek;
    if (c == null) throw const FormatException('end');
    if (c == '-') {
      i++;
      return Ratio.of(0) - atom();
    }
    if (c == '+') {
      i++;
      return atom();
    }
    if (c == '(' || c == '{') {
      final close = c == '(' ? ')' : '}';
      i++;
      final v = expression();
      if (peek != close) throw const FormatException('bracket');
      i++;
      return v;
    }
    if (c == '[') {
      // \lfloor x \rfloor
      i++;
      final v = expression();
      if (peek != ']') throw const FormatException('floor');
      i++;
      var q = v.n ~/ v.d;
      if (v.n % v.d != 0 && v.n < 0) q -= 1;
      return Ratio.of(q);
    }
    if (s.startsWith(r'\frac', i)) {
      i += 5;
      final n = atom();
      final d = atom();
      return n / d;
    }
    final digits = RegExp(r'^\d+').firstMatch(s.substring(i));
    if (digits == null) throw const FormatException('atom');
    i += digits.group(0)!.length;
    var v = Ratio.of(int.parse(digits.group(0)!));
    if (peek == '.') {
      final dec = RegExp(r'^\.(\d+)').firstMatch(s.substring(i));
      if (dec == null) throw const FormatException('decimal');
      i += dec.group(0)!.length;
      var scale = 1;
      for (var k = 0; k < dec.group(1)!.length; k++) {
        scale *= 10;
      }
      v = v + Ratio(int.parse(dec.group(1)!), scale);
    }
    return v;
  }
}
