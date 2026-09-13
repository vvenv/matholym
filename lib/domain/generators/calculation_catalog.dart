import 'dart:math';

import '../calculation.dart';
import 'build.dart';
import 'question.dart';

final List<QuestionTemplate> calculationTemplates = [
  QuestionTemplate(
    id: 'add.make10',
    nodeId: 'calc_addsub',
    difficulties: Difficulty.values.toSet(),
    build: _addMake10,
  ),
  QuestionTemplate(
    id: 'add.subtract',
    nodeId: 'calc_addsub',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _addSubtract,
  ),
  QuestionTemplate(
    id: 'mul.special',
    nodeId: 'calc_mul',
    difficulties: Difficulty.values.toSet(),
    build: _mulSpecial,
  ),
  QuestionTemplate(
    id: 'mul.near100',
    nodeId: 'calc_mul',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _mulNear100,
  ),
  QuestionTemplate(
    id: 'laws.dist',
    nodeId: 'calc_laws',
    difficulties: Difficulty.values.toSet(),
    build: _lawsDist,
  ),
  QuestionTemplate(
    id: 'laws.assoc',
    nodeId: 'calc_laws',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _lawsAssoc,
  ),
  QuestionTemplate(
    id: 'frac.add',
    nodeId: 'frac_ops',
    difficulties: Difficulty.values.toSet(),
    build: _fracAdd,
  ),
  QuestionTemplate(
    id: 'frac.mul',
    nodeId: 'frac_ops',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _fracMul,
  ),
  QuestionTemplate(
    id: 'frac.judge',
    nodeId: 'frac_cmp',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _fracJudge,
  ),
  QuestionTemplate(
    id: 'frac.which',
    nodeId: 'frac_cmp',
    difficulties: Difficulty.values.toSet(),
    build: _fracWhich,
  ),
  QuestionTemplate(
    id: 'dec.one',
    nodeId: 'dec_rep',
    difficulties: Difficulty.values.toSet(),
    build: _decOne,
  ),
  QuestionTemplate(
    id: 'dec.two',
    nodeId: 'dec_rep',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _decTwo,
  ),
  QuestionTemplate(
    id: 'op.star',
    nodeId: 'new_op',
    difficulties: Difficulty.values.toSet(),
    build: _opStar,
  ),
  QuestionTemplate(
    id: 'op.undo',
    nodeId: 'new_op',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _opUndo,
  ),
  QuestionTemplate(
    id: 'split.sum',
    nodeId: 'split_unit',
    difficulties: Difficulty.values.toSet(),
    build: _splitSum,
  ),
  QuestionTemplate(
    id: 'split.one',
    nodeId: 'split_unit',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _splitOne,
  ),
  QuestionTemplate(
    id: 'mean.value',
    nodeId: 'mean_avg',
    difficulties: Difficulty.values.toSet(),
    build: _meanValue,
  ),
  QuestionTemplate(
    id: 'mean.missing',
    nodeId: 'mean_avg',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _meanMissing,
  ),
  QuestionTemplate(
    id: 'page.digits',
    nodeId: 'page_num',
    difficulties: Difficulty.values.toSet(),
    build: _pageDigits,
  ),
  QuestionTemplate(
    id: 'page.upto',
    nodeId: 'page_num',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _pageUpto,
  ),
  QuestionTemplate(
    id: 'cplx.value',
    nodeId: 'complex_frac',
    difficulties: Difficulty.values.toSet(),
    build: _cplxValue,
  ),
  QuestionTemplate(
    id: 'cplx.den',
    nodeId: 'complex_frac',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _cplxDen,
  ),
];

String _m(Object v) => mathInline(v);

/// A fraction as an answer string: reduced, so `2/4` is never the key.
String _frac(int n, int d) {
  final r = Calculation.reduce(n, d);
  return '${r.n}/${r.d}';
}

int _rand(Random rng, int lo, int hi) => randClosed(rng, lo, hi);

GeneratedQuestion _q({
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
}) {
  return buildQuestion(
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
  );
}

