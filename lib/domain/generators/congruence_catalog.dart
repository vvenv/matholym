import 'dart:math';

import '../number_theory.dart';
import 'build.dart';
import 'question.dart';

final List<QuestionTemplate> congruenceTemplates = [
  QuestionTemplate(
    id: 'cong.judge',
    nodeId: 'congruence_def',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _congJudge,
  ),
  QuestionTemplate(
    id: 'cong.residue',
    nodeId: 'congruence_def',
    difficulties: Difficulty.values.toSet(),
    build: _congResidue,
  ),
  QuestionTemplate(
    id: 'cong_ops.product',
    nodeId: 'congruence_ops',
    difficulties: Difficulty.values.toSet(),
    build: _congProduct,
  ),
  QuestionTemplate(
    id: 'cong_ops.cancel',
    nodeId: 'congruence_ops',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _congCancel,
  ),
  QuestionTemplate(
    id: 'residue.least',
    nodeId: 'complete_residue',
    difficulties: Difficulty.values.toSet(),
    build: _leastResidue,
  ),
  QuestionTemplate(
    id: 'residue.count',
    nodeId: 'complete_residue',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _residueCount,
  ),
  QuestionTemplate(
    id: 'bezout.exists',
    nodeId: 'bezout',
    difficulties: Difficulty.values.toSet(),
    build: _bezoutExists,
  ),
  QuestionTemplate(
    id: 'bezout.coeff',
    nodeId: 'bezout',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _bezoutCoeff,
  ),
  QuestionTemplate(
    id: 'fermat.ap',
    nodeId: 'fermat',
    difficulties: Difficulty.values.toSet(),
    build: _fermatAp,
  ),
  QuestionTemplate(
    id: 'fermat.reduce',
    nodeId: 'fermat',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _fermatReduce,
  ),
  QuestionTemplate(
    id: 'wilson.value',
    nodeId: 'wilson',
    difficulties: Difficulty.values.toSet(),
    build: _wilsonValue,
  ),
  QuestionTemplate(
    id: 'wilson.judge',
    nodeId: 'wilson',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _wilsonJudge,
  ),
  QuestionTemplate(
    id: 'euler.phi',
    nodeId: 'euler',
    difficulties: Difficulty.values.toSet(),
    build: _eulerPhi,
  ),
  QuestionTemplate(
    id: 'euler.power',
    nodeId: 'euler',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _eulerPower,
  ),
  QuestionTemplate(
    id: 'crt.two',
    nodeId: 'crt',
    difficulties: Difficulty.values.toSet(),
    build: _crtTwo,
  ),
  QuestionTemplate(
    id: 'crt.construct',
    nodeId: 'crt',
    difficulties: {Difficulty.contest},
    build: _crtConstruct,
  ),
  QuestionTemplate(
    id: 'floor.value',
    nodeId: 'gauss_floor',
    difficulties: Difficulty.values.toSet(),
    build: _floorValue,
  ),
  QuestionTemplate(
    id: 'floor.multiples',
    nodeId: 'gauss_floor',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _floorMultiples,
  ),
  QuestionTemplate(
    id: 'dio.exists',
    nodeId: 'diophantine',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _dioExists,
  ),
  QuestionTemplate(
    id: 'dio.positive',
    nodeId: 'diophantine',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _dioPositive,
  ),
  QuestionTemplate(
    id: 'binomial.pval',
    nodeId: 'base_binomial',
    difficulties: Difficulty.values.toSet(),
    build: _pValuation,
  ),
  QuestionTemplate(
    id: 'binomial.base',
    nodeId: 'base_binomial',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _baseConvert,
  ),
];

String _m(Object v) => mathInline(v);

/// A negative multiplier needs brackets: `8 \times (-1)`, never `8 \times -1`.
String _signed(int v) => v < 0 ? '($v)' : '$v';

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
  List<String> choices = const [],
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
    choices: choices,
    answerRange: answerRange,
  );
}

