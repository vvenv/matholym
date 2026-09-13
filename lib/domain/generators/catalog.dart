import 'dart:math';

import '../number_theory.dart';
import 'algebra_catalog.dart';
import 'calculation_catalog.dart';
import 'congruence_catalog.dart';
import 'counting_catalog.dart';
import 'geometry_catalog.dart';
import 'logic_catalog.dart';
import 'question.dart';
import 'classic_catalog.dart';
import 'depth_catalog.dart';
import 'encore_catalog.dart';
import 'syllabus_catalog.dart';

final questionEngine = QuestionEngine(questionTemplates);

final List<QuestionTemplate> questionTemplates = [
  ..._coreNumberTheoryTemplates,
  ...congruenceTemplates,
  ...countingTemplates,
  ...algebraTemplates,
  ...geometryTemplates,
  ...calculationTemplates,
  ...logicTemplates,
  ...syllabusTemplates,
  ...classicTemplates,
  ...depthTemplates,
  ...encoreTemplates,
];

final List<QuestionTemplate> _coreNumberTheoryTemplates = [
  QuestionTemplate(
    id: 'div_def.divides',
    nodeId: 'divisibility_def',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _divides,
  ),
  QuestionTemplate(
    id: 'div_def.divisor_count',
    nodeId: 'divisibility_def',
    difficulties: Difficulty.values.toSet(),
    build: _divisorCount,
  ),
  QuestionTemplate(
    id: 'div_alg.quot_rem',
    nodeId: 'division_algorithm',
    difficulties: Difficulty.values.toSet(),
    build: _quotRem,
  ),
  QuestionTemplate(
    id: 'div_alg.identity',
    nodeId: 'division_algorithm',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _divIdentity,
  ),
  QuestionTemplate(
    id: 'rules.check',
    nodeId: 'divisibility_rules',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _rulesCheck,
  ),
  QuestionTemplate(
    id: 'rules.missing_digit',
    nodeId: 'divisibility_rules',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _missingDigit,
  ),
  QuestionTemplate(
    id: 'primes.judge',
    nodeId: 'primes_composites',
    difficulties: Difficulty.values.toSet(),
    build: _primeJudge,
  ),
  QuestionTemplate(
    id: 'primes.count_range',
    nodeId: 'primes_composites',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _primeCount,
  ),
  QuestionTemplate(
    id: 'primes.smallest_factor',
    nodeId: 'primes_composites',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _smallestFactor,
  ),
  QuestionTemplate(
    id: 'fta.factorize',
    nodeId: 'fta',
    difficulties: Difficulty.values.toSet(),
    build: _factorize,
  ),
  QuestionTemplate(
    id: 'fta.divisor_count',
    nodeId: 'fta',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _ftaDivisorCount,
  ),
  QuestionTemplate(
    id: 'sieve.list',
    nodeId: 'sieve',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _sieveList,
  ),
  QuestionTemplate(
    id: 'sieve.count',
    nodeId: 'sieve',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _sieveCount,
  ),
  QuestionTemplate(
    id: 'gcd.value',
    nodeId: 'gcd',
    difficulties: Difficulty.values.toSet(),
    build: _gcdValue,
  ),
  QuestionTemplate(
    id: 'gcd.euclid_step',
    nodeId: 'gcd',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _euclidStep,
  ),
  QuestionTemplate(
    id: 'gcd.from_factors',
    nodeId: 'gcd',
    difficulties: {Difficulty.contest},
    build: _gcdFromFactors,
  ),
  QuestionTemplate(
    id: 'lcm.value',
    nodeId: 'lcm',
    difficulties: Difficulty.values.toSet(),
    build: _lcmValue,
  ),
  QuestionTemplate(
    id: 'lcm.identity',
    nodeId: 'lcm',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _lcmIdentity,
  ),
  QuestionTemplate(
    id: 'coprime.judge',
    nodeId: 'coprime',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _coprimeJudge,
  ),
  QuestionTemplate(
    id: 'coprime.count_with',
    nodeId: 'coprime',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _coprimeCount,
  ),
  QuestionTemplate(
    id: 'div_def.common_multiple_check',
    nodeId: 'divisibility_def',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _commonMultiple,
  ),
  QuestionTemplate(
    id: 'primes.next',
    nodeId: 'primes_composites',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _nextPrime,
  ),
  QuestionTemplate(
    id: 'gcd.three',
    nodeId: 'gcd',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _gcdThree,
  ),
  QuestionTemplate(
    id: 'fta.omega',
    nodeId: 'fta',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _distinctPrimes,
  ),
];

