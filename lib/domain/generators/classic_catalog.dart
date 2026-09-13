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

/// Classic 中小学奥数 models still missing after the syllabus pass.
final List<QuestionTemplate> classicTemplates = [
  QuestionTemplate(
    id: 'deca.add',
    nodeId: 'dec_arith',
    difficulties: Difficulty.values.toSet(),
    build: _decaAdd,
  ),
  QuestionTemplate(
    id: 'deca.mul',
    nodeId: 'dec_arith',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _decaMul,
  ),
  QuestionTemplate(
    id: 'sqd.ten',
    nodeId: 'sq_diff',
    difficulties: Difficulty.values.toSet(),
    build: _sqdTen,
  ),
  QuestionTemplate(
    id: 'sqd.hundred',
    nodeId: 'sq_diff',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _sqdHundred,
  ),
  QuestionTemplate(
    id: 'csq.plus',
    nodeId: 'complete_sq',
    difficulties: Difficulty.values.toSet(),
    build: _csqPlus,
  ),
  QuestionTemplate(
    id: 'csq.minus',
    nodeId: 'complete_sq',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _csqMinus,
  ),
  QuestionTemplate(
    id: 'wavg.val',
    nodeId: 'weighted_avg',
    difficulties: Difficulty.values.toSet(),
    build: _wavgVal,
  ),
  QuestionTemplate(
    id: 'wavg.one',
    nodeId: 'weighted_avg',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _wavgOne,
  ),
  QuestionTemplate(
    id: 'per.sum',
    nodeId: 'period_sum',
    difficulties: Difficulty.values.toSet(),
    build: _perSum,
  ),
  QuestionTemplate(
    id: 'per.term',
    nodeId: 'period_sum',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _perTerm,
  ),
  QuestionTemplate(
    id: 'sqs.n',
    nodeId: 'square_sum',
    difficulties: Difficulty.values.toSet(),
    build: _sqsN,
  ),
  QuestionTemplate(
    id: 'sqs.range',
    nodeId: 'square_sum',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _sqsRange,
  ),
  QuestionTemplate(
    id: 'dir.y',
    nodeId: 'direct_prop',
    difficulties: Difficulty.values.toSet(),
    build: _dirY,
  ),
  QuestionTemplate(
    id: 'dir.x',
    nodeId: 'direct_prop',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _dirX,
  ),
  QuestionTemplate(
    id: 'inv.y',
    nodeId: 'inverse_prop',
    difficulties: Difficulty.values.toSet(),
    build: _invY,
  ),
  QuestionTemplate(
    id: 'inv.k',
    nodeId: 'inverse_prop',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _invK,
  ),
  QuestionTemplate(
    id: 'int.i',
    nodeId: 'interest',
    difficulties: Difficulty.values.toSet(),
    build: _intI,
  ),
  QuestionTemplate(
    id: 'int.p',
    nodeId: 'interest',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _intP,
  ),
  QuestionTemplate(
    id: 'pce.fare',
    nodeId: 'piecewise',
    difficulties: Difficulty.values.toSet(),
    build: _pceFare,
  ),
  QuestionTemplate(
    id: 'pce.extra',
    nodeId: 'piecewise',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _pceExtra,
  ),
  QuestionTemplate(
    id: 'inq.cnt',
    nodeId: 'ineq_sys',
    difficulties: Difficulty.values.toSet(),
    build: _inqCnt,
  ),
  QuestionTemplate(
    id: 'inq.max',
    nodeId: 'ineq_sys',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _inqMax,
  ),
  QuestionTemplate(
    id: 'cmp.amt',
    nodeId: 'compound',
    difficulties: Difficulty.values.toSet(),
    build: _cmpAmt,
  ),
  QuestionTemplate(
    id: 'cmp.gain',
    nodeId: 'compound',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _cmpGain,
  ),
  QuestionTemplate(
    id: 'mid.trap',
    nodeId: 'midline',
    difficulties: Difficulty.values.toSet(),
    build: _midTrap,
  ),
  QuestionTemplate(
    id: 'mid.tri',
    nodeId: 'midline',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _midTri,
  ),
  QuestionTemplate(
    id: 'cong.side',
    nodeId: 'cong_tri',
    difficulties: Difficulty.values.toSet(),
    build: _congSide,
  ),
  QuestionTemplate(
    id: 'cong.ang',
    nodeId: 'cong_tri',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _congAng,
  ),
  QuestionTemplate(
    id: 'arat.area',
    nodeId: 'area_ratio',
    difficulties: Difficulty.values.toSet(),
    build: _aratArea,
  ),
  QuestionTemplate(
    id: 'arat.sum',
    nodeId: 'area_ratio',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _aratSum,
  ),
  QuestionTemplate(
    id: 'tan.inc',
    nodeId: 'tangent_len',
    difficulties: Difficulty.values.toSet(),
    build: _tanInc,
  ),
  QuestionTemplate(
    id: 'tan.eq',
    nodeId: 'tangent_len',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _tanEq,
  ),
  QuestionTemplate(
    id: 'cyc.opp',
    nodeId: 'cyclic_quad',
    difficulties: Difficulty.values.toSet(),
    build: _cycOpp,
  ),
  QuestionTemplate(
    id: 'cyc.sum',
    nodeId: 'cyclic_quad',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _cycSum,
  ),
  QuestionTemplate(
    id: 'cone.l',
    nodeId: 'cone_slant',
    difficulties: Difficulty.values.toSet(),
    build: _coneL,
  ),
  QuestionTemplate(
    id: 'cone.deg',
    nodeId: 'cone_slant',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _coneDeg,
  ),
  QuestionTemplate(
    id: 'who.right',
    nodeId: 'who_map',
    difficulties: Difficulty.values.toSet(),
    build: _whoRight,
  ),
  QuestionTemplate(
    id: 'who.job',
    nodeId: 'who_map',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _whoJob,
  ),
  QuestionTemplate(
    id: 'liar.tri',
    nodeId: 'liar_pair',
    difficulties: Difficulty.values.toSet(),
    build: _liarTri,
  ),
  QuestionTemplate(
    id: 'liar.odd',
    nodeId: 'liar_pair',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _liarOdd,
  ),
  QuestionTemplate(
    id: 'match.rr',
    nodeId: 'match_count',
    difficulties: Difficulty.values.toSet(),
    build: _matchRr,
  ),
  QuestionTemplate(
    id: 'match.ko',
    nodeId: 'match_count',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _matchKo,
  ),
  QuestionTemplate(
    id: 'cross.trip',
    nodeId: 'crossing',
    difficulties: Difficulty.values.toSet(),
    build: _crossTrip,
  ),
  QuestionTemplate(
    id: 'cross.back',
    nodeId: 'crossing',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _crossBack,
  ),
  QuestionTemplate(
    id: 'seat.opp',
    nodeId: 'seating',
    difficulties: Difficulty.values.toSet(),
    build: _seatOpp,
  ),
  QuestionTemplate(
    id: 'seat.cw',
    nodeId: 'seating',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _seatCw,
  ),
  QuestionTemplate(
    id: 'wfk.bal',
    nodeId: 'weigh_fake',
    difficulties: Difficulty.values.toSet(),
    build: _wfkBal,
  ),
  QuestionTemplate(
    id: 'wfk.tilt',
    nodeId: 'weigh_fake',
    difficulties: Difficulty.values.toSet(),
    build: _wfkTilt,
  ),
  QuestionTemplate(
    id: 'nadj.pos',
    nodeId: 'adjacent_ban',
    difficulties: Difficulty.values.toSet(),
    build: _nadjPos,
  ),
  QuestionTemplate(
    id: 'nadj.line',
    nodeId: 'adjacent_ban',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _nadjLine,
  ),
  QuestionTemplate(
    id: 'grp.half',
    nodeId: 'group_split',
    difficulties: Difficulty.values.toSet(),
    build: _grpHalf,
  ),
  QuestionTemplate(
    id: 'grp.pick',
    nodeId: 'group_split',
    difficulties: Difficulty.values.toSet(),
    build: _grpPick,
  ),
  QuestionTemplate(
    id: 'brow.sum',
    nodeId: 'binom_row',
    difficulties: Difficulty.values.toSet(),
    build: _browSum,
  ),
  QuestionTemplate(
    id: 'brow.half',
    nodeId: 'binom_row',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _browHalf,
  ),
  QuestionTemplate(
    id: 'bcol.blk',
    nodeId: 'board_color',
    difficulties: Difficulty.values.toSet(),
    build: _bcolBlk,
  ),
  QuestionTemplate(
    id: 'bcol.need',
    nodeId: 'board_color',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _bcolNeed,
  ),
  QuestionTemplate(
    id: 'adjc.line',
    nodeId: 'adj_color',
    difficulties: Difficulty.values.toSet(),
    build: _adjcLine,
  ),
  QuestionTemplate(
    id: 'adjc.k',
    nodeId: 'adj_color',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _adjcK,
  ),
  QuestionTemplate(
    id: 'cat.par',
    nodeId: 'catalan',
    difficulties: Difficulty.values.toSet(),
    build: _catPar,
  ),
  QuestionTemplate(
    id: 'cat.poly',
    nodeId: 'catalan',
    difficulties: Difficulty.values.toSet(),
    build: _catPoly,
  ),
  QuestionTemplate(
    id: 'cmul.n',
    nodeId: 'count_mult',
    difficulties: Difficulty.values.toSet(),
    build: _cmulN,
  ),
  QuestionTemplate(
    id: 'cmul.range',
    nodeId: 'count_mult',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _cmulRange,
  ),
  QuestionTemplate(
    id: 'droot.val',
    nodeId: 'digit_root',
    difficulties: Difficulty.values.toSet(),
    build: _drootVal,
  ),
  QuestionTemplate(
    id: 'droot.mod',
    nodeId: 'digit_root',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _drootMod,
  ),
  QuestionTemplate(
    id: 'dsum.n',
    nodeId: 'divisor_sum',
    difficulties: Difficulty.values.toSet(),
    build: _dsumN,
  ),
  QuestionTemplate(
    id: 'dsum.proper',
    nodeId: 'divisor_sum',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _dsumProper,
  ),
  QuestionTemplate(
    id: 'oddv.n',
    nodeId: 'odd_div',
    difficulties: Difficulty.values.toSet(),
    build: _oddvN,
  ),
  QuestionTemplate(
    id: 'oddv.list',
    nodeId: 'odd_div',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _oddvList,
  ),
  QuestionTemplate(
    id: 'ltwo.val',
    nodeId: 'last_two',
    difficulties: Difficulty.values.toSet(),
    build: _ltwoVal,
  ),
  QuestionTemplate(
    id: 'ltwo.same',
    nodeId: 'last_two',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _ltwoSame,
  ),
];

