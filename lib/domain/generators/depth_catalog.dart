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

/// Next layer: 幻方、圆幂、二次函数、环形染色、进制、标签全错.
final List<QuestionTemplate> depthTemplates = [
  QuestionTemplate(
    id: 'scu.km',
    nodeId: 'scale_unit',
    difficulties: Difficulty.values.toSet(),
    build: _scuKm,
  ),
  QuestionTemplate(
    id: 'scu.min',
    nodeId: 'scale_unit',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _scuMin,
  ),
  QuestionTemplate(
    id: 'egy.mate',
    nodeId: 'unit_frac',
    difficulties: Difficulty.values.toSet(),
    build: _egyMate,
  ),
  QuestionTemplate(
    id: 'egy.two',
    nodeId: 'unit_frac',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _egyTwo,
  ),
  QuestionTemplate(
    id: 'grd.row',
    nodeId: 'grid_fill',
    difficulties: Difficulty.values.toSet(),
    build: _grdRow,
  ),
  QuestionTemplate(
    id: 'grd.miss',
    nodeId: 'grid_fill',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _grdMiss,
  ),
  QuestionTemplate(
    id: 'mag.cell',
    nodeId: 'magic_sq',
    difficulties: Difficulty.values.toSet(),
    build: _magCell,
  ),
  QuestionTemplate(
    id: 'mag.line',
    nodeId: 'magic_sq',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _magLine,
  ),
  QuestionTemplate(
    id: 'dsw.diff',
    nodeId: 'digit_swap',
    difficulties: Difficulty.values.toSet(),
    build: _dswDiff,
  ),
  QuestionTemplate(
    id: 'dsw.sum',
    nodeId: 'digit_swap',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _dswSum,
  ),
  QuestionTemplate(
    id: 'asp.val',
    nodeId: 'avg_speed',
    difficulties: Difficulty.values.toSet(),
    build: _aspVal,
  ),
  QuestionTemplate(
    id: 'asp.one',
    nodeId: 'avg_speed',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _aspOne,
  ),
  QuestionTemplate(
    id: 'rch.one',
    nodeId: 'ratio_chain',
    difficulties: Difficulty.values.toSet(),
    build: _rchOne,
  ),
  QuestionTemplate(
    id: 'rch.mid',
    nodeId: 'ratio_chain',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _rchMid,
  ),
  QuestionTemplate(
    id: 'rmw.next',
    nodeId: 'rem_word',
    difficulties: Difficulty.values.toSet(),
    build: _rmwNext,
  ),
  QuestionTemplate(
    id: 'rmw.add',
    nodeId: 'rem_word',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _rmwAdd,
  ),
  QuestionTemplate(
    id: 'abx.big',
    nodeId: 'abs_eq',
    difficulties: Difficulty.values.toSet(),
    build: _abxBig,
  ),
  QuestionTemplate(
    id: 'abx.cnt',
    nodeId: 'abs_eq',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _abxCnt,
  ),
  QuestionTemplate(
    id: 'qfn.x',
    nodeId: 'quad_fn',
    difficulties: Difficulty.values.toSet(),
    build: _qfnX,
  ),
  QuestionTemplate(
    id: 'qfn.y',
    nodeId: 'quad_fn',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _qfnY,
  ),
  QuestionTemplate(
    id: 'dsc.val',
    nodeId: 'disc_val',
    difficulties: Difficulty.values.toSet(),
    build: _dscVal,
  ),
  QuestionTemplate(
    id: 'dsc.n',
    nodeId: 'disc_val',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _dscN,
  ),
  QuestionTemplate(
    id: 'alt.area',
    nodeId: 'altitude',
    difficulties: Difficulty.values.toSet(),
    build: _altArea,
  ),
  QuestionTemplate(
    id: 'alt.base',
    nodeId: 'altitude',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _altBase,
  ),
  QuestionTemplate(
    id: 'icp.seg',
    nodeId: 'intercept',
    difficulties: Difficulty.values.toSet(),
    build: _icpSeg,
  ),
  QuestionTemplate(
    id: 'icp.ask',
    nodeId: 'intercept',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _icpAsk,
  ),
  QuestionTemplate(
    id: 'bis.seg',
    nodeId: 'bisector',
    difficulties: Difficulty.values.toSet(),
    build: _bisSeg,
  ),
  QuestionTemplate(
    id: 'bis.side',
    nodeId: 'bisector',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _bisSide,
  ),
  QuestionTemplate(
    id: 'sarc.eq',
    nodeId: 'same_arc',
    difficulties: Difficulty.values.toSet(),
    build: _sarcEq,
  ),
  QuestionTemplate(
    id: 'sarc.half',
    nodeId: 'same_arc',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _sarcHalf,
  ),
  QuestionTemplate(
    id: 'exq.side',
    nodeId: 'ext_quad',
    difficulties: Difficulty.values.toSet(),
    build: _exqSide,
  ),
  QuestionTemplate(
    id: 'exq.sum',
    nodeId: 'ext_quad',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _exqSum,
  ),
  QuestionTemplate(
    id: 'ppt.chord',
    nodeId: 'power_pt',
    difficulties: Difficulty.values.toSet(),
    build: _pptChord,
  ),
  QuestionTemplate(
    id: 'ppt.tan',
    nodeId: 'power_pt',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _pptTan,
  ),
  QuestionTemplate(
    id: 'ndv.next',
    nodeId: 'near_div',
    difficulties: Difficulty.values.toSet(),
    build: _ndvNext,
  ),
  QuestionTemplate(
    id: 'ndv.gap',
    nodeId: 'near_div',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _ndvGap,
  ),
  QuestionTemplate(
    id: 'bop.add',
    nodeId: 'base_ops',
    difficulties: Difficulty.values.toSet(),
    build: _bopAdd,
  ),
  QuestionTemplate(
    id: 'bop.val',
    nodeId: 'base_ops',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _bopVal,
  ),
  QuestionTemplate(
    id: 'cyln.p',
    nodeId: 'cycle_len',
    difficulties: Difficulty.values.toSet(),
    build: _cylnP,
  ),
  QuestionTemplate(
    id: 'cyln.term',
    nodeId: 'cycle_len',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _cylnTerm,
  ),
  QuestionTemplate(
    id: 'ipa.n',
    nodeId: 'int_part',
    difficulties: Difficulty.values.toSet(),
    build: _ipaN,
  ),
  QuestionTemplate(
    id: 'ipa.two',
    nodeId: 'int_part',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _ipaTwo,
  ),
  QuestionTemplate(
    id: 'lban.av',
    nodeId: 'lattice_ban',
    difficulties: Difficulty.values.toSet(),
    build: _lbanAv,
  ),
  QuestionTemplate(
    id: 'lban.th',
    nodeId: 'lattice_ban',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _lbanTh,
  ),
  QuestionTemplate(
    id: 'ccol.n',
    nodeId: 'circle_color',
    difficulties: Difficulty.values.toSet(),
    build: _ccolN,
  ),
  QuestionTemplate(
    id: 'ccol.k',
    nodeId: 'circle_color',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _ccolK,
  ),
  QuestionTemplate(
    id: 'box.pear',
    nodeId: 'box_label',
    difficulties: Difficulty.values.toSet(),
    build: _boxPear,
  ),
  QuestionTemplate(
    id: 'box.apple',
    nodeId: 'box_label',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _boxApple,
  ),
  QuestionTemplate(
    id: 'wst.rank',
    nodeId: 'who_story',
    difficulties: Difficulty.values.toSet(),
    build: _wstRank,
  ),
  QuestionTemplate(
    id: 'wst.who',
    nodeId: 'who_story',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _wstWho,
  ),
  QuestionTemplate(
    id: 'hat.col',
    nodeId: 'hat_logic',
    difficulties: Difficulty.values.toSet(),
    build: _hatCol,
  ),
  QuestionTemplate(
    id: 'hat.know',
    nodeId: 'hat_logic',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _hatKnow,
  ),
  QuestionTemplate(
    id: 'wlf.n',
    nodeId: 'wolf_goat',
    difficulties: Difficulty.values.toSet(),
    build: _wlfN,
  ),
  QuestionTemplate(
    id: 'wlf.goat',
    nodeId: 'wolf_goat',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _wlfGoat,
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

GeneratedQuestion _scuKm(int seed, Difficulty d) {
  final rng = Random(seed);
  final km = _rand(rng, 2, d == Difficulty.contest ? 12 : 8);
  final ans = Calculation.kmToM(km);
  return _q(
    templateId: 'scu.km',
    seed: seed,
    nodeId: 'scale_unit',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(km)} 千米等于多少米？',
    answer: '$ans',
    hints: ['1 千米 = 1000 米。'],
    steps: ['${_m('$km \\times 1000 = $ans')}。'],
    nodeRefs: ['scale_unit'],
  );
}

GeneratedQuestion _scuMin(int seed, Difficulty d) {
  final rng = Random(seed);
  final h = _rand(rng, 1, 4);
  final m = _rand(rng, 0, 50);
  final ans = Calculation.toMinutes(h, m);
  return _q(
    templateId: 'scu.min',
    seed: seed,
    nodeId: 'scale_unit',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(h)} 小时 ${_m(m)} 分等于多少分钟？',
    answer: '$ans',
    hints: ['1 小时 = 60 分。'],
    steps: ['${_m('$h \\times 60 + $m = $ans')}。'],
    nodeRefs: ['scale_unit'],
  );
}