/// Inline TeX. Factor strings arrive as `2*17`; typeset the product as ×.
String _m(Object v) => '\$${'$v'.replaceAll('*', r' \times ')}\$';

int _rand(Random rng, int lo, int hi) => lo + rng.nextInt(hi - lo + 1);

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
  List<String> choices = const [],
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
    answerRange: answerRange,
  );
}

GeneratedQuestion _divides(int seed, Difficulty d) {
  final rng = Random(seed);
  final maxA = d == Difficulty.basic ? 12 : 40;
  var a = _rand(rng, 2, maxA);
  var b = a * _rand(rng, 2, d == Difficulty.basic ? 6 : 12);
  if (rng.nextBool()) {
    b += _rand(rng, 1, a - 1);
  }
  final yes = NumberTheory.divides(a, b);
  return _q(
    templateId: 'div_def.divides',
    seed: seed,
    nodeId: 'divisibility_def',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '判断：${_m(a)} 能否整除 ${_m(b)}？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: [
      '回忆定义：存在整数 k 使得 ${_m('$b = $a k')}，则称 a 整除 b。',
      '看 ${_m(b)} 除以 ${_m(a)} 的余数是否为 0。',
    ],
    steps: [
      '${_m('$b = $a \\times ${b ~/ a} + ${b % a}')}。',
      yes ? '余数为 0，故 ${_m('$a\\mid $b')}。' : '余数非 0，不能整除。',
    ],
    nodeRefs: ['divisibility_def'],
  );
}

GeneratedQuestion _divisorCount(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = switch (d) {
    Difficulty.basic => _rand(rng, 6, 36),
    Difficulty.medium => _rand(rng, 20, 120),
    Difficulty.contest => [
      72,
      84,
      90,
      96,
      108,
      120,
      144,
      180,
      240,
    ][rng.nextInt(9)],
  };
  final count = NumberTheory.divisorCount(n);
  final factors = NumberTheory.formatFactorization(NumberTheory.factorize(n));
  return _q(
    templateId: 'div_def.divisor_count',
    seed: seed,
    nodeId: 'divisibility_def',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求正整数 ${_m(n)} 的正因数个数。',
    answer: '$count',
    hints: ['先列出 ${_m(n)} 的全部正因数，或先做质因数分解。', '若 n 的质因数分解已知，则正因数个数为各指数加一再相乘。'],
    steps: [
      '${_m('$n = $factors')}。',
      '正因数个数为 ${_m(count)}。',
      '因数列表：${NumberTheory.positiveDivisors(n).join(', ')}。',
    ],
    nodeRefs: ['divisibility_def', 'fta'],
  );
}

GeneratedQuestion _quotRem(int seed, Difficulty d) {
  final rng = Random(seed);
  final b = _rand(rng, 3, d == Difficulty.basic ? 12 : 30);
  final q = _rand(rng, 1, d == Difficulty.basic ? 8 : 40);
  final r = _rand(rng, 0, b - 1);
  final a = b * q + r;
  return _q(
    templateId: 'div_alg.quot_rem',
    seed: seed,
    nodeId: 'division_algorithm',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '做带余除法：${_m('$a \\div $b')}。把商和余数写成「商,余数」，例如 3,2。',
    answer: '$q,$r',
    hints: [
      '带余除法：${_m('a = bq + r')}，其中余数满足 ${_m('0 \\le r < b')}。',
      '先估商，再算 ${_m('r = a - bq')}。',
    ],
    steps: ['${_m('$a = $b \\times $q + $r')}。', '商是 ${_m(q)}，余数是 ${_m(r)}。'],
    nodeRefs: ['division_algorithm'],
  );
}

GeneratedQuestion _divIdentity(int seed, Difficulty d) {
  final rng = Random(seed);
  final b = _rand(rng, 4, d == Difficulty.basic ? 9 : 18);
  final q = _rand(rng, 2, d == Difficulty.basic ? 8 : 20);
  final r = _rand(rng, 1, b - 1);
  final a = b * q + r;
  return _q(
    templateId: 'div_alg.identity',
    seed: seed,
    nodeId: 'division_algorithm',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '已知 ${_m('$a = $b \\times q + r')}，其中 ${_m('r = $r')} 且 ${_m('0 \\le r < $b')}，求 q。',
    answer: '$q',
    hints: ['把等式看成带余除法的标准形。', 'q 就是 ${_m(a)} 除以 ${_m(b)} 的商。'],
    steps: ['${_m('$a \\div $b')} 的商为 ${_m(q)}。'],
    nodeRefs: ['division_algorithm'],
  );
}

