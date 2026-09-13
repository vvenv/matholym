import 'dart:math';

import '../olympiad_logic.dart';
import 'build.dart';
import 'question.dart';

final List<QuestionTemplate> logicTemplates = [
  QuestionTemplate(
    id: 'parity.sum',
    nodeId: 'even_odd',
    difficulties: Difficulty.values.toSet(),
    build: _paritySum,
  ),
  QuestionTemplate(
    id: 'parity.prod',
    nodeId: 'even_odd',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _parityProd,
  ),
  QuestionTemplate(
    id: 'truth.exact',
    nodeId: 'true_count',
    difficulties: Difficulty.values.toSet(),
    build: _truthExact,
  ),
  QuestionTemplate(
    id: 'truth.who',
    nodeId: 'true_count',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _truthWho,
  ),
  QuestionTemplate(
    id: 'digit.twice',
    nodeId: 'digit_riddle',
    difficulties: Difficulty.values.toSet(),
    build: _digitTwice,
  ),
  QuestionTemplate(
    id: 'digit.abab',
    nodeId: 'digit_riddle',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _digitAbab,
  ),
  QuestionTemplate(
    id: 'undo.linear',
    nodeId: 'undo_op',
    difficulties: Difficulty.values.toSet(),
    build: _undoLinear,
  ),
  QuestionTemplate(
    id: 'undo.two',
    nodeId: 'undo_op',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _undoTwo,
  ),
  QuestionTemplate(
    id: 'mm.large',
    nodeId: 'max_min',
    difficulties: Difficulty.values.toSet(),
    build: _mmLarge,
  ),
  QuestionTemplate(
    id: 'mm.small',
    nodeId: 'max_min',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _mmSmall,
  ),
  QuestionTemplate(
    id: 'weigh.n',
    nodeId: 'weigh_count',
    difficulties: Difficulty.values.toSet(),
    build: _weighN,
  ),
  QuestionTemplate(
    id: 'weigh.cap',
    nodeId: 'weigh_count',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _weighCap,
  ),
  QuestionTemplate(
    id: 'week.shift',
    nodeId: 'weekday',
    difficulties: Difficulty.values.toSet(),
    build: _weekShift,
  ),
  QuestionTemplate(
    id: 'week.back',
    nodeId: 'weekday',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _weekBack,
  ),
  QuestionTemplate(
    id: 'clock.angle',
    nodeId: 'clock_hand',
    difficulties: Difficulty.values.toSet(),
    build: _clockAngle,
  ),
  QuestionTemplate(
    id: 'clock.hour',
    nodeId: 'clock_hand',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _clockHour,
  ),
  QuestionTemplate(
    id: 'cycle.say',
    nodeId: 'remainder_cycle',
    difficulties: Difficulty.values.toSet(),
    build: _cycleSay,
  ),
  QuestionTemplate(
    id: 'cycle.which',
    nodeId: 'remainder_cycle',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _cycleWhich,
  ),
  QuestionTemplate(
    id: 'inv.flip',
    nodeId: 'invariant_parity',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _invFlip,
  ),
  QuestionTemplate(
    id: 'inv.add',
    nodeId: 'invariant_parity',
    difficulties: Difficulty.values.toSet(),
    build: _invAdd,
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
    answerRange: answerRange,
  );
}

GeneratedQuestion _paritySum(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 30);
  final b = _rand(rng, 2, 30);
  final even = OlympiadLogic.isEven(a + b);
  return _q(
    templateId: 'parity.sum',
    seed: seed,
    nodeId: 'even_odd',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '判断：${_m(a)} 与 ${_m(b)} 的和是偶数吗？回答「是」或「否」。',
    answer: even ? '是' : '否',
    hints: ['两个偶数或两个奇数相加得偶数；一奇一偶得奇数。'],
    steps: ['${_m('$a + $b = ${a + b}')}，${even ? '是偶数' : '是奇数'}。'],
    nodeRefs: ['even_odd'],
  );
}

GeneratedQuestion _parityProd(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 20);
  final b = _rand(rng, 2, 20);
  final even = OlympiadLogic.isEven(a * b);
  return _q(
    templateId: 'parity.prod',
    seed: seed,
    nodeId: 'even_odd',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '判断：${_m(a)} 与 ${_m(b)} 的积是偶数吗？回答「是」或「否」。',
    answer: even ? '是' : '否',
    hints: ['有一个因数是偶数，积就是偶数。'],
    steps: [even ? '至少一个因数为偶，积为偶。' : '两个都是奇数，积为奇。'],
    nodeRefs: ['even_odd'],
  );
}