String _m(Object v) => mathInline(v);
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

GeneratedQuestion _decaAdd(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 12, d == Difficulty.basic ? 40 : 80);
  final b = _rand(rng, 11, d == Difficulty.basic ? 35 : 70);
  final ans = a + b;
  return _q(
    templateId: 'deca.add',
    seed: seed,
    nodeId: 'dec_arith',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '${_m('${a ~/ 10}.${a % 10}')} 元加 ${_m('${b ~/ 10}.${b % 10}')} 元，一共多少角？',
    answer: '$ans',
    hints: ['先都化成角：${_m(a)} 角加 ${_m(b)} 角。', '1 元 = 10 角。'],
    steps: ['${_m('$a + $b = $ans')} 角。'],
    nodeRefs: ['dec_arith'],
  );
}

GeneratedQuestion _decaMul(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 2, d == Difficulty.basic ? 6 : 10);
  final even = n.isEven ? n : n + 1;
  final ans = 25 * even ~/ 10;
  return _q(
    templateId: 'deca.mul',
    seed: seed,
    nodeId: 'dec_arith',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '计算 ${_m('2.5 \\times $even')}。',
    answer: '$ans',
    hints: ['${_m('2.5 = 5/2')}，或先算 ${_m('25 \\times $even')} 再除以 10。'],
    steps: ['${_m('2.5 \\times $even = $ans')}。'],
    nodeRefs: ['dec_arith'],
  );
}

GeneratedQuestion _sqdTen(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 1, d == Difficulty.contest ? 8 : 6);
  final ans = Calculation.sqDiff(10, k);
  return _q(
    templateId: 'sqd.ten',
    seed: seed,
    nodeId: 'sq_diff',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '用平方差计算 ${_m('${10 + k} \\times ${10 - k}')}。',
    answer: '$ans',
    hints: ['${_m('(10+$k)(10-$k)=10^2-$k^2')}。'],
    steps: ['${_m('100 - ${k * k} = $ans')}。'],
    nodeRefs: ['sq_diff'],
  );
}

GeneratedQuestion _sqdHundred(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 2, 6);
  final ans = Calculation.sqDiff(100, k);
  return _q(
    templateId: 'sqd.hundred',
    seed: seed,
    nodeId: 'sq_diff',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '用平方差计算 ${_m('${100 + k} \\times ${100 - k}')}。',
    answer: '$ans',
    hints: ['${_m('(100+$k)(100-$k)=10000-$k^2')}。'],
    steps: ['${_m('10000 - ${k * k} = $ans')}。'],
    nodeRefs: ['sq_diff'],
  );
}

GeneratedQuestion _csqPlus(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 1, d == Difficulty.contest ? 9 : 6);
  final ans = Calculation.completeSq(10, k);
  return _q(
    templateId: 'csq.plus',
    seed: seed,
    nodeId: 'complete_sq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '计算 ${_m('(10+$k)^2')}。',
    answer: '$ans',
    hints: ['${_m('(a+b)^2=a^2+2ab+b^2')}。'],
    steps: ['${_m('100 + ${20 * k} + ${k * k} = $ans')}。'],
    nodeRefs: ['complete_sq'],
  );
}

GeneratedQuestion _csqMinus(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 1, 4);
  final ans = Calculation.completeSq(100, -k);
  return _q(
    templateId: 'csq.minus',
    seed: seed,
    nodeId: 'complete_sq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '计算 ${_m('${100 - k}^2')}，先写成 ${_m('(100-$k)^2')}。',
    answer: '$ans',
    hints: ['${_m('(a-b)^2=a^2-2ab+b^2')}。'],
    steps: ['${_m('10000 - ${200 * k} + ${k * k} = $ans')}。'],
    nodeRefs: ['complete_sq'],
  );
}

GeneratedQuestion _wavgVal(int seed, Difficulty d) {
  final rng = Random(seed);
  final cases = [
    ([80, 90, 70], [2, 2, 1], 82),
    ([60, 80, 100], [1, 2, 1], 80),
    ([70, 85, 95], [2, 1, 1], 80),
    ([50, 70, 90], [1, 1, 2], 75),
    ([88, 76, 92], [1, 2, 1], 83),
  ];
  final pick = cases[rng.nextInt(cases.length)];
  final xs = pick.$1;
  final ws = pick.$2;
  final ans = pick.$3;
  assert(Calculation.weightedMean(xs, ws) == ans);
  return _q(
    templateId: 'wavg.val',
    seed: seed,
    nodeId: 'weighted_avg',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '三科成绩 ${_m(xs[0])}、${_m(xs[1])}、${_m(xs[2])}，权重 ${_m(ws[0])}、${_m(ws[1])}、${_m(ws[2])}。加权平均数是多少？',
    answer: '$ans',
    hints: ['分子是成绩乘权重再相加，分母是权重之和 ${_m(ws[0] + ws[1] + ws[2])}。'],
    steps: ['加权平均是 ${_m(ans)}。'],
    nodeRefs: ['weighted_avg', 'mean_avg'],
  );
}