GeneratedQuestion _rulesCheck(int seed, Difficulty d) {
  final rng = Random(seed);
  final divisor = [2, 3, 5, 9, 11][rng.nextInt(5)];
  final n = _rand(
    rng,
    d == Difficulty.basic ? 20 : 100,
    d == Difficulty.basic ? 99 : 9999,
  );
  final yes = NumberTheory.hasDivisibilityRule(divisor, n);
  final rule = switch (divisor) {
    2 => '看个位是否为偶数',
    3 => '各位数字之和能否被 3 整除',
    5 => '个位是 0 或 5',
    9 => '各位数字之和能否被 9 整除',
    _ => '从右起交替加减各位数字，结果能否被 11 整除',
  };
  return _q(
    templateId: 'rules.check',
    seed: seed,
    nodeId: 'divisibility_rules',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '判断：${_m(n)} 能否被 ${_m(divisor)} 整除？回答「是」或「否」。请用整除特征，不要硬除。',
    answer: yes ? '是' : '否',
    hints: [
      '被 ${_m(divisor)} 整除的特征：$rule。',
      divisor == 3 || divisor == 9
          ? '数字之和为 ${NumberTheory.digitSum(n)}。'
          : divisor == 11
          ? '交替和为 ${NumberTheory.alternatingDigitSum(n)}。'
          : '观察个位 ${n % 10}。',
    ],
    steps: ['所用特征：$rule。', yes ? '结论：能整除。' : '结论：不能整除。'],
    nodeRefs: ['divisibility_rules'],
  );
}

GeneratedQuestion _missingDigit(int seed, Difficulty d) {
  final rng = Random(seed);
  var divisor = rng.nextBool() ? 9 : 11;
  final len = d == Difficulty.contest ? 5 : 4;
  var digits = <int?>[];
  var hits = <int>[];
  var guard = 0;
  do {
    digits = [for (var i = 0; i < len; i++) _rand(rng, i == 0 ? 1 : 0, 9)];
    final blank = _rand(rng, 0, len - 1);
    digits[blank] = null;
    hits = NumberTheory.missingDigitCandidates(
      digits: digits,
      divisor: divisor,
    );
    guard++;
  } while (hits.length != 1 && guard < 80);
  if (hits.length != 1) {
    digits = [1, 2, null, 6];
    divisor = 9;
    hits = NumberTheory.missingDigitCandidates(digits: digits, divisor: 9);
  }
  final shown = digits.map((e) => e == null ? r'\square' : '$e').join();
  final answer = hits.first;
  final filled = digits.map((e) => e ?? answer).join();
  return _q(
    templateId: 'rules.missing_digit',
    seed: seed,
    nodeId: 'divisibility_rules',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '求一位数字 ${_m(r'\square')}，使得 ${_m(shown)} 能被 ${_m(divisor)} 整除。若有多个取最小。',
    answer: '$answer',
    hints: [
      divisor == 9 ? '被 9 整除：各位数字之和是 9 的倍数。' : '被 11 整除：从右起交替和是 11 的倍数。',
      '把空位设为未知数 x，列出关于 x 的整除条件。',
    ],
    steps: [
      '满足条件的数字为 ${_m(answer)}。',
      '代入后 ${_m(filled)} 能被 ${_m(divisor)} 整除。',
    ],
    nodeRefs: ['divisibility_rules'],
    answerRange: (min: 0, max: 9),
  );
}

