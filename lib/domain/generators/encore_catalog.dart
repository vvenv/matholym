import 'dart:math';

import '../algebra.dart';
import '../calculation.dart';
import '../combinatorics.dart';
import '../figure.dart';
import '../geometry.dart';
import '../number_theory.dart';
import '../olympiad_logic.dart';
import 'build.dart';
import 'question.dart';

/// High-frequency models still missing after the depth pass.
final List<QuestionTemplate> encoreTemplates = [
  QuestionTemplate(
    id: 'mvp.right',
    nodeId: 'move_point',
    difficulties: Difficulty.values.toSet(),
    build: _mvpRight,
  ),
  QuestionTemplate(
    id: 'mvp.left',
    nodeId: 'move_point',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _mvpLeft,
  ),
  QuestionTemplate(
    id: 'crs.arm',
    nodeId: 'cross_sum',
    difficulties: Difficulty.values.toSet(),
    build: _crsArm,
  ),
  QuestionTemplate(
    id: 'crs.ctr',
    nodeId: 'cross_sum',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _crsCtr,
  ),
  QuestionTemplate(
    id: 'shf.mul',
    nodeId: 'sci_shift',
    difficulties: Difficulty.values.toSet(),
    build: _shfMul,
  ),
  QuestionTemplate(
    id: 'shf.div',
    nodeId: 'sci_shift',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _shfDiv,
  ),
  QuestionTemplate(
    id: 'cub.n',
    nodeId: 'cube_sum',
    difficulties: Difficulty.values.toSet(),
    build: _cubN,
  ),
  QuestionTemplate(
    id: 'cub.sq',
    nodeId: 'cube_sum',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _cubSq,
  ),
  QuestionTemplate(
    id: 'lnz.x',
    nodeId: 'lin_zero',
    difficulties: Difficulty.values.toSet(),
    build: _lnzX,
  ),
  QuestionTemplate(
    id: 'lnz.y',
    nodeId: 'lin_zero',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _lnzY,
  ),
  QuestionTemplate(
    id: 'ivg.k',
    nodeId: 'inv_graph',
    difficulties: Difficulty.values.toSet(),
    build: _ivgK,
  ),
  QuestionTemplate(
    id: 'ivg.y',
    nodeId: 'inv_graph',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _ivgY,
  ),
  QuestionTemplate(
    id: 'axi.y',
    nodeId: 'axis_int',
    difficulties: Difficulty.values.toSet(),
    build: _axiY,
  ),
  QuestionTemplate(
    id: 'axi.sum',
    nodeId: 'axis_int',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _axiSum,
  ),
  QuestionTemplate(
    id: 'qex.min',
    nodeId: 'quad_ext',
    difficulties: Difficulty.values.toSet(),
    build: _qexMin,
  ),
  QuestionTemplate(
    id: 'qex.axis',
    nodeId: 'quad_ext',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _qexAxis,
  ),
  QuestionTemplate(
    id: 'exa.sum',
    nodeId: 'ext_angle',
    difficulties: Difficulty.values.toSet(),
    build: _exaSum,
  ),
  QuestionTemplate(
    id: 'exa.miss',
    nodeId: 'ext_angle',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _exaMiss,
  ),
  QuestionTemplate(
    id: 'iso.base',
    nodeId: 'iso_base',
    difficulties: Difficulty.values.toSet(),
    build: _isoBase,
  ),
  QuestionTemplate(
    id: 'iso.vert',
    nodeId: 'iso_base',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _isoVert,
  ),
  QuestionTemplate(
    id: 'tha.right',
    nodeId: 'thales',
    difficulties: Difficulty.values.toSet(),
    build: _thaRight,
  ),
  QuestionTemplate(
    id: 'tha.acute',
    nodeId: 'thales',
    difficulties: Difficulty.values.toSet(),
    build: _thaAcute,
  ),
  QuestionTemplate(
    id: 'cyc.ex',
    nodeId: 'cyclic_out',
    difficulties: Difficulty.values.toSet(),
    build: _cycEx,
  ),
  QuestionTemplate(
    id: 'cyc.in',
    nodeId: 'cyclic_out',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _cycIn,
  ),
  QuestionTemplate(
    id: 'bmu.prod',
    nodeId: 'base_mul',
    difficulties: Difficulty.values.toSet(),
    build: _bmuProd,
  ),
  QuestionTemplate(
    id: 'bmu.one',
    nodeId: 'base_mul',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _bmuOne,
  ),
  QuestionTemplate(
    id: 'rpu.val',
    nodeId: 'repunit',
    difficulties: Difficulty.values.toSet(),
    build: _rpuVal,
  ),
  QuestionTemplate(
    id: 'rpu.div',
    nodeId: 'repunit',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _rpuDiv,
  ),
  QuestionTemplate(
    id: 'fzr.n',
    nodeId: 'fact_zero',
    difficulties: Difficulty.values.toSet(),
    build: _fzrN,
  ),
  QuestionTemplate(
    id: 'fzr.add',
    nodeId: 'fact_zero',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _fzrAdd,
  ),
  QuestionTemplate(
    id: 'sne.n',
    nodeId: 'subset_ne',
    difficulties: Difficulty.values.toSet(),
    build: _sneN,
  ),
  QuestionTemplate(
    id: 'sne.all',
    nodeId: 'subset_ne',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _sneAll,
  ),
  QuestionTemplate(
    id: 'hky.sum',
    nodeId: 'hockey',
    difficulties: Difficulty.values.toSet(),
    build: _hkySum,
  ),
  QuestionTemplate(
    id: 'hky.one',
    nodeId: 'hockey',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _hkyOne,
  ),
  QuestionTemplate(
    id: 'atl.k',
    nodeId: 'at_least',
    difficulties: Difficulty.values.toSet(),
    build: _atlK,
  ),
  QuestionTemplate(
    id: 'atl.last',
    nodeId: 'at_least',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _atlLast,
  ),
  QuestionTemplate(
    id: 'tsy.n',
    nodeId: 'three_say',
    difficulties: Difficulty.values.toSet(),
    build: _tsyN,
  ),
  QuestionTemplate(
    id: 'tsy.who',
    nodeId: 'three_say',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _tsyWho,
  ),
  QuestionTemplate(
    id: 'odr.idx',
    nodeId: 'order_true',
    difficulties: Difficulty.values.toSet(),
    build: _odrIdx,
  ),
  QuestionTemplate(
    id: 'odr.n',
    nodeId: 'order_true',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _odrN,
  ),
  QuestionTemplate(
    id: 'whc.a',
    nodeId: 'who_chain',
    difficulties: Difficulty.values.toSet(),
    build: _whcA,
  ),
  QuestionTemplate(
    id: 'whc.b',
    nodeId: 'who_chain',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _whcB,
  ),
  QuestionTemplate(
    id: 'lsq.on',
    nodeId: 'light_sq',
    difficulties: Difficulty.values.toSet(),
    build: _lsqOn,
  ),
  QuestionTemplate(
    id: 'lsq.last',
    nodeId: 'light_sq',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _lsqLast,
  ),
];