GeneratedQuestion _wavgOne(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 60, 80);
  final wa = _rand(rng, 1, 3);
  final wb = _rand(rng, 1, 3);
  // A weighted average of 82.5 asked as「整数部分」teaches rounding, not
  // weighting; keep only the second score that divides out exactly.
  final fits = [
    for (var k = 4; k <= 16; k++)
      if ((a * wa + (a + k) * wb) % (wa + wb) == 0) a + k,
  ];
  final b = fits[rng.nextInt(fits.length)];
  final ans = Calculation.weightedMean([a, b], [wa, wb]);
  return _q(
    templateId: 'wavg.one',
    seed: seed,
    nodeId: 'weighted_avg',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(a)} 分出现 ${_m(wa)} 次，${_m(b)} 分出现 ${_m(wb)} 次。加权平均数是多少？',
    answer: '$ans',
    hints: ['总和 ${_m('$a \\times $wa + $b \\times $wb')}，再除以 ${_m(wa + wb)}。'],
    steps: ['加权平均数是 ${_m(ans)}。'],
    nodeRefs: ['weighted_avg'],
  );
}

GeneratedQuestion _perSum(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 1, 5);
  // Two equal terms make a constant sequence, not a periodic one.
  var b = _rand(rng, 1, 6);
  if (b == a) b = a == 6 ? 1 : a + 1;
  final n = _rand(rng, 8, d == Difficulty.contest ? 18 : 14);
  final period = [a, b];
  final ans = Calculation.periodSum(period, n);
  return _q(
    templateId: 'per.sum',
    seed: seed,
    nodeId: 'period_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '数列 ${_m(a)}、${_m(b)}、${_m(a)}、${_m(b)}、…… 的前 ${_m(n)} 项和是多少？',
    answer: '$ans',
    hints: ['循环节 ${_m('$a,$b')} 的和是 ${_m(a + b)}。先算完整循环，再加剩余项。'],
    steps: ['前 ${_m(n)} 项和是 ${_m(ans)}。'],
    nodeRefs: ['period_sum'],
  );
}

GeneratedQuestion _perTerm(int seed, Difficulty d) {
  final rng = Random(seed);
  final period = [_rand(rng, 2, 7), _rand(rng, 1, 6), _rand(rng, 3, 8)];
  final n = _rand(rng, 5, 14);
  final ans = period[(n - 1) % 3];
  return _q(
    templateId: 'per.term',
    seed: seed,
    nodeId: 'period_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '数列按 ${_m(period[0])}, ${_m(period[1])}, ${_m(period[2])} 循环。第 ${_m(n)} 项是多少？',
    answer: '$ans',
    hints: ['项号减 1 再模 3。'],
    steps: ['第 ${_m(n)} 项是 ${_m(ans)}。'],
    nodeRefs: ['period_sum'],
  );
}

GeneratedQuestion _sqsN(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, d == Difficulty.contest ? 12 : 8);
  final ans = Calculation.squareSum(n);
  return _q(
    templateId: 'sqs.n',
    seed: seed,
    nodeId: 'square_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('1^2+2^2+\\cdots+$n^2')}。',
    answer: '$ans',
    hints: ['公式 ${_m('\\frac{n(n+1)(2n+1)}{6}')}。'],
    steps: ['代入 ${_m(n)} 得 ${_m(ans)}。'],
    nodeRefs: ['square_sum'],
  );
}

GeneratedQuestion _sqsRange(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 5);
  final b = a + _rand(rng, 2, 5);
  final ans = Calculation.squareSum(b) - Calculation.squareSum(a - 1);
  return _q(
    templateId: 'sqs.range',
    seed: seed,
    nodeId: 'square_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('$a^2+\\cdots+$b^2')}。',
    answer: '$ans',
    hints: ['用 ${_m('S_b - S_{${a - 1}}')}。'],
    steps: ['差是 ${_m(ans)}。'],
    nodeRefs: ['square_sum'],
  );
}

GeneratedQuestion _dirY(int seed, Difficulty d) {
  final rng = Random(seed);
  final knownX = _rand(rng, 2, 6);
  final k = _rand(rng, 3, 8);
  final knownY = knownX * k;
  final askX = knownX * _rand(rng, 2, 4);
  final ans = Algebra.directY(knownX: knownX, knownY: knownY, askX: askX);
  return _q(
    templateId: 'dir.y',
    seed: seed,
    nodeId: 'direct_prop',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(knownX)} 千克售 ${_m(knownY)} 元，按正比例，${_m(askX)} 千克售多少元？',
    answer: '$ans',
    hints: ['单价 ${_m('$knownY / $knownX')} 元/千克。'],
    steps: ['${_m('$askX')} 千克售 ${_m(ans)} 元。'],
    nodeRefs: ['direct_prop'],
  );
}

GeneratedQuestion _dirX(int seed, Difficulty d) {
  final rng = Random(seed);
  final knownX = _rand(rng, 2, 5);
  final k = _rand(rng, 4, 9);
  final knownY = knownX * k;
  final askY = knownY * _rand(rng, 2, 3);
  final ans = askY ~/ k;
  return _q(
    templateId: 'dir.x',
    seed: seed,
    nodeId: 'direct_prop',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        'y 与 x 成正比例。当 ${_m('x=$knownX')} 时 ${_m('y=$knownY')}。问 y 为 ${_m(askY)} 时 x 是多少？',
    answer: '$ans',
    hints: ['${_m('k=y/x=$k')}，故 ${_m('x=y/k')}。'],
    steps: ['x 是 ${_m(ans)}。'],
    nodeRefs: ['direct_prop'],
  );
}

GeneratedQuestion _invY(int seed, Difficulty d) {
  final rng = Random(seed);
  final knownX = _rand(rng, 3, 8);
  final knownY = _rand(rng, 4, 12);
  final k = knownX * knownY;
  final factors = <int>[
    for (var t = 2; t <= k; t++)
      if (t != knownX && k % t == 0) t,
  ];
  final askX = factors.isEmpty ? k : factors[rng.nextInt(factors.length)];
  final ans = Algebra.inverseY(knownX: knownX, knownY: knownY, askX: askX);
  return _q(
    templateId: 'inv.y',
    seed: seed,
    nodeId: 'inverse_prop',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(knownX)} 人 ${_m(knownY)} 天完工。人数与天数成反比例。${_m(askX)} 人要几天？',
    answer: '$ans',
    hints: ['${_m('xy=${knownX * knownY}')} 保持不变。'],
    steps: ['需要 ${_m(ans)} 天。'],
    nodeRefs: ['inverse_prop'],
  );
}

GeneratedQuestion _invK(int seed, Difficulty d) {
  final rng = Random(seed);
  final x = _rand(rng, 3, 9);
  final y = _rand(rng, 4, 12);
  final ans = x * y;
  return _q(
    templateId: 'inv.k',
    seed: seed,
    nodeId: 'inverse_prop',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '反比例 ${_m('xy=k')}。已知 ${_m('x=$x')}、${_m('y=$y')}，求 k。',
    answer: '$ans',
    hints: ['k 就是乘积。'],
    steps: ['${_m('k=$ans')}。'],
    nodeRefs: ['inverse_prop'],
  );
}

GeneratedQuestion _intI(int seed, Difficulty d) {
  final rng = Random(seed);
  final p = [200, 400, 500, 800][rng.nextInt(4)];
  final r = [5, 10, 20][rng.nextInt(3)];
  final t = _rand(rng, 2, 4);
  final ans = Algebra.simpleInterest(principal: p, rate: r, years: t);
  return _q(
    templateId: 'int.i',
    seed: seed,
    nodeId: 'interest',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '本金 ${_m(p)} 元，年利率 ${_m('$r\\%')}，单利 ${_m(t)} 年。利息是多少元？',
    answer: '$ans',
    hints: ['${_m('I = prt')}，利率先写成百分数。'],
    steps: ['利息 ${_m(ans)} 元。'],
    nodeRefs: ['interest'],
  );
}