GeneratedQuestion _congJudge(int seed, Difficulty d) {
  final rng = Random(seed);
  final m = _rand(rng, 3, d == Difficulty.basic ? 9 : 16);
  final a = _rand(rng, d == Difficulty.basic ? 0 : -20, 40);
  final b = rng.nextBool()
      ? a + m * _rand(rng, -3, 3)
      : a + _rand(rng, 1, m - 1);
  final yes = NumberTheory.congruent(a, b, m);
  return _q(
    templateId: 'cong.judge',
    seed: seed,
    nodeId: 'congruence_def',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '判断：${_m('$a \\equiv $b \\pmod{$m}')} 是否成立？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: [
      '定义：${_m('a \\equiv b \\pmod{m}')} 当且仅当 ${_m('m \\mid (a-b)')}。',
      '计算 ${_m('$a - $b = ${a - b}')}，看能否被 ${_m(m)} 整除。',
    ],
    steps: [
      // Floor division, not truncation: for a negative difference
      // `-7 ~/ 5` is -1, which would print the false 「-7 = 5×(-1)+3」.
      '${_m('$a - $b = ${a - b}')}，${_m('${a - b} = $m \\times ${_signed(NumberTheory.floorDiv(a - b, m))} + ${(a - b) % m}')}。',
      yes ? '差能被模数整除，同余成立。' : '差不能被模数整除，同余不成立。',
    ],
    nodeRefs: ['congruence_def'],
  );
}

GeneratedQuestion _congResidue(int seed, Difficulty d) {
  final rng = Random(seed);
  final m = _rand(rng, 3, d == Difficulty.basic ? 10 : 18);
  final a = switch (d) {
    Difficulty.basic => _rand(rng, 0, 80),
    Difficulty.medium => _rand(rng, -40, 120),
    Difficulty.contest => _rand(rng, -200, 400),
  };
  final r = NumberTheory.mod(a, m);
  return _q(
    templateId: 'cong.residue',
    seed: seed,
    nodeId: 'congruence_def',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m(a)} 模 ${_m(m)} 的最小非负剩余。',
    answer: '$r',
    hints: [
      '最小非负剩余是满足 ${_m('$a \\equiv r \\pmod{$m}')} 且 ${_m('0 \\le r < $m')} 的那个 r。',
      '做带余除法，余数取在 ${_m('[0, $m)')}。',
    ],
    steps: [
      '${_m('$a = $m \\times ${NumberTheory.divMod(a, m).q} + $r')}。',
      '故最小非负剩余为 ${_m(r)}。',
    ],
    nodeRefs: ['congruence_def', 'division_algorithm'],
    answerRange: (min: 0, max: m - 1),
  );
}

GeneratedQuestion _congProduct(int seed, Difficulty d) {
  final rng = Random(seed);
  final m = _rand(rng, 4, d == Difficulty.basic ? 12 : 20);
  final a = _rand(rng, 2, d == Difficulty.basic ? 15 : 40);
  final b = _rand(rng, 2, d == Difficulty.basic ? 15 : 40);
  final ans = NumberTheory.mod(a * b, m);
  return _q(
    templateId: 'cong_ops.product',
    seed: seed,
    nodeId: 'congruence_ops',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('$a \\times $b')} 模 ${_m(m)} 的最小非负剩余。',
    answer: '$ans',
    hints: [
      '可以先各自取余再相乘：${_m('$a \\equiv ${NumberTheory.mod(a, m)}')}, ${_m('$b \\equiv ${NumberTheory.mod(b, m)} \\pmod{$m}')}。',
      '同余式两边可以同时乘同一个整数。',
    ],
    steps: [
      '${_m('$a \\equiv ${NumberTheory.mod(a, m)} \\pmod{$m}')}，${_m('$b \\equiv ${NumberTheory.mod(b, m)} \\pmod{$m}')}。',
      '${_m('${NumberTheory.mod(a, m)} \\times ${NumberTheory.mod(b, m)} = ${NumberTheory.mod(a, m) * NumberTheory.mod(b, m)} \\equiv $ans \\pmod{$m}')}。',
    ],
    nodeRefs: ['congruence_ops'],
    answerRange: (min: 0, max: m - 1),
  );
}

