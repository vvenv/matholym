import 'dart:math';

import '../algebra.dart';
import 'build.dart';
import 'question.dart';

final List<QuestionTemplate> algebraTemplates = [
  QuestionTemplate(
    id: 'eq.solve',
    nodeId: 'linear_eq',
    difficulties: Difficulty.values.toSet(),
    build: _eqSolve,
  ),
  QuestionTemplate(
    id: 'eq.word',
    nodeId: 'linear_eq',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _eqWord,
  ),
  QuestionTemplate(
    id: 'sumdiff.pair',
    nodeId: 'sum_diff',
    difficulties: Difficulty.values.toSet(),
    build: _sumDiffPair,
  ),
  QuestionTemplate(
    id: 'sumdiff.word',
    nodeId: 'sum_diff',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _sumDiffWord,
  ),
  QuestionTemplate(
    id: 'excess.people',
    nodeId: 'excess_deficit',
    difficulties: Difficulty.values.toSet(),
    build: _excessPeople,
  ),
  QuestionTemplate(
    id: 'excess.items',
    nodeId: 'excess_deficit',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _excessItems,
  ),
  QuestionTemplate(
    id: 'ratio.share',
    nodeId: 'ratio_share',
    difficulties: Difficulty.values.toSet(),
    build: _ratioShare,
  ),
  QuestionTemplate(
    id: 'ratio.people',
    nodeId: 'ratio_share',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _ratioPeople,
  ),
  QuestionTemplate(
    id: 'travel.meet',
    nodeId: 'travel',
    difficulties: Difficulty.values.toSet(),
    build: _travelMeet,
  ),
  QuestionTemplate(
    id: 'travel.catch',
    nodeId: 'travel',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _travelCatch,
  ),
  QuestionTemplate(
    id: 'work.together',
    nodeId: 'work_rate',
    difficulties: Difficulty.values.toSet(),
    build: _workTogether,
  ),
  QuestionTemplate(
    id: 'work.remain',
    nodeId: 'work_rate',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _workRemain,
  ),
  QuestionTemplate(
    id: 'expand.value',
    nodeId: 'expand_dist',
    difficulties: Difficulty.values.toSet(),
    build: _expandValue,
  ),
  QuestionTemplate(
    id: 'expand.trick',
    nodeId: 'expand_dist',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _expandTrick,
  ),
  QuestionTemplate(
    id: 'ineq.largest',
    nodeId: 'linear_ineq',
    difficulties: Difficulty.values.toSet(),
    build: _ineqLargest,
  ),
  QuestionTemplate(
    id: 'ineq.count',
    nodeId: 'linear_ineq',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _ineqCount,
  ),
  QuestionTemplate(
    id: 'arith.term',
    nodeId: 'arith_seq',
    difficulties: Difficulty.values.toSet(),
    build: _arithTerm,
  ),
  QuestionTemplate(
    id: 'arith.sum',
    nodeId: 'arith_seq',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _arithSum,
  ),
  QuestionTemplate(
    id: 'mix.percent',
    nodeId: 'percent_mix',
    difficulties: Difficulty.values.toSet(),
    build: _mixPercent,
  ),
  QuestionTemplate(
    id: 'mix.water',
    nodeId: 'percent_mix',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _mixWater,
  ),
  QuestionTemplate(
    id: 'cr.chickens',
    nodeId: 'chicken_rabbit',
    difficulties: Difficulty.values.toSet(),
    build: _crChickens,
  ),
  QuestionTemplate(
    id: 'cr.rabbits',
    nodeId: 'chicken_rabbit',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _crRabbits,
  ),
  QuestionTemplate(
    id: 'tree.line',
    nodeId: 'tree_plant',
    difficulties: Difficulty.values.toSet(),
    build: _treeLine,
  ),
  QuestionTemplate(
    id: 'tree.circle',
    nodeId: 'tree_plant',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _treeCircle,
  ),
  QuestionTemplate(
    id: 'age.years',
    nodeId: 'age_problem',
    difficulties: Difficulty.values.toSet(),
    build: _ageYears,
  ),
  QuestionTemplate(
    id: 'age.then',
    nodeId: 'age_problem',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _ageThen,
  ),
  QuestionTemplate(
    id: 'form.edge',
    nodeId: 'square_form',
    difficulties: Difficulty.values.toSet(),
    build: _formEdge,
  ),
  QuestionTemplate(
    id: 'form.side',
    nodeId: 'square_form',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _formSide,
  ),
  QuestionTemplate(
    id: 'quad.sum',
    nodeId: 'quadratic',
    difficulties: Difficulty.values.toSet(),
    build: _quadSum,
  ),
  QuestionTemplate(
    id: 'quad.root',
    nodeId: 'quadratic',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _quadRoot,
  ),
  QuestionTemplate(
    id: 'grass.days',
    nodeId: 'grass_cow',
    difficulties: Difficulty.values.toSet(),
    build: _grassDays,
  ),
  QuestionTemplate(
    id: 'grass.cows',
    nodeId: 'grass_cow',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _grassCows,
  ),
  QuestionTemplate(
    id: 'fn.eval',
    nodeId: 'function_intro',
    difficulties: Difficulty.values.toSet(),
    build: _fnEval,
  ),
  QuestionTemplate(
    id: 'fn.slope',
    nodeId: 'function_intro',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _fnSlope,
  ),
  QuestionTemplate(
    id: 'fac.diff',
    nodeId: 'factor_poly',
    difficulties: Difficulty.values.toSet(),
    build: _facDiff,
  ),
  QuestionTemplate(
    id: 'fac.expand',
    nodeId: 'factor_poly',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _facExpand,
  ),
  QuestionTemplate(
    id: 'am.min',
    nodeId: 'am_gm',
    difficulties: Difficulty.values.toSet(),
    build: _amMin,
  ),
  QuestionTemplate(
    id: 'am.prod',
    nodeId: 'am_gm',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _amProd,
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

GeneratedQuestion _eqSolve(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, d == Difficulty.basic ? 6 : 9);
  final x = _rand(rng, 1, d == Difficulty.contest ? 20 : 12);
  final b = _rand(rng, 1, 15);
  final c = a * x + b;
  return _q(
    templateId: 'eq.solve',
    seed: seed,
    nodeId: 'linear_eq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '解方程 ${_m('$a x + $b = $c')}。求 x。',
    answer: '$x',
    hints: ['先把 ${_m(b)} 移到右边。', '再两边同时除以 ${_m(a)}。'],
    steps: ['${_m('$a x = $c - $b = ${c - b}')}。', '${_m('x = $x')}。'],
    nodeRefs: ['linear_eq'],
  );
}

GeneratedQuestion _eqWord(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 5);
  final x = _rand(rng, 3, 12);
  final b = _rand(rng, 2, 10);
  final c = a * x + b;
  return _q(
    templateId: 'eq.word',
    seed: seed,
    nodeId: 'linear_eq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '某数的 ${_m(a)} 倍加上 ${_m(b)} 等于 ${_m(c)}。求这个数。',
    answer: '$x',
    hints: ['列方程 ${_m('$a x + $b = $c')}。', '移项再除以系数。'],
    steps: ['${_m('x = $x')}。'],
    nodeRefs: ['linear_eq'],
  );
}