GeneratedQuestion _primeJudge(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = switch (d) {
    Difficulty.basic => [
      2,
      3,
      4,
      9,
      11,
      15,
      17,
      21,
      25,
      27,
      29,
      33,
    ][rng.nextInt(12)],
    Difficulty.medium => _rand(rng, 20, 120),
    Difficulty.contest => _rand(rng, 100, 250),
  };
  final yes = NumberTheory.isPrime(n);
  return _q(
    templateId: 'primes.judge',
    seed: seed,
    nodeId: 'primes_composites',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '判断：${_m(n)} 是质数吗？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: [
      '质数只有 1 和自身两个正因数；合数至少有三个正因数。1 既非质也非合。',
      '试除不超过 ${_m('\\sqrt{$n}')} 的质数。',
    ],
    steps: [
      if (n <= 1)
        '${_m(n)} 不大于 1，不是质数。'
      else if (yes)
        '试除后无因子，${_m(n)} 是质数。'
      else
        '最小质因数为 ${NumberTheory.smallestPrimeFactor(n)}，故为合数。',
    ],
    nodeRefs: ['primes_composites'],
  );
}

GeneratedQuestion _primeCount(int seed, Difficulty d) {
  final rng = Random(seed);
  final width = d == Difficulty.contest ? 40 : 20;
  final low = _rand(rng, 10, d == Difficulty.contest ? 80 : 40);
  final high = low + width;
  final count = NumberTheory.primeCountInRange(low, high);
  final listed = [
    for (var i = low; i <= high; i++)
      if (NumberTheory.isPrime(i)) i,
  ];
  return _q(
    templateId: 'primes.count_range',
    seed: seed,
    nodeId: 'primes_composites',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '闭区间 [${_m(low)}, ${_m(high)}] 内有多少个质数？',
    answer: '$count',
    hints: ['枚举区间内整数并做素性判定，或借助筛法。', '注意区间是闭区间。'],
    steps: ['该区间内质数为：${listed.join(', ')}。', '共 ${_m(count)} 个。'],
    nodeRefs: ['primes_composites', 'sieve'],
  );
}

GeneratedQuestion _smallestFactor(int seed, Difficulty d) {
  final rng = Random(seed);
  var n = _rand(rng, 8, d == Difficulty.basic ? 60 : 180);
  if (NumberTheory.isPrime(n)) n *= _rand(rng, 2, 5);
  final p = NumberTheory.smallestPrimeFactor(n);
  return _q(
    templateId: 'primes.smallest_factor',
    seed: seed,
    nodeId: 'primes_composites',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m(n)} 的最小质因数。',
    answer: '$p',
    hints: ['从 2, 3, 5, … 依次试除，第一个整除 ${_m(n)} 的质数即是。', '若 ${_m(n)} 为偶数则答案为 2。'],
    steps: ['最小质因数是 ${_m(p)}，因为 ${_m('$p\\mid $n')} 且更小的质数都不能整除。'],
    nodeRefs: ['primes_composites'],
  );
}

GeneratedQuestion _factorize(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = switch (d) {
    Difficulty.basic => [
      12,
      18,
      20,
      24,
      28,
      30,
      36,
      40,
      42,
      45,
    ][rng.nextInt(10)],
    Difficulty.medium => [48, 54, 60, 72, 84, 90, 96, 108, 120][rng.nextInt(9)],
    Difficulty.contest => [
      180,
      210,
      240,
      252,
      300,
      336,
      360,
      420,
    ][rng.nextInt(8)],
  };
  final formatted = NumberTheory.formatFactorization(NumberTheory.factorize(n));
  return _q(
    templateId: 'fta.factorize',
    seed: seed,
    nodeId: 'fta',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '将 ${_m(n)} 分解为标准质因数形式。',
    answer: formatted,
    hints: ['算术基本定理：每个大于 1 的整数可唯一写成质数幂的乘积（不计次序）。', '从小到大试除质数，并累计指数。'],
    steps: ['${_m('$n = $formatted')}。'],
    nodeRefs: ['fta'],
  );
}

GeneratedQuestion _ftaDivisorCount(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = d == Difficulty.contest
      ? [180, 240, 360, 420, 720][rng.nextInt(5)]
      : [60, 72, 84, 90, 120][rng.nextInt(5)];
  final factors = NumberTheory.factorize(n);
  final count = NumberTheory.divisorCount(n);
  final formula = factors.entries.map((e) => '(${e.value}+1)').join();
  final formatted = NumberTheory.formatFactorization(factors);
  return _q(
    templateId: 'fta.divisor_count',
    seed: seed,
    nodeId: 'fta',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '已知正整数 ${_m(n)}，利用质因数分解求它的正因数个数。',
    answer: '$count',
    hints: ['先分解 ${_m(n)}，再用「指数加一再相乘」。', '${_m('$n = $formatted')}。'],
    steps: ['${_m('$n = $formatted')}。', '正因数个数 = $formula = ${_m(count)}。'],
    nodeRefs: ['fta'],
  );
}