GeneratedQuestion _intP(int seed, Difficulty d) {
  final rng = Random(seed);
  final r = [5, 10][rng.nextInt(2)];
  final t = _rand(rng, 2, 4);
  final i = r * t * _rand(rng, 2, 6);
  final ans = i * 100 ~/ (r * t);
  return _q(
    templateId: 'int.p',
    seed: seed,
    nodeId: 'interest',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '单利年利率 ${_m('$r\\%')}，${_m(t)} 年利息 ${_m(i)} 元。本金是多少元？',
    answer: '$ans',
    hints: ['${_m('p = I / (rt)')}。'],
    steps: ['本金 ${_m(ans)} 元。'],
    nodeRefs: ['interest'],
  );
}

GeneratedQuestion _pceFare(int seed, Difficulty d) {
  final rng = Random(seed);
  final baseKm = 3;
  final baseFare = _rand(rng, 8, 12);
  final extra = _rand(rng, 2, 4);
  final dist = _rand(rng, 4, d == Difficulty.contest ? 14 : 10);
  final ans = Algebra.taxiFare(
    baseKm: baseKm,
    baseFare: baseFare,
    extraPer: extra,
    dist: dist,
  );
  return _q(
    templateId: 'pce.fare',
    seed: seed,
    nodeId: 'piecewise',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '出租车起步 ${_m(baseKm)} 千米 ${_m(baseFare)} 元，之后每千米 ${_m(extra)} 元。走 ${_m(dist)} 千米要多少元？',
    answer: '$ans',
    hints: ['超出 ${_m(dist - baseKm)} 千米，续费 ${_m((dist - baseKm) * extra)}。'],
    steps: ['共 ${_m(ans)} 元。'],
    nodeRefs: ['piecewise'],
  );
}

GeneratedQuestion _pceExtra(int seed, Difficulty d) {
  final rng = Random(seed);
  final baseKm = 3;
  final extra = _rand(rng, 2, 5);
  final dist = _rand(rng, 5, 12);
  final ans = (dist - baseKm) * extra;
  return _q(
    templateId: 'pce.extra',
    seed: seed,
    nodeId: 'piecewise',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '起步 ${_m(baseKm)} 千米后每千米 ${_m(extra)} 元。走 ${_m(dist)} 千米，续费多少元（不含起步价）？',
    answer: '$ans',
    hints: ['续费里程 ${_m(dist - baseKm)}。'],
    steps: ['续费 ${_m(ans)} 元。'],
    nodeRefs: ['piecewise'],
  );
}

GeneratedQuestion _inqCnt(int seed, Difficulty d) {
  final rng = Random(seed);
  final lo = _rand(rng, 1, 6);
  final hi = lo + _rand(rng, 4, d == Difficulty.contest ? 10 : 7);
  final ans = Algebra.openCount(lo, hi);
  return _q(
    templateId: 'inq.cnt',
    seed: seed,
    nodeId: 'ineq_sys',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '整数 x 同时满足 ${_m('x>$lo')} 与 ${_m('x<$hi')}。这样的 x 有多少个？',
    answer: '$ans',
    hints: ['开区间 ${_m('($lo,$hi)')} 里的整数个数是 ${_m('$hi-$lo-1')}。'],
    steps: ['共 ${_m(ans)} 个。'],
    nodeRefs: ['ineq_sys'],
  );
}

GeneratedQuestion _inqMax(int seed, Difficulty d) {
  final rng = Random(seed);
  final lo = _rand(rng, 2, 8);
  final hi = lo + _rand(rng, 3, 8);
  final ans = Algebra.openLargest(lo, hi);
  return _q(
    templateId: 'inq.max',
    seed: seed,
    nodeId: 'ineq_sys',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '整数 x 满足 ${_m('$lo<x<$hi')}。最大的 x 是多少？',
    answer: '$ans',
    hints: ['比 ${_m(hi)} 小的最大整数。'],
    steps: ['最大是 ${_m(ans)}。'],
    nodeRefs: ['ineq_sys'],
  );
}

GeneratedQuestion _cmpAmt(int seed, Difficulty d) {
  final rng = Random(seed);
  final p = [100, 200, 400][rng.nextInt(3)];
  final r = [10, 20][rng.nextInt(2)];
  final ans = Algebra.compoundAmount(principal: p, rate: r, years: 2);
  return _q(
    templateId: 'cmp.amt',
    seed: seed,
    nodeId: 'compound',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '本金 ${_m(p)} 元，年利率 ${_m('$r\\%')}，每年复利一次，2 年后本利和是多少元？',
    answer: '$ans',
    hints: ['每年乘 ${_m('${100 + r}/100')}，连乘两次。'],
    steps: ['本利和 ${_m(ans)} 元。'],
    nodeRefs: ['compound'],
  );
}

GeneratedQuestion _cmpGain(int seed, Difficulty d) {
  final rng = Random(seed);
  final p = [100, 200][rng.nextInt(2)];
  final r = [10, 20][rng.nextInt(2)];
  final amt = Algebra.compoundAmount(principal: p, rate: r, years: 2);
  final ans = amt - p;
  return _q(
    templateId: 'cmp.gain',
    seed: seed,
    nodeId: 'compound',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '本金 ${_m(p)} 元，年利率 ${_m('$r\\%')}，复利 2 年。比本金多了多少元？',
    answer: '$ans',
    hints: ['先算本利和再减本金。不要用单利 ${_m('2pr')}。'],
    steps: ['多 ${_m(ans)} 元。'],
    nodeRefs: ['compound', 'interest'],
  );
}

GeneratedQuestion _midTrap(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 4, 12);
  final b = a + 2 * _rand(rng, 1, 6);
  final ans = Geometry.trapMidline(a, b);
  return _q(
    templateId: 'mid.trap',
    seed: seed,
    nodeId: 'midline',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '梯形两底 ${_m(a)}、${_m(b)}。中位线长多少？',
    answer: '$ans',
    hints: ['梯形中位线是两底的算术平均。'],
    steps: ['${_m('($a+$b)/2=$ans')}。'],
    figure: TrapezoidFigure(top: '$a', bottom: '$b', midline: '?'),
    nodeRefs: ['midline'],
  );
}

GeneratedQuestion _midTri(int seed, Difficulty d) {
  final rng = Random(seed);
  final base = 2 * _rand(rng, 4, 12);
  final ans = base ~/ 2;
  return _q(
    templateId: 'mid.tri',
    seed: seed,
    nodeId: 'midline',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '三角形一边长 ${_m(base)}。这边的中位线长多少？',
    answer: '$ans',
    hints: ['三角形中位线等于第三边的一半。'],
    steps: ['中位线 ${_m(ans)}。'],
    figure: TriangleFigure(midline: true, sideAB: '$base'),
    nodeRefs: ['midline'],
  );
}

GeneratedQuestion _congSide(int seed, Difficulty d) {
  final rng = Random(seed);
  final c = _rand(rng, 5, 16);
  return _q(
    templateId: 'cong.side',
    seed: seed,
    nodeId: 'cong_tri',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '${_m('\\triangle ABC \\cong \\triangle DEF')}，且 ${_m('AB=$c')}。求 ${_m('DE')}。',
    answer: '$c',
    hints: ['全等对应边相等。顶点顺序 ABC 对 DEF，故 AB 对 DE。'],
    steps: ['${_m('DE=$c')}。'],
    figure: SimilarPairFigure(congruent: true, smallSide: '$c'),
    nodeRefs: ['cong_tri'],
  );
}