GeneratedQuestion _sumDiffPair(int seed, Difficulty d) {
  final rng = Random(seed);
  final small = _rand(rng, 4, d == Difficulty.basic ? 16 : 30);
  final diff = _rand(rng, 2, 12);
  final large = small + diff;
  final sum = large + small;
  return _q(
    templateId: 'sumdiff.pair',
    seed: seed,
    nodeId: 'sum_diff',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '两数之和是 ${_m(sum)}，差是 ${_m(diff)}。求较大的数。',
    answer: '$large',
    hints: ['较大数 ${_m('(和 + 差)/2')}。', '${_m('($sum + $diff)/2')}。'],
    steps: ['${_m('($sum + $diff)/2 = $large')}。'],
    nodeRefs: ['sum_diff'],
  );
}

GeneratedQuestion _sumDiffWord(int seed, Difficulty d) {
  final rng = Random(seed);
  final small = _rand(rng, 8, 24);
  final diff = _rand(rng, 2, 10);
  final large = small + diff;
  final sum = large + small;
  return _q(
    templateId: 'sumdiff.word',
    seed: seed,
    nodeId: 'sum_diff',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '甲乙共有 ${_m(sum)} 颗糖，甲比乙多 ${_m(diff)} 颗。甲有多少颗？',
    answer: '$large',
    hints: ['甲是较大数，乙是较小数。', '甲 ${_m('(和 + 差)/2')}。'],
    steps: ['甲有 ${_m(large)} 颗。'],
    nodeRefs: ['sum_diff', 'linear_eq'],
  );
}

GeneratedQuestion _excessPeople(int seed, Difficulty d) {
  final rng = Random(seed);
  final perMore = _rand(rng, 2, 5);
  final perLess = perMore + _rand(rng, 1, 3);
  final leftover = _rand(rng, 1, 6);
  // 盈 + 亏 has to be a whole number of 份数差, or there is no whole number of
  // people and the answer would be a rounded one.
  final gap = perLess - perMore;
  final fits = [
    for (var s = 1; s <= 9; s++)
      if ((leftover + s) % gap == 0) s,
  ];
  final short = fits[rng.nextInt(fits.length)];
  final people = Algebra.peopleFromExcessDeficit(
    perMore: perMore,
    leftover: leftover,
    perLess: perLess,
    short: short,
  );
  return _q(
    templateId: 'excess.people',
    seed: seed,
    nodeId: 'excess_deficit',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '若干人分物品：每人 ${_m(perMore)} 个剩 ${_m(leftover)} 个；每人 ${_m(perLess)} 个差 ${_m(short)} 个。有多少人？',
    answer: '$people',
    hints: [
      '人数 ${_m('(盈 + 亏) / 份数差')}。',
      '${_m('($leftover + $short)/(${perLess - perMore})')}。',
    ],
    steps: ['人数是 ${_m(people)}。'],
    nodeRefs: ['excess_deficit'],
  );
}