GeneratedQuestion _truthExact(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, d == Difficulty.contest ? 6 : 5);
  return _q(
    templateId: 'truth.exact',
    seed: seed,
    nodeId: 'true_count',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '${_m(n)} 个人分别说：「我们当中恰有 1 人说真话」「恰有 2 人说真话」……「恰有 ${_m(n)} 人说真话」。有几人说真话？',
    answer: '1',
    hints: ['这些话互相矛盾，最多一句为真。', '若恰有 k 句真，则只有「恰有 k 人」那句能为真，故 k=1。'],
    steps: ['恰有 1 人说真话（说「恰有 1 人」的那一位）。'],
    nodeRefs: ['true_count'],
  );
}

GeneratedQuestion _truthWho(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, 5);
  return _q(
    templateId: 'truth.who',
    seed: seed,
    nodeId: 'true_count',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '${_m(n)} 个人依次说「我们当中恰有 1 人说真话」「恰有 2 人说真话」…「恰有 ${_m(n)} 人说真话」，每人一句。说真话的是第几句（第 k 句就是「恰有 k 人」）？',
    answer: '1',
    hints: ['只能有一种「恰有 k 人」成立，且此时真语句数就是 k。'],
    steps: ['编号 1 的说法为真。'],
    nodeRefs: ['true_count'],
  );
}

GeneratedQuestion _digitTwice(int seed, Difficulty d) {
  final rng = Random(seed);
  final ones = _rand(rng, 1, 4);
  final tens = 2 * ones;
  final n = 10 * tens + ones;
  return _q(
    templateId: 'digit.twice',
    seed: seed,
    nodeId: 'digit_riddle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '一个两位数，十位数字是个位数字的 2 倍，个位是 ${_m(ones)}。这个两位数是多少？',
    answer: '$n',
    hints: ['设个位是 a，十位是 2a，且 2a 是一位数字。', 'a 只能是 1 到 4。本题取个位 ${_m(ones)}。'],
    steps: ['这个数是 ${_m(n)}。'],
    nodeRefs: ['digit_riddle'],
  );
}

GeneratedQuestion _digitAbab(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 1, 9);
  final b = _rand(rng, 0, 9);
  final n = 1000 * a + 100 * b + 10 * a + b;
  return _q(
    templateId: 'digit.abab',
    seed: seed,
    nodeId: 'digit_riddle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '四位数 ${_m('ABAB')} 表示千位、十位都是 A，百位、个位都是 B。已知 A=${_m(a)}，B=${_m(b)}。这个四位数是多少？',
    answer: '$n',
    hints: [
      '${_m('ABAB = 1001 \\times A + 110 \\times B')}，或看成 ${_m('AB')} 重复。',
    ],
    steps: ['这个数是 ${_m(n)}。'],
    nodeRefs: ['digit_riddle'],
  );
}

GeneratedQuestion _undoLinear(int seed, Difficulty d) {
  final rng = Random(seed);
  final x = _rand(rng, 3, 15);
  final add = _rand(rng, 2, 9);
  final mul = _rand(rng, 2, 5);
  final result = (x + add) * mul;
  return _q(
    templateId: 'undo.linear',
    seed: seed,
    nodeId: 'undo_op',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '某数先加 ${_m(add)}，再乘 ${_m(mul)}，得到 ${_m(result)}。原来的数是多少？',
    answer: '$x',
    hints: ['逆过来：先除以 ${_m(mul)}，再减去 ${_m(add)}。'],
    steps: [
      '${_m('$result \\div $mul = ${result ~/ mul}')}，再减 ${_m(add)} 得 ${_m(x)}。',
    ],
    nodeRefs: ['undo_op'],
  );
}

GeneratedQuestion _undoTwo(int seed, Difficulty d) {
  final rng = Random(seed);
  final x = _rand(rng, 2, 12);
  final a = _rand(rng, 2, 6);
  final b = _rand(rng, 2, 5);
  final result = x * a + b;
  return _q(
    templateId: 'undo.two',
    seed: seed,
    nodeId: 'undo_op',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '某数乘 ${_m(a)} 再加 ${_m(b)} 等于 ${_m(result)}。求这个数。',
    answer: '$x',
    hints: ['先减 ${_m(b)}，再除以 ${_m(a)}。'],
    steps: ['${_m('($result - $b)/$a = $x')}。'],
    nodeRefs: ['undo_op'],
  );
}

GeneratedQuestion _mmLarge(int seed, Difficulty d) {
  final rng = Random(seed);
  final digits = d == Difficulty.contest ? 4 : 3;
  final sum = _rand(rng, digits, min(9 * digits - 1, digits + 12));
  final ans = OlympiadLogic.largestWithDigitSum(digits: digits, sum: sum);
  return _q(
    templateId: 'mm.large',
    seed: seed,
    nodeId: 'max_min',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '各位数字之和为 ${_m(sum)} 的 ${_m(digits)} 位数中，最大的是多少？',
    answer: '$ans',
    hints: ['高位尽量取 9，剩下的留给低位。'],
    steps: ['最大数是 ${_m(ans)}。'],
    nodeRefs: ['max_min'],
  );
}