GeneratedQuestion _congCancel(int seed, Difficulty d) {
  final rng = Random(seed);
  // (a, b, m, d, keepModulus)
  final cases = [
    (6, 2, 4, 2, false),
    (15, 5, 10, 5, false),
    (15, 3, 4, 3, true),
    (14, 4, 5, 2, true),
    (12, 2, 5, 2, true),
    (21, 9, 6, 3, false),
  ];
  final c = cases[rng.nextInt(cases.length)];
  final yes = c.$5;
  return _q(
    templateId: 'cong_ops.cancel',
    seed: seed,
    nodeId: 'congruence_ops',
    difficulty: d,
    kind: QuestionKind.judge,
    stem:
        '已知 ${_m('${c.$1} \\equiv ${c.$2} \\pmod{${c.$3}}')}。判断：两边同除以 ${_m(c.$4)} 后，是否得到 ${_m('${c.$1 ~/ c.$4} \\equiv ${c.$2 ~/ c.$4} \\pmod{${c.$3}}')}？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: ['同余式两边除以 d 时，模数一般要同时除以 ${_m('\\gcd(d,m)')}。', '直接检验目标同余式是否成立。'],
    steps: [
      '目标式左右差为 ${_m('${c.$1 ~/ c.$4} - ${c.$2 ~/ c.$4} = ${(c.$1 - c.$2) ~/ c.$4}')}，模数仍是 ${_m(c.$3)}。',
      yes ? '目标同余式成立，这次约去是合法的。' : '目标同余式不成立。约去公因数时必须相应缩小模数。',
    ],
    nodeRefs: ['congruence_ops'],
  );
}

GeneratedQuestion _leastResidue(int seed, Difficulty d) {
  final rng = Random(seed);
  final m = _rand(rng, 4, d == Difficulty.basic ? 9 : 15);
  final q = _rand(rng, d == Difficulty.basic ? 1 : -4, 8);
  final r = _rand(rng, 0, m - 1);
  final a = q * m + r;
  return _q(
    templateId: 'residue.least',
    seed: seed,
    nodeId: 'complete_residue',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '在模 ${_m(m)} 的完全剩余系 ${_m('\\{0,1,\\ldots,${m - 1}\\}')} 中，与 ${_m(a)} 同余的代表元是多少？',
    answer: '$r',
    hints: ['完全剩余系里每个剩余类恰好出现一次。', '所求即 ${_m(a)} 的最小非负剩余。'],
    steps: ['${_m('$a = $m \\times $q + $r')}，故代表元为 ${_m(r)}。'],
    nodeRefs: ['complete_residue', 'congruence_def'],
    answerRange: (min: 0, max: m - 1),
  );
}

GeneratedQuestion _residueCount(int seed, Difficulty d) {
  final rng = Random(seed);
  final m = _rand(rng, 3, 8);
  final r = _rand(rng, 0, m - 1);
  final n = d == Difficulty.contest ? _rand(rng, 40, 80) : _rand(rng, 20, 40);
  final count = NumberTheory.residueInRange(
    modulus: m,
    residue: r,
    low: 1,
    high: n,
  );
  return _q(
    templateId: 'residue.count',
    seed: seed,
    nodeId: 'complete_residue',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '在 1, 2, …, ${_m(n)} 中，有多少个数满足 ${_m('x \\equiv $r \\pmod{$m}')}？',
    answer: '$count',
    hints: ['这些数构成公差为 ${_m(m)} 的等差数列。', '也可以用取整：从 1 到 n 数有多少个落在这个剩余类。'],
    steps: ['满足条件的个数为 ${_m(count)}。'],
    nodeRefs: ['complete_residue', 'gauss_floor'],
  );
}