String _m(Object v) => mathInline(v);
int _rand(Random rng, int lo, int hi) => randClosed(rng, lo, hi);

String _line(int k, int b) => b >= 0 ? 'y=${k}x+$b' : 'y=${k}x$b';

String _quadOpen(int b, int c) {
  final bx = b < 0 ? '${b}x' : '+${b}x';
  final cz = c < 0 ? '$c' : '+$c';
  return 'y=x^2$bx$cz';
}

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
  MathFigure? figure,
  ({int min, int max})? answerRange,
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
    figure: figure,
    answerRange: answerRange,
  );
}

GeneratedQuestion _mvpRight(int seed, Difficulty d) {
  final rng = Random(seed);
  final tenths = _rand(rng, 11, 89);
  final shift = _rand(rng, 1, 3);
  final ans = Calculation.shiftTenths(tenths, shift);
  return _q(
    templateId: 'mvp.right',
    seed: seed,
    nodeId: 'move_point',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '把 ${_m('${tenths ~/ 10}.${tenths % 10}')} 的小数点向右移 ${_m(shift)} 位。得到的数是多少？',
    answer: '$ans',
    hints: ['向右移 ${_m(shift)} 位等于乘 ${_m('10^$shift')}。'],
    steps: ['得到 ${_m(ans)}。'],
    nodeRefs: ['move_point'],
  );
}

GeneratedQuestion _mvpLeft(int seed, Difficulty d) {
  final rng = Random(seed);
  // Moving the point left has to change the number: ask it on a value that
  // ends in enough zeros to land on a whole answer. Repeating the number back
  // (「$n 除以 100 等于百分之多少」) asks nothing.
  final shift = _rand(rng, 1, 2);
  final ans = _rand(rng, 12, 80);
  var value = ans;
  for (var i = 0; i < shift; i++) {
    value *= 10;
  }
  return _q(
    templateId: 'mvp.left',
    seed: seed,
    nodeId: 'move_point',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '把 ${_m(value)} 的小数点向左移 ${_m(shift)} 位。得到的数是多少？',
    answer: '$ans',
    hints: ['向左移 ${_m(shift)} 位等于除以 ${_m(shift == 1 ? 10 : 100)}。'],
    steps: ['${_m('$value / ${shift == 1 ? 10 : 100} = $ans')}。'],
    nodeRefs: ['move_point'],
  );
}

