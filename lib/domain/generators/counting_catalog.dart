import 'dart:math';

import '../combinatorics.dart';
import '../figure.dart';
import '../number_theory.dart';
import 'build.dart';
import 'question.dart';

final List<QuestionTemplate> countingTemplates = [
  QuestionTemplate(
    id: 'add.two',
    nodeId: 'count_add',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _addTwo,
  ),
  QuestionTemplate(
    id: 'add.three',
    nodeId: 'count_add',
    difficulties: Difficulty.values.toSet(),
    build: _addThree,
  ),
  QuestionTemplate(
    id: 'mul.seq',
    nodeId: 'count_mul',
    difficulties: Difficulty.values.toSet(),
    build: _mulSeq,
  ),
  QuestionTemplate(
    id: 'mul.outfit',
    nodeId: 'count_mul',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _mulOutfit,
  ),
  QuestionTemplate(
    id: 'comp.not_multiple',
    nodeId: 'count_complement',
    difficulties: Difficulty.values.toSet(),
    build: _compNotMultiple,
  ),
  QuestionTemplate(
    id: 'comp.at_least',
    nodeId: 'count_complement',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _compAtLeast,
  ),
  QuestionTemplate(
    id: 'perm.value',
    nodeId: 'permutation',
    difficulties: Difficulty.values.toSet(),
    build: _permValue,
  ),
  QuestionTemplate(
    id: 'perm.line',
    nodeId: 'permutation',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _permLine,
  ),
  QuestionTemplate(
    id: 'comb.value',
    nodeId: 'combination',
    difficulties: Difficulty.values.toSet(),
    build: _combValue,
  ),
  QuestionTemplate(
    id: 'comb.team',
    nodeId: 'combination',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _combTeam,
  ),
  QuestionTemplate(
    id: 'fact.value',
    nodeId: 'factorial_count',
    difficulties: Difficulty.values.toSet(),
    build: _factValue,
  ),
  QuestionTemplate(
    id: 'fact.line',
    nodeId: 'factorial_count',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _factLine,
  ),
  QuestionTemplate(
    id: 'path.grid',
    nodeId: 'lattice_path',
    difficulties: Difficulty.values.toSet(),
    build: _pathGrid,
  ),
  QuestionTemplate(
    id: 'path.steps',
    nodeId: 'lattice_path',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _pathSteps,
  ),
  QuestionTemplate(
    id: 'inc.union',
    nodeId: 'inclusion',
    difficulties: Difficulty.values.toSet(),
    build: _incUnion,
  ),
  QuestionTemplate(
    id: 'inc.divisors',
    nodeId: 'inclusion',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _incDivisors,
  ),
  QuestionTemplate(
    id: 'binom.sym',
    nodeId: 'binom_identity',
    difficulties: Difficulty.values.toSet(),
    build: _binomSym,
  ),
  QuestionTemplate(
    id: 'binom.pascal',
    nodeId: 'binom_identity',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _binomPascal,
  ),
  QuestionTemplate(
    id: 'pigeon.pair',
    nodeId: 'pigeonhole',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _pigeonPair,
  ),
  QuestionTemplate(
    id: 'pigeon.k',
    nodeId: 'pigeonhole',
    difficulties: Difficulty.values.toSet(),
    build: _pigeonK,
  ),
  QuestionTemplate(
    id: 'color.flags',
    nodeId: 'coloring',
    difficulties: Difficulty.values.toSet(),
    build: _colorFlags,
  ),
  QuestionTemplate(
    id: 'color.board',
    nodeId: 'coloring',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _colorBoard,
  ),
  QuestionTemplate(
    id: 'rec.stairs',
    nodeId: 'recurrence',
    difficulties: Difficulty.values.toSet(),
    build: _recStairs,
  ),
  QuestionTemplate(
    id: 'rec.next',
    nodeId: 'recurrence',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _recNext,
  ),
  QuestionTemplate(
    id: 'graph.hand',
    nodeId: 'graph_basic',
    difficulties: Difficulty.values.toSet(),
    build: _graphHand,
  ),
  QuestionTemplate(
    id: 'graph.edges',
    nodeId: 'graph_basic',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _graphEdges,
  ),
  QuestionTemplate(
    id: 'dbl.match',
    nodeId: 'double_count',
    difficulties: Difficulty.values.toSet(),
    build: _dblMatch,
  ),
  QuestionTemplate(
    id: 'dbl.choose',
    nodeId: 'double_count',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _dblChoose,
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
  );
}