GeneratedQuestion _bezoutExists(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 4, d == Difficulty.basic ? 12 : 24);
  final b = _rand(rng, 4, d == Difficulty.basic ? 12 : 24);
  final g = NumberTheory.gcd(a, b);
  final c = rng.nextBool()
      ? g * _rand(rng, 1, 4)
      : g * _rand(rng, 1, 4) + _rand(rng, 1, g);
  final yes = NumberTheory.divides(g, c);
  return _q(
    templateId: 'bezout.exists',
    seed: seed,
    nodeId: 'bezout',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '判断：方程 ${_m('$a x + $b y = $c')} 是否有整数解？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: [
      '裴蜀定理：${_m('ax+by=c')} 有整数解当且仅当 ${_m('\\gcd(a,b) \\mid c')}。',
      '${_m('\\gcd($a, $b) = $g')}。',
    ],
    steps: [
      '${_m('\\gcd($a, $b) = $g')}。',
      yes ? '${_m('$g \\mid $c')}，故有整数解。' : '${_m(g)} 不能整除 ${_m(c)}，无整数解。',
    ],
    nodeRefs: ['bezout', 'gcd'],
  );
}

GeneratedQuestion _bezoutCoeff(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = [6, 8, 9, 10, 12, 15][rng.nextInt(6)];
  final b = [4, 5, 7, 9, 14, 21][rng.nextInt(6)];
  final e = NumberTheory.egcd(a, b);
  final g = e.g;
  return _q(
    templateId: 'bezout.coeff',
    seed: seed,
    nodeId: 'bezout',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('\\gcd($a, $b)')}。裴蜀定理保证它能写成 ${_m('$a x + $b y')} 的形式。',
    answer: '$g',
    hints: ['先用欧几里得算法求最大公约数。', '倒代即可得到一组系数，本题只要求这个公约数。'],
    steps: [
      '${_m('$a \\cdot (${e.x}) + $b \\cdot (${e.y}) = $g')}。',
      '故 ${_m('\\gcd($a, $b) = $g')}。',
    ],
    nodeRefs: ['bezout', 'gcd'],
  );
}

const _smallPrimes = [3, 5, 7, 11, 13];

GeneratedQuestion _fermatAp(int seed, Difficulty d) {
  final rng = Random(seed);
  final p = _smallPrimes[rng.nextInt(_smallPrimes.length)];
  var a = _rand(rng, 2, d == Difficulty.basic ? 12 : 20);
  if (d == Difficulty.basic && a % p == 0) a += 1;
  final ans = NumberTheory.powMod(a, p, p);
  return _q(
    templateId: 'fermat.ap',
    seed: seed,
    nodeId: 'fermat',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('$a^{$p}')} 模 ${_m(p)} 的最小非负剩余。',
    answer: '$ans',
    hints: [
      '费马小定理的常用形式：${_m('a^p \\equiv a \\pmod{p}')}（p 为质数）。',
      '因此答案就是 ${_m(a)} 模 ${_m(p)}。',
    ],
    steps: [
      '${_m(p)} 是质数，故 ${_m('$a^{$p} \\equiv $a \\equiv $ans \\pmod{$p}')}。',
    ],
    nodeRefs: ['fermat'],
    answerRange: (min: 0, max: p - 1),
  );
}

GeneratedQuestion _fermatReduce(int seed, Difficulty d) {
  final rng = Random(seed);
  final p = [5, 7, 11, 13][rng.nextInt(4)];
  var a = _rand(rng, 2, p + 8);
  while (a % p == 0) {
    a = _rand(rng, 2, p + 8);
  }
  final exp = d == Difficulty.contest
      ? (p - 1) * _rand(rng, 2, 5) + _rand(rng, 0, p - 2)
      : (p - 1) + _rand(rng, 0, p - 2);
  final r = exp % (p - 1);
  final ans = NumberTheory.powMod(a, exp, p);
  return _q(
    templateId: 'fermat.reduce',
    seed: seed,
    nodeId: 'fermat',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('$a^{$exp}')} 模 ${_m(p)} 的最小非负剩余。',
    answer: '$ans',
    hints: [
      '${_m(p)} 是质数且 ${_m('$p \\nmid $a')}，故 ${_m('$a^{${p - 1}} \\equiv 1 \\pmod{$p}')}。',
      '把指数写成 ${_m('$exp = ${p - 1} \\cdot ${exp ~/ (p - 1)} + $r')}。',
    ],
    steps: [
      '${_m('$a^{$exp} = ($a^{${p - 1}})^{${exp ~/ (p - 1)}} \\cdot $a^{$r} \\equiv $a^{$r} \\equiv $ans \\pmod{$p}')}。',
    ],
    nodeRefs: ['fermat', 'congruence_ops'],
    answerRange: (min: 0, max: p - 1),
  );
}