GeneratedQuestion _addMake10(int seed, Difficulty d) {
  final rng = Random(seed);
  final tens = _rand(rng, 2, d == Difficulty.contest ? 12 : 8) * 100;
  final off = _rand(rng, 1, 15);
  final add = _rand(rng, 10, 80);
  final a = tens - off;
  final ans = a + add;
  return _q(
    templateId: 'add.make10',
    seed: seed,
    nodeId: 'calc_addsub',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '用凑整计算 ${_m('$a + $add')}。',
    answer: '$ans',
    hints: ['先把 ${_m(a)} 凑成 ${_m(tens)}。', '${_m('$tens + $add - $off')}。'],
    steps: ['${_m('$a + $add = $ans')}。'],
    nodeRefs: ['calc_addsub'],
  );
}

GeneratedQuestion _addSubtract(int seed, Difficulty d) {
  final rng = Random(seed);
  final base = _rand(rng, 3, 9) * 100;
  final sub = _rand(rng, 12, 89);
  final ans = base - sub;
  return _q(
    templateId: 'add.subtract',
    seed: seed,
    nodeId: 'calc_addsub',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '计算 ${_m('$base - $sub')}。',
    answer: '$ans',
    hints: ['可以看成 ${_m('$base - $sub')}，或 ${_m('${base - 1} - ${sub - 1}')}。'],
    steps: ['差是 ${_m(ans)}。'],
    nodeRefs: ['calc_addsub'],
  );
}

GeneratedQuestion _mulSpecial(int seed, Difficulty d) {
  final rng = Random(seed);
  final pairs = [(25, 16), (25, 8), (125, 8), (125, 16), (5, 24), (25, 12)];
  final p = pairs[rng.nextInt(pairs.length)];
  final ans = p.$1 * p.$2;
  return _q(
    templateId: 'mul.special',
    seed: seed,
    nodeId: 'calc_mul',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '巧算 ${_m('${p.$1} \\times ${p.$2}')}。',
    answer: '$ans',
    hints: ['把因数拆成 ${_m('4')}、${_m('8')}、${_m('125')} 等与 ${_m('1000')} 配套的数。'],
    steps: ['${_m('${p.$1} \\times ${p.$2} = $ans')}。'],
    nodeRefs: ['calc_mul'],
  );
}

GeneratedQuestion _mulNear100(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, 15);
  final ans = 99 * n;
  return _q(
    templateId: 'mul.near100',
    seed: seed,
    nodeId: 'calc_mul',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '计算 ${_m('99 \\times $n')}。',
    answer: '$ans',
    hints: [
      '${_m('99 \\times n = 100n - n')}。',
      '${_m('100 \\times $n = ${100 * n}')}。',
    ],
    steps: ['${_m('${100 * n} - $n = $ans')}。'],
    nodeRefs: ['calc_mul', 'calc_laws'],
  );
}

GeneratedQuestion _lawsDist(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 4, 20);
  final b = _rand(rng, 3, 15);
  final c = _rand(rng, 5, 20);
  final ans = a * b + a * c;
  return _q(
    templateId: 'laws.dist',
    seed: seed,
    nodeId: 'calc_laws',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '用运算律计算 ${_m('$a \\times $b + $a \\times $c')}。',
    answer: '$ans',
    hints: ['提出 ${_m(a)}：${_m('$a($b + $c)')}。'],
    steps: ['${_m('$a \\times ${b + c} = $ans')}。'],
    nodeRefs: ['calc_laws'],
  );
}

GeneratedQuestion _lawsAssoc(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = [2, 4, 5, 8][rng.nextInt(4)];
  final b = [25, 125, 5][rng.nextInt(3)];
  final c = _rand(rng, 3, 9);
  final ans = a * b * c;
  return _q(
    templateId: 'laws.assoc',
    seed: seed,
    nodeId: 'calc_laws',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '计算 ${_m('$a \\times $b \\times $c')}。可先把好算的两个相乘。',
    answer: '$ans',
    hints: ['结合律：先算 ${_m('$a \\times $b = ${a * b}')}。'],
    steps: ['乘积是 ${_m(ans)}。'],
    nodeRefs: ['calc_laws'],
  );
}

GeneratedQuestion _fracAdd(int seed, Difficulty d) {
  final rng = Random(seed);
  final b = [2, 3, 4, 6][rng.nextInt(4)];
  final den = [3, 4, 5, 6][rng.nextInt(4)];
  final a = _rand(rng, 1, b - 1);
  final c = _rand(rng, 1, den - 1);
  final r = Calculation.addFrac(a, b, c, den);
  return _q(
    templateId: 'frac.add',
    seed: seed,
    nodeId: 'frac_ops',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '计算 ${_m('\\frac{$a}{$b} + \\frac{$c}{$den}')}。写成最简分数 ${_m('p/q')}，例如 3/4。',
    answer: '${r.n}/${r.d}',
    hints: ['通分，分母取 ${_m('$b')} 与 ${_m('$den')} 的最小公倍数。', '再约分。'],
    steps: ['结果是 ${_m('\\frac{${r.n}}{${r.d}}')}。'],
    nodeRefs: ['frac_ops'],
  );
}