GeneratedQuestion _addTwo(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, d == Difficulty.basic ? 8 : 14);
  final b = _rand(rng, 2, d == Difficulty.basic ? 8 : 14);
  return _q(
    templateId: 'add.two',
    seed: seed,
    nodeId: 'count_add',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '从甲地到乙地有 ${_m(a)} 条公路、${_m(b)} 条铁路，不混合换乘。共有多少种走法？',
    answer: '${a + b}',
    hints: ['公路与铁路是两类互斥的走法。', '加法原理：各类做法数相加。'],
    steps: ['${_m('$a + $b = ${a + b}')}。'],
    nodeRefs: ['count_add'],
  );
}

GeneratedQuestion _addThree(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 7);
  final b = _rand(rng, 2, 7);
  final c = _rand(rng, 1, 6);
  return _q(
    templateId: 'add.three',
    seed: seed,
    nodeId: 'count_add',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '完成一件事有三类互斥做法，分别有 ${_m(a)}、${_m(b)}、${_m(c)} 种。总共多少种做法？',
    answer: '${a + b + c}',
    hints: ['三类互斥，直接相加。', '不要把它们乘起来。'],
    steps: ['${_m('$a + $b + $c = ${a + b + c}')}。'],
    nodeRefs: ['count_add'],
  );
}

GeneratedQuestion _mulSeq(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, d == Difficulty.basic ? 6 : 9);
  final b = _rand(rng, 2, d == Difficulty.basic ? 6 : 8);
  return _q(
    templateId: 'mul.seq',
    seed: seed,
    nodeId: 'count_mul',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '从甲到乙有 ${_m(a)} 条路，从乙到丙有 ${_m(b)} 条路。从甲经乙到丙有多少种走法？',
    answer: '${a * b}',
    hints: ['先走甲到乙，再走乙到丙，是相继两步。', '乘法原理：各步做法数相乘。'],
    steps: ['${_m('$a \\times $b = ${a * b}')}。'],
    nodeRefs: ['count_mul'],
  );
}

GeneratedQuestion _mulOutfit(int seed, Difficulty d) {
  final rng = Random(seed);
  final shirts = _rand(rng, 2, 6);
  final pants = _rand(rng, 2, 5);
  final hats = d == Difficulty.medium ? _rand(rng, 2, 4) : 1;
  final ans = shirts * pants * hats;
  final stem = hats == 1
      ? '有 ${_m(shirts)} 件上衣、${_m(pants)} 条裤子，一套穿法有多少种？'
      : '有 ${_m(shirts)} 件上衣、${_m(pants)} 条裤子、${_m(hats)} 顶帽子，一套穿法有多少种？';
  return _q(
    templateId: 'mul.outfit',
    seed: seed,
    nodeId: 'count_mul',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: stem,
    answer: '$ans',
    hints: ['每一件衣物选一件，各步独立。', '把各步的选择数乘起来。'],
    steps: [
      hats == 1
          ? '${_m('$shirts \\times $pants = $ans')}。'
          : '${_m('$shirts \\times $pants \\times $hats = $ans')}。',
    ],
    nodeRefs: ['count_mul'],
  );
}

GeneratedQuestion _compNotMultiple(int seed, Difficulty d) {
  final rng = Random(seed);
  final m = _rand(rng, 2, 6);
  final n = d == Difficulty.contest ? _rand(rng, 30, 50) : _rand(rng, 12, 28);
  final multiples = NumberTheory.floorDiv(n, m);
  final ans = n - multiples;
  return _q(
    templateId: 'comp.not_multiple',
    seed: seed,
    nodeId: 'count_complement',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '在 1 到 ${_m(n)} 中，有多少个数不是 ${_m(m)} 的倍数？',
    answer: '$ans',
    hints: [
      '先算是 ${_m(m)} 的倍数的有多少，再从总数里减去。',
      '倍数的个数是 ${_m('\\lfloor $n/$m \\rfloor')}。',
    ],
    steps: ['倍数有 ${_m(multiples)} 个，故 ${_m('$n - $multiples = $ans')}。'],
    nodeRefs: ['count_complement'],
  );
}