GeneratedQuestion _wilsonValue(int seed, Difficulty d) {
  final rng = Random(seed);
  final p = d == Difficulty.contest
      ? [11, 13][rng.nextInt(2)]
      : _smallPrimes[rng.nextInt(3)];
  final ans = NumberTheory.mod(NumberTheory.factorial(p - 1), p);
  return _q(
    templateId: 'wilson.value',
    seed: seed,
    nodeId: 'wilson',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('${p - 1}!')} 模 ${_m(p)} 的最小非负剩余。',
    answer: '$ans',
    hints: [
      '威尔逊定理：质数 p 满足 ${_m('(p-1)! \\equiv -1 \\pmod{p}')}。',
      '${_m('-1')} 模 ${_m(p)} 的最小非负剩余是 ${_m(p - 1)}。',
    ],
    steps: [
      '${_m(p)} 是质数，故 ${_m('${p - 1}! \\equiv -1 \\equiv $ans \\pmod{$p}')}。',
    ],
    nodeRefs: ['wilson'],
    answerRange: (min: 0, max: p - 1),
  );
}

GeneratedQuestion _wilsonJudge(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [4, 5, 6, 7, 8, 9, 11][rng.nextInt(7)];
  final value = NumberTheory.mod(NumberTheory.factorial(n - 1), n);
  final yes = NumberTheory.congruent(value, -1, n);
  return _q(
    templateId: 'wilson.judge',
    seed: seed,
    nodeId: 'wilson',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '判断：${_m(n)} 是否满足 ${_m('(n-1)! \\equiv -1 \\pmod{n}')}？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: ['威尔逊定理：该式成立当且仅当 n 是质数（n ≥ 2）。', '也可直接算 ${_m('${n - 1}!')} 再取模。'],
    steps: [
      '${_m('${n - 1}! \\equiv $value \\pmod{$n}')}，而 ${_m('-1 \\equiv ${n - 1} \\pmod{$n}')}。',
      yes ? '${_m(n)} 是质数，成立。' : '${_m(n)} 不是质数，不成立。',
    ],
    nodeRefs: ['wilson', 'primes_composites'],
  );
}

GeneratedQuestion _eulerPhi(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = switch (d) {
    Difficulty.basic => [6, 8, 9, 10, 12, 14][rng.nextInt(6)],
    Difficulty.medium => [15, 16, 18, 20, 21, 24][rng.nextInt(6)],
    Difficulty.contest => [25, 27, 28, 30, 32, 36][rng.nextInt(6)],
  };
  final ans = NumberTheory.phi(n);
  final factors = NumberTheory.formatFactorization(NumberTheory.factorize(n));
  return _q(
    templateId: 'euler.phi',
    seed: seed,
    nodeId: 'euler',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求欧拉函数 ${_m('\\varphi($n)')}。',
    answer: '$ans',
    hints: [
      '若 ${_m('n = \\prod p^e')}，则 ${_m('\\varphi(n) = n \\prod_{p\\mid n} (1-1/p)')}。',
      '${_m('$n = $factors')}。',
    ],
    steps: [
      '${_m('$n = $factors')}。',
      '${_m('\\varphi($n) = $ans')}，即 1 到 ${_m(n)} 中与 ${_m(n)} 互质的个数。',
    ],
    nodeRefs: ['euler', 'coprime'],
  );
}