GeneratedQuestion _egyMate(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, d == Difficulty.contest ? 12 : 8);
  final ans = Calculation.egyptMate(n);
  return _q(
    templateId: 'egy.mate',
    seed: seed,
    nodeId: 'unit_frac',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '把 ${_m('1/$n')} 拆成 ${_m('1/${n + 1} + 1/x')}。求 x。',
    answer: '$ans',
    hints: ['${_m('1/n-1/(n+1)=1/(n(n+1))')}。'],
    steps: ['x 是 ${_m(ans)}。'],
    nodeRefs: ['unit_frac', 'split_unit'],
  );
}

GeneratedQuestion _egyTwo(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, 9);
  final ans = n * (n + 1);
  return _q(
    templateId: 'egy.two',
    seed: seed,
    nodeId: 'unit_frac',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('1/$n = 1/${n + 1} + 1/${n * (n + 1)}')}。右边第二个分母是多少？',
    answer: '$ans',
    hints: ['就是 ${_m('n(n+1)')}。'],
    steps: ['分母 ${_m(ans)}。'],
    nodeRefs: ['unit_frac'],
  );
}

GeneratedQuestion _grdRow(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 3, 20);
  final b = _rand(rng, 3, 20);
  final s = a + b + _rand(rng, 5, 25);
  final ans = s - a - b;
  return _q(
    templateId: 'grd.row',
    seed: seed,
    nodeId: 'grid_fill',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '一行三个数之和是 ${_m(s)}。已知 ${_m(a)} 与 ${_m(b)}，空格是多少？',
    answer: '$ans',
    hints: ['空格 = 行和减去已知两项。'],
    steps: ['${_m('$s-$a-$b=$ans')}。'],
    figure: GridFigure(rows: 1, cols: 3, cells: ['$a', '$b', '?']),
    nodeRefs: ['grid_fill'],
  );
}

GeneratedQuestion _grdMiss(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 4, 15);
  final b = _rand(rng, 4, 15);
  final c = _rand(rng, 4, 15);
  final row1 = a + b;
  final col1 = a + c;
  final ans = b + c;
  return _q(
    templateId: 'grd.miss',
    seed: seed,
    nodeId: 'grid_fill',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '2×2 数表：左上 ${_m(a)}，第一行和 ${_m(row1)}，第一列和 ${_m(col1)}。右下角是多少？',
    answer: '$ans',
    hints: [
      '右上 = ${_m(row1)}−${_m(a)} = ${_m(b)}，左下 = ${_m(col1)}−${_m(a)} = ${_m(c)}。',
    ],
    steps: ['右下是 ${_m(ans)}。'],
    figure: GridFigure(rows: 2, cols: 2, cells: ['$a', '$b', '$c', '?']),
    nodeRefs: ['grid_fill'],
  );
}