GeneratedQuestion _fracMul(int seed, Difficulty d) {
  final rng = Random(seed);
  final b = _rand(rng, 2, 8);
  final den = _rand(rng, 2, 8);
  // Proper fractions on both sides: a factor equal to 1 asks nothing.
  final a = _rand(rng, 1, b - 1);
  final c = _rand(rng, 1, den - 1);
  final r = Calculation.mulFrac(a, b, c, den);
  return _q(
    templateId: 'frac.mul',
    seed: seed,
    nodeId: 'frac_ops',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '计算 ${_m('\\frac{$a}{$b} \\times \\frac{$c}{$den}')}。写成最简分数 ${_m('p/q')}。',
    answer: '${r.n}/${r.d}',
    hints: ['分子乘分子，分母乘分母，能约先约。'],
    steps: ['${_m('\\frac{${r.n}}{${r.d}}')}。'],
    nodeRefs: ['frac_ops'],
  );
}

GeneratedQuestion _fracJudge(int seed, Difficulty d) {
  final rng = Random(seed);
  final b = _rand(rng, 3, 9);
  final den = _rand(rng, 3, 9);
  final a = _rand(rng, 1, b - 1);
  final c = _rand(rng, 1, den - 1);
  final yes = Calculation.compareFrac(a, b, c, den) > 0;
  return _q(
    templateId: 'frac.judge',
    seed: seed,
    nodeId: 'frac_cmp',
    difficulty: d,
    kind: QuestionKind.judge,
    stem:
        '判断：${_m('\\frac{$a}{$b}')} 是否大于 ${_m('\\frac{$c}{$den}')}？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: ['交叉相乘：比较 ${_m('$a \\times $den')} 与 ${_m('$c \\times $b')}。'],
    steps: [
      '${_m('$a \\times $den = ${a * den}')}，${_m('$c \\times $b = ${c * b}')}。',
      yes ? '左边更大。' : '左边不更大。',
    ],
    nodeRefs: ['frac_cmp'],
  );
}

GeneratedQuestion _fracWhich(int seed, Difficulty d) {
  final rng = Random(seed);
  final b = _rand(rng, 3, 8);
  var den = _rand(rng, 3, 8);
  if (den == b) den++;
  final a = _rand(rng, 1, b - 1);
  final c = _rand(rng, 1, den - 1);
  final cmp = Calculation.compareFrac(a, b, c, den);
  final first = cmp >= 0;
  return _q(
    templateId: 'frac.which',
    seed: seed,
    nodeId: 'frac_cmp',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '${_m('\\frac{$a}{$b}')} 与 ${_m('\\frac{$c}{$den}')} 哪个不小？较大者写成最简分数 ${_m('p/q')}；相等就写第一个。',
    answer: first ? _frac(a, b) : _frac(c, den),
    hints: ['通分或交叉相乘。'],
    steps: [
      first
          ? '${_m('\\frac{$a}{$b}')} 不小于另一个。'
          : '${_m('\\frac{$c}{$den}')} 更大。',
    ],
    nodeRefs: ['frac_cmp'],
  );
}

GeneratedQuestion _decOne(int seed, Difficulty d) {
  final rng = Random(seed);
  final digit = _rand(rng, 1, 8);
  final r = Calculation.repeatingOne(digit);
  return _q(
    templateId: 'dec.one',
    seed: seed,
    nodeId: 'dec_rep',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '纯循环小数 ${_m('0.\\dot{$digit}')} 化成最简分数，写成 ${_m('p/q')}。',
    answer: '${r.n}/${r.d}',
    hints: ['一位循环：${_m('0.\\dot{a} = a/9')}。', '再约分。'],
    steps: ['${_m('\\frac{${r.n}}{${r.d}}')}。'],
    nodeRefs: ['dec_rep'],
  );
}