GeneratedQuestion _crsArm(int seed, Difficulty d) {
  final rng = Random(seed);
  final ctr = _rand(rng, 4, 12);
  final a = _rand(rng, 2, 9);
  final b = _rand(rng, 2, 9);
  final c = _rand(rng, 2, 9);
  final s = ctr + a + b + c + _rand(rng, 3, 10);
  final ans = s - ctr - a - b - c;
  return _q(
    templateId: 'crs.arm',
    seed: seed,
    nodeId: 'cross_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '十字数阵：中心 ${_m(ctr)}，四臂中三臂是 ${_m(a)}、${_m(b)}、${_m(c)}，五数之和 ${_m(s)}。第四臂是多少？',
    answer: '$ans',
    hints: ['第四臂 = 总和 − 中心 − 已知三臂。'],
    steps: ['第四臂 ${_m(ans)}。'],
    figure: CrossFigure(
      center: '$ctr',
      up: '$a',
      left: '$b',
      right: '$c',
      down: '?',
    ),
    nodeRefs: ['cross_sum'],
  );
}

GeneratedQuestion _crsCtr(int seed, Difficulty d) {
  final rng = Random(seed);
  final arms = _rand(rng, 10, 30);
  final s = arms + _rand(rng, 5, 20);
  final ans = s - arms;
  return _q(
    templateId: 'crs.ctr',
    seed: seed,
    nodeId: 'cross_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '十字五数之和 ${_m(s)}，四臂之和 ${_m(arms)}。中心是多少？',
    answer: '$ans',
    hints: ['中心 = 总和 − 四臂。'],
    steps: ['中心 ${_m(ans)}。'],
    figure: const CrossFigure(
      center: '?',
      up: '',
      down: '',
      left: '',
      right: '',
    ),
    nodeRefs: ['cross_sum'],
  );
}

GeneratedQuestion _shfMul(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 15);
  final n = _rand(rng, 1, 4);
  final ans = Calculation.timesTenPow(a, n);
  return _q(
    templateId: 'shf.mul',
    seed: seed,
    nodeId: 'sci_shift',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '计算 ${_m('$a \\times 10^$n')}。',
    answer: '$ans',
    hints: ['在 ${_m(a)} 后面添 ${_m(n)} 个 0。'],
    steps: ['等于 ${_m(ans)}。'],
    nodeRefs: ['sci_shift'],
  );
}

GeneratedQuestion _shfDiv(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 1, 3);
  final ans = _rand(rng, 2, 20);
  final a = Calculation.timesTenPow(ans, n);
  return _q(
    templateId: 'shf.div',
    seed: seed,
    nodeId: 'sci_shift',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('$a \\div 10^$n')} 等于多少？',
    answer: '$ans',
    hints: ['去掉末尾 ${_m(n)} 个 0。'],
    steps: ['等于 ${_m(ans)}。'],
    nodeRefs: ['sci_shift'],
  );
}

GeneratedQuestion _cubN(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, d == Difficulty.contest ? 10 : 7);
  final ans = Calculation.cubeSum(n);
  return _q(
    templateId: 'cub.n',
    seed: seed,
    nodeId: 'cube_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('1^3+2^3+\\cdots+$n^3')}。',
    answer: '$ans',
    hints: ['立方和等于前 n 项和的平方。'],
    steps: ['${_m('S=$ans')}。'],
    nodeRefs: ['cube_sum'],
  );
}

GeneratedQuestion _cubSq(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, 8);
  final g = Calculation.gaussSum(n);
  final ans = Calculation.cubeSum(n);
  return _q(
    templateId: 'cub.sq',
    seed: seed,
    nodeId: 'cube_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '已知 ${_m('1+\\cdots+$n=$g')}。求 ${_m('1^3+\\cdots+$n^3')}。',
    answer: '$ans',
    hints: ['立方和 = ${_m('$g^2')}。'],
    steps: ['${_m('$g^2=$ans')}。'],
    nodeRefs: ['cube_sum', 'gauss_sum'],
  );
}

GeneratedQuestion _lnzX(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 2, 6);
  final x = _rand(rng, 2, 8);
  final b = -k * x;
  final ans = Algebra.xIntercept(k, b);
  return _q(
    templateId: 'lnz.x',
    seed: seed,
    nodeId: 'lin_zero',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '直线 ${_m(_line(k, b))} 与 x 轴交点的横坐标是多少？',
    answer: '$ans',
    hints: ['令 y=0，解 ${_m('${k}x+$b=0')}。'],
    steps: ['横坐标 ${_m(ans)}。'],
    figure: AxesFigure(kind: AxesKind.line, k: k, b: b),
    nodeRefs: ['lin_zero'],
  );
}

GeneratedQuestion _lnzY(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 2, 7);
  var b = _rand(rng, -9, 9);
  while (b == 0) {
    b = _rand(rng, -9, 9);
  }
  return _q(
    templateId: 'lnz.y',
    seed: seed,
    nodeId: 'lin_zero',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '直线 ${_m(_line(k, b))} 与 y 轴交点的纵坐标是多少？',
    answer: '$b',
    hints: ['x=0 时 y=b。'],
    steps: ['纵坐标 ${_m(b)}。'],
    figure: AxesFigure(kind: AxesKind.line, k: k, b: b),
    nodeRefs: ['lin_zero'],
  );
}