GeneratedQuestion _compAtLeast(int seed, Difficulty d) {
  final rng = Random(seed);
  final bits = d == Difficulty.contest ? _rand(rng, 4, 6) : _rand(rng, 3, 5);
  final ans = (1 << bits) - 1;
  return _q(
    templateId: 'comp.at_least',
    seed: seed,
    nodeId: 'count_complement',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '用 ${_m(bits)} 盏灯（每盏亮或灭），至少亮一盏的开关方案有多少种？',
    answer: '$ans',
    hints: ['全部方案有 ${_m('2^{$bits}')} 种。', '减去「全灭」这一种。'],
    steps: ['${_m('2^{$bits} - 1 = $ans')}。'],
    nodeRefs: ['count_complement', 'count_mul'],
  );
}

GeneratedQuestion _permValue(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = switch (d) {
    Difficulty.basic => _rand(rng, 4, 6),
    Difficulty.medium => _rand(rng, 6, 8),
    Difficulty.contest => _rand(rng, 7, 9),
  };
  final k = _rand(rng, 2, n < 5 ? 3 : 4);
  final kk = k > n ? n : k;
  final ans = Counting.perm(n, kk);
  return _q(
    templateId: 'perm.value',
    seed: seed,
    nodeId: 'permutation',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('A_{$n}^{$kk}')}。',
    answer: '$ans',
    hints: [
      '${_m('A_n^k = n(n-1)\\cdots(n-k+1)')}。国内也把这个数写成 ${_m('P(n,k)')}。',
      '从 ${_m(n)} 乘到连续 ${_m(kk)} 个因数。',
    ],
    steps: ['${_m('A_{$n}^{$kk} = $ans')}。'],
    nodeRefs: ['permutation'],
  );
}

GeneratedQuestion _permLine(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 5, d == Difficulty.basic ? 7 : 8);
  final k = _rand(rng, 2, 3);
  final ans = Counting.perm(n, k);
  return _q(
    templateId: 'perm.line',
    seed: seed,
    nodeId: 'permutation',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 名同学中选 ${_m(k)} 名站成一排领奖（要排顺序），有多少种排法？',
    answer: '$ans',
    hints: [
      '有顺序，用排列 ${_m('A_{$n}^{$k}')}。',
      '第一名有 ${_m(n)} 种选法，第二名 ${_m(n - 1)} 种，……',
    ],
    steps: ['${_m('A_{$n}^{$k} = $ans')}。'],
    nodeRefs: ['permutation', 'count_mul'],
  );
}

GeneratedQuestion _combValue(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = switch (d) {
    Difficulty.basic => _rand(rng, 5, 7),
    Difficulty.medium => _rand(rng, 7, 10),
    Difficulty.contest => _rand(rng, 9, 12),
  };
  final k = _rand(rng, 2, n <= 6 ? 3 : 4);
  final kk = k > n ? n : k;
  final ans = Counting.comb(n, kk);
  return _q(
    templateId: 'comb.value',
    seed: seed,
    nodeId: 'combination',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('C_{$n}^{$kk}')}。',
    answer: '$ans',
    hints: ['${_m('C_n^k = A_n^k / k!')}。', '也可写成 ${_m('n! / (k!(n-k)!)')}。'],
    steps: ['${_m('C_{$n}^{$kk} = $ans')}。'],
    nodeRefs: ['combination'],
  );
}

GeneratedQuestion _combTeam(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 6, d == Difficulty.basic ? 8 : 10);
  final k = _rand(rng, 2, 4);
  final ans = Counting.comb(n, k);
  return _q(
    templateId: 'comb.team',
    seed: seed,
    nodeId: 'combination',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 人中选 ${_m(k)} 人组成小组（不排座位），有多少种选法？',
    answer: '$ans',
    hints: ['不计顺序，用组合 ${_m('C_{$n}^{$k}')}。', '若先按排列再除以 ${_m('$k!')}，结果相同。'],
    steps: ['${_m('C_{$n}^{$k} = $ans')}。'],
    nodeRefs: ['combination'],
  );
}

GeneratedQuestion _factValue(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = switch (d) {
    Difficulty.basic => _rand(rng, 4, 6),
    Difficulty.medium => _rand(rng, 6, 7),
    Difficulty.contest => _rand(rng, 7, 8),
  };
  final ans = Counting.factorial(n);
  return _q(
    templateId: 'fact.value',
    seed: seed,
    nodeId: 'factorial_count',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('$n!')}。',
    answer: '$ans',
    hints: [
      '${_m('$n! = 1 \\times 2 \\times \\cdots \\times $n')}。',
      '${_m('$n! = $n \\times ${n - 1}!')}。',
    ],
    steps: ['${_m('$n! = $ans')}。'],
    nodeRefs: ['factorial_count'],
  );
}