GeneratedQuestion _congAng(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 20, 80);
  return _q(
    templateId: 'cong.ang',
    seed: seed,
    nodeId: 'cong_tri',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '${_m('\\triangle ABC \\cong \\triangle XYZ')}，${_m('\\angle A=$a^\\circ')}。求 ${_m('\\angle X')} 的度数。',
    answer: '$a',
    hints: ['对应角相等，A 对 X。'],
    steps: ['${_m('\\angle X=$a')}。'],
    figure: const SimilarPairFigure(congruent: true),
    nodeRefs: ['cong_tri'],
  );
}

GeneratedQuestion _aratArea(int seed, Difficulty d) {
  final rng = Random(seed);
  final t = _rand(rng, 2, 6);
  final small = 4 * t;
  final ans = Geometry.similarArea(
    knownArea: small,
    knownRatio: 2,
    askRatio: 3,
  );
  return _q(
    templateId: 'arat.area',
    seed: seed,
    nodeId: 'area_ratio',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '两相似三角形对应边之比为 ${_m('2:3')}，较小的面积是 ${_m(small)}。较大的面积是多少？',
    answer: '$ans',
    hints: ['面积比是相似比的平方 ${_m('4:9')}。'],
    steps: ['较大面积 ${_m(ans)}。'],
    figure: const SimilarPairFigure(ratio: '2:3'),
    nodeRefs: ['area_ratio', 'similar_tri'],
  );
}

GeneratedQuestion _aratSum(int seed, Difficulty d) {
  final rng = Random(seed);
  final t = _rand(rng, 1, 5);
  final ans = 4 * t + 9 * t;
  return _q(
    templateId: 'arat.sum',
    seed: seed,
    nodeId: 'area_ratio',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '相似比为 ${_m('2:3')}。若较小面积是 ${_m(4 * t)}，两块面积之和是多少？',
    answer: '$ans',
    hints: ['较大是 ${_m(9 * t)}。'],
    steps: ['和为 ${_m(ans)}。'],
    figure: const SimilarPairFigure(ratio: '2:3'),
    nodeRefs: ['area_ratio'],
  );
}

GeneratedQuestion _tanInc(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 1, d == Difficulty.contest ? 5 : 3);
  final a = 5 * k;
  final b = 4 * k;
  final c = 3 * k;
  final ans = Geometry.incircleTangent(a, b, c);
  return _q(
    templateId: 'tan.inc',
    seed: seed,
    nodeId: 'tangent_len',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '直角三角形三边 ${_m(c)}、${_m(b)}、${_m(a)}，有内切圆。从直角顶点（对边 ${_m(a)}）到切点的切线长是多少？',
    answer: '$ans',
    hints: ['切线长 ${_m('s-a')}，其中 ${_m('s=(a+b+c)/2')}。'],
    steps: ['切线长 ${_m(ans)}。'],
    figure: TriangleFigure(
      rightAt: 'C',
      sideAB: '$a',
      sideBC: '$b',
      sideCA: '$c',
      incircle: true,
    ),
    nodeRefs: ['tangent_len'],
  );
}

GeneratedQuestion _tanEq(int seed, Difficulty d) {
  final rng = Random(seed);
  final t = _rand(rng, 5, 18);
  return _q(
    templateId: 'tan.eq',
    seed: seed,
    nodeId: 'tangent_len',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '圆外一点引两条切线，其中一条长 ${_m(t)}。另一条长多少？',
    answer: '$t',
    hints: ['从圆外一点所引两条切线长相等。'],
    steps: ['另一条也是 ${_m(t)}。'],
    figure: TangentFigure(twoTangents: true, length: '$t'),
    nodeRefs: ['tangent_len'],
  );
}

GeneratedQuestion _cycOpp(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 40, 100);
  final ans = 180 - a;
  return _q(
    templateId: 'cyc.opp',
    seed: seed,
    nodeId: 'cyclic_quad',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '圆内接四边形一内角是 ${_m('$a^\\circ')}。它的对角是多少度？',
    answer: '$ans',
    hints: ['圆内接四边形对角互补。'],
    steps: ['${_m('180-$a=$ans')}。'],
    figure: CyclicQuadFigure(interior: '$a'),
    nodeRefs: ['cyclic_quad'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _cycSum(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 50, 110);
  final b = _rand(rng, 50, 110);
  // Asking for x + a would answer 180 whatever the numbers are. Naming the
  // vertices asks the real question: which angle is opposite which.
  return _q(
    templateId: 'cyc.sum',
    seed: seed,
    nodeId: 'cyclic_quad',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '圆内接四边形 ABCD 中 ${_m('\\angle A = $a^\\circ')}，${_m('\\angle B = $b^\\circ')}。求 ${_m('\\angle D')} 的度数。',
    answer: '${180 - b}',
    hints: [
      '对角互补：${_m('\\angle A + \\angle C = 180^\\circ')}，${_m('\\angle B + \\angle D = 180^\\circ')}。',
      '${_m('\\angle D')} 与 ${_m('\\angle B')} 是对角。',
    ],
    steps: ['${_m('\\angle D = 180 - $b = ${180 - b}')} 度。'],
    figure: CyclicQuadFigure(interior: '$b'),
    nodeRefs: ['cyclic_quad'],
    answerRange: (min: 1, max: 179),
  );
}

/// Radius and height of a cone whose slant is whole: a Pythagorean pair.
List<(int r, int h)> _slantLegs(Difficulty d) => switch (d) {
  Difficulty.basic => const [(3, 4), (6, 8), (9, 12), (5, 12), (8, 15)],
  Difficulty.medium => const [(6, 8), (9, 12), (5, 12), (8, 15), (12, 16)],
  Difficulty.contest => const [(9, 12), (8, 15), (12, 16), (7, 24), (20, 21)],
};

GeneratedQuestion _coneL(int seed, Difficulty d) {
  final rng = Random(seed);
  final legs = _slantLegs(d);
  final (r, h) = legs[rng.nextInt(legs.length)];
  final ans = Geometry.hypotInt(r, h);
  return _q(
    templateId: 'cone.l',
    seed: seed,
    nodeId: 'cone_slant',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '圆锥底半径 ${_m(r)}、高 ${_m(h)}。母线长多少？',
    answer: '$ans',
    hints: ['母线、半径、高组成直角三角形。'],
    steps: ['母线 ${_m(ans)}。'],
    figure: RevolutionFigure(
      kind: RevolutionKind.cone,
      radius: '$r',
      height: '$h',
      slant: '?',
    ),
    nodeRefs: ['cone_slant', 'pythagorean'],
  );
}

GeneratedQuestion _coneDeg(int seed, Difficulty d) {
  final rng = Random(seed);
  // Any (r, l) whose 360r/l is whole, so the unrolled angle varies.
  final pairs = [
    (3, 5),
    (2, 5),
    (3, 4),
    (5, 8),
    (4, 5),
    (1, 2),
    (5, 6),
    (7, 8),
  ];
  final p = pairs[rng.nextInt(pairs.length)];
  final k = _rand(rng, 1, 3);
  final r = p.$1 * k;
  final l = p.$2 * k;
  final ans = Geometry.coneUnfoldDeg(r, l);
  return _q(
    templateId: 'cone.deg',
    seed: seed,
    nodeId: 'cone_slant',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '圆锥底半径 ${_m(r)}、母线 ${_m(l)}。侧面展开扇形的圆心角是多少度？',
    answer: '$ans',
    hints: ['圆心角 ${_m('360 \\times r / l')}。'],
    steps: ['圆心角 ${_m(ans)} 度。'],
    figure: SectorFigure(radius: '$l', degrees: ans, angle: '?', arc: '2πr'),
    nodeRefs: ['cone_slant', 'sector_arc'],
    answerRange: (min: 1, max: 360),
  );
}

GeneratedQuestion _whoRight(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 5, d == Difficulty.contest ? 12 : 9);
  final k = _rand(rng, 1, n);
  final ans = OlympiadLogic.fromRight(n, k);
  return _q(
    templateId: 'who.right',
    seed: seed,
    nodeId: 'who_map',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 个杯子从左排到右。左边数第 ${_m(k)} 个，从右边数是第几个？',
    answer: '$ans',
    hints: ['左右编号之和是 ${_m(n + 1)}。'],
    steps: ['从右数第 ${_m(ans)} 个。'],
    nodeRefs: ['who_map'],
  );
}