GeneratedQuestion _ivgK(int seed, Difficulty d) {
  final rng = Random(seed);
  final x = _rand(rng, 2, 8);
  final y = _rand(rng, 2, 9);
  final ans = Algebra.invK(x, y);
  return _q(
    templateId: 'ivg.k',
    seed: seed,
    nodeId: 'inv_graph',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '反比例函数 ${_m('y=k/x')} 过点 ${_m('($x,$y)')}。求 k。',
    answer: '$ans',
    hints: ['${_m('k=xy')}。'],
    steps: ['k = ${_m(ans)}。'],
    figure: AxesFigure(kind: AxesKind.inverse, k: ans, point: (x, y)),
    nodeRefs: ['inv_graph'],
  );
}

GeneratedQuestion _ivgY(int seed, Difficulty d) {
  final rng = Random(seed);
  const pairs = [(2, 6, 3), (3, 4, 2), (4, 6, 3), (5, 4, 2), (6, 3, 2)];
  final t = pairs[rng.nextInt(pairs.length)];
  final x1 = t.$1;
  final y1 = t.$2;
  final x2 = t.$3;
  final k = x1 * y1;
  final ans = k ~/ x2;
  return _q(
    templateId: 'ivg.y',
    seed: seed,
    nodeId: 'inv_graph',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('y=k/x')} 过 ${_m('($x1,$y1)')}。当 x=${_m(x2)} 时 y 是多少？',
    answer: '$ans',
    hints: ['先求 k=${_m(k)}。'],
    steps: ['y = ${_m(ans)}。'],
    figure: AxesFigure(kind: AxesKind.inverse, k: k, point: (x1, y1)),
    nodeRefs: ['inv_graph'],
  );
}

GeneratedQuestion _axiY(int seed, Difficulty d) {
  final rng = Random(seed);
  final p = _rand(rng, 1, 5);
  final q = p + _rand(rng, 1, 4);
  final c = p * q;
  final ans = Algebra.yInterceptQuad(c);
  return _q(
    templateId: 'axi.y',
    seed: seed,
    nodeId: 'axis_int',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '抛物线 ${_m('y=x^2-${p + q}x+$c')} 与 y 轴交点的纵坐标是多少？',
    answer: '$ans',
    hints: ['x=0 时 y=c。'],
    steps: ['纵坐标 ${_m(ans)}。'],
    figure: AxesFigure(kind: AxesKind.parabola, h: (p + q) ~/ 2, m: ans),
    nodeRefs: ['axis_int'],
  );
}

GeneratedQuestion _axiSum(int seed, Difficulty d) {
  final rng = Random(seed);
  final p = _rand(rng, 1, 5);
  final q = p + _rand(rng, 1, 4);
  final ans = p + q;
  return _q(
    templateId: 'axi.sum',
    seed: seed,
    nodeId: 'axis_int',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '抛物线 ${_m('y=(x-$p)(x-$q)')} 与 x 轴两个交点的横坐标之和是多少？',
    answer: '$ans',
    hints: ['交点就是 ${_m(p)} 与 ${_m(q)}。'],
    steps: ['和是 ${_m(ans)}。'],
    figure: AxesFigure(kind: AxesKind.parabola, h: (p + q) ~/ 2, m: 0),
    nodeRefs: ['axis_int', 'quadratic'],
  );
}

GeneratedQuestion _qexMin(int seed, Difficulty d) {
  final rng = Random(seed);
  final h = _rand(rng, 1, 5);
  final k = _rand(rng, -3, 6);
  final b = -2 * h;
  final c = h * h + k;
  final ans = Algebra.quadMinWhenAPos(1, b, c);
  return _q(
    templateId: 'qex.min',
    seed: seed,
    nodeId: 'quad_ext',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '函数 ${_m(_quadOpen(b, c))} 的最小值是多少？',
    answer: '$ans',
    hints: ['开口向上，最小值在顶点。'],
    steps: ['最小值 ${_m(ans)}。'],
    figure: AxesFigure(kind: AxesKind.parabola, h: h, m: ans),
    nodeRefs: ['quad_ext'],
  );
}

GeneratedQuestion _qexAxis(int seed, Difficulty d) {
  final rng = Random(seed);
  final h = _rand(rng, 1, 6);
  return _q(
    templateId: 'qex.axis',
    seed: seed,
    nodeId: 'quad_ext',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '抛物线 ${_m('y=(x-$h)^2+3')} 在 x 等于多少时取到最值？',
    answer: '$h',
    hints: ['对称轴就是顶点的横坐标。'],
    steps: ['x = ${_m(h)}。'],
    figure: AxesFigure(kind: AxesKind.parabola, h: h, m: 3),
    nodeRefs: ['quad_ext'],
  );
}