GeneratedQuestion _eulerPower(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [8, 9, 10, 12, 14, 15][rng.nextInt(6)];
  final coprime = <int>[
    for (var t = 2; t < n + 8; t++)
      if (NumberTheory.isCoprime(t, n)) t,
  ];
  final a = coprime[rng.nextInt(coprime.length)];
  final phi = NumberTheory.phi(n);
  // a^φ(n) is 1 every time, so the answer can be given without the theorem.
  // One extra factor of a keeps Euler's theorem as the step that matters.
  final exp = phi + 1;
  final ans = NumberTheory.powMod(a, exp, n);
  return _q(
    templateId: 'euler.power',
    seed: seed,
    nodeId: 'euler',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '已知 ${_m('\\gcd($a, $n) = 1')}。求 ${_m('$a^{\\varphi($n) + 1}')} 模 ${_m(n)} 的最小非负剩余。',
    answer: '$ans',
    hints: [
      '欧拉定理：${_m('a^{\\varphi(n)} \\equiv 1 \\pmod{n}')}（当 ${_m('\\gcd(a,n)=1')}）。',
      '${_m('\\varphi($n) = $phi')}。',
    ],
    steps: [
      '由欧拉定理，${_m('$a^{$phi} \\equiv 1 \\pmod{$n}')}。',
      '再乘一个 ${_m(a)}：${_m('$a^{$exp} \\equiv $a \\equiv $ans \\pmod{$n}')}。',
    ],
    nodeRefs: ['euler'],
    answerRange: (min: 0, max: n - 1),
  );
}

const _crtPairs = [(3, 4), (3, 5), (4, 5), (3, 7), (5, 8), (5, 9), (4, 7)];

GeneratedQuestion _crtTwo(int seed, Difficulty d) {
  final rng = Random(seed);
  final pair = _crtPairs[rng.nextInt(_crtPairs.length)];
  final m1 = pair.$1;
  final m2 = pair.$2;
  final a1 = _rand(rng, 0, m1 - 1);
  final a2 = _rand(rng, 0, m2 - 1);
  final ans = NumberTheory.crt2(a1, m1, a2, m2)!;
  final m = m1 * m2;
  return _q(
    templateId: 'crt.two',
    seed: seed,
    nodeId: 'crt',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '解同余方程组 ${_m('x \\equiv $a1 \\pmod{$m1}')}，${_m('x \\equiv $a2 \\pmod{$m2}')}。把解写成模 ${_m(m)} 的最小非负剩余。',
    answer: '$ans',
    hints: [
      '${_m(m1)} 与 ${_m(m2)} 互质，解在模 ${_m(m)} 下唯一。',
      '令 ${_m('x = $a1 + $m1 k')}，代入第二个同余式求 k。',
    ],
    steps: ['解为 ${_m('x \\equiv $ans \\pmod{$m}')}。'],
    nodeRefs: ['crt', 'congruence_ops'],
    answerRange: (min: 0, max: m - 1),
  );
}

GeneratedQuestion _crtConstruct(int seed, Difficulty d) {
  final rng = Random(seed);
  final a1 = _rand(rng, 0, 2);
  final a2 = _rand(rng, 0, 4);
  const m1 = 3;
  const m2 = 5;
  final ans = NumberTheory.crt2(a1, m1, a2, m2)!;
  return _q(
    templateId: 'crt.construct',
    seed: seed,
    nodeId: 'crt',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '用构造法解 ${_m('x \\equiv $a1 \\pmod{3}')}，${_m('x \\equiv $a2 \\pmod{5}')}。${_m('M=15')}，${_m('M_1=5')}，${_m('M_2=3')}。答案写最小非负剩余。',
    answer: '$ans',
    hints: [
      '先求 ${_m('5 y_1 \\equiv 1 \\pmod{3}')}，${_m('3 y_2 \\equiv 1 \\pmod{5}')}。',
      '然后 ${_m('x = $a1 \\cdot 5 \\cdot y_1 + $a2 \\cdot 3 \\cdot y_2')}，再模 15。',
    ],
    steps: [
      '${_m('5 \\equiv 2 \\pmod{3}')}，${_m('2 y_1 \\equiv 1 \\pmod{3}')}，故 ${_m('y_1 \\equiv 2')}。',
      '${_m('3 y_2 \\equiv 1 \\pmod{5}')}，故 ${_m('y_2 \\equiv 2')}。',
      '${_m('x \\equiv $ans \\pmod{15}')}。',
    ],
    nodeRefs: ['crt'],
    answerRange: (min: 0, max: 14),
  );
}