GeneratedQuestion _magCell(int seed, Difficulty d) {
  final rng = Random(seed);
  final g = Calculation.magic3(_rand(rng, 0, 7));
  final r = _rand(rng, 0, 2);
  final c = _rand(rng, 0, 2);
  final ans = g[r][c];
  final shown = [
    for (var i = 0; i < 3; i++)
      [for (var j = 0; j < 3; j++) (i == r && j == c) ? '□' : '${g[i][j]}']
          .join(' '),
  ].indexed.map((e) => '第${'一二三'[e.$1]}行 ${e.$2}').join('，');
  return _q(
    templateId: 'mag.cell',
    seed: seed,
    nodeId: 'magic_sq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '三阶幻方（1 到 9 各用一次）缺一格：$shown。空格是多少？',
    answer: '$ans',
    hints: ['每行、每列、对角线之和都是 15。'],
    steps: ['空格是 ${_m(ans)}。'],
    figure: GridFigure(
      rows: 3,
      cols: 3,
      cells: [
        for (var i = 0; i < 3; i++)
          for (var j = 0; j < 3; j++) (i == r && j == c) ? '?' : '${g[i][j]}',
      ],
    ),
    nodeRefs: ['magic_sq'],
  );
}

GeneratedQuestion _magLine(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = rng.nextBool() ? 3 : 5;
  final ans = Calculation.magicLine(n);
  return _q(
    templateId: 'mag.line',
    seed: seed,
    nodeId: 'magic_sq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 阶幻方用 1 到 ${_m(n * n)} 各一次。每一行的和是多少？',
    answer: '$ans',
    hints: ['幻和 ${_m('\\frac{n(n^2+1)}{2}')}。'],
    steps: ['幻和 ${_m(ans)}。'],
    nodeRefs: ['magic_sq'],
  );
}

GeneratedQuestion _dswDiff(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 9);
  var b = _rand(rng, 1, 9);
  if (b == a) b = a == 9 ? 1 : a + 1;
  final ans = Calculation.digitSwapDiff(a, b);
  return _q(
    templateId: 'dsw.diff',
    seed: seed,
    nodeId: 'digit_swap',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '两位数 ${_m('$a$b')} 与对调后的 ${_m('$b$a')} 差的绝对值是多少？',
    answer: '$ans',
    hints: ['差等于 ${_m('9|a-b|')}。'],
    steps: ['差是 ${_m(ans)}。'],
    nodeRefs: ['digit_swap'],
  );
}

GeneratedQuestion _dswSum(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 1, 8);
  final b = _rand(rng, a + 1, 9);
  final ans = Calculation.digitSwapSum(a, b);
  return _q(
    templateId: 'dsw.sum',
    seed: seed,
    nodeId: 'digit_swap',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '两位数 ${_m('$a$b')} 与 ${_m('$b$a')} 的和是多少？',
    answer: '$ans',
    hints: ['和等于 ${_m('11(a+b)')}。'],
    steps: ['和是 ${_m(ans)}。'],
    nodeRefs: ['digit_swap'],
  );
}

GeneratedQuestion _aspVal(int seed, Difficulty d) {
  final rng = Random(seed);
  final pairs = [
    [3, 6, 4],
    [4, 12, 6],
    [5, 20, 8],
    [6, 3, 4],
    [8, 24, 12],
    [10, 15, 12],
  ];
  final p = pairs[rng.nextInt(pairs.length)];
  final ans = p[2];
  return _q(
    templateId: 'asp.val',
    seed: seed,
    nodeId: 'avg_speed',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '去程时速 ${_m(p[0])}，回程时速 ${_m(p[1])}，路程相同。往返平均速度是多少？',
    answer: '$ans',
    hints: ['不是算术平均。${_m('\\frac{2ab}{a+b}')}。'],
    steps: ['均速 ${_m(ans)}。'],
    nodeRefs: ['avg_speed'],
  );
}

GeneratedQuestion _aspOne(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = [4, 6, 8, 10][rng.nextInt(4)];
  final ans = a;
  return _q(
    templateId: 'asp.one',
    seed: seed,
    nodeId: 'avg_speed',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '去程、回程时速都是 ${_m(a)}。往返平均速度是多少？',
    answer: '$ans',
    hints: ['两速相同，均速就是该速度。'],
    steps: ['均速 ${_m(ans)}。'],
    nodeRefs: ['avg_speed'],
  );
}

GeneratedQuestion _rchOne(int seed, Difficulty d) {
  final rng = Random(seed);
  final p = _rand(rng, 2, 4);
  final q = p + 1;
  final r = q + 1;
  final parts = p + q + r;
  final total = parts * _rand(rng, 2, 5);
  final ans = Algebra.chainShare(total: total, part: p, parts: parts);
  return _q(
    templateId: 'rch.one',
    seed: seed,
    nodeId: 'ratio_chain',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '按 ${_m('$p:$q:$r')} 分配 ${_m(total)}。第一份是多少？',
    answer: '$ans',
    hints: ['总份数 ${_m(parts)}。'],
    steps: ['第一份 ${_m(ans)}。'],
    nodeRefs: ['ratio_chain'],
  );
}

GeneratedQuestion _rchMid(int seed, Difficulty d) {
  final rng = Random(seed);
  final q = 3;
  final parts = 9;
  final total = 9 * _rand(rng, 2, 6);
  final ans = Algebra.chainShare(total: total, part: q, parts: parts);
  return _q(
    templateId: 'rch.mid',
    seed: seed,
    nodeId: 'ratio_chain',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('a:b=2:3')}，${_m('b:c=3:4')}，共 ${_m(total)}。b 是多少？',
    answer: '$ans',
    hints: ['连比 ${_m('2:3:4')}，b 占 3 份。'],
    steps: ['b 是 ${_m(ans)}。'],
    nodeRefs: ['ratio_chain'],
  );
}

GeneratedQuestion _rmwNext(int seed, Difficulty d) {
  final rng = Random(seed);
  final m = _rand(rng, 3, 9);
  final r = _rand(rng, 1, m - 1);
  final after = _rand(rng, 10, d == Difficulty.contest ? 80 : 40);
  final ans = Algebra.nextWithRemainder(after: after, modulus: m, residue: r);
  return _q(
    templateId: 'rmw.next',
    seed: seed,
    nodeId: 'rem_word',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '比 ${_m(after)} 大、除以 ${_m(m)} 余 ${_m(r)} 的最小正整数是多少？',
    answer: '$ans',
    hints: ['先找到 ${_m(after)} 附近形如 ${_m('$m k+$r')} 的数。'],
    steps: ['是 ${_m(ans)}。'],
    nodeRefs: ['rem_word'],
  );
}