GeneratedQuestion _exaSum(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 20, 55);
  final b = _rand(rng, 20, 90 - a);
  final ans = Geometry.exteriorAngle(a, b);
  return _q(
    templateId: 'exa.sum',
    seed: seed,
    nodeId: 'ext_angle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '三角形两个不相邻的内角是 ${_m('$a^\\circ')}、${_m('$b^\\circ')}。此外角是多少度？',
    answer: '$ans',
    hints: ['外角等于不相邻两内角之和。'],
    steps: ['外角 ${_m(ans)} 度。'],
    figure: TriangleFigure(
      angleA: '$a',
      angleB: '$b',
      exteriorAt: 'C',
      exteriorLabel: '?',
    ),
    nodeRefs: ['ext_angle'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _exaMiss(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 30, 70);
  final ext = a + _rand(rng, 25, 60);
  final ans = ext - a;
  return _q(
    templateId: 'exa.miss',
    seed: seed,
    nodeId: 'ext_angle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '外角 ${_m('$ext^\\circ')}，其中一个不相邻内角 ${_m('$a^\\circ')}。另一个是多少度？',
    answer: '$ans',
    hints: ['另一个 = 外角 − 已知内角。'],
    steps: ['${_m(ans)} 度。'],
    figure: TriangleFigure(
      angleA: '$a',
      exteriorAt: 'C',
      exteriorLabel: '$ext',
    ),
    nodeRefs: ['ext_angle'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _isoBase(int seed, Difficulty d) {
  final rng = Random(seed);
  final vertex = 2 * _rand(rng, 10, 40);
  final ans = Geometry.isoBaseAngle(vertex);
  return _q(
    templateId: 'iso.base',
    seed: seed,
    nodeId: 'iso_base',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '等腰三角形顶角 ${_m('$vertex^\\circ')}。一个底角是多少度？',
    answer: '$ans',
    hints: ['两底角相等，和为 ${_m(180 - vertex)}。'],
    steps: ['底角 ${_m(ans)} 度。'],
    figure: TriangleFigure(
      isoVertex: 'C',
      angleC: '$vertex',
      angleA: '?',
      angleB: '?',
    ),
    nodeRefs: ['iso_base'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _isoVert(int seed, Difficulty d) {
  final rng = Random(seed);
  final base = _rand(rng, 20, 70);
  final ans = Geometry.isoVertex(base);
  return _q(
    templateId: 'iso.vert',
    seed: seed,
    nodeId: 'iso_base',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '等腰三角形一个底角 ${_m('$base^\\circ')}。顶角是多少度？',
    answer: '$ans',
    hints: ['顶角 ${_m('180-2\\times$base')}。'],
    steps: ['顶角 ${_m(ans)} 度。'],
    figure: TriangleFigure(
      isoVertex: 'C',
      angleA: '$base',
      angleB: '$base',
      angleC: '?',
    ),
    nodeRefs: ['iso_base'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _thaRight(int seed, Difficulty d) {
  final rng = Random(seed);
  final dnm = rng.nextBool() ? 'AB' : 'PQ';
  final tip = dnm == 'AB' ? 'C' : 'R';
  return _q(
    templateId: 'tha.right',
    seed: seed,
    nodeId: 'thales',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '直径 $dnm，$tip 在圆周上。求 ${_m('\\angle $tip')} 的度数。',
    answer: '90',
    hints: ['直径所对的圆周角是直角。'],
    steps: ['${_m('\\angle $tip=90')}。'],
    figure: const CircleAngleFigure(diameter: true),
    nodeRefs: ['thales'],
  );
}

GeneratedQuestion _thaAcute(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 20, 70);
  final ans = 90 - a;
  return _q(
    templateId: 'tha.acute',
    seed: seed,
    nodeId: 'thales',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '直径 AB，C 在圆周上，${_m('\\angle A=$a^\\circ')}。求 ${_m('\\angle B')} 的度数。',
    answer: '$ans',
    hints: ['C 处是直角，两锐角互余。'],
    steps: ['${_m('\\angle B=$ans')}。'],
    figure: CircleAngleFigure(diameter: true, acuteAtA: '$a'),
    nodeRefs: ['thales'],
  );
}

GeneratedQuestion _cycEx(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 40, 120);
  final ans = Geometry.cyclicExterior(a);
  return _q(
    templateId: 'cyc.ex',
    seed: seed,
    nodeId: 'cyclic_out',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '圆内接四边形一内角 ${_m('$a^\\circ')}。它对角的外角是多少度？',
    answer: '$ans',
    hints: ['对角与这个内角互补，对角的外角再补回来，等于原内角。'],
    steps: ['对角的外角是 ${_m(ans)} 度。'],
    figure: CyclicQuadFigure(interior: '$a', exterior: '?', showExterior: true),
    nodeRefs: ['cyclic_out', 'cyclic_quad'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _cycIn(int seed, Difficulty d) {
  final rng = Random(seed);
  final ext = _rand(rng, 50, 130);
  return _q(
    templateId: 'cyc.in',
    seed: seed,
    nodeId: 'cyclic_out',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '圆内接四边形一外角 ${_m('$ext^\\circ')}。它的内对角是多少度？',
    answer: '$ext',
    hints: ['外角等于内对角。'],
    steps: ['内对角 ${_m(ext)} 度。'],
    figure: CyclicQuadFigure(
      interior: '?',
      exterior: '$ext',
      showExterior: true,
    ),
    nodeRefs: ['cyclic_out'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _bmuProd(int seed, Difficulty d) {
  final rng = Random(seed);
  final base = [2, 3, 4][rng.nextInt(3)];
  final a = switch (base) {
    2 => [11, 101, 110, 111][rng.nextInt(4)],
    3 => [12, 21, 22, 10][rng.nextInt(4)],
    _ => [12, 13, 21, 23][rng.nextInt(4)],
  };
  final b = switch (base) {
    2 => [10, 11, 101][rng.nextInt(3)],
    3 => [2, 10, 11][rng.nextInt(3)],
    _ => [2, 3, 10][rng.nextInt(3)],
  };
  final ans = NumberTheory.mulShown(a, b, base);
  return _q(
    templateId: 'bmu.prod',
    seed: seed,
    nodeId: 'base_mul',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(base)} 进制中 ${_m('$a \\times $b')} 等于多少（写成十进制）？',
    answer: '$ans',
    hints: ['先各自化成十进制再相乘。'],
    steps: ['十进制积是 ${_m(ans)}。'],
    nodeRefs: ['base_mul'],
  );
}

GeneratedQuestion _bmuOne(int seed, Difficulty d) {
  final rng = Random(seed);
  final base = [2, 3, 4][rng.nextInt(3)];
  final a = switch (base) {
    2 => [11, 101, 110, 111][rng.nextInt(4)],
    3 => [12, 21, 22, 10][rng.nextInt(4)],
    _ => [12, 13, 21, 23][rng.nextInt(4)],
  };
  final ans = NumberTheory.parseShown(a, base) * base;
  return _q(
    templateId: 'bmu.one',
    seed: seed,
    nodeId: 'base_mul',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(base)} 进制中 ${_m('$a \\times 10')} 等于多少（写成十进制）？',
    answer: '$ans',
    hints: ['${_m(10)} 在 ${_m(base)} 进制里就是 ${_m(base)}。'],
    steps: ['十进制积是 ${_m(ans)}。'],
    nodeRefs: ['base_mul'],
  );
}

GeneratedQuestion _rpuVal(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 2, 5);
  final ans = NumberTheory.repunit(n);
  return _q(
    templateId: 'rpu.val',
    seed: seed,
    nodeId: 'repunit',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 个 1 连写成的数是多少？',
    answer: '$ans',
    hints: ['就是 ${_m(n)} 位全 1。'],
    steps: ['这个数是 ${_m(ans)}。'],
    nodeRefs: ['repunit'],
  );
}

GeneratedQuestion _rpuDiv(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = rng.nextBool() ? 3 : 6;
  final ans = NumberTheory.repunit(n) ~/ 3;
  return _q(
    templateId: 'rpu.div',
    seed: seed,
    nodeId: 'repunit',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 个 1 连写的数除以 3 等于多少？',
    answer: '$ans',
    hints: ['位数是 3 的倍数，数字和也能被 3 整除。'],
    steps: ['商是 ${_m(ans)}。'],
    nodeRefs: ['repunit', 'divisibility_rules'],
  );
}

GeneratedQuestion _fzrN(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [10, 12, 15, 20, 25][rng.nextInt(5)];
  final ans = NumberTheory.trailingZeros(n);
  return _q(
    templateId: 'fzr.n',
    seed: seed,
    nodeId: 'fact_zero',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('$n!')} 的十进制写法末尾有几个 0？',
    answer: '$ans',
    hints: [
      '尾零个数由因子 5 的个数决定：${_m('\\lfloor n/5\\rfloor+\\lfloor n/25\\rfloor+\\cdots')}。',
    ],
    steps: ['有 ${_m(ans)} 个尾零。'],
    nodeRefs: ['fact_zero'],
  );
}

GeneratedQuestion _fzrAdd(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [10, 15, 20][rng.nextInt(3)];
  final m = n + (rng.nextBool() ? 5 : 10);
  final ans = NumberTheory.trailingZeros(n) + NumberTheory.trailingZeros(m);
  return _q(
    templateId: 'fzr.add',
    seed: seed,
    nodeId: 'fact_zero',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('$n!')} 与 ${_m('$m!')} 的尾零个数之和是多少？',
    answer: '$ans',
    hints: ['分别数因子 5，再相加。'],
    steps: ['个数之和是 ${_m(ans)}。'],
    nodeRefs: ['fact_zero'],
  );
}

GeneratedQuestion _sneN(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, 8);
  final ans = Counting.atLeastOne(n);
  return _q(
    templateId: 'sne.n',
    seed: seed,
    nodeId: 'subset_ne',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 个不同元素的非空子集有多少个？',
    answer: '$ans',
    hints: ['全部子集 ${_m('2^$n')} 个，再去掉空集。'],
    steps: ['有 ${_m(ans)} 个。'],
    nodeRefs: ['subset_ne'],
  );
}

GeneratedQuestion _sneAll(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, 8);
  final ans = 1 << n;
  return _q(
    templateId: 'sne.all',
    seed: seed,
    nodeId: 'subset_ne',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 个不同元素的子集（含空集）有多少个？',
    answer: '$ans',
    hints: ['每个元素选或不选，共 ${_m('2^$n')}。'],
    steps: ['有 ${_m(ans)} 个。'],
    nodeRefs: ['subset_ne'],
  );
}

GeneratedQuestion _hkySum(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 5, 8);
  final k = _rand(rng, 1, n - 2);
  final ans = Counting.hockeyRight(n, k);
  return _q(
    templateId: 'hky.sum',
    seed: seed,
    nodeId: 'hockey',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('C($n,$k)+C($n,${k + 1})')} 等于多少？',
    answer: '$ans',
    hints: ['杨辉三角邻项：${_m('C(n,k)+C(n,k+1)=C(n+1,k+1)')}。'],
    steps: ['等于 ${_m('C(${n + 1},${k + 1})=$ans')}。'],
    nodeRefs: ['hockey', 'binom_identity'],
  );
}

GeneratedQuestion _hkyOne(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, 9);
  final ans = n + 1;
  return _q(
    templateId: 'hky.one',
    seed: seed,
    nodeId: 'hockey',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('C($n,0)+C($n,1)')} 等于多少？',
    answer: '$ans',
    hints: ['${_m('C(n,0)=1')}，${_m('C(n,1)=n')}。'],
    steps: ['和是 ${_m(ans)}。'],
    nodeRefs: ['hockey'],
  );
}

GeneratedQuestion _atlK(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 5, 7);
  final k = _rand(rng, 2, n - 1);
  final ans = Counting.atLeast(n, k);
  return _q(
    templateId: 'atl.k',
    seed: seed,
    nodeId: 'at_least',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '从 ${_m(n)} 人中至少选 ${_m(k)} 人，有多少种选法？',
    answer: '$ans',
    hints: ['把选 ${_m(k)}、${_m(k + 1)}、…、${_m(n)} 人的组合数加起来。'],
    steps: ['共 ${_m(ans)} 种。'],
    nodeRefs: ['at_least'],
  );
}

GeneratedQuestion _atlLast(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, 8);
  final ans = n + 1;
  return _q(
    templateId: 'atl.last',
    seed: seed,
    nodeId: 'at_least',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '从 ${_m(n)} 人中至少选 ${_m(n - 1)} 人，有多少种选法？',
    answer: '$ans',
    hints: ['只剩选 ${_m(n - 1)} 人或全选：${_m('C($n,${n - 1})+C($n,$n)=n+1')}。'],
    steps: ['共 ${_m(ans)} 种。'],
    nodeRefs: ['at_least'],
  );
}

GeneratedQuestion _tsyN(int seed, Difficulty d) {
  final rng = Random(seed);
  final x = _rand(rng, 3, 12);
  final ans = OlympiadLogic.threeSay(x);
  return _q(
    templateId: 'tsy.n',
    seed: seed,
    nodeId: 'three_say',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '一个数是 ${_m(x)}、${_m(x + 1)}、${_m(x + 2)} 之一。甲说「是 ${_m(x)}」，乙说「大于 ${_m(x)}」，丙说「小于 ${_m(x + 2)}」。恰一句为真。这个数是多少？',
    answer: '$ans',
    hints: ['若是 ${_m(x)} 或 ${_m(x + 1)}，都会有两句真。只剩 ${_m(x + 2)}。'],
    steps: ['这个数是 ${_m(ans)}。'],
    nodeRefs: ['three_say'],
  );
}

GeneratedQuestion _tsyWho(int seed, Difficulty d) {
  final rng = Random(seed);
  final x = _rand(rng, 3, 12);
  final names = ['甲', '乙', '丙']..shuffle(rng);
  final code = switch (names[1]) {
    '甲' => 1,
    '乙' => 2,
    _ => 3,
  };
  return _q(
    templateId: 'tsy.who',
    seed: seed,
    nodeId: 'three_say',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '一个数是 ${_m(x)}、${_m(x + 1)}、${_m(x + 2)} 之一。${names[0]}说「是 ${_m(x)}」，${names[1]}说「大于 ${_m(x)}」，${names[2]}说「小于 ${_m(x + 2)}」。恰一句为真。谁在说真话？甲=1，乙=2，丙=3。',
    answer: '$code',
    hints: ['数为 ${_m(x + 2)} 时，只有「大于 ${_m(x)}」为真。'],
    steps: ['${names[1]}说真话，答案 ${_m(code)}。'],
    nodeRefs: ['three_say'],
  );
}

GeneratedQuestion _odrIdx(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, 5);
  return _q(
    templateId: 'odr.idx',
    seed: seed,
    nodeId: 'order_true',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '有 ${_m(n)} 句话：第 1 句说「恰有 0 句真」，第 2 句说「恰有 1 句真」，依此类推直到第 ${_m(n)} 句。哪一句为真？写出句序号。',
    answer: '2',
    hints: ['这些话互相排斥，只能有一句真，所以必须是「恰有 1 句真」。'],
    steps: ['第 2 句为真。'],
    nodeRefs: ['order_true'],
  );
}