GeneratedQuestion _floorValue(int seed, Difficulty d) {
  final rng = Random(seed);
  final b = _rand(rng, 2, d == Difficulty.basic ? 9 : 14);
  final a = switch (d) {
    Difficulty.basic => _rand(rng, 0, 80),
    Difficulty.medium => _rand(rng, -20, 80),
    Difficulty.contest => _rand(rng, -40, 120),
  };
  final ans = NumberTheory.floorDiv(a, b);
  return _q(
    templateId: 'floor.value',
    seed: seed,
    nodeId: 'gauss_floor',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('\\lfloor $a / $b \\rfloor')}。',
    answer: '$ans',
    hints: [
      '高斯函数 ${_m('\\lfloor x \\rfloor')} 是不超过 x 的最大整数。',
      if (a < 0) '注意负数：向小的方向取整，不是截断小数。',
    ],
    steps: [
      if (a % b == 0)
        '${_m('$a / $b = $ans')} 本身就是整数，取整后不变。'
      else
        '${_m('$a / $b')} 落在 ${_m(ans)} 与 ${_m(ans + 1)} 之间，向下取整得 ${_m(ans)}。',
    ],
    nodeRefs: ['gauss_floor'],
  );
}

GeneratedQuestion _floorMultiples(int seed, Difficulty d) {
  final rng = Random(seed);
  final m = _rand(rng, 2, 9);
  final n = _rand(
    rng,
    d == Difficulty.basic ? 12 : 20,
    d == Difficulty.basic ? 40 : 80,
  );
  final ans = NumberTheory.floorDiv(n, m);
  return _q(
    templateId: 'floor.multiples',
    seed: seed,
    nodeId: 'gauss_floor',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '在 1, 2, …, ${_m(n)} 中，有多少个 ${_m(m)} 的倍数？',
    answer: '$ans',
    hints: [
      '个数等于 ${_m('\\lfloor n/m \\rfloor')}。',
      '最大的不超过 ${_m(n)} 的倍数是 ${_m(m)} 乘这个商。',
    ],
    steps: ['${_m('\\lfloor $n / $m \\rfloor = $ans')}。'],
    nodeRefs: ['gauss_floor', 'division_algorithm'],
  );
}

GeneratedQuestion _dioExists(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 3, 12);
  final b = _rand(rng, 3, 12);
  final g = NumberTheory.gcd(a, b);
  final c = rng.nextBool() ? g * _rand(rng, 1, 5) : g * _rand(rng, 1, 5) + 1;
  final yes = NumberTheory.divides(g, c);
  return _q(
    templateId: 'dio.exists',
    seed: seed,
    nodeId: 'diophantine',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '判断：不定方程 ${_m('$a x + $b y = $c')} 是否有整数解？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: ['线性不定方程有解的充要条件是公约数整除常数项。', '${_m('\\gcd($a, $b) = $g')}。'],
    steps: [yes ? '${_m('$g \\mid $c')}，有解。' : '${_m(g)} 不整除 ${_m(c)}，无解。'],
    nodeRefs: ['diophantine', 'bezout'],
  );
}