GeneratedQuestion _excessItems(int seed, Difficulty d) {
  final rng = Random(seed);
  final perMore = _rand(rng, 2, 4);
  final perLess = perMore + 1;
  final leftover = _rand(rng, 1, 5);
  final short = _rand(rng, 1, 5);
  final people = Algebra.peopleFromExcessDeficit(
    perMore: perMore,
    leftover: leftover,
    perLess: perLess,
    short: short,
  );
  final items = Algebra.itemsFromExcessDeficit(
    people: people,
    perMore: perMore,
    leftover: leftover,
  );
  return _q(
    templateId: 'excess.items',
    seed: seed,
    nodeId: 'excess_deficit',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '每人 ${_m(perMore)} 个剩 ${_m(leftover)} 个，每人 ${_m(perLess)} 个差 ${_m(short)} 个。物品一共多少个？',
    answer: '$items',
    hints: ['先求人数，再 ${_m('人数 \\times 每人份数 + 盈')}。', '人数是 ${_m(people)}。'],
    steps: ['物品 ${_m('$people \\times $perMore + $leftover = $items')} 个。'],
    nodeRefs: ['excess_deficit'],
  );
}

GeneratedQuestion _ratioShare(int seed, Difficulty d) {
  final rng = Random(seed);
  final ratio = ratioPair(_rand(rng, 2, 5), _rand(rng, 2, 6));
  final a = ratio.a;
  final b = ratio.b;
  final part = _rand(rng, 4, d == Difficulty.contest ? 12 : 8);
  final total = (a + b) * part;
  final ans = Algebra.shareByRatio(total: total, part: a, other: b);
  return _q(
    templateId: 'ratio.share',
    seed: seed,
    nodeId: 'ratio_share',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '把 ${_m(total)} 按 ${_m('$a:$b')} 分成两份。按 ${_m(a)} 份分得的那一份是多少？',
    answer: '$ans',
    hints: ['总份数 ${_m(a + b)}，一份 ${_m(total ~/ (a + b))}。', '所求是 ${_m(a)} 份。'],
    steps: ['${_m('$total \\times $a / ${a + b} = $ans')}。'],
    nodeRefs: ['ratio_share'],
  );
}

GeneratedQuestion _ratioPeople(int seed, Difficulty d) {
  final rng = Random(seed);
  final ratio = ratioPair(_rand(rng, 2, 5), _rand(rng, 3, 7));
  final a = ratio.a;
  final b = ratio.b;
  final part = _rand(rng, 3, 8);
  final total = (a + b) * part;
  final ans = Algebra.shareByRatio(total: total, part: a, other: b);
  return _q(
    templateId: 'ratio.people',
    seed: seed,
    nodeId: 'ratio_share',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '甲乙人数比 ${_m('$a:$b')}，一共 ${_m(total)} 人。甲有多少人？',
    answer: '$ans',
    hints: ['甲占 ${_m(a)} 份，总 ${_m(a + b)} 份。', '一份 ${_m(part)} 人。'],
    steps: ['甲 ${_m('$part \\times $a = $ans')} 人。'],
    nodeRefs: ['ratio_share'],
  );
}

GeneratedQuestion _travelMeet(int seed, Difficulty d) {
  final rng = Random(seed);
  final v1 = _rand(rng, 4, 12);
  final v2 = _rand(rng, 3, 10);
  final hours = _rand(rng, 2, d == Difficulty.contest ? 8 : 5);
  final dist = (v1 + v2) * hours;
  return _q(
    templateId: 'travel.meet',
    seed: seed,
    nodeId: 'travel',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '两地相距 ${_m(dist)} 千米，甲每小时 ${_m(v1)} 千米，乙每小时 ${_m(v2)} 千米，相向而行。多少小时相遇？',
    answer: '$hours',
    hints: ['相遇时间 ${_m('路程 / (速度和)')}。', '速度和是 ${_m(v1 + v2)}。'],
    steps: ['${_m('$dist / ${v1 + v2} = $hours')} 小时。'],
    nodeRefs: ['travel'],
  );
}