GeneratedQuestion _factLine(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, d == Difficulty.basic ? 6 : 7);
  final ans = Counting.factorial(n);
  return _q(
    templateId: 'fact.line',
    seed: seed,
    nodeId: 'factorial_count',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 个不同的人排成一列，有多少种排法？',
    answer: '$ans',
    hints: ['全排列数等于 ${_m('$n!')}。', '第一位 ${_m(n)} 种，下一位 ${_m(n - 1)} 种，直到 1。'],
    steps: ['${_m('$n! = $ans')}。'],
    nodeRefs: ['factorial_count', 'permutation'],
  );
}

GeneratedQuestion _pathGrid(int seed, Difficulty d) {
  final rng = Random(seed);
  final right = switch (d) {
    Difficulty.basic => _rand(rng, 2, 3),
    Difficulty.medium => _rand(rng, 3, 4),
    Difficulty.contest => _rand(rng, 4, 5),
  };
  final up = _rand(rng, 2, d == Difficulty.basic ? 3 : 4);
  final ans = Counting.latticePaths(right, up);
  return _q(
    templateId: 'path.grid',
    seed: seed,
    nodeId: 'lattice_path',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '从 ${_m('(0,0)')} 走到 ${_m('($right,$up)')}，只许向右或向上，有多少条路径？',
    answer: '$ans',
    hints: [
      '一共 ${_m(right + up)} 步，其中 ${_m(right)} 步向右。',
      '路径数是 ${_m('C(${right + up}, $right)')}。',
    ],
    steps: ['${_m('C(${right + up}, $right) = $ans')}。'],
    figure: LatticeFigure(right: right, up: up),
    nodeRefs: ['lattice_path', 'combination'],
  );
}

GeneratedQuestion _pathSteps(int seed, Difficulty d) {
  final rng = Random(seed);
  final right = _rand(rng, 2, 5);
  final up = _rand(rng, 2, 4);
  final ans = Counting.latticePaths(right, up);
  return _q(
    templateId: 'path.steps',
    seed: seed,
    nodeId: 'lattice_path',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '要走 ${_m(right)} 步东、${_m(up)} 步北，顺序任意。有多少种走法？',
    answer: '$ans',
    hints: [
      '这就是从原点到 ${_m('($right,$up)')} 的格点路。',
      '在 ${_m(right + up)} 步里选 ${_m(right)} 步向东。',
    ],
    steps: ['${_m('C(${right + up}, $right) = $ans')}。'],
    nodeRefs: ['lattice_path'],
  );
}

GeneratedQuestion _incUnion(int seed, Difficulty d) {
  final rng = Random(seed);
  final both = _rand(rng, 2, 8);
  final a = both + _rand(rng, 2, 10);
  final b = both + _rand(rng, 2, 10);
  final ans = a + b - both;
  return _q(
    templateId: 'inc.union',
    seed: seed,
    nodeId: 'inclusion',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '班上会游泳 ${_m(a)} 人，会打球 ${_m(b)} 人，两项都会 ${_m(both)} 人。至少会一项的有多少人？',
    answer: '$ans',
    hints: [
      '${_m('|A \\cup B| = |A| + |B| - |A \\cap B|')}。',
      '两项都会的人被加了两次，要减掉一次。',
    ],
    steps: ['${_m('$a + $b - $both = $ans')}。'],
    nodeRefs: ['inclusion'],
  );
}

GeneratedQuestion _incDivisors(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = d == Difficulty.contest ? _rand(rng, 40, 80) : _rand(rng, 20, 40);
  final a = [2, 3, 4][rng.nextInt(3)];
  var b = [3, 5, 6][rng.nextInt(3)];
  if (b == a) b = a + 1;
  final ans =
      NumberTheory.floorDiv(n, a) +
      NumberTheory.floorDiv(n, b) -
      NumberTheory.floorDiv(n, NumberTheory.lcm(a, b));
  return _q(
    templateId: 'inc.divisors',
    seed: seed,
    nodeId: 'inclusion',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '在 1 到 ${_m(n)} 中，被 ${_m(a)} 或 ${_m(b)} 整除的数有多少个？',
    answer: '$ans',
    hints: [
      '分别数 a 的倍数、b 的倍数，再减去 ${_m('\\mathrm{lcm}(a,b)')} 的倍数。',
      '${_m('\\mathrm{lcm}($a, $b) = ${NumberTheory.lcm(a, b)}')}。',
    ],
    steps: [
      '${_m('\\lfloor $n/$a \\rfloor + \\lfloor $n/$b \\rfloor - \\lfloor $n/${NumberTheory.lcm(a, b)} \\rfloor = $ans')}。',
    ],
    nodeRefs: ['inclusion', 'gauss_floor'],
  );
}