GeneratedQuestion _rmwAdd(int seed, Difficulty d) {
  final rng = Random(seed);
  final m = _rand(rng, 4, 9);
  final n = _rand(rng, 10, 40);
  final r = n % m;
  final ans = r == 0 ? m : m - r;
  return _q(
    templateId: 'rmw.add',
    seed: seed,
    nodeId: 'rem_word',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 再加多少才能被 ${_m(m)} 整除？',
    answer: '$ans',
    hints: ['加上 ${_m('m-(n\\bmod m)')}，余数为 0 时加 ${_m(m)}。'],
    steps: ['再加 ${_m(ans)}。'],
    nodeRefs: ['rem_word'],
  );
}

GeneratedQuestion _abxBig(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 12);
  final b = _rand(rng, 1, 9);
  final ans = Algebra.absLarger(a, b);
  return _q(
    templateId: 'abx.big',
    seed: seed,
    nodeId: 'abs_eq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '方程 ${_m('|x-$a|=$b')} 较大的根是多少？',
    answer: '$ans',
    hints: ['x 到 ${_m(a)} 的距离是 ${_m(b)}。'],
    steps: ['较大根 ${_m(ans)}。'],
    nodeRefs: ['abs_eq'],
  );
}

GeneratedQuestion _abxCnt(int seed, Difficulty d) {
  final rng = Random(seed);
  final c = _rand(rng, 3, 10);
  final r = _rand(rng, 2, 6);
  final ans = Algebra.absIneqCount(c, r);
  return _q(
    templateId: 'abx.cnt',
    seed: seed,
    nodeId: 'abs_eq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '整数 x 满足 ${_m('|x-$c|<$r')}。这样的 x 有多少个？',
    answer: '$ans',
    hints: ['开区间 ${_m('(${c - r}, ${c + r})')} 里的整数。'],
    steps: ['共 ${_m(ans)} 个。'],
    nodeRefs: ['abs_eq'],
  );
}

GeneratedQuestion _qfnX(int seed, Difficulty d) {
  final rng = Random(seed);
  final h = _rand(rng, 1, 6);
  final b = -2 * h;
  final c = _rand(rng, 1, 8);
  final ans = Algebra.vertexX(1, b);
  final bb = b;
  return _q(
    templateId: 'qfn.x',
    seed: seed,
    nodeId: 'quad_fn',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '抛物线 ${_m('y=x^2 ${bb < 0 ? "" : "+"}${bb}x+$c')} 的对称轴是 x 等于多少？',
    answer: '$ans',
    hints: ['对称轴 ${_m('x=-b/(2a)')}。'],
    steps: ['x = ${_m(ans)}。'],
    nodeRefs: ['quad_fn'],
  );
}

GeneratedQuestion _qfnY(int seed, Difficulty d) {
  final rng = Random(seed);
  final h = _rand(rng, 1, 5);
  final k = _rand(rng, -4, 6);
  final b = -2 * h;
  final c = h * h + k;
  final ans = Algebra.vertexY(1, b, c);
  return _q(
    templateId: 'qfn.y',
    seed: seed,
    nodeId: 'quad_fn',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '抛物线 ${_m('y=x^2 ${b < 0 ? "" : "+"}${b}x+$c')} 的顶点纵坐标是多少？',
    answer: '$ans',
    hints: ['先求 ${_m('x=-b/2')}，再代入。'],
    steps: ['顶点纵坐标 ${_m(ans)}。'],
    nodeRefs: ['quad_fn'],
  );
}

GeneratedQuestion _dscVal(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = 1;
  final b = _rand(rng, 3, 9);
  final c = _rand(rng, 1, 6);
  final ans = Algebra.discriminant(a, b, c);
  return _q(
    templateId: 'dsc.val',
    seed: seed,
    nodeId: 'disc_val',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '方程 ${_m('${quadTex(a, b, c)}=0')} 的判别式 ${_m('\\Delta')} 等于多少？',
    answer: '$ans',
    hints: ['${_m('\\Delta=b^2-4ac')}。'],
    steps: ['${_m('\\Delta=$ans')}。'],
    nodeRefs: ['disc_val'],
  );
}

GeneratedQuestion _dscN(int seed, Difficulty d) {
  final rng = Random(seed);
  final cases = [
    [1, 5, 6, 2],
    [1, 2, 1, 1],
    [1, 1, 1, 0],
    [1, 4, 4, 1],
    [1, 3, 2, 2],
  ];
  final t = cases[rng.nextInt(cases.length)];
  return _q(
    templateId: 'dsc.n',
    seed: seed,
    nodeId: 'disc_val',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '方程 ${_m('${quadTex(t[0], t[1], t[2])}=0')} 有多少个不同的实根？',
    answer: '${t[3]}',
    hints: ['看 ${_m('\\Delta')} 的符号：正两根、零一根、负零根。'],
    steps: ['不同实根 ${_m(t[3])} 个。'],
    nodeRefs: ['disc_val'],
  );
}

GeneratedQuestion _altArea(int seed, Difficulty d) {
  final rng = Random(seed);
  final b1 = _rand(rng, 3, 8);
  final b2 = b1 + _rand(rng, 1, 6);
  final area1 = b1 * _rand(rng, 2, 5);
  final ans = Geometry.altitudeArea(
    knownArea: area1,
    knownBase: b1,
    askBase: b2,
  );
  return _q(
    templateId: 'alt.area',
    seed: seed,
    nodeId: 'altitude',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '两三角形等高，底 ${_m(b1)} 与 ${_m(b2)}。底 ${_m(b1)} 的面积是 ${_m(area1)}。另一块面积是多少？',
    answer: '$ans',
    hints: ['等高则面积比等于底之比。'],
    steps: ['面积 ${_m(ans)}。'],
    nodeRefs: ['altitude'],
  );
}