GeneratedQuestion _decTwo(int seed, Difficulty d) {
  final rng = Random(seed);
  final ab = [12, 18, 24, 36, 45, 15][rng.nextInt(6)];
  final r = Calculation.repeatingTwo(ab);
  final tens = ab ~/ 10;
  final ones = ab % 10;
  return _q(
    templateId: 'dec.two',
    seed: seed,
    nodeId: 'dec_rep',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('0.\\overline{$tens$ones}')} 化成最简分数，写成 ${_m('p/q')}。',
    answer: '${r.n}/${r.d}',
    hints: ['两位循环：${_m('0.\\overline{ab} = ab/99')}。'],
    steps: ['${_m('\\frac{${r.n}}{${r.d}}')}。'],
    nodeRefs: ['dec_rep'],
  );
}

GeneratedQuestion _opStar(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 8);
  final b = _rand(rng, 2, 8);
  final ans = Calculation.star(a, b);
  return _q(
    templateId: 'op.star',
    seed: seed,
    nodeId: 'new_op',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '规定 ${_m('a \\oplus b = a + b + ab')}。求 ${_m('$a \\oplus $b')}。',
    answer: '$ans',
    hints: ['代入定义，或用 ${_m('(a+1)(b+1)-1')}。'],
    steps: ['${_m('$a + $b + $a \\times $b = $ans')}。'],
    nodeRefs: ['new_op'],
  );
}

GeneratedQuestion _opUndo(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 6);
  final x = _rand(rng, 2, 8);
  final result = Calculation.star(a, x);
  return _q(
    templateId: 'op.undo',
    seed: seed,
    nodeId: 'new_op',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '规定 ${_m('a \\oplus b = a + b + ab')}。已知 ${_m('$a \\oplus x = $result')}，求 x。',
    answer: '$x',
    hints: [
      '${_m('$a + x + $a x = $result')}。',
      '${_m('${a + 1}x = ${result - a}')}。',
    ],
    steps: ['${_m('x = $x')}。'],
    nodeRefs: ['new_op'],
  );
}

GeneratedQuestion _splitSum(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 5);
  final b = a + _rand(rng, 2, d == Difficulty.contest ? 5 : 3);
  final r = Calculation.telescoping(a, b);
  return _q(
    templateId: 'split.sum',
    seed: seed,
    nodeId: 'split_unit',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '求 ${_m('\\dfrac{1}{$a\\cdot${a + 1}} + \\cdots + \\dfrac{1}{${b - 1}\\cdot $b}')}。写成最简 ${_m('p/q')}。',
    answer: '${r.n}/${r.d}',
    hints: [
      '${_m('\\frac{1}{k(k+1)} = \\frac{1}{k} - \\frac{1}{k+1}')}。',
      '裂项后中间抵消，剩 ${_m('\\frac{1}{$a} - \\frac{1}{$b}')}。',
    ],
    steps: ['${_m('\\frac{${r.n}}{${r.d}}')}。'],
    nodeRefs: ['split_unit'],
  );
}

GeneratedQuestion _splitOne(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 2, 12);
  return _q(
    templateId: 'split.one',
    seed: seed,
    nodeId: 'split_unit',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '${_m('\\frac{1}{$n} - \\frac{1}{${n + 1}}')} 可以写成 ${_m('\\frac{1}{m}')}。m 是多少？',
    answer: '${n * (n + 1)}',
    hints: [
      '通分：分子 ${_m('${n + 1} - $n = 1')}，分母 ${_m('$n \\times ${n + 1}')}。',
    ],
    steps: ['分母是 ${_m(n * (n + 1))}。'],
    nodeRefs: ['split_unit'],
  );
}

GeneratedQuestion _meanValue(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = d == Difficulty.basic ? 3 : 4;
  final xs = [for (var i = 0; i < n; i++) _rand(rng, 4, 18)];
  final sum = xs.reduce((a, b) => a + b);
  final mean = sum ~/ n;
  final adjusted = [...xs];
  adjusted[n - 1] += (mean * n) - sum;
  final ans = Calculation.mean(adjusted);
  return _q(
    templateId: 'mean.value',
    seed: seed,
    nodeId: 'mean_avg',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${adjusted.join('、')} 的平均数是多少？',
    answer: '$ans',
    hints: ['先求和再除以 ${_m(n)}。'],
    steps: ['和是 ${_m(adjusted.reduce((a, b) => a + b))}，平均数 ${_m(ans)}。'],
    nodeRefs: ['mean_avg'],
  );
}