GeneratedQuestion _binomSym(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 6, d == Difficulty.contest ? 14 : 10);
  final k = _rand(rng, 2, n - 2);
  return _q(
    templateId: 'binom.sym',
    seed: seed,
    nodeId: 'binom_identity',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '已知 ${_m('C_{$n}^{$k} = C_{$n}^{x}')} 且 x ≠ ${_m(k)}。求 x。',
    answer: '${n - k}',
    hints: [
      '对称性：${_m('C_n^k = C_n^{n-k}')}。',
      '选 ${_m(k)} 个留下，等价于选 ${_m(n - k)} 个去掉。',
    ],
    steps: ['${_m('x = $n - $k = ${n - k}')}。'],
    nodeRefs: ['binom_identity'],
  );
}

GeneratedQuestion _binomPascal(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 5, 10);
  final k = _rand(rng, 2, n - 1);
  final ans = Counting.comb(n + 1, k);
  final left = Counting.comb(n, k);
  final right = Counting.comb(n, k - 1);
  return _q(
    templateId: 'binom.pascal',
    seed: seed,
    nodeId: 'binom_identity',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '利用杨辉恒等式求 ${_m('C_{$n}^{$k} + C_{$n}^{${k - 1}}')}。',
    answer: '$ans',
    hints: [
      '${_m('C_n^k + C_n^{k-1} = C_{n+1}^k')}。',
      '因此等于 ${_m('C_{${n + 1}}^{$k}')}。',
    ],
    steps: ['${_m('$left + $right = $ans = C_{${n + 1}}^{$k}')}。'],
    nodeRefs: ['binom_identity'],
  );
}

GeneratedQuestion _pigeonPair(int seed, Difficulty d) {
  final rng = Random(seed);
  final holes = _rand(rng, 4, d == Difficulty.basic ? 8 : 12);
  final ans = holes + 1;
  return _q(
    templateId: 'pigeon.pair',
    seed: seed,
    nodeId: 'pigeonhole',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '把物品放入 ${_m(holes)} 个抽屉，要保证必有一个抽屉至少 2 件，至少需要多少件物品？',
    answer: '$ans',
    hints: ['最坏情况每个抽屉 1 件，再加 1 件就被迫成对。', '答案是抽屉数加 1。'],
    steps: ['${_m('$holes + 1 = $ans')}。'],
    nodeRefs: ['pigeonhole'],
  );
}

GeneratedQuestion _pigeonK(int seed, Difficulty d) {
  final rng = Random(seed);
  final holes = _rand(rng, 3, 8);
  final k = _rand(rng, 2, d == Difficulty.contest ? 5 : 4);
  final ans = Counting.pigeonholeGuarantee(holes: holes, perHole: k);
  return _q(
    templateId: 'pigeon.k',
    seed: seed,
    nodeId: 'pigeonhole',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '把物品放入 ${_m(holes)} 个抽屉，要保证必有一个抽屉至少 ${_m(k)} 件，至少需要多少件物品？',
    answer: '$ans',
    hints: [
      '最坏情况每个抽屉 ${_m(k - 1)} 件，再加 1 件。',
      '公式：${_m('$holes \\times ${k - 1} + 1')}。',
    ],
    steps: ['${_m('$holes \\times ${k - 1} + 1 = $ans')}。'],
    nodeRefs: ['pigeonhole'],
  );
}

GeneratedQuestion _colorFlags(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, d == Difficulty.contest ? 6 : 5);
  final colors = rng.nextBool() ? 2 : 3;
  final ans = Counting.colorings(n, colors);
  return _q(
    templateId: 'color.flags',
    seed: seed,
    nodeId: 'coloring',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 面旗子，每面有 ${_m(colors)} 种颜色可选。共有多少种染色？',
    answer: '$ans',
    hints: ['每面独立选择，共 ${_m('$colors^{$n}')} 种。'],
    steps: ['${_m('$colors^{$n} = $ans')}。'],
    nodeRefs: ['coloring', 'count_mul'],
  );
}