GeneratedQuestion _altBase(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 1, 4);
  final b1 = 4 * k;
  final area1 = 12 * k;
  final area2 = 18 * k;
  final ans = 6 * k;
  return _q(
    templateId: 'alt.base',
    seed: seed,
    nodeId: 'altitude',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '等高三角形面积 ${_m(area1)}、${_m(area2)}，较小底是 ${_m(b1)}。较大底是多少？',
    answer: '$ans',
    hints: ['底比 = 面积比 ${_m('12:18=2:3')}。'],
    steps: ['较大底 ${_m(ans)}。'],
    nodeRefs: ['altitude'],
  );
}

GeneratedQuestion _icpSeg(int seed, Difficulty d) {
  final rng = Random(seed);
  final k1 = 2;
  final k2 = 3;
  final known = 2 * _rand(rng, 2, 6);
  final ans = Geometry.interceptFourth(a: k1, b: k2, c: known);
  return _q(
    templateId: 'icp.seg',
    seed: seed,
    nodeId: 'intercept',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '平行线分两边成 ${_m('$k1:$k2')}。较短那段是 ${_m(known)}。较长那段是多少？',
    answer: '$ans',
    hints: ['对应线段成比例。'],
    steps: ['较长 ${_m(ans)}。'],
    figure: InterceptFigure(
      ratioLeft: k1,
      ratioRight: k2,
      ad: '$known',
      db: '?',
    ),
    nodeRefs: ['intercept'],
  );
}

GeneratedQuestion _icpAsk(int seed, Difficulty d) {
  final a = 3;
  final b = 5;
  final c = 6;
  final ans = Geometry.interceptFourth(a: a, b: b, c: c);
  return _q(
    templateId: 'icp.ask',
    seed: seed,
    nodeId: 'intercept',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('AD/DB=AE/EC=3/5')}，${_m('AE=6')}。求 ${_m('EC')}。',
    answer: '$ans',
    hints: ['${_m('3/5=6/EC')}。'],
    steps: ['${_m('EC=$ans')}。'],
    figure: const InterceptFigure(
      ratioLeft: 3,
      ratioRight: 5,
      ae: '6',
      ec: '?',
    ),
    nodeRefs: ['intercept'],
  );
}

GeneratedQuestion _bisSeg(int seed, Difficulty d) {
  final rng = Random(seed);
  final left = _rand(rng, 2, 6);
  final right = left + _rand(rng, 1, 4);
  final side = (left + right) * _rand(rng, 2, 4);
  final ans = Geometry.bisectSegment(
    side: side,
    adjLeft: left,
    adjRight: right,
  );
  return _q(
    templateId: 'bis.seg',
    seed: seed,
    nodeId: 'bisector',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '三角形两边 ${_m(left)}、${_m(right)}，夹角平分线分对边 ${_m(side)}。靠 ${_m(left)} 的那段是多少？',
    answer: '$ans',
    hints: ['角平分线定理：对段比等于邻边比。'],
    steps: ['这段 ${_m(ans)}。'],
    figure: TriangleFigure(
      bisector: true,
      sideCA: '$left',
      sideBC: '$right',
      sideAB: '$side',
    ),
    nodeRefs: ['bisector'],
  );
}

GeneratedQuestion _bisSide(int seed, Difficulty d) {
  final left = 6;
  final right = 3;
  final seg = 8;
  final ans = 4;
  return _q(
    templateId: 'bis.side',
    seed: seed,
    nodeId: 'bisector',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '角平分线分对边为 ${_m(seg)} 与 x，邻边 ${_m(left)}、${_m(right)}（${_m(left)} 对着 ${_m(seg)}）。求 x。',
    answer: '$ans',
    hints: ['${_m('8/x=6/3')}。'],
    steps: ['x = ${_m(ans)}。'],
    figure: const TriangleFigure(bisector: true, sideCA: '6', sideBC: '3'),
    nodeRefs: ['bisector'],
  );
}