GeneratedQuestion _meanMissing(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, 7);
  final mean = _rand(rng, 8, 16);
  final known = mean + _rand(rng, -3, 3);
  final rest = mean * n - known;
  return _q(
    templateId: 'mean.missing',
    seed: seed,
    nodeId: 'mean_avg',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 个数的平均数是 ${_m(mean)}。已知其中一个是 ${_m(known)}，其余数的和是多少？',
    answer: '$rest',
    hints: ['总和是 ${_m('$mean \\times $n')}。', '减去已知的 ${_m(known)}。'],
    steps: ['其余和 ${_m('${mean * n} - $known = $rest')}。'],
    nodeRefs: ['mean_avg'],
  );
}

GeneratedQuestion _pageDigits(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = switch (d) {
    Difficulty.basic => _rand(rng, 12, 20),
    Difficulty.medium => [25, 50, 99, 80][rng.nextInt(4)],
    Difficulty.contest => [100, 120, 200, 256][rng.nextInt(4)],
  };
  final ans = Calculation.pageDigits(n);
  return _q(
    templateId: 'page.digits',
    seed: seed,
    nodeId: 'page_num',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '一本书从第 1 页编到第 ${_m(n)} 页。一共用了多少个数字？',
    answer: '$ans',
    hints: ['1–9 每位 1 个数字，10–99 每位 2 个，100–999 每位 3 个。'],
    steps: ['共用 ${_m(ans)} 个数字。'],
    nodeRefs: ['page_num'],
  );
}

GeneratedQuestion _pageUpto(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [10, 11, 19, 20, 55, 99][rng.nextInt(6)];
  final ans = Calculation.pageDigits(n);
  return _q(
    templateId: 'page.upto',
    seed: seed,
    nodeId: 'page_num',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '页码从 1 打到 ${_m(n)}，印刷厂用了多少个数字？',
    answer: '$ans',
    hints: ['先算 1–9 用 9 个，再算两位数部分。'],
    steps: ['答案是 ${_m(ans)}。'],
    nodeRefs: ['page_num'],
  );
}

GeneratedQuestion _cplxValue(int seed, Difficulty d) {
  final rng = Random(seed);
  // The stem promises a fraction, so keep drawing until the quotient is one.
  var a = 1;
  var b = 2;
  var c = 1;
  var den = 3;
  var r = Calculation.complexFrac(a, b, c, den);
  for (var tries = 0; tries < 20; tries++) {
    a = _rand(rng, 1, 5);
    b = _rand(rng, 2, 6);
    c = _rand(rng, 1, 5);
    den = _rand(rng, 2, 6);
    r = Calculation.complexFrac(a, b, c, den);
    if (r.d > 1) break;
  }
  if (r.d == 1) {
    // (1/b) / (c/(bc+1)) = (bc+1)/(bc), never an integer.
    a = 1;
    den = b * c + 1;
    r = Calculation.complexFrac(a, b, c, den);
  }
  return _q(
    templateId: 'cplx.value',
    seed: seed,
    nodeId: 'complex_frac',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '化简繁分数 ${_m('\\dfrac{$a/$b}{$c/$den}')}，写成最简 ${_m('p/q')}。',
    answer: '${r.n}/${r.d}',
    hints: ['除以分数等于乘它的倒数：${_m('\\frac{$a}{$b} \\times \\frac{$den}{$c}')}。'],
    steps: ['${_m('\\frac{${r.n}}{${r.d}}')}。'],
    nodeRefs: ['complex_frac'],
  );
}

GeneratedQuestion _cplxDen(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = 1;
  final b = _rand(rng, 2, 5);
  final c = 1;
  final den = b + _rand(rng, 1, 3);
  final r = Calculation.complexFrac(a, b, c, den);
  return _q(
    templateId: 'cplx.den',
    seed: seed,
    nodeId: 'complex_frac',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('\\dfrac{1/$b}{1/$den}')} 化简后最简分数的分母是多少？若结果是整数，分母写 1。',
    answer: '${r.d}',
    hints: ['${_m('\\frac{1}{$b} \\div \\frac{1}{$den} = \\frac{$den}{$b}')}。'],
    steps: ['最简分母是 ${_m(r.d)}。'],
    nodeRefs: ['complex_frac'],
  );
}