GeneratedQuestion _whoJob(int seed, Difficulty d) {
  final rng = Random(seed);
  final jobs = [1, 2, 3]..shuffle(rng);
  final a = jobs[0];
  final b = jobs[1];
  final c = jobs[2];
  return _q(
    templateId: 'who.job',
    seed: seed,
    nodeId: 'who_map',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '甲乙丙各做 1、2、3 号工作，每人一份。丙做 ${_m(c)} 号，甲不做 ${_m(b)} 号。乙做几号？',
    answer: '$b',
    hints: ['丙拿走 ${_m(c)} 后剩下 ${_m(a)} 与 ${_m(b)}。甲不做 ${_m(b)}，故甲做 ${_m(a)}。'],
    steps: ['乙做 ${_m(b)} 号。'],
    nodeRefs: ['who_map'],
  );
}

GeneratedQuestion _liarTri(int seed, Difficulty d) {
  final rng = Random(seed);
  final x = _rand(rng, 2, d == Difficulty.contest ? 12 : 8);
  final ans = OlympiadLogic.liarTriple(x);
  return _q(
    templateId: 'liar.tri',
    seed: seed,
    nodeId: 'liar_pair',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '答案只可能是 ${_m(x)}、${_m(x + 1)}、${_m(x + 2)}。甲说「是 ${_m(x)}」，乙说「不是 ${_m(x + 1)}」。恰好一句为真。答案是多少？',
    answer: '$ans',
    hints: ['若是 ${_m(x)}，两句都真；若是 ${_m(x + 1)}，两句都假。'],
    steps: ['只能是 ${_m(ans)}：甲假乙真。'],
    nodeRefs: ['liar_pair', 'true_count'],
  );
}

GeneratedQuestion _liarOdd(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = 2 * _rand(rng, 3, 8) + 1;
  final ans = OlympiadLogic.liarAroundOdd(n);
  return _q(
    templateId: 'liar.odd',
    seed: seed,
    nodeId: 'liar_pair',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '答案是 ${_m(n - 1)}、${_m(n)}、${_m(n + 1)} 之一。甲说「是偶数」，乙说「大于 ${_m(n)}」。恰好一句为真。答案是多少？',
    answer: '$ans',
    hints: ['${_m(n)} 是奇数。逐个代入看谁一真一假。'],
    steps: ['只有 ${_m(ans)}：甲真乙假。'],
    nodeRefs: ['liar_pair'],
  );
}

GeneratedQuestion _matchRr(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, d == Difficulty.contest ? 10 : 8);
  final ans = OlympiadLogic.roundRobin(n);
  return _q(
    templateId: 'match.rr',
    seed: seed,
    nodeId: 'match_count',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 支球队单循环，每两队赛一场。一共多少场？',
    answer: '$ans',
    hints: ['场次是 ${_m('C($n,2)')}。'],
    steps: ['共 ${_m(ans)} 场。'],
    nodeRefs: ['match_count'],
  );
}

GeneratedQuestion _matchKo(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 5, 16);
  final ans = OlympiadLogic.knockoutMatches(n);
  return _q(
    templateId: 'match.ko',
    seed: seed,
    nodeId: 'match_count',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 支球队单场淘汰决出冠军。一共要赛多少场？',
    answer: '$ans',
    hints: ['每场淘汰 1 队，要淘汰 ${_m(n - 1)} 队。'],
    steps: ['共 ${_m(ans)} 场。'],
    nodeRefs: ['match_count'],
  );
}

GeneratedQuestion _crossTrip(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, d == Difficulty.contest ? 8 : 6);
  final ans = OlympiadLogic.boatTrips(n);
  return _q(
    templateId: 'cross.trip',
    seed: seed,
    nodeId: 'crossing',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 人过河，船每次最多 2 人，且过河后必须有人把船划回来（最后一次除外）。共要走多少趟？',
    answer: '$ans',
    hints: ['两人船、一人送回：趟数 ${_m('2n-3')}。'],
    steps: ['共 ${_m(ans)} 趟。'],
    nodeRefs: ['crossing'],
  );
}

GeneratedQuestion _crossBack(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, 7);
  final ans = OlympiadLogic.boatReturns(n);
  return _q(
    templateId: 'cross.back',
    seed: seed,
    nodeId: 'crossing',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 人过河，船载 2 人、需人送回。送回的趟数是多少（不含最后一次到达）？',
    answer: '$ans',
    hints: ['送回 ${_m('n-2')} 次。'],
    steps: ['送回 ${_m(ans)} 趟。'],
    nodeRefs: ['crossing'],
  );
}

GeneratedQuestion _seatOpp(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = 2 * _rand(rng, 3, 6);
  final k = _rand(rng, 1, n);
  final ans = OlympiadLogic.oppositeSeat(n, k);
  return _q(
    templateId: 'seat.opp',
    seed: seed,
    nodeId: 'seating',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 个座位围成一圈，依次编号 1 到 ${_m(n)}。与 ${_m(k)} 号对坐的是几号？',
    answer: '$ans',
    hints: ['对座相差 ${_m(n ~/ 2)} 个座位。'],
    steps: ['对座是 ${_m(ans)} 号。'],
    nodeRefs: ['seating'],
  );
}

GeneratedQuestion _seatCw(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 5, 10);
  final start = _rand(rng, 1, n);
  final steps = _rand(rng, 1, n - 1);
  final ans = OlympiadLogic.clockwiseSeat(n, start, steps);
  return _q(
    templateId: 'seat.cw',
    seed: seed,
    nodeId: 'seating',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '${_m(n)} 人围圈编号 1 到 ${_m(n)}。从 ${_m(start)} 号顺时针数 ${_m(steps)} 个（含起点的下一个算 1）。到达几号？',
    answer: '$ans',
    hints: ['编号加 ${_m(steps)} 再模 ${_m(n)}。'],
    steps: ['到达 ${_m(ans)} 号。'],
    nodeRefs: ['seating'],
  );
}

/// Coin counts the three-way split keeps whole.
List<int> _weighTotals(Difficulty d) => switch (d) {
  Difficulty.basic => const [9, 27, 81],
  Difficulty.medium => const [27, 81, 243],
  Difficulty.contest => const [81, 243, 729],
};

GeneratedQuestion _wfkBal(int seed, Difficulty d) {
  final rng = Random(seed);
  final totals = _weighTotals(d);
  final total = totals[rng.nextInt(totals.length)];
  final ans = OlympiadLogic.weighIfBalance(total);
  return _q(
    templateId: 'wfk.bal',
    seed: seed,
    nodeId: 'weigh_fake',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(total)} 枚硬币有 1 枚较轻。天平两边各放 ${_m(total ~/ 3)} 枚。若平衡，假币还在几枚里？',
    answer: '$ans',
    hints: ['平衡说明假币在没上秤的那一堆。'],
    steps: ['还在 ${_m(ans)} 枚里。'],
    nodeRefs: ['weigh_fake', 'weigh_count'],
  );
}