GeneratedQuestion _travelCatch(int seed, Difficulty d) {
  final rng = Random(seed);
  final slow = _rand(rng, 3, 8);
  final fast = slow + _rand(rng, 2, 6);
  final hours = _rand(rng, 2, 6);
  final lead = (fast - slow) * hours;
  return _q(
    templateId: 'travel.catch',
    seed: seed,
    nodeId: 'travel',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '乙每小时 ${_m(slow)} 千米，已先走 ${_m(lead)} 千米。甲每小时 ${_m(fast)} 千米去追。多少小时追上？',
    answer: '$hours',
    hints: ['追及时间 ${_m('距离差 / 速度差')}。', '速度差是 ${_m(fast - slow)}。'],
    steps: ['${_m('$lead / ${fast - slow} = $hours')} 小时。'],
    nodeRefs: ['travel'],
  );
}

GeneratedQuestion _workTogether(int seed, Difficulty d) {
  final rng = Random(seed);
  final pairs = [(6, 3), (12, 6), (12, 4), (10, 15), (8, 8), (20, 5), (9, 18)];
  final pair = pairs[rng.nextInt(pairs.length)];
  final a = pair.$1;
  final b = pair.$2;
  final ans = Algebra.togetherDays(a, b);
  return _q(
    templateId: 'work.together',
    seed: seed,
    nodeId: 'work_rate',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '甲独做 ${_m(a)} 天完成，乙独做 ${_m(b)} 天完成。两人合作多少天完成？',
    answer: '$ans',
    hints: ['合作天数 ${_m('ab/(a+b)')}。', '工率 ${_m('1/$a + 1/$b')}。'],
    steps: ['${_m('$a \\times $b / ${a + b} = $ans')} 天。'],
    nodeRefs: ['work_rate'],
  );
}

GeneratedQuestion _workRemain(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = [6, 8, 10, 12][rng.nextInt(4)];
  final b = [3, 4, 6, 8][rng.nextInt(4)];
  // Only the threshold matters here, and ab/(a+b) need not be whole, so
  // compare without dividing.
  if (a * b <= a + b) {
    return _workTogether(seed, d);
  }
  // 甲 works `first` days, leaving (a-first)/a of the job; 乙 then needs
  // (a-first)*b/a days. Only the starts that make that whole are offered, so
  // the template keeps its own shape instead of falling back.
  final starts = [
    for (var f = 1; f < a; f++)
      if ((a - f) * b % a == 0) f,
  ];
  if (starts.isEmpty) {
    return _workTogether(seed, d);
  }
  final first = starts[rng.nextInt(starts.length)];
  final days = (a - first) * b ~/ a;
  return _q(
    templateId: 'work.remain',
    seed: seed,
    nodeId: 'work_rate',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '甲独做 ${_m(a)} 天完成。甲先做 ${_m(first)} 天，余下由乙做（乙独做 ${_m(b)} 天完成）。乙还要做多少天？',
    answer: '$days',
    hints: [
      '甲做完 ${_m('$first/$a')}，剩下 ${_m('${a - first}/$a')}。',
      '乙的工率是 ${_m('1/$b')}。',
    ],
    steps: ['乙还要 ${_m(days)} 天。'],
    nodeRefs: ['work_rate'],
  );
}

GeneratedQuestion _expandValue(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 12);
  final b = _rand(rng, 2, 12);
  final c = _rand(rng, 2, d == Difficulty.basic ? 9 : 15);
  final ans = Algebra.expandValue(a, b, c);
  return _q(
    templateId: 'expand.value',
    seed: seed,
    nodeId: 'expand_dist',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '用分配律计算 ${_m('($a + $b) \\times $c')}。',
    answer: '$ans',
    hints: ['${_m('(a+b)c = ac + bc')}。', '也可以先算括号再乘。'],
    steps: [
      '${_m('$a \\times $c + $b \\times $c = ${a * c} + ${b * c} = $ans')}。',
    ],
    nodeRefs: ['expand_dist'],
  );
}

GeneratedQuestion _expandTrick(int seed, Difficulty d) {
  final rng = Random(seed);
  final tens = _rand(rng, 2, 9) * 10;
  final off = _rand(rng, 1, 4);
  final c = _rand(rng, 3, 9);
  final n = tens - off;
  final ans = n * c;
  return _q(
    templateId: 'expand.trick',
    seed: seed,
    nodeId: 'expand_dist',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '用分配律计算 ${_m('$n \\times $c')}。可先拆成 ${_m('($tens - $off) \\times $c')}。',
    answer: '$ans',
    hints: [
      '${_m('($tens - $off) \\times $c = $tens \\times $c - $off \\times $c')}。',
      '${_m('$tens \\times $c = ${tens * c}')}。',
    ],
    steps: ['${_m('${tens * c} - ${off * c} = $ans')}。'],
    nodeRefs: ['expand_dist'],
  );
}