GeneratedQuestion _sarcEq(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 20, 70);
  return _q(
    templateId: 'sarc.eq',
    seed: seed,
    nodeId: 'same_arc',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '同弧所对的两个圆周角，一个是 ${_m('$a^\\circ')}。另一个是多少度？',
    answer: '$a',
    hints: ['同弧所对圆周角相等。'],
    steps: ['也是 ${_m(a)} 度。'],
    nodeRefs: ['same_arc'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _sarcHalf(int seed, Difficulty d) {
  final rng = Random(seed);
  final central = 2 * _rand(rng, 15, 50);
  final ans = central ~/ 2;
  return _q(
    templateId: 'sarc.half',
    seed: seed,
    nodeId: 'same_arc',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '一段弧的圆心角是 ${_m('$central^\\circ')}。它所对的圆周角是多少度？',
    answer: '$ans',
    hints: ['圆周角是同弧圆心角的一半。'],
    steps: ['圆周角 ${_m(ans)} 度。'],
    figure: CircleAngleFigure(central: '$central', inscribed: '?'),
    nodeRefs: ['same_arc', 'circle_angle'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _exqSide(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 4, 12);
  final c = _rand(rng, 5, 14);
  final b = _rand(rng, 3, a + c - 1);
  final ans = Geometry.tangentialFourth(a, b, c);
  return _q(
    templateId: 'exq.side',
    seed: seed,
    nodeId: 'ext_quad',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '圆外切四边形三边依次 ${_m(a)}、${_m(b)}、${_m(c)}。第四边是多少？',
    answer: '$ans',
    hints: ['对边之和相等：${_m('a+c=b+d')}。'],
    steps: ['第四边 ${_m(ans)}。'],
    figure: TangentFigure(tangentialQuad: true, sides: ['$a', '$b', '$c', '?']),
    nodeRefs: ['ext_quad', 'tangent_len'],
  );
}

GeneratedQuestion _exqSum(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 5, 10);
  final c = _rand(rng, 5, 10);
  final ans = a + c;
  return _q(
    templateId: 'exq.sum',
    seed: seed,
    nodeId: 'ext_quad',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '圆外切四边形一组对边 ${_m(a)} 与 ${_m(c)}。另一组对边之和是多少？',
    answer: '$ans',
    hints: ['两组对边之和相等。'],
    steps: ['和是 ${_m(ans)}。'],
    figure: TangentFigure(tangentialQuad: true, sides: ['$a', '?', '$c', '?']),
    nodeRefs: ['ext_quad'],
  );
}

GeneratedQuestion _pptChord(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 6);
  final b = _rand(rng, 3, 8);
  final prod = a * b;
  final divisors = [
    for (var t = 2; t < prod; t++)
      if (prod % t == 0) t,
  ];
  final c = divisors[rng.nextInt(divisors.length)];
  final ans = Geometry.chordMate(a: a, b: b, c: c);
  return _q(
    templateId: 'ppt.chord',
    seed: seed,
    nodeId: 'power_pt',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '圆内两弦交于一点，一段 ${_m(a)}、邻段 ${_m(b)}，另一弦一段 ${_m(c)}。另一邻段是多少？',
    answer: '$ans',
    hints: ['相交弦定理：${_m('a\\cdot b=c\\cdot d')}。'],
    steps: ['邻段 ${_m(ans)}。'],
    figure: ChordsFigure(a: '$a', b: '$b', c: '$c', d: '?'),
    nodeRefs: ['power_pt'],
  );
}

GeneratedQuestion _pptTan(int seed, Difficulty d) {
  final rng = Random(seed);
  final triples = [
    [4, 9, 6],
    [3, 12, 6],
    [4, 16, 8],
    [5, 20, 10],
  ];
  final t = triples[rng.nextInt(triples.length)];
  return _q(
    templateId: 'ppt.tan',
    seed: seed,
    nodeId: 'power_pt',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '从圆外一点引切线与割线。圆外一段 ${_m(t[0])}，整段 ${_m(t[1])}。切线长多少？',
    answer: '${t[2]}',
    hints: ['${_m('PT^2 = PA\\cdot PB')}。'],
    steps: ['切线长 ${_m(t[2])}。'],
    figure: TangentFigure(length: '?', external: '${t[0]}', whole: '${t[1]}'),
    nodeRefs: ['power_pt'],
  );
}

GeneratedQuestion _ndvNext(int seed, Difficulty d) {
  final rng = Random(seed);
  final dv = _rand(rng, 3, 9);
  final n = _rand(rng, 10, d == Difficulty.contest ? 80 : 40);
  final ans = NumberTheory.nextMultipleAbove(n, dv);
  return _q(
    templateId: 'ndv.next',
    seed: seed,
    nodeId: 'near_div',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '比 ${_m(n)} 大的、最小的 ${_m(dv)} 的倍数是多少？',
    answer: '$ans',
    hints: ['若已整除就再加一个 ${_m(dv)}。'],
    steps: ['是 ${_m(ans)}。'],
    nodeRefs: ['near_div'],
  );
}

GeneratedQuestion _ndvGap(int seed, Difficulty d) {
  final rng = Random(seed);
  final dv = _rand(rng, 3, 9);
  final n = _rand(rng, 8, 40);
  final ans = NumberTheory.nextMultipleAbove(n, dv) - n;
  return _q(
    templateId: 'ndv.gap',
    seed: seed,
    nodeId: 'near_div',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 再加多少才能变成 ${_m(dv)} 的倍数？',
    answer: '$ans',
    hints: ['加上 ${_m('d-(n\\bmod d)')}，整除时加 ${_m(dv)}。'],
    steps: ['再加 ${_m(ans)}。'],
    nodeRefs: ['near_div'],
  );
}

GeneratedQuestion _bopAdd(int seed, Difficulty d) {
  final rng = Random(seed);
  final base = rng.nextBool() ? 2 : 3;
  final a = base == 2
      ? [101, 110, 111, 1001][rng.nextInt(4)]
      : [12, 21, 22, 10][rng.nextInt(4)];
  final b = base == 2
      ? [11, 10, 1, 101][rng.nextInt(4)]
      : [11, 2, 10, 1][rng.nextInt(4)];
  final ans =
      NumberTheory.parseShown(a, base) + NumberTheory.parseShown(b, base);
  return _q(
    templateId: 'bop.add',
    seed: seed,
    nodeId: 'base_ops',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(base)} 进制中 ${_m(a)} + ${_m(b)} 等于多少（写成十进制）？',
    answer: '$ans',
    hints: ['先各自化成十进制再相加。'],
    steps: ['十进制和是 ${_m(ans)}。'],
    nodeRefs: ['base_ops'],
  );
}

GeneratedQuestion _bopVal(int seed, Difficulty d) {
  final rng = Random(seed);
  final base = [2, 3, 4, 5][rng.nextInt(4)];
  final shown = base == 2
      ? [1010, 111, 1101][rng.nextInt(3)]
      : [12, 21, 31, 23][rng.nextInt(4)];
  final digitsOk = shown
      .toString()
      .split('')
      .every((ch) => int.parse(ch) < base);
  final use = digitsOk ? shown : 12;
  final useBase = digitsOk ? base : 4;
  final ans = NumberTheory.parseShown(use, useBase);
  return _q(
    templateId: 'bop.val',
    seed: seed,
    nodeId: 'base_ops',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '把 ${_m(useBase)} 进制数 ${_m(use)} 化成十进制。',
    answer: '$ans',
    hints: ['按权展开：个位 ${_m('b^0')}，十位 ${_m('b^1')}。'],
    steps: ['十进制是 ${_m(ans)}。'],
    nodeRefs: ['base_ops'],
  );
}

GeneratedQuestion _cylnP(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [3, 6, 7, 9, 11, 13, 21, 27][rng.nextInt(8)];
  final ans = NumberTheory.recipPeriod(n);
  return _q(
    templateId: 'cyln.p',
    seed: seed,
    nodeId: 'cycle_len',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('1/$n')} 化成小数后，循环节有多长？（有限小数写 0）',
    answer: '$ans',
    hints: ['先除掉因子 2 和 5，再看 10 模剩下那个数的阶。'],
    steps: ['循环节长度 ${_m(ans)}。'],
    nodeRefs: ['cycle_len'],
  );
}