GeneratedQuestion _dioPositive(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = [2, 3, 4, 5][rng.nextInt(4)];
  var b = [3, 4, 5, 6][rng.nextInt(4)];
  if (b == a) b += 1;
  final x0 = _rand(rng, 1, 4);
  final y0 = _rand(rng, 1, 4);
  final c = a * x0 + b * y0;
  final ans = NumberTheory.positiveSolutionCount(a, b, c);
  return _q(
    templateId: 'dio.positive',
    seed: seed,
    nodeId: 'diophantine',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '方程 ${_m('$a x + $b y = $c')} 有多少组正整数解 ${_m('(x,y)')}（${_m('x>0,\\, y>0')}）？',
    answer: '$ans',
    hints: [
      '先求一组特解，通解为 ${_m('x = x_0 + (b/d)t')}，${_m('y = y_0 - (a/d)t')}，其中 ${_m('d=\\gcd(a,b)')}。',
      '再找使 x、y 都为正的整数 t。',
    ],
    steps: ['正整数解的组数为 ${_m(ans)}。'],
    nodeRefs: ['diophantine', 'bezout'],
  );
}

GeneratedQuestion _pValuation(int seed, Difficulty d) {
  final rng = Random(seed);
  final p = [2, 3, 5][rng.nextInt(3)];
  final n = switch (d) {
    Difficulty.basic => [6, 8, 10, 12][rng.nextInt(4)],
    Difficulty.medium => [15, 20, 25, 30][rng.nextInt(4)],
    Difficulty.contest => [50, 80, 100][rng.nextInt(3)],
  };
  final ans = NumberTheory.factorialValuation(n, p);
  return _q(
    templateId: 'binomial.pval',
    seed: seed,
    nodeId: 'base_binomial',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('$n!')} 的标准分解中质因数 ${_m(p)} 的指数。',
    answer: '$ans',
    hints: [
      '勒让德公式：指数为 ${_m('\\lfloor n/p \\rfloor + \\lfloor n/p^2 \\rfloor + \\cdots')}。',
      '不要只算 ${_m('\\lfloor n/p \\rfloor')}。',
    ],
    steps: ['按 ${_m(p)} 的方幂累加取整，得到 ${_m(ans)}。'],
    nodeRefs: ['base_binomial', 'gauss_floor', 'fta'],
  );
}

GeneratedQuestion _baseConvert(int seed, Difficulty d) {
  final rng = Random(seed);
  final base = d == Difficulty.contest
      ? [2, 3, 8][rng.nextInt(3)]
      : [2, 8][rng.nextInt(2)];
  final n = _rand(
    rng,
    d == Difficulty.basic ? 8 : 16,
    d == Difficulty.contest ? 80 : 40,
  );
  final digits = <int>[];
  var x = n;
  while (x > 0) {
    digits.add(x % base);
    x ~/= base;
  }
  final shown = digits.reversed.join();
  return _q(
    templateId: 'binomial.base',
    choices: _baseChoices(n, base),
    seed: seed,
    nodeId: 'base_binomial',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '把十进制数 ${_m(n)} 写成 ${_m(base)} 进制。只写数字串，不要写下标。',
    answer: shown,
    hints: ['反复除以 ${_m(base)}，余数从低位到高位。', '最后把余数倒序写出。'],
    steps: ['${_m(n)} 的 ${_m(base)} 进制是 ${_m(shown)}。'],
    nodeRefs: ['base_binomial', 'division_algorithm'],
  );
}

/// Distractors for a base-[base] numeral. They have to be numerals in that
/// base — a `5` inside a binary string is not a wrong answer, it is a typo.
/// The errors worth offering: the neighbouring value, a dropped or doubled
/// trailing digit, and the digits read back to front.
List<String> _baseChoices(int n, int base) {
  String render(int v) {
    if (v <= 0) return '';
    final digits = <int>[];
    var x = v;
    while (x > 0) {
      digits.add(x % base);
      x ~/= base;
    }
    return digits.reversed.join();
  }

  final shown = render(n);
  final reversed = shown.split('').reversed.join();
  return [
    render(n + 1),
    render(n - 1),
    render(n * base), // a stray trailing zero
    render(n ~/ base), // one division too many
    if (reversed != shown && !reversed.startsWith('0')) reversed,
    render(n + base),
  ].where((e) => e.isNotEmpty).toList();
}