GeneratedQuestion _ineqLargest(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 6);
  final b = _rand(rng, 1, 8);
  final x = _rand(rng, 2, 10);
  // want largest integer < x or = x- something
  // Build a*x + b < c with c = a*x + b + extra, extra 1..a
  final extra = _rand(rng, 1, a);
  final c = a * x + b + extra;
  final ans = Algebra.largestIntLess(a, b, c);
  return _q(
    templateId: 'ineq.largest',
    seed: seed,
    nodeId: 'linear_ineq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求不等式 ${_m('$a x + $b < $c')} 的最大整数解。',
    answer: '$ans',
    hints: ['先移项得到 ${_m('$a x < ${c - b}')}。', '再除以正数 ${_m(a)}，取不超过界的最大整数。'],
    steps: ['最大整数解是 ${_m(ans)}。'],
    nodeRefs: ['linear_ineq'],
  );
}

GeneratedQuestion _ineqCount(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 5);
  final b = _rand(rng, 0, 6);
  final ansWanted = _rand(rng, 2, 6);
  // x >= 1 and x <= ansWanted, so largest is ansWanted, x < ansWanted+1
  // a*x + b < a*(ansWanted+1) + b
  final c = a * (ansWanted + 1) + b;
  final largest = Algebra.largestIntLess(a, b, c);
  final count = largest >= 1 ? largest : 0;
  return _q(
    templateId: 'ineq.count',
    seed: seed,
    nodeId: 'linear_ineq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '不等式 ${_m('$a x + $b < $c')} 有多少个正整数解？',
    answer: '$count',
    hints: ['先求最大整数解，再看从 1 数到它。', '最大整数解是 ${_m(largest)}。'],
    steps: ['正整数解有 ${_m(count)} 个。'],
    nodeRefs: ['linear_ineq'],
  );
}

GeneratedQuestion _arithTerm(int seed, Difficulty d) {
  final rng = Random(seed);
  final a1 = _rand(rng, 1, 10);
  final diff = _rand(rng, 1, d == Difficulty.basic ? 5 : 8);
  final n = _rand(rng, 4, d == Difficulty.contest ? 12 : 8);
  final ans = Algebra.arithTerm(a1, diff, n);
  return _q(
    templateId: 'arith.term',
    seed: seed,
    nodeId: 'arith_seq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '等差数列 ${_m('a_1 = $a1')}，公差 ${_m(diff)}。求 ${_m('a_{$n}')}。',
    answer: '$ans',
    hints: [
      '${_m('a_n = a_1 + (n-1)d')}。',
      '${_m('a_{$n} = $a1 + ${n - 1} \\times $diff')}。',
    ],
    steps: ['${_m('a_{$n} = $ans')}。'],
    nodeRefs: ['arith_seq'],
  );
}

GeneratedQuestion _arithSum(int seed, Difficulty d) {
  final rng = Random(seed);
  final a1 = _rand(rng, 1, 8);
  final diff = _rand(rng, 1, 5);
  final n = _rand(rng, 4, 10);
  final ans = Algebra.arithSum(a1, diff, n);
  return _q(
    templateId: 'arith.sum',
    seed: seed,
    nodeId: 'arith_seq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '等差数列 ${_m('a_1 = $a1')}，公差 ${_m(diff)}。求前 ${_m(n)} 项和 ${_m('S_{$n}')}。',
    answer: '$ans',
    hints: [
      '${_m('S_n = n(2a_1 + (n-1)d)/2')}。',
      '先求 ${_m('a_{$n} = ${Algebra.arithTerm(a1, diff, n)}')}，再用 ${_m('n(a_1+a_n)/2')}。',
    ],
    steps: ['${_m('S_{$n} = $ans')}。'],
    nodeRefs: ['arith_seq'],
  );
}

GeneratedQuestion _mixPercent(int seed, Difficulty d) {
  final rng = Random(seed);
  // Weights summing to 5 kg make any two multiples of 5 percent mix to a
  // whole percentage, so the answer is exact and the two strengths differ.
  final w1 = _rand(rng, 1, 4);
  final w2 = 5 - w1;
  final p1 = [10, 20, 30, 40][rng.nextInt(4)];
  final others = [
    for (final p in [10, 15, 20, 25, 30, 35, 40])
      if (p != p1) p,
  ];
  final p2 = others[rng.nextInt(others.length)];
  final ans = Algebra.mixPercent(w1: w1, p1: p1, w2: w2, p2: p2)!;
  return _q(
    templateId: 'mix.percent',
    seed: seed,
    nodeId: 'percent_mix',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '${_m(w1)} 千克 ${_m('$p1\\%')} 的盐水与 ${_m(w2)} 千克 ${_m('$p2\\%')} 的盐水混合。混合后浓度是百分之几？只写数字。',
    answer: '$ans',
    hints: [
      '溶质 ${_m('$w1 \\times $p1 + $w2 \\times $p2')}（再除以 100 是千克，这里先算加权）。',
      '除以总质量 ${_m(w1 + w2)}。',
    ],
    steps: ['${_m('($w1 \\times $p1 + $w2 \\times $p2)/${w1 + w2} = $ans')}。'],
    nodeRefs: ['percent_mix'],
  );
}