GeneratedQuestion _sieveList(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = d == Difficulty.basic ? _rand(rng, 12, 20) : _rand(rng, 20, 36);
  final primes = NumberTheory.primesUpTo(n);
  return _q(
    templateId: 'sieve.list',
    seed: seed,
    nodeId: 'sieve',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '用埃拉托斯特尼筛法筛 2 到 ${_m(n)} 后，剩下的质数从小到大用逗号分隔写出。',
    answer: primes.join(','),
    hints: ['从 2 开始，划掉它的倍数；再对下一个未划掉的数重复。', '只需筛到 ${_m('\\sqrt{$n}')} 即可。'],
    steps: ['筛完剩下：${primes.join(', ')}。'],
    nodeRefs: ['sieve'],
  );
}

GeneratedQuestion _sieveCount(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = d == Difficulty.contest ? _rand(rng, 40, 80) : _rand(rng, 25, 50);
  final primes = NumberTheory.primesUpTo(n);
  return _q(
    templateId: 'sieve.count',
    seed: seed,
    nodeId: 'sieve',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '用筛法处理 1 到 ${_m(n)} 后，还剩多少个质数？（1 不是质数）',
    answer: '${primes.length}',
    hints: ['先划掉 1，再按倍数划合数。', '剩下的个数即 ${_m('\\pi($n)')}。'],
    steps: ['${_m('\\pi($n) = ${primes.length}')}。'],
    nodeRefs: ['sieve'],
  );
}

GeneratedQuestion _gcdValue(int seed, Difficulty d) {
  final rng = Random(seed);
  final g = switch (d) {
    Difficulty.basic => _rand(rng, 2, 6),
    Difficulty.medium => _rand(rng, 3, 12),
    Difficulty.contest => _rand(rng, 6, 24),
  };
  var x = _rand(rng, 2, d == Difficulty.basic ? 8 : 18);
  var y = _rand(rng, 2, d == Difficulty.basic ? 8 : 18);
  while (NumberTheory.gcd(x, y) != 1) {
    y = _rand(rng, 2, 18);
  }
  final a = g * x;
  final b = g * y;
  final ans = NumberTheory.gcd(a, b);
  return _q(
    templateId: 'gcd.value',
    seed: seed,
    nodeId: 'gcd',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('\\gcd($a, $b)')}。',
    answer: '$ans',
    hints: ['欧几里得算法：反复用较大数除以较小数，取余数。', '${_m(r'\gcd(a,b)=\gcd(b,a\bmod b)')}。'],
    steps: ['欧几里得算法得到 ${_m('\\gcd($a, $b) = $ans')}。'],
    nodeRefs: ['gcd'],
  );
}

GeneratedQuestion _euclidStep(int seed, Difficulty d) {
  final rng = Random(seed);
  var a = _rand(rng, 20, d == Difficulty.basic ? 60 : 180);
  var b = _rand(rng, 8, a - 1);
  if (a < b) {
    final t = a;
    a = b;
    b = t;
  }
  final r = a % b;
  return _q(
    templateId: 'gcd.euclid_step',
    seed: seed,
    nodeId: 'gcd',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '用欧几里得算法求 ${_m('\\gcd($a, $b)')} 时，第一步得到的余数是多少？',
    answer: '$r',
    hints: ['第一步计算 ${_m('$a \\bmod $b')}。', '带余除法：${_m('a = bq + r')}。'],
    steps: ['${_m('$a = $b \\times ${a ~/ b} + $r')}，故余数为 ${_m(r)}。'],
    nodeRefs: ['gcd', 'division_algorithm'],
  );
}

GeneratedQuestion _gcdFromFactors(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = [60, 84, 90, 120, 180][rng.nextInt(5)];
  final b = [36, 48, 72, 105, 210][rng.nextInt(5)];
  final g = NumberTheory.gcd(a, b);
  final fa = NumberTheory.formatFactorization(NumberTheory.factorize(a));
  final fb = NumberTheory.formatFactorization(NumberTheory.factorize(b));
  final fg = NumberTheory.formatFactorization(NumberTheory.factorize(g));
  return _q(
    templateId: 'gcd.from_factors',
    seed: seed,
    nodeId: 'gcd',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '先分解再求公约数：${_m('$a = $fa')}，${_m('$b = $fb')}。求 ${_m('\\gcd($a, $b)')}。',
    answer: '$g',
    hints: ['对每个质数取两边指数的最小值。', '再把这些质数幂乘起来。'],
    steps: ['${_m('\\gcd($a, $b) = $g = $fg')}。'],
    nodeRefs: ['gcd', 'fta'],
  );
}