GeneratedQuestion _colorBoard(int seed, Difficulty d) {
  final rng = Random(seed);
  final rows = _rand(rng, 3, 8);
  final cols = _rand(rng, 3, 8);
  final ans = Counting.chessBlack(rows, cols);
  return _q(
    templateId: 'color.board',
    seed: seed,
    nodeId: 'coloring',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('$rows \\times $cols')} 的棋盘黑白相间，左上角为黑。黑色格子有多少个？',
    answer: '$ans',
    hints: ['格子总数 ${_m(rows * cols)}，黑格是 ${_m('\\lceil mn/2 \\rceil')}。'],
    steps: ['黑格 ${_m(ans)} 个。'],
    nodeRefs: ['coloring'],
  );
}

GeneratedQuestion _recStairs(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, d == Difficulty.contest ? 10 : 8);
  final ans = Counting.stairWays(n);
  return _q(
    templateId: 'rec.stairs',
    seed: seed,
    nodeId: 'recurrence',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '上 ${_m(n)} 级台阶，每次只能走 1 级或 2 级。有多少种走法？',
    answer: '$ans',
    hints: [
      '最后一步走 1 级或 2 级：${_m('a_n = a_{n-1} + a_{n-2}')}。',
      '${_m('a_1 = 1')}，${_m('a_2 = 2')}。',
    ],
    steps: ['走法有 ${_m(ans)} 种。'],
    nodeRefs: ['recurrence'],
  );
}

GeneratedQuestion _recNext(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 5, 9);
  final prev2 = Counting.stairWays(n - 2);
  final prev1 = Counting.stairWays(n - 1);
  final ans = Counting.stairWays(n);
  return _q(
    templateId: 'rec.next',
    seed: seed,
    nodeId: 'recurrence',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '数列满足 ${_m('a_n = a_{n-1} + a_{n-2}')}，且 ${_m('a_{${n - 2}} = $prev2')}，${_m('a_{${n - 1}} = $prev1')}。求 ${_m('a_{$n}')}。',
    answer: '$ans',
    hints: ['代入递推式直接相加。'],
    steps: ['${_m('$prev1 + $prev2 = $ans')}。'],
    nodeRefs: ['recurrence'],
  );
}

GeneratedQuestion _graphHand(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, d == Difficulty.contest ? 10 : 8);
  final ans = Counting.handshake(n);
  return _q(
    templateId: 'graph.hand',
    seed: seed,
    nodeId: 'graph_basic',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 个人两两握手一次。一共握了多少次手？',
    answer: '$ans',
    hints: ['每对只握一次，次数是 ${_m('C($n,2)')}。'],
    steps: ['${_m('C($n,2) = $ans')}。'],
    nodeRefs: ['graph_basic', 'combination'],
  );
}

GeneratedQuestion _graphEdges(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [4, 5, 6, 8][rng.nextInt(4)];
  final deg = [2, 3][rng.nextInt(2)];
  if ((n * deg).isOdd) {
    return _graphHand(seed, d);
  }
  final edges = n * deg ~/ 2;
  return _q(
    templateId: 'graph.edges',
    seed: seed,
    nodeId: 'graph_basic',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 个点，每个点的度数都是 ${_m(deg)}。边数是多少？',
    answer: '$edges',
    hints: ['握手引理：度数和等于边数的两倍。', '${_m('$n \\times $deg / 2')}。'],
    steps: ['边数是 ${_m(edges)}。'],
    nodeRefs: ['graph_basic'],
  );
}

GeneratedQuestion _dblMatch(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 5, 10);
  final ans = Counting.comb(n, 2);
  return _q(
    templateId: 'dbl.match',
    seed: seed,
    nodeId: 'double_count',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 支球队两两赛一场。一共多少场比赛？',
    answer: '$ans',
    hints: ['从两边数：每队打 ${_m(n - 1)} 场，但每场被数了两次。', '或直接 ${_m('C($n,2)')}。'],
    steps: ['${_m('$n \\times ${n - 1} / 2 = $ans')}。'],
    nodeRefs: ['double_count'],
  );
}

GeneratedQuestion _dblChoose(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 5, 9);
  final ans = n * (1 << (n - 1));
  return _q(
    templateId: 'dbl.choose',
    seed: seed,
    nodeId: 'double_count',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 人中指定一名主席，其余每人可在委员会或不在。有多少种方案？',
    answer: '$ans',
    hints: ['先选主席 ${_m(n)} 种，其余人可在可不在。'],
    steps: ['${_m('$n \\times 2^{${n - 1}} = $ans')}。'],
    nodeRefs: ['double_count'],
  );
}