GeneratedQuestion _mixWater(int seed, Difficulty d) {
  final rng = Random(seed);
  final p = [20, 30, 40][rng.nextInt(3)];
  final salt = _rand(rng, 2, 6);
  final water0 = salt * (100 - p) ~/ p;
  // ensure integer initial water: salt/p * 100 = total, p | 100*salt
  if (p * water0 != salt * (100 - p)) {
    return _mixPercent(seed, d);
  }
  final total0 = salt + water0;
  // Add the amount of water that lands on a whole percentage; diluting to
  // 11.11% and calling it 11 would be a wrong answer, not a tidy one.
  var add = 0;
  var newP = p;
  for (var q = p - 1; q >= 1; q--) {
    if (100 * salt % q != 0) continue;
    final newTotal = 100 * salt ~/ q;
    if (newTotal <= total0) continue;
    add = newTotal - total0;
    newP = q;
    break;
  }
  if (add == 0) return _mixPercent(seed, d);
  return _q(
    templateId: 'mix.water',
    seed: seed,
    nodeId: 'percent_mix',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '一瓶 ${_m('$p\\%')} 的盐水有 ${_m(total0)} 克。加入 ${_m(add)} 克水后，浓度是百分之几？只写数字。',
    answer: '$newP',
    hints: [
      '加水不改变溶质。溶质仍是 ${_m('$p\\%')} 乘原来的 ${_m(total0)} 克，即 ${_m(salt)} 克。',
      '新溶液 ${_m(total0 + add)} 克。',
    ],
    steps: ['浓度是 ${_m(newP)}%。'],
    nodeRefs: ['percent_mix'],
  );
}

GeneratedQuestion _crChickens(int seed, Difficulty d) {
  final rng = Random(seed);
  final chickens = _rand(rng, 3, d == Difficulty.contest ? 20 : 12);
  final rabbits = _rand(rng, 2, 10);
  final heads = chickens + rabbits;
  final legs = 2 * chickens + 4 * rabbits;
  return _q(
    templateId: 'cr.chickens',
    seed: seed,
    nodeId: 'chicken_rabbit',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '鸡兔同笼：共 ${_m(heads)} 个头、${_m(legs)} 只脚。鸡有多少只？',
    answer: '$chickens',
    hints: [
      '若全是鸡应有 ${_m(2 * heads)} 只脚，多出来的 ${_m(legs - 2 * heads)} 只来自兔子。',
      '兔子 ${_m('(脚 - 2\\times 头)/2')}。',
    ],
    steps: ['鸡有 ${_m(chickens)} 只。'],
    nodeRefs: ['chicken_rabbit'],
  );
}

GeneratedQuestion _crRabbits(int seed, Difficulty d) {
  final rng = Random(seed);
  final chickens = _rand(rng, 4, 10);
  final rabbits = _rand(rng, 2, 8);
  final heads = chickens + rabbits;
  final legs = 2 * chickens + 4 * rabbits;
  return _q(
    templateId: 'cr.rabbits',
    seed: seed,
    nodeId: 'chicken_rabbit',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '共 ${_m(heads)} 个头、${_m(legs)} 只脚。兔子有多少只？',
    answer: '$rabbits',
    hints: ['每把一只鸡换成兔子就多 2 只脚。'],
    steps: ['兔子 ${_m(rabbits)} 只。'],
    nodeRefs: ['chicken_rabbit'],
  );
}

GeneratedQuestion _treeLine(int seed, Difficulty d) {
  final rng = Random(seed);
  final gap = _rand(rng, 2, 6);
  final intervals = _rand(rng, 4, 12);
  final length = gap * intervals;
  final ans = Algebra.treesOnLine(length: length, gap: gap);
  return _q(
    templateId: 'tree.line',
    seed: seed,
    nodeId: 'tree_plant',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '一条 ${_m(length)} 米的路，两端都栽树，每隔 ${_m(gap)} 米一棵。一共栽多少棵？',
    answer: '$ans',
    hints: ['直线两端都栽：棵数 = 间隔数 + 1。', '间隔 ${_m(intervals)} 段。'],
    steps: ['${_m('$intervals + 1 = $ans')} 棵。'],
    nodeRefs: ['tree_plant'],
  );
}

GeneratedQuestion _treeCircle(int seed, Difficulty d) {
  final rng = Random(seed);
  final gap = _rand(rng, 2, 5);
  final trees = _rand(rng, 6, 16);
  final length = gap * trees;
  return _q(
    templateId: 'tree.circle',
    seed: seed,
    nodeId: 'tree_plant',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '周长 ${_m(length)} 米的圆形池塘，每隔 ${_m(gap)} 米栽一棵。栽多少棵？',
    answer: '$trees',
    hints: ['封闭路线：棵数 = 间隔数 = 周长 / 间隔。'],
    steps: ['${_m('$length / $gap = $trees')} 棵。'],
    nodeRefs: ['tree_plant'],
  );
}

