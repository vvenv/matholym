import 'dart:math';

import '../figure.dart';
import 'question.dart';

/// Inline TeX. Factor strings arrive as `2*17`; typeset the product as ×.
String mathInline(Object v) => '\$${'$v'.replaceAll('*', r' \times ')}\$';

int randClosed(Random rng, int lo, int hi) {
  if (hi < lo) {
    throw ArgumentError('randClosed: $lo > $hi');
  }
  return lo + rng.nextInt(hi - lo + 1);
}

GeneratedQuestion buildQuestion({
  required String templateId,
  required int seed,
  required String nodeId,
  required Difficulty difficulty,
  required QuestionKind kind,
  required String stem,
  required String answer,
  required List<String> hints,
  required List<String> steps,
  required List<String> nodeRefs,
  List<String> choices = const [],
  MathFigure? figure,
  ({int min, int max})? answerRange,
}) {
  return GeneratedQuestion(
    templateId: templateId,
    seed: seed,
    nodeId: nodeId,
    difficulty: difficulty,
    kind: kind,
    stem: stem,
    answer: answer,
    hints: hints,
    steps: steps,
    nodeRefs: nodeRefs,
    choices: choices,
    figure: figure,
    answerRange: answerRange,
  );
}

/// A coefficient in front of a variable, the way a textbook prints it: `x`
/// rather than `1x`, `-x` rather than `-1x`.
String termTex(int k, String variable) {
  if (k == 1) return variable;
  if (k == -1) return '-$variable';
  return '$k$variable';
}

/// Joins signed terms: `x^2 + 5x + 4`, `x^2 - 3x`, `2x - 1`. A zero
/// coefficient drops its term instead of printing `+ 0x`.
String polyTex(List<({int k, String variable})> terms) {
  final out = StringBuffer();
  for (final t in terms) {
    if (t.k == 0) continue;
    final body = t.variable.isEmpty
        ? '${t.k.abs()}'
        : termTex(t.k.abs(), t.variable);
    if (out.isEmpty) {
      out.write(t.k < 0 ? '-$body' : body);
    } else {
      out.write(t.k < 0 ? ' - $body' : ' + $body');
    }
  }
  return out.isEmpty ? '0' : out.toString();
}

/// `kx + b`, tidied.
String linearTex(int k, int b, {String variable = 'x'}) =>
    polyTex([(k: k, variable: variable), (k: b, variable: '')]);

/// `ax^2 + bx + c`, tidied.
String quadTex(int a, int b, int c, {String variable = 'x'}) => polyTex([
  (k: a, variable: '$variable^2'),
  (k: b, variable: variable),
  (k: c, variable: ''),
]);

/// The substitution line for `y = kx + b` at `x`: `y = 3 \times 4 + 2`, and
/// simply `y = 4 + 2` when the coefficient is 1.
String linearEvalTex(int k, int x, int b) {
  final product = k == 1 ? '$x' : '$k \\times $x';
  if (b == 0) return product;
  return b < 0 ? '$product - ${-b}' : '$product + $b';
}

/// A ratio written the way it should be read: reduced, and with two different
/// shares — `2:4` is unfinished work and `3:3` is not a ratio question.
({int a, int b}) ratioPair(int a, int b) {
  var x = a;
  var y = b;
  while (y != 0) {
    final t = x % y;
    x = y;
    y = t;
  }
  final g = x == 0 ? 1 : x;
  final ra = a ~/ g;
  final rb = b ~/ g;
  return ra == rb ? (a: ra, b: rb + 1) : (a: ra, b: rb);
}