GeneratedQuestion _cylnTerm(int seed, Difficulty d) {
  final rng = Random(seed);
  // Both kinds, or the answer is always 0 and the question asks nothing.
  final n = [2, 4, 5, 8, 10, 3, 9, 11, 7, 13, 37][rng.nextInt(11)];
  final ans = NumberTheory.recipPeriod(n);
  return _q(
    templateId: 'cyln.term',
    seed: seed,
    nodeId: 'cycle_len',
    difficulty: d,
    kind: QuestionKind.judge,
    // `cyln.p` already asks for the period; here the question is the kind of
    // decimal, which is what the prime factors of the denominator decide.
    stem: '判断：${_m('1/$n')} 是有限小数吗？回答「是」或「否」。',
    answer: ans == 0 ? '是' : '否',
    hints: ['分母只含质因数 2 和 5 时是有限小数。'],
    steps: [
      ans == 0
          ? '${_m(n)} 只含质因数 2、5，所以是有限小数。'
          : '${_m(n)} 含 2、5 以外的质因数，所以是纯循环小数，循环节长 ${_m(ans)}。',
    ],
    nodeRefs: ['cycle_len'],
  );
}

GeneratedQuestion _ipaN(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, 8);
  final ans = Counting.partition(n);
  return _q(
    templateId: 'ipa.n',
    seed: seed,
    nodeId: 'int_part',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '把 ${_m(n)} 拆成若干正整数之和，不计顺序。有多少种拆法？（包括 ${_m(n)} 本身）',
    answer: '$ans',
    hints: ['例如 4：${_m('4, 3+1, 2+2, 2+1+1, 1+1+1+1')} 共 5。'],
    steps: ['有 ${_m(ans)} 种。'],
    nodeRefs: ['int_part'],
  );
}

GeneratedQuestion _ipaTwo(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, 12);
  final ans = Counting.splitTwo(n);
  return _q(
    templateId: 'ipa.two',
    seed: seed,
    nodeId: 'int_part',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '把 ${_m(n)} 拆成两个正整数之和，不计顺序。有多少种？',
    answer: '$ans',
    hints: ['${_m('1+(n-1)')} 与 ${_m('(n-1)+1')} 算一种，一直到一半。'],
    steps: ['有 ${_m(ans)} 种。'],
    nodeRefs: ['int_part'],
  );
}

GeneratedQuestion _lbanAv(int seed, Difficulty d) {
  final rng = Random(seed);
  final r = _rand(rng, 2, 4);
  final u = _rand(rng, 2, 4);
  final br = _rand(rng, 1, r - 1);
  final bu = _rand(rng, 1, u - 1);
  final ans = Counting.latticeAvoid(right: r, up: u, blockR: br, blockU: bu);
  return _q(
    templateId: 'lban.av',
    seed: seed,
    nodeId: 'lattice_ban',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '从 ${_m('(0,0)')} 到 ${_m('($r,$u)')} 只向右向上，且不经过 ${_m('($br,$bu)')}。有多少条路？',
    answer: '$ans',
    hints: ['总路径减去经过该点的路径。'],
    steps: ['有 ${_m(ans)} 条。'],
    figure: LatticeFigure(right: r, up: u, blockRight: br, blockUp: bu),
    nodeRefs: ['lattice_ban', 'lattice_path'],
  );
}

GeneratedQuestion _lbanTh(int seed, Difficulty d) {
  final rng = Random(seed);
  final r = _rand(rng, 2, 4);
  final u = _rand(rng, 2, 4);
  final br = 1;
  final bu = 1;
  final ans =
      Counting.latticePaths(br, bu) * Counting.latticePaths(r - br, u - bu);
  return _q(
    templateId: 'lban.th',
    seed: seed,
    nodeId: 'lattice_ban',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '从 ${_m('(0,0)')} 到 ${_m('($r,$u)')} 只向右向上，经过 ${_m('(1,1)')} 的路有多少条？',
    answer: '$ans',
    hints: ['两段相乘：到该点，再从该点到终点。'],
    steps: ['有 ${_m(ans)} 条。'],
    nodeRefs: ['lattice_ban'],
  );
}

GeneratedQuestion _ccolN(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, 6);
  final k = _rand(rng, 3, 4);
  final ans = Counting.cycleColor(n, k);
  return _q(
    templateId: 'ccol.n',
    seed: seed,
    nodeId: 'circle_color',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 个珠子围成圈，用 ${_m(k)} 种颜色，相邻不同色（珠子位置固定）。有多少种涂法？',
    answer: '$ans',
    hints: ['圆周染色 ${_m('(k-1)^n+(-1)^n(k-1)')}。'],
    steps: ['有 ${_m(ans)} 种。'],
    nodeRefs: ['circle_color', 'adj_color'],
  );
}

GeneratedQuestion _ccolK(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = 3;
  final k = _rand(rng, 3, 5);
  final ans = Counting.cycleColor(n, k);
  return _q(
    templateId: 'ccol.k',
    seed: seed,
    nodeId: 'circle_color',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '三角形三顶点用 ${_m(k)} 色、相邻不同色。有多少种涂法？',
    answer: '$ans',
    hints: ['三个位置两两相邻，相当于 ${_m('P(k,3)')}。'],
    steps: ['有 ${_m(ans)} 种。'],
    nodeRefs: ['circle_color'],
  );
}

/// Two fruits and a mixed box, all three labels wrong. Which two fruits does
/// not change the reasoning, only the reading.
({String a, String b, String seen}) _boxes(Random rng) {
  final pairs = [('苹果', '梨'), ('橘子', '香蕉'), ('桃', '杏')];
  final (a, b) = pairs[rng.nextInt(pairs.length)];
  return (a: a, b: b, seen: rng.nextBool() ? a : b);
}

GeneratedQuestion _boxPear(int seed, Difficulty d) {
  final rng = Random(seed);
  final (a: a, b: b, seen: seen) = _boxes(rng);
  // The opened 混装 box is pure [seen], so the box labelled the other fruit
  // can be neither that fruit nor the pure pile already found: it is 混装.
  final other = seen == a ? b : a;
  const mixed = 3;
  return _q(
    templateId: 'box.pear',
    seed: seed,
    nodeId: 'box_label',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '三盒分别装$a、$b、混装，标签全错。打开标「混装」的盒子，里面全是$seen。标着「$other」的盒子里是什么？（1=$a，2=$b，3=混装）',
    answer: '$mixed',
    hints: ['打开的「混装」其实是纯$seen。剩下两个标签也都错。'],
    steps: ['那个盒子只能是混装，答案 3。'],
    nodeRefs: ['box_label'],
  );
}