GeneratedQuestion _ageYears(int seed, Difficulty d) {
  final rng = Random(seed);
  final younger = _rand(rng, 3, 8);
  final times = 2;
  final k = _rand(rng, 2, 8);
  final older = times * younger + (times - 1) * k;
  return _q(
    templateId: 'age.years',
    seed: seed,
    nodeId: 'age_problem',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '父亲 ${_m(older)} 岁，孩子 ${_m(younger)} 岁。多少年后父亲的年龄是孩子的 ${_m(times)} 倍？',
    answer: '$k',
    hints: ['${_m('$older + x = $times($younger + x)')}。'],
    steps: ['${_m(k)} 年后。'],
    nodeRefs: ['age_problem'],
  );
}

GeneratedQuestion _ageThen(int seed, Difficulty d) {
  final rng = Random(seed);
  final younger = _rand(rng, 4, 9);
  final k = _rand(rng, 2, 6);
  final older = 2 * younger + k;
  final thenOlder = older + k;
  return _q(
    templateId: 'age.then',
    seed: seed,
    nodeId: 'age_problem',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '现在父 ${_m(older)} 岁、子 ${_m(younger)} 岁。再过若干年父是子的 2 倍。那时父亲多少岁？',
    answer: '$thenOlder',
    hints: ['先求年数 x：${_m('$older + x = 2($younger + x)')}，x=${_m(k)}。'],
    steps: ['那时父亲 ${_m(thenOlder)} 岁。'],
    nodeRefs: ['age_problem'],
  );
}

GeneratedQuestion _formEdge(int seed, Difficulty d) {
  final rng = Random(seed);
  final side = _rand(rng, 3, d == Difficulty.contest ? 15 : 10);
  final ans = Algebra.formationEdge(side);
  return _q(
    templateId: 'form.edge',
    seed: seed,
    nodeId: 'square_form',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(side)} 行 ${_m(side)} 列的方阵，最外圈站多少人？',
    answer: '$ans',
    hints: ['四边各 ${_m(side)} 人，四个角重复算了，要减去 4。', '或 ${_m('4($side - 1)')}。'],
    steps: ['最外圈 ${_m(ans)} 人。'],
    nodeRefs: ['square_form'],
  );
}

GeneratedQuestion _formSide(int seed, Difficulty d) {
  final rng = Random(seed);
  final side = _rand(rng, 4, 12);
  final edge = Algebra.formationEdge(side);
  return _q(
    templateId: 'form.side',
    seed: seed,
    nodeId: 'square_form',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '方阵最外圈有 ${_m(edge)} 人。每边有多少人？',
    answer: '$side',
    hints: ['${_m('4(n-1) = $edge')}，故 ${_m('n-1 = ${edge ~/ 4}')}。'],
    steps: ['每边 ${_m(side)} 人。'],
    nodeRefs: ['square_form'],
  );
}

GeneratedQuestion _quadSum(int seed, Difficulty d) {
  final rng = Random(seed);
  final p = _rand(rng, 1, 6);
  final q = p + _rand(rng, 1, 5);
  final s = Algebra.quadSum(p, q);
  final prod = Algebra.quadProd(p, q);
  return _q(
    templateId: 'quad.sum',
    seed: seed,
    nodeId: 'quadratic',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '方程 ${_m('x^2 - $s x + $prod = 0')} 的两根之和是多少？',
    answer: '$s',
    hints: ['韦达定理：两根之和等于一次项系数的相反数（首项为 1 时）。'],
    steps: ['两根之和是 ${_m(s)}。'],
    nodeRefs: ['quadratic'],
  );
}

GeneratedQuestion _quadRoot(int seed, Difficulty d) {
  final rng = Random(seed);
  final p = _rand(rng, 1, 5);
  final q = p + _rand(rng, 1, 4);
  final s = p + q;
  final prod = p * q;
  return _q(
    templateId: 'quad.root',
    seed: seed,
    nodeId: 'quadratic',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '方程 ${_m('x^2 - $s x + $prod = 0')} 的较小根是多少？',
    answer: '$p',
    hints: ['找两个数，和 ${_m(s)}、积 ${_m(prod)}。'],
    steps: ['较小根是 ${_m(p)}。'],
    nodeRefs: ['quadratic'],
  );
}

GeneratedQuestion _grassDays(int seed, Difficulty d) {
  final rng = Random(seed);
  final grow = _rand(rng, 2, 4);
  final extra = _rand(rng, 2, 6);
  final cows = grow + extra;
  final days = _rand(rng, 4, 10);
  final stock = extra * days;
  return _q(
    templateId: 'grass.days',
    seed: seed,
    nodeId: 'grass_cow',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '牧场原有草够折合 ${_m(stock)} 头牛吃 1 天，草每天新长出够 ${_m(grow)} 头牛吃 1 天。${_m(cows)} 头牛几天能吃完？',
    answer: '$days',
    hints: ['设 t 天：${_m('$stock + $grow t = $cows t')}。'],
    steps: ['${_m(days)} 天吃完。'],
    nodeRefs: ['grass_cow'],
  );
}