GeneratedQuestion _odrN(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, 6);
  return _q(
    templateId: 'odr.n',
    seed: seed,
    nodeId: 'order_true',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '有 ${_m(n)} 句话，分别声称「恰有 0 句真」「恰有 1 句真」……「恰有 ${_m(n - 1)} 句真」。恰有几句为真？',
    answer: '1',
    hints: ['自指且互斥，只有「恰有 1 句真」能自洽。'],
    steps: ['恰有 1 句为真。'],
    nodeRefs: ['order_true'],
  );
}

GeneratedQuestion _whcA(int seed, Difficulty d) {
  final rng = Random(seed);
  final names = ['甲', '乙', '丙', '丁']..shuffle(rng);
  // ranks: names[2] first, names[0] second, names[1] third, names[3] last.
  const ranks = [2, 3, 1, 4];
  final ask = rng.nextInt(4);
  return _q(
    templateId: 'whc.a',
    seed: seed,
    nodeId: 'who_chain',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '${names[2]}第一，${names[3]}最后，${names[0]}不是第一，${names[1]}不是第二。${names[ask]}的名次是多少？（1 最高）',
    answer: '${ranks[ask]}',
    hints: ['第一、最后已定，剩下 2 和 3。${names[1]}不是第二，所以${names[0]}是第二。'],
    steps: ['${names[ask]}的名次是 ${_m(ranks[ask])}。'],
    nodeRefs: ['who_chain'],
    answerRange: (min: 1, max: 4),
  );
}