GeneratedQuestion _mmSmall(int seed, Difficulty d) {
  final rng = Random(seed);
  final digits = 3;
  final sum = _rand(rng, 4, 15);
  final ans = OlympiadLogic.smallestWithDigitSum(digits: digits, sum: sum);
  return _q(
    templateId: 'mm.small',
    seed: seed,
    nodeId: 'max_min',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '各位数字之和为 ${_m(sum)} 的 ${_m(digits)} 位数中，最小的是多少？',
    answer: '$ans',
    hints: ['最高位至少是 1，尽量把大数字放到末位。'],
    steps: ['最小数是 ${_m(ans)}。'],
    nodeRefs: ['max_min'],
  );
}

GeneratedQuestion _weighN(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [3, 9, 12, 13, 27][rng.nextInt(5)];
  final ans = OlympiadLogic.weighings(n);
  return _q(
    templateId: 'weigh.n',
    seed: seed,
    nodeId: 'weigh_count',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '有 ${_m(n)} 个外观相同的球，其中一个较重。用天平至少称几次一定能找出重球？（每次分三堆：左、右、不称）',
    answer: '$ans',
    hints: ['一次称量有 3 种结果，k 次最多分辨 ${_m('3^k')} 种情形。'],
    steps: ['至少 ${_m(ans)} 次。'],
    nodeRefs: ['weigh_count'],
  );
}

GeneratedQuestion _weighCap(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 1, 4);
  var cap = 1;
  for (var i = 0; i < k; i++) {
    cap *= 3;
  }
  return _q(
    templateId: 'weigh.cap',
    seed: seed,
    nodeId: 'weigh_count',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '天平称 ${_m(k)} 次（每次左、右、不称三种结果），最多能在多少个球里保证找出一个较重的？',
    answer: '$cap',
    hints: ['答案是 ${_m('3^{$k}')}。'],
    steps: ['${_m('3^{$k} = $cap')}。'],
    nodeRefs: ['weigh_count'],
  );
}

/// 星期一…星期日 as Chinese reads it. The answer stays 1–7 so it can be typed.
String _weekdayName(int n) =>
    '星期${const ['一', '二', '三', '四', '五', '六', '日'][n - 1]}';

GeneratedQuestion _weekShift(int seed, Difficulty d) {
  final rng = Random(seed);
  final start = _rand(rng, 1, 7);
  final days = _rand(rng, 1, d == Difficulty.contest ? 40 : 20);
  final start0 = start == 7 ? 0 : start;
  final end0 = OlympiadLogic.weekdayShift(start0, days);
  final end = end0 == 0 ? 7 : end0;
  return _q(
    templateId: 'week.shift',
    seed: seed,
    nodeId: 'weekday',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '今天是${_weekdayName(start)}。再过 ${_m(days)} 天是星期几？只写 1–7，7 表示星期日。',
    answer: '$end',
    hints: ['星期以 7 为周期：${_m('(今天编号 + $days) \\bmod 7')}。'],
    steps: ['是${_weekdayName(end)}，填 ${_m(end)}。'],
    nodeRefs: ['weekday'],
    answerRange: (min: 1, max: 7),
  );
}

GeneratedQuestion _weekBack(int seed, Difficulty d) {
  final rng = Random(seed);
  final start = _rand(rng, 1, 7);
  final days = _rand(rng, 1, 14);
  final start0 = start == 7 ? 0 : start;
  final end0 = OlympiadLogic.weekdayShift(start0, -days);
  final end = end0 == 0 ? 7 : end0;
  return _q(
    templateId: 'week.back',
    seed: seed,
    nodeId: 'weekday',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '今天是${_weekdayName(start)}。${_m(days)} 天前是星期几？只写 1–7，7 表示星期日。',
    answer: '$end',
    hints: ['往回走同样对 7 取余。'],
    steps: ['是${_weekdayName(end)}，填 ${_m(end)}。'],
    nodeRefs: ['weekday'],
    answerRange: (min: 1, max: 7),
  );
}