GeneratedQuestion _wfkTilt(int seed, Difficulty d) {
  final rng = Random(seed);
  final totals = _weighTotals(d);
  final total = totals[rng.nextInt(totals.length)];
  final ans = OlympiadLogic.weighIfTilt(total);
  return _q(
    templateId: 'wfk.tilt',
    seed: seed,
    nodeId: 'weigh_fake',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(total)} 枚硬币有 1 枚较轻。两边各放 ${_m(total ~/ 3)} 枚。若不平衡，假币还在几枚里？',
    answer: '$ans',
    hints: ['假币在上秤的两堆里。'],
    steps: ['还在 ${_m(ans)} 枚里。'],
    nodeRefs: ['weigh_fake'],
  );
}

GeneratedQuestion _nadjPos(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 2, 3);
  final n = k + _rand(rng, 3, d == Difficulty.contest ? 7 : 5);
  final ans = Counting.nonAdjacent(n, k);
  return _q(
    templateId: 'nadj.pos',
    seed: seed,
    nodeId: 'adjacent_ban',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '从 ${_m(n)} 个排成一排的座位中选 ${_m(k)} 个，任意两个不相邻。有多少种选法？',
    answer: '$ans',
    hints: ['先放下 ${_m(k)} 个再插空，相当于 ${_m('C(${n - k + 1},$k)')}。'],
    steps: ['有 ${_m(ans)} 种。'],
    nodeRefs: ['adjacent_ban', 'combination'],
  );
}

GeneratedQuestion _nadjLine(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, 6);
  final ans = Counting.lineTwoApart(n);
  return _q(
    templateId: 'nadj.line',
    seed: seed,
    nodeId: 'adjacent_ban',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 人排成一列，其中甲、乙两人不相邻。有多少种排法？',
    answer: '$ans',
    hints: ['总排法 ${_m('$n!')} 减去甲乙相邻 ${_m('2($n-1)!')}。'],
    steps: ['共 ${_m(ans)} 种。'],
    nodeRefs: ['adjacent_ban', 'permutation'],
  );
}

GeneratedQuestion _grpHalf(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, switch (d) {
    Difficulty.basic => 4,
    Difficulty.medium => 5,
    Difficulty.contest => 6,
  });
  final ans = Counting.unlabeledHalves(n);
  return _q(
    templateId: 'grp.half',
    seed: seed,
    nodeId: 'group_split',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(2 * n)} 个不同的人分成两队，每队 ${_m(n)} 人，队与队没有区别。有多少种分法？',
    answer: '$ans',
    hints: ['先选 ${_m(n)} 人再除以 2，因为两队无标号。'],
    steps: ['有 ${_m(ans)} 种。'],
    nodeRefs: ['group_split'],
  );
}

GeneratedQuestion _grpPick(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 5, 8);
  final k = _rand(rng, 2, n ~/ 2);
  final ans = Counting.comb(n, k);
  return _q(
    templateId: 'grp.pick',
    seed: seed,
    nodeId: 'group_split',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 人中选出 ${_m(k)} 人组成一队（其余自动另一队，两队有区别：选出的是主队）。有多少种选法？',
    answer: '$ans',
    hints: ['这就是 ${_m('C($n,$k)')}。'],
    steps: ['有 ${_m(ans)} 种。'],
    nodeRefs: ['group_split', 'combination'],
  );
}

GeneratedQuestion _browSum(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, d == Difficulty.contest ? 8 : 6);
  final ans = Counting.binomRow(n);
  return _q(
    templateId: 'brow.sum',
    seed: seed,
    nodeId: 'binom_row',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '杨辉三角第 ${_m(n)} 行（从 ${_m('C($n,0)')} 到 ${_m('C($n,$n)')}）各项之和是多少？',
    answer: '$ans',
    hints: ['行和等于 ${_m('2^n')}。'],
    steps: ['${_m('2^$n=$ans')}。'],
    nodeRefs: ['binom_row', 'binom_identity'],
  );
}

GeneratedQuestion _browHalf(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = 2 * _rand(rng, 2, 4);
  final half = Counting.binomRow(n) ~/ 2;
  return _q(
    templateId: 'brow.half',
    seed: seed,
    nodeId: 'binom_row',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '杨辉三角第 ${_m(n)} 行各项之和的一半是多少？',
    answer: '$half',
    hints: ['行和 ${_m('2^$n')}，一半是 ${_m('2^{${n - 1}}')}。'],
    steps: ['一半是 ${_m(half)}。'],
    nodeRefs: ['binom_row'],
  );
}

GeneratedQuestion _bcolBlk(int seed, Difficulty d) {
  final rng = Random(seed);
  final rows = _rand(rng, 3, d == Difficulty.contest ? 8 : 6);
  final cols = _rand(rng, 3, 8);
  final ans = Counting.chessBlack(rows, cols);
  return _q(
    templateId: 'bcol.blk',
    seed: seed,
    nodeId: 'board_color',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(rows)} 行 ${_m(cols)} 列的棋盘按黑白相间着色，左上为黑。黑格有多少个？',
    answer: '$ans',
    hints: ['黑格大约一半，奇数格时多 1 个黑格。'],
    steps: ['黑格 ${_m(ans)} 个。'],
    nodeRefs: ['board_color'],
  );
}

GeneratedQuestion _bcolNeed(int seed, Difficulty d) {
  final rng = Random(seed);
  final rows = _rand(rng, 3, 6);
  final cols = _rand(rng, 3, 6);
  final black = Counting.chessBlack(rows, cols);
  final white = rows * cols - black;
  final ans = white + 1;
  return _q(
    templateId: 'bcol.need',
    seed: seed,
    nodeId: 'board_color',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(rows)}×${_m(cols)} 黑白棋盘，左上为黑。至少放几枚棋子，才能保证有一枚在黑格上？',
    answer: '$ans',
    hints: ['最坏先占满全部 ${_m(white)} 个白格，再加 1。'],
    steps: ['至少 ${_m(ans)} 枚。'],
    nodeRefs: ['board_color', 'pigeonhole'],
  );
}

GeneratedQuestion _adjcLine(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, 6);
  final k = _rand(rng, 2, 4);
  final ans = Counting.adjColor(n, k);
  return _q(
    templateId: 'adjc.line',
    seed: seed,
    nodeId: 'adj_color',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '用 ${_m(k)} 种颜色涂 ${_m(n)} 个排成一排的格子，相邻不同色。有多少种涂法？',
    answer: '$ans',
    hints: ['第一格 ${_m(k)} 种，之后每格 ${_m(k - 1)} 种。'],
    steps: ['共 ${_m(ans)} 种。'],
    nodeRefs: ['adj_color'],
  );
}

GeneratedQuestion _adjcK(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, 5);
  final k = _rand(rng, 3, 5);
  final ans = k - 1;
  return _q(
    templateId: 'adjc.k',
    seed: seed,
    nodeId: 'adj_color',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 格一排、${_m(k)} 色、相邻异色。从第二格起，每格有几种选法？',
    answer: '$ans',
    hints: ['只要和前一格不同，还剩 ${_m(k - 1)} 色。'],
    steps: ['每格 ${_m(ans)} 种。'],
    nodeRefs: ['adj_color'],
  );
}

/// How many pairs to ask about. C_2 = 2 up to C_7 = 429.
(int lo, int hi) _catalanBand(Difficulty d) => switch (d) {
  Difficulty.basic => (2, 5),
  Difficulty.medium => (3, 6),
  Difficulty.contest => (4, 7),
};

GeneratedQuestion _catPar(int seed, Difficulty d) {
  final rng = Random(seed);
  final (lo, hi) = _catalanBand(d);
  final n = _rand(rng, lo, hi);
  final ans = Counting.catalan(n);
  return _q(
    templateId: 'cat.par',
    seed: seed,
    nodeId: 'catalan',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 对括号合法配对（每步前缀左括号不少于右括号）有多少种？',
    answer: '$ans',
    hints: ['卡特兰数 ${_m('C_n = \\frac{1}{n+1}C(2n,n)')}。'],
    steps: ['${_m('C_$n=$ans')}。'],
    nodeRefs: ['catalan'],
  );
}