GeneratedQuestion _grassCows(int seed, Difficulty d) {
  final rng = Random(seed);
  final grow = _rand(rng, 2, 5);
  final cows = grow + _rand(rng, 2, 6);
  final days = _rand(rng, 5, 10);
  final stock = (cows - grow) * days;
  return _q(
    templateId: 'grass.cows',
    seed: seed,
    nodeId: 'grass_cow',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '原有草 ${_m(stock)} 头·天，每天长 ${_m(grow)} 头·天。要恰好 ${_m(days)} 天吃完，应放多少头牛？',
    answer: '$cows',
    hints: ['${_m('$stock + $grow \\times $days = 牛数 \\times $days')}。'],
    steps: ['应放 ${_m(cows)} 头。'],
    nodeRefs: ['grass_cow'],
  );
}

GeneratedQuestion _fnEval(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 1, 6);
  final b = _rand(rng, 0, 8);
  final x = _rand(rng, 1, 9);
  final y = Algebra.linearAt(k: k, b: b, x: x);
  return _q(
    templateId: 'fn.eval',
    seed: seed,
    nodeId: 'function_intro',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '一次函数 ${_m('y = ${linearTex(k, b)}')}。当 ${_m('x = $x')} 时，y 等于多少？',
    answer: '$y',
    hints: ['把 x 代入解析式。'],
    steps: ['${_m('y = ${linearEvalTex(k, x, b)} = $y')}。'],
    nodeRefs: ['function_intro'],
  );
}

GeneratedQuestion _fnSlope(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 2, 8);
  final b = _rand(rng, 1, 6);
  return _q(
    templateId: 'fn.slope',
    seed: seed,
    nodeId: 'function_intro',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '直线 ${_m('y = $k x + $b')} 的斜率是多少？',
    answer: '$k',
    hints: ['${_m('y = kx + b')} 中 k 是斜率。'],
    steps: ['斜率是 ${_m(k)}。'],
    nodeRefs: ['function_intro'],
  );
}

GeneratedQuestion _facDiff(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 2, 9);
  return _q(
    templateId: 'fac.diff',
    seed: seed,
    nodeId: 'factor_poly',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('x^2 - ${n * n}')} 因式分解后是 ${_m('(x-a)(x+a)')}。求 a。',
    answer: '$n',
    hints: ['平方差：${_m('x^2 - a^2 = (x-a)(x+a)')}。'],
    steps: ['${_m('a = $n')}。'],
    nodeRefs: ['factor_poly'],
  );
}

GeneratedQuestion _facExpand(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 1, 6);
  final b = a + _rand(rng, 1, 5);
  return _q(
    templateId: 'fac.expand',
    seed: seed,
    nodeId: 'factor_poly',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('(x+$a)(x+$b)')} 展开后一次项系数是多少？',
    answer: '${a + b}',
    hints: ['展开 ${_m('x^2 + (${a + b})x + ${a * b}')}。'],
    steps: ['一次项系数 ${_m(a + b)}。'],
    nodeRefs: ['factor_poly', 'expand_dist'],
  );
}

GeneratedQuestion _amMin(int seed, Difficulty d) {
  final rng = Random(seed);
  final r = [1, 2, 3, 4, 5][rng.nextInt(5)];
  final c = r * r;
  final ans = Algebra.amGmMin(c);
  return _q(
    templateId: 'am.min',
    seed: seed,
    nodeId: 'am_gm',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: 'x > 0 时，${_m('x + \\frac{$c}{x}')} 的最小值是多少？',
    answer: '$ans',
    hints: ['${_m('x + c/x \\ge 2\\sqrt{c}')}，等号当 ${_m('x = \\sqrt{c}')}。'],
    steps: ['最小值是 ${_m(ans)}。'],
    nodeRefs: ['am_gm'],
  );
}

GeneratedQuestion _amProd(int seed, Difficulty d) {
  final rng = Random(seed);
  final s = [8, 10, 12, 16][rng.nextInt(4)];
  final ans = (s ~/ 2) * (s ~/ 2);
  return _q(
    templateId: 'am.prod',
    seed: seed,
    nodeId: 'am_gm',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '两个正数之和为 ${_m(s)}。它们的积最大是多少？',
    answer: '$ans',
    hints: ['和一定时，两数相等积最大。', '各取 ${_m(s ~/ 2)}。'],
    steps: ['最大积是 ${_m(ans)}。'],
    nodeRefs: ['am_gm'],
  );
}