GeneratedQuestion _lcmValue(int seed, Difficulty d) {
  final rng = Random(seed);
  final g = _rand(rng, 2, d == Difficulty.basic ? 5 : 10);
  var x = _rand(rng, 2, 8);
  var y = _rand(rng, 2, 8);
  while (NumberTheory.gcd(x, y) != 1) {
    y = _rand(rng, 2, 9);
  }
  final a = g * x;
  final b = g * y;
  final ans = NumberTheory.lcm(a, b);
  final gcd = NumberTheory.gcd(a, b);
  return _q(
    templateId: 'lcm.value',
    seed: seed,
    nodeId: 'lcm',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('\\mathrm{lcm}($a, $b)')}。',
    answer: '$ans',
    hints: ['可用 ${_m(r'\mathrm{lcm}(a,b)=ab/\gcd(a,b)')}。', '或对每个质数取指数最大值。'],
    steps: [
      '${_m('\\gcd($a, $b) = $gcd')}。',
      '${_m('\\mathrm{lcm}($a, $b) = $a \\times $b / $gcd = $ans')}。',
    ],
    nodeRefs: ['lcm', 'gcd'],
  );
}

GeneratedQuestion _lcmIdentity(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 6, d == Difficulty.contest ? 40 : 24);
  final b = _rand(rng, 6, d == Difficulty.contest ? 40 : 24);
  final g = NumberTheory.gcd(a, b);
  final l = NumberTheory.lcm(a, b);
  final askGcd = rng.nextBool();
  return _q(
    templateId: 'lcm.identity',
    seed: seed,
    nodeId: 'lcm',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: askGcd
        ? '已知 ${_m(a)}、${_m(b)} 且 ${_m('\\mathrm{lcm}($a, $b) = $l')}。求 ${_m('\\gcd($a, $b)')}。'
        : '已知 ${_m('\\gcd($a, $b) = $g')}。求 ${_m('\\mathrm{lcm}($a, $b)')}。',
    answer: askGcd ? '$g' : '$l',
    hints: [
      '恒等式：${_m(r'\gcd(a,b)\cdot\mathrm{lcm}(a,b)=ab')}（正整数）。',
      askGcd ? '因此 gcd = ab / lcm。' : '因此 lcm = ab / gcd。',
    ],
    steps: [
      '${_m('$a \\times $b = ${a * b}')}。',
      askGcd
          ? '${_m('\\gcd = ${a * b} / $l = $g')}。'
          : '${_m('\\mathrm{lcm} = ${a * b} / $g = $l')}。',
    ],
    nodeRefs: ['lcm', 'gcd'],
  );
}

GeneratedQuestion _coprimeJudge(int seed, Difficulty d) {
  final rng = Random(seed);
  final makeCoprime = rng.nextBool();
  late int a;
  late int b;
  if (makeCoprime) {
    a = _rand(rng, 4, d == Difficulty.basic ? 20 : 50);
    b = _rand(rng, 4, d == Difficulty.basic ? 20 : 50);
    while (NumberTheory.gcd(a, b) != 1) {
      b++;
    }
  } else {
    final g = _rand(rng, 2, 7);
    a = g * _rand(rng, 2, 9);
    b = g * _rand(rng, 2, 9);
  }
  final yes = NumberTheory.isCoprime(a, b);
  final g = NumberTheory.gcd(a, b);
  return _q(
    templateId: 'coprime.judge',
    seed: seed,
    nodeId: 'coprime',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '判断：${_m(a)} 与 ${_m(b)} 是否互质？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: ['互质指 ${_m(r'\gcd(a,b)=1')}，不必都是质数。', '先算最大公约数。'],
    steps: ['${_m('\\gcd($a, $b) = $g')}，故${yes ? '互质' : '不互质'}。'],
    nodeRefs: ['coprime', 'gcd'],
  );
}