GeneratedQuestion _clockAngle(int seed, Difficulty d) {
  final rng = Random(seed);
  final pairs = [(3, 0), (6, 0), (2, 20), (10, 10), (4, 0), (8, 0), (1, 10)];
  final p = pairs[rng.nextInt(pairs.length)];
  final ans = OlympiadLogic.clockAngle(p.$1, p.$2);
  return _q(
    templateId: 'clock.angle',
    seed: seed,
    nodeId: 'clock_hand',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: p.$2 == 0
        ? '${_m(p.$1)} 点整，时针与分针的夹角是多少度？（取不超过 180 的那个）'
        : '${_m(p.$1)} 点 ${_m(p.$2)} 分，时针与分针的夹角是多少度？（取不超过 180 的那个）',
    answer: '$ans',
    hints: ['分针 ${_m('6m')} 度，时针 ${_m('30H + 0.5m')} 度。'],
    steps: ['夹角是 ${_m(ans)} 度。'],
    nodeRefs: ['clock_hand'],
    answerRange: (min: 0, max: 180),
  );
}

GeneratedQuestion _clockHour(int seed, Difficulty d) {
  final rng = Random(seed);
  final h = _rand(rng, 1, 11);
  final ans = OlympiadLogic.clockAngle(h, 0);
  return _q(
    templateId: 'clock.hour',
    seed: seed,
    nodeId: 'clock_hand',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(h)} 点整，时针与分针夹角是多少度？',
    answer: '$ans',
    hints: [
      '整点时分针在 12，时针走了 ${_m('$h \\times 30')} 度。',
      '夹角取 ${_m('\\min(30H, 360-30H)')}。',
    ],
    steps: ['夹角 ${_m(ans)} 度。'],
    nodeRefs: ['clock_hand'],
    answerRange: (min: 0, max: 180),
  );
}

GeneratedQuestion _cycleSay(int seed, Difficulty d) {
  final rng = Random(seed);
  final mod = _rand(rng, 3, 7);
  final n = _rand(rng, 5, d == Difficulty.contest ? 40 : 25);
  final ans = OlympiadLogic.cycleReport(n, mod);
  return _q(
    templateId: 'cycle.say',
    seed: seed,
    nodeId: 'remainder_cycle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '一队人从 1 报到 ${_m(mod)} 再回到 1，循环报数。第 ${_m(n)} 个人报的是几？',
    answer: '$ans',
    hints: ['编号对 ${_m(mod)} 取余，余 0 时报 ${_m(mod)}。'],
    steps: ['报 ${_m(ans)}。'],
    nodeRefs: ['remainder_cycle'],
  );
}

GeneratedQuestion _cycleWhich(int seed, Difficulty d) {
  final rng = Random(seed);
  final mod = _rand(rng, 4, 8);
  final target = _rand(rng, 1, mod);
  final k = _rand(rng, 2, 6);
  final n = (k - 1) * mod + target;
  return _q(
    templateId: 'cycle.which',
    seed: seed,
    nodeId: 'remainder_cycle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '一队人从 1 报到 ${_m(mod)} 再回到 1，循环报数。第 ${_m(k)} 轮报到 ${_m(target)} 的是第几个人？',
    answer: '$n',
    hints: ['第 k 轮的 ${_m(target)} 是第 ${_m('(k-1)\\times $mod + $target')} 个人。'],
    steps: ['是第 ${_m(n)} 个人。'],
    nodeRefs: ['remainder_cycle'],
  );
}

GeneratedQuestion _invFlip(int seed, Difficulty d) {
  final rng = Random(seed);
  final tails = _rand(rng, 1, 10);
  final yes = OlympiadLogic.canClearTails(tails);
  return _q(
    templateId: 'inv.flip',
    seed: seed,
    nodeId: 'invariant_parity',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '桌上有 ${_m(tails)} 枚背面朝上的硬币。每次必须同时翻两枚。能否全部翻成正面？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: ['每次背面枚数的奇偶性不变。', '要变成 0 枚背面，开始时背面数必须是偶数。'],
    steps: [yes ? '背面数为偶，可以。' : '背面数为奇，奇偶不变，不能变成 0。'],
    nodeRefs: ['invariant_parity', 'even_odd'],
  );
}

GeneratedQuestion _invAdd(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 1, 9);
  final b = _rand(rng, 1, 9);
  final targetA = a + _rand(rng, 1, 5);
  final steps = targetA - a;
  final targetB = b + steps;
  final askYes = rng.nextBool();
  final other = askYes ? targetB : targetB + 1;
  final yes = other == targetB;
  return _q(
    templateId: 'inv.add',
    seed: seed,
    nodeId: 'invariant_parity',
    difficulty: d,
    kind: QuestionKind.judge,
    stem:
        '黑板上写着 ${_m(a)} 和 ${_m(b)}。每次把两个数都加 1。能否变成 ${_m(targetA)} 和 ${_m(other)}？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: ['两个数的差不变。', '原来差 ${_m(a - b)}，目标差 ${_m(targetA - other)}。'],
    steps: [yes ? '差相同，可以。' : '差变了，不可能。'],
    nodeRefs: ['invariant_parity'],
  );
}