GeneratedQuestion _boxApple(int seed, Difficulty d) {
  final rng = Random(seed);
  final (a: a, b: b, seen: seen) = _boxes(rng);
  // Asked about the box labelled [a]: it cannot hold a. If the opened 混装 box
  // was pure a, the a-labelled box is the other fruit (2); if it was pure b,
  // the pure-b pile is taken, so the a-labelled box is 混装 (3).
  final ans = seen == a ? 2 : 3;
  return _q(
    templateId: 'box.apple',
    seed: seed,
    nodeId: 'box_label',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '三盒装$a、$b、混装，标签全错。打开「混装」，里面全是$seen。标着「$a」的盒子里是什么？1=$a、2=$b、3=混装。',
    answer: '$ans',
    hints: ['「混装」实际是纯$seen；「$a」不能是$a。'],
    steps: ['答案 ${_m(ans)}。'],
    nodeRefs: ['box_label'],
  );
}

GeneratedQuestion _wstRank(int seed, Difficulty d) {
  final rng = Random(seed);
  final names = ['甲', '乙', '丙']..shuffle(rng);
  // ranks 1 tallest. Youngest/shortest is names[2] rank 3.
  // names[0] is not rank 1, so names[0]=2, names[1]=1.
  return _q(
    templateId: 'wst.rank',
    seed: seed,
    nodeId: 'who_story',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '${names[0]}、${names[1]}、${names[2]}比高矮。${names[2]}最矮，${names[0]}不是最高。${names[1]}的名次是多少？（1 最高）',
    answer: '1',
    hints: ['最矮占 3，${names[0]}不是 1，只剩${names[1]}是 1。'],
    steps: ['${names[1]}最高，名次是 ${_m(1)}。'],
    nodeRefs: ['who_story'],
  );
}

GeneratedQuestion _wstWho(int seed, Difficulty d) {
  final rng = Random(seed);
  final names = ['甲', '乙', '丙']..shuffle(rng);
  // Ask names[0]'s rank: 2
  return _q(
    templateId: 'wst.who',
    seed: seed,
    nodeId: 'who_story',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${names[2]}最小，${names[0]}不是最大。${names[0]}的年龄名次是多少？（1 最大）',
    answer: '2',
    hints: ['最小是 3，不是最大只能是 2。'],
    steps: ['${names[0]}的名次是 ${_m(2)}。'],
    nodeRefs: ['who_story'],
  );
}

/// Three of one colour, two of the other. Seeing both scarce hats on the
/// others uses them up, so the last one is the plentiful colour.
({String who, String many, String few}) _hats(Random rng) {
  final who = ['甲', '乙', '丙'][rng.nextInt(3)];
  final redIsMany = rng.nextBool();
  return (who: who, many: redIsMany ? '红' : '白', few: redIsMany ? '白' : '红');
}

GeneratedQuestion _hatCol(int seed, Difficulty d) {
  final rng = Random(seed);
  final (who: who, many: many, few: few) = _hats(rng);
  return _q(
    templateId: 'hat.col',
    seed: seed,
    nodeId: 'hat_logic',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '帽子共 3 顶$many、2 顶$few，三人各戴一顶。$who看见另外两人都是$few的。$who自己是什么颜色？（1=红，0=白）',
    answer: many == '红' ? '1' : '0',
    hints: ['$few帽只有两顶，另外两人都是$few，$who只能是$many。'],
    steps: ['$who是$many，答案 ${many == '红' ? 1 : 0}。'],
    nodeRefs: ['hat_logic'],
  );
}

GeneratedQuestion _hatKnow(int seed, Difficulty d) {
  final rng = Random(seed);
  final (who: who, many: many, few: few) = _hats(rng);
  final sees = rng.nextBool() ? many : few;
  final sure = sees == few;
  final others = ['甲', '乙', '丙'].where((n) => n != who).join('、');
  return _q(
    templateId: 'hat.know',
    seed: seed,
    nodeId: 'hat_logic',
    difficulty: d,
    kind: QuestionKind.judge,
    stem:
        '帽子 3 顶$many、2 顶$few。$who看见$others都是$sees的。$who能立刻确定自己的颜色吗？回答「是」或「否」。',
    answer: sure ? '是' : '否',
    hints: ['两顶$few用尽就能确定；两顶$many之外还剩$many和$few，不能确定。'],
    steps: [sure ? '能确定是$many。' : '不能确定。'],
    nodeRefs: ['hat_logic'],
  );
}

GeneratedQuestion _wlfN(int seed, Difficulty d) {
  final rng = Random(seed);
  // Same crossing, three things to count in it.
  final (ask, ans) = [
    ('最少几趟', OlympiadLogic.wolfTrips),
    ('农夫空船返回几趟', OlympiadLogic.wolfEmptyTrips),
    ('从这岸开往对岸几趟', OlympiadLogic.wolfForwardTrips),
  ][rng.nextInt(3)];
  return _q(
    templateId: 'wlf.n',
    seed: seed,
    nodeId: 'wolf_goat',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '农夫要把狼、羊、白菜运过河，船一次只能再载一样，且狼羊、羊菜不能独处。$ask？',
    answer: '$ans',
    hints: ['羊先过，空船回来送狼，羊带回，送菜，空船回来，最后接羊。'],
    steps: ['答案是 ${_m(ans)} 趟。'],
    nodeRefs: ['wolf_goat', 'crossing'],
  );
}

GeneratedQuestion _wlfGoat(int seed, Difficulty d) {
  final rng = Random(seed);
  final (who, ans, why) = [
    ('羊', OlympiadLogic.goatOnBoat, '羊先过、再被带回、最后再过。'),
    ('狼', OlympiadLogic.wolfOnBoat, '狼只在中间送过去一次。'),
    ('白菜', OlympiadLogic.cabbageOnBoat, '白菜只在后半段送过去一次。'),
  ][rng.nextInt(3)];
  return _q(
    templateId: 'wlf.goat',
    seed: seed,
    nodeId: 'wolf_goat',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '农夫、狼、羊、白菜过河（标准互斥）。$who一共上了几趟船？',
    answer: '$ans',
    hints: [why],
    steps: ['$who上了 ${_m(ans)} 趟船。'],
    nodeRefs: ['wolf_goat'],
  );
}