GeneratedQuestion _coprimeCount(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = d == Difficulty.contest ? _rand(rng, 12, 24) : _rand(rng, 8, 16);
  final list = <int>[
    for (var i = 1; i <= n; i++)
      if (NumberTheory.isCoprime(i, n)) i,
  ];
  return _q(
    templateId: 'coprime.count_with',
    seed: seed,
    nodeId: 'coprime',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '在 1, 2, …, ${_m(n)} 中，有多少个数与 ${_m(n)} 互质？',
    answer: '${list.length}',
    hints: [
      '即欧拉函数 ${_m('\\varphi($n)')} 的定义（可枚举）。',
      '对每个 k 检查它与 ${_m(n)} 是否互质。',
    ],
    steps: ['与 ${_m(n)} 互质的是：${list.join(', ')}。', '共 ${_m(list.length)} 个。'],
    nodeRefs: ['coprime'],
  );
}

GeneratedQuestion _commonMultiple(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, d == Difficulty.basic ? 9 : 14);
  final b = a * _rand(rng, 2, 8);
  final c = rng.nextBool() ? b : b + 1;
  final yes = NumberTheory.divides(a, c);
  return _q(
    templateId: 'div_def.common_multiple_check',
    seed: seed,
    nodeId: 'divisibility_def',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '已知 ${_m('$a\\mid $b')}。判断：${_m(a)} 是否整除 ${_m(c)}？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: [
      '整除有传递性，但不能由 a 整除 b 推出 a 整除任意与 b 接近的数。',
      '直接检查 ${_m('$c \\bmod $a')}。',
    ],
    steps: [
      '${_m('$c = $a \\times ${c ~/ a} + ${c % a}')}。',
      yes ? '余数为 0，成立。' : '余数非 0，不成立。',
    ],
    nodeRefs: ['divisibility_def'],
  );
}

GeneratedQuestion _nextPrime(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 10, d == Difficulty.contest ? 120 : 60);
  final p = NumberTheory.nextPrime(n);
  return _q(
    templateId: 'primes.next',
    seed: seed,
    nodeId: 'primes_composites',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求比 ${_m(n)} 大的最小质数。',
    answer: '$p',
    hints: ['从 ${_m(n + 1)} 起逐个检验素性。', '偶数（大于 2）直接跳过。'],
    steps: ['下一个质数是 ${_m(p)}。'],
    nodeRefs: ['primes_composites'],
  );
}

GeneratedQuestion _gcdThree(int seed, Difficulty d) {
  final rng = Random(seed);
  final g = _rand(rng, 2, d == Difficulty.contest ? 8 : 5);
  var x = _rand(rng, 2, 8);
  var y = _rand(rng, 2, 8);
  var z = _rand(rng, 2, 8);
  while (NumberTheory.gcd(NumberTheory.gcd(x, y), z) != 1) {
    z = _rand(rng, 2, 9);
  }
  final a = g * x;
  final b = g * y;
  final c = g * z;
  final ans = NumberTheory.gcd(NumberTheory.gcd(a, b), c);
  return _q(
    templateId: 'gcd.three',
    seed: seed,
    nodeId: 'gcd',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('\\gcd($a, $b, $c)')}。',
    answer: '$ans',
    hints: [
      '先算其中两个的最大公约数，再与第三个数求一次。',
      '${_m('\\gcd(a,b,c)=\\gcd(\\gcd(a,b),c)')}。',
    ],
    steps: [
      '${_m('\\gcd($a, $b) = ${NumberTheory.gcd(a, b)}')}。',
      '再与 ${_m(c)} 求公约数，得 ${_m(ans)}。',
    ],
    nodeRefs: ['gcd'],
  );
}

GeneratedQuestion _distinctPrimes(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = d == Difficulty.medium
      ? [60, 84, 90, 120, 180][rng.nextInt(5)]
      : [12, 18, 20, 30, 42, 45][rng.nextInt(6)];
  final factors = NumberTheory.factorize(n);
  final ans = factors.length;
  final formatted = NumberTheory.formatFactorization(factors);
  return _q(
    templateId: 'fta.omega',
    seed: seed,
    nodeId: 'fta',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m(n)} 的不同质因数的个数。',
    answer: '$ans',
    hints: ['先做质因数分解，再数有几个不同的质数。', '不要把指数加进个数里。'],
    steps: ['${_m('$n = $formatted')}，不同质因数 ${_m(ans)} 个。'],
    nodeRefs: ['fta'],
  );
}