GeneratedQuestion _whcB(int seed, Difficulty d) {
  final rng = Random(seed);
  final names = ['甲', '乙', '丙', '丁']..shuffle(rng);
  const ranks = [2, 3, 1, 4];
  // The pair whose rank needs the 「不是第二」 clue, either way round.
  final ask = rng.nextBool() ? 1 : 0;
  return _q(
    templateId: 'whc.b',
    seed: seed,
    nodeId: 'who_chain',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '${names[2]}第一，${names[3]}最后，${names[0]}不是第一，${names[1]}不是第二。${names[ask]}的名次是多少？（1 最高）',
    answer: '${ranks[ask]}',
    hints: ['${names[1]}不是第二，只剩第三。'],
    steps: ['${names[ask]}的名次是 ${_m(ranks[ask])}。'],
    nodeRefs: ['who_chain'],
    answerRange: (min: 1, max: 4),
  );
}

GeneratedQuestion _lsqOn(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [10, 16, 25, 36, 50, 100][rng.nextInt(6)];
  final ans = OlympiadLogic.lightsOn(n);
  return _q(
    templateId: 'lsq.on',
    seed: seed,
    nodeId: 'light_sq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 盏灯开始全关。第 ${_m('k')} 人拨动编号为 ${_m('k')} 的倍数的灯。最后亮着几盏？',
    answer: '$ans',
    hints: ['编号被拨奇数次的灯亮着，只有完全平方数有奇数个因数。'],
    steps: ['亮着 ${_m(ans)} 盏。'],
    figure: LightsFigure(count: n > 12 ? 12 : n, onSquares: true),
    nodeRefs: ['light_sq'],
  );
}

GeneratedQuestion _lsqLast(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 2, 10);
  final lamp = k * k;
  return _q(
    templateId: 'lsq.last',
    seed: seed,
    nodeId: 'light_sq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '100 盏灯按倍数拨动。第 ${_m(lamp)} 号灯最后被第几人拨动？',
    answer: '$k',
    hints: ['最后一次是它的最大因数，也就是它自己。${_m(lamp)} 是平方数。'],
    steps: ['最后是第 ${_m(k)} 人。'],
    figure: LightsFigure(count: 10, highlight: lamp > 10 ? null : lamp),
    nodeRefs: ['light_sq'],
  );
}