GeneratedQuestion _catPoly(int seed, Difficulty d) {
  final rng = Random(seed);
  final (lo, hi) = _catalanBand(d);
  final n = _rand(rng, lo, hi);
  final sides = n + 2;
  final ans = Counting.catalan(n);
  return _q(
    templateId: 'cat.poly',
    seed: seed,
    nodeId: 'catalan',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '凸 ${_m(sides)} 边形用不相交对角线剖分成三角形。有多少种剖分？',
    answer: '$ans',
    hints: ['凸 ${_m('n+2')} 边形的三角剖分数是 ${_m('C_n')}。这里 n=${_m(n)}。'],
    steps: ['有 ${_m(ans)} 种。'],
    nodeRefs: ['catalan'],
  );
}

GeneratedQuestion _cmulN(int seed, Difficulty d) {
  final rng = Random(seed);
  final dv = _rand(rng, 2, 9);
  final n = _rand(rng, 20, d == Difficulty.contest ? 120 : 60);
  final ans = NumberTheory.countMultiples(n, dv);
  return _q(
    templateId: 'cmul.n',
    seed: seed,
    nodeId: 'count_mult',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '1 到 ${_m(n)} 中有多少个 ${_m(dv)} 的倍数？',
    answer: '$ans',
    hints: ['个数是 ${_m('\\lfloor $n/$dv \\rfloor')}。'],
    steps: ['有 ${_m(ans)} 个。'],
    nodeRefs: ['count_mult'],
  );
}

GeneratedQuestion _cmulRange(int seed, Difficulty d) {
  final rng = Random(seed);
  final dv = _rand(rng, 3, 9);
  final lo = _rand(rng, 10, 30);
  final hi = lo + _rand(rng, 15, 40);
  final ans =
      NumberTheory.countMultiples(hi, dv) -
      NumberTheory.countMultiples(lo - 1, dv);
  return _q(
    templateId: 'cmul.range',
    seed: seed,
    nodeId: 'count_mult',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(lo)} 到 ${_m(hi)} 中有多少个 ${_m(dv)} 的倍数（含端点）？',
    answer: '$ans',
    hints: [
      '${_m('\\lfloor $hi/$dv \\rfloor - \\lfloor ${lo - 1}/$dv \\rfloor')}。',
    ],
    steps: ['有 ${_m(ans)} 个。'],
    nodeRefs: ['count_mult'],
  );
}

GeneratedQuestion _drootVal(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 20, d == Difficulty.contest ? 999 : 400);
  final ans = NumberTheory.digitRoot(n);
  return _q(
    templateId: 'droot.val',
    seed: seed,
    nodeId: 'digit_root',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '把 ${_m(n)} 的各位数字反复相加，直到剩下一位。得到多少？',
    answer: '$ans',
    hints: ['数根等于 ${_m('n \\bmod 9')}，但 ${_m('9\\mid n')} 时是 9（0 除外）。'],
    steps: ['数根是 ${_m(ans)}。'],
    nodeRefs: ['digit_root', 'divisibility_rules'],
  );
}

GeneratedQuestion _drootMod(int seed, Difficulty d) {
  final rng = Random(seed);
  var n = _rand(rng, 15, 90);
  if (n % 9 == 0) n += 1;
  final ans = n % 9;
  return _q(
    templateId: 'droot.mod',
    seed: seed,
    nodeId: 'digit_root',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 的数根与它除以 9 的余数相同。这个余数是多少？',
    answer: '$ans',
    hints: ['先算 ${_m('$n \\bmod 9')}。'],
    steps: ['余数 ${_m(ans)}。'],
    nodeRefs: ['digit_root'],
  );
}

GeneratedQuestion _dsumN(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [12, 18, 20, 24, 28, 30, 36][rng.nextInt(7)];
  final ans = NumberTheory.divisorSum(n);
  return _q(
    templateId: 'dsum.n',
    seed: seed,
    nodeId: 'divisor_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m(n)} 的所有正因数之和（包括 1 和它本身）。',
    answer: '$ans',
    hints: [
      '若 ${_m('n=p^a q^b')}，则 ${_m('\\sigma(n)=(1+p+\\cdots+p^a)(\\cdots)')}。',
    ],
    steps: ['因数和是 ${_m(ans)}。'],
    nodeRefs: ['divisor_sum', 'fta'],
  );
}

GeneratedQuestion _dsumProper(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [12, 18, 20, 28, 36][rng.nextInt(5)];
  final ans = NumberTheory.divisorSum(n) - n;
  return _q(
    templateId: 'dsum.proper',
    seed: seed,
    nodeId: 'divisor_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m(n)} 的真因数之和（所有正因数去掉它本身）。',
    answer: '$ans',
    hints: ['先求和再减去 ${_m(n)}。'],
    steps: ['真因数和 ${_m(ans)}。'],
    nodeRefs: ['divisor_sum'],
  );
}

GeneratedQuestion _oddvN(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [12, 16, 18, 20, 24, 36, 48][rng.nextInt(7)];
  final ans = NumberTheory.oddDivisorCount(n);
  return _q(
    templateId: 'oddv.n',
    seed: seed,
    nodeId: 'odd_div',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 有多少个正的奇数因数？',
    answer: '$ans',
    hints: ['先把因数 2 全部除掉，再数剩下那个奇数的因数。'],
    steps: ['奇数因数 ${_m(ans)} 个。'],
    nodeRefs: ['odd_div', 'fta'],
  );
}

GeneratedQuestion _oddvList(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [8, 12, 16, 18][rng.nextInt(4)];
  final odds = NumberTheory.positiveDivisors(n).where((e) => e.isOdd).toList();
  final ans = odds.last;
  return _q(
    templateId: 'oddv.list',
    seed: seed,
    nodeId: 'odd_div',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 的最大奇数因数是多少？',
    answer: '$ans',
    hints: ['不断除以 2，直到变成奇数。'],
    steps: ['最大奇数因数是 ${_m(ans)}。'],
    nodeRefs: ['odd_div'],
  );
}

GeneratedQuestion _ltwoVal(int seed, Difficulty d) {
  final rng = Random(seed);
  final pairs = [
    [2, 8],
    [2, 10],
    [3, 5],
    [4, 5],
    [7, 4],
    [8, 3],
    [6, 4],
    [9, 3],
  ];
  final pair = pairs[rng.nextInt(pairs.length)];
  final base = pair[0];
  final exp = pair[1];
  final ans = NumberTheory.powerLastTwo(base, exp);
  return _q(
    templateId: 'ltwo.val',
    seed: seed,
    nodeId: 'last_two',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('$base^{$exp}')} 的末两位数（个位和十位组成的整数）。',
    answer: '$ans',
    hints: ['模 100 做幂运算，或看末两位的循环节。'],
    steps: ['末两位是 ${_m(ans)}。'],
    nodeRefs: ['last_two', 'power_last'],
  );
}

GeneratedQuestion _ltwoSame(int seed, Difficulty d) {
  final rng = Random(seed);
  final base = [2, 3, 7, 8][rng.nextInt(4)];
  final exp = _rand(rng, 4, 8);
  final a = NumberTheory.powerLastTwo(base, exp);
  final b = NumberTheory.powerLastTwo(base, exp + 20);
  final yes = a == b;
  return _q(
    templateId: 'ltwo.same',
    seed: seed,
    nodeId: 'last_two',
    difficulty: d,
    kind: QuestionKind.judge,
    stem:
        '判断：${_m('$base^{$exp}')} 与 ${_m('$base^{${exp + 20}}')} 的末两位是否相同？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: ['末两位的循环节整除指数差时才相同。对 2、5 要单独看。'],
    steps: [yes ? '末两位相同。' : '末两位不同。'],
    nodeRefs: ['last_two'],
  );
}
