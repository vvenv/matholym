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

/// Remaining elementary / junior-high olympiad models.
final List<QuestionTemplate> syllabusTemplates = [
  QuestionTemplate(
    id: 'fracof.part',
    nodeId: 'frac_of',
    difficulties: Difficulty.values.toSet(),
    build: _fracOfPart,
  ),
  QuestionTemplate(
    id: 'fracof.whole',
    nodeId: 'frac_of',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _fracOfWhole,
  ),
  QuestionTemplate(
    id: 'gauss.n',
    nodeId: 'gauss_sum',
    difficulties: Difficulty.values.toSet(),
    build: _gaussN,
  ),
  QuestionTemplate(
    id: 'gauss.range',
    nodeId: 'gauss_sum',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _gaussRange,
  ),
  QuestionTemplate(
    id: 'est.add',
    nodeId: 'est_round',
    difficulties: Difficulty.values.toSet(),
    build: _estAdd,
  ),
  QuestionTemplate(
    id: 'est.mul',
    nodeId: 'est_round',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _estMul,
  ),
  QuestionTemplate(
    id: 'pow.val',
    nodeId: 'pow_value',
    difficulties: Difficulty.values.toSet(),
    build: _powVal,
  ),
  QuestionTemplate(
    id: 'pow.same',
    nodeId: 'pow_value',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _powSame,
  ),
  QuestionTemplate(
    id: 'odd.sum',
    nodeId: 'odd_square_sum',
    difficulties: Difficulty.values.toSet(),
    build: _oddSum,
  ),
  QuestionTemplate(
    id: 'odd.which',
    nodeId: 'odd_square_sum',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _oddWhich,
  ),
  QuestionTemplate(
    id: 'boat.down',
    nodeId: 'stream_boat',
    difficulties: Difficulty.values.toSet(),
    build: _boatDown,
  ),
  QuestionTemplate(
    id: 'boat.up',
    nodeId: 'stream_boat',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _boatUp,
  ),
  QuestionTemplate(
    id: 'train.time',
    nodeId: 'train_bridge',
    difficulties: Difficulty.values.toSet(),
    build: _trainTime,
  ),
  QuestionTemplate(
    id: 'train.len',
    nodeId: 'train_bridge',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _trainLen,
  ),
  QuestionTemplate(
    id: 'geo.term',
    nodeId: 'geo_seq',
    difficulties: Difficulty.values.toSet(),
    build: _geoTerm,
  ),
  QuestionTemplate(
    id: 'geo.ratio',
    nodeId: 'geo_seq',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _geoRatio,
  ),
  QuestionTemplate(
    id: 'loop.meet',
    nodeId: 'track_loop',
    difficulties: Difficulty.values.toSet(),
    build: _loopMeet,
  ),
  QuestionTemplate(
    id: 'loop.lap',
    nodeId: 'track_loop',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _loopLap,
  ),
  QuestionTemplate(
    id: 'sale.price',
    nodeId: 'percent_app',
    difficulties: Difficulty.values.toSet(),
    build: _salePrice,
  ),
  QuestionTemplate(
    id: 'sale.profit',
    nodeId: 'percent_app',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _saleProfit,
  ),
  QuestionTemplate(
    id: 'sys.x',
    nodeId: 'linear_sys',
    difficulties: Difficulty.values.toSet(),
    build: _sysX,
  ),
  QuestionTemplate(
    id: 'sys.y',
    nodeId: 'linear_sys',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _sysY,
  ),
  QuestionTemplate(
    id: 'poly.in',
    nodeId: 'poly_angle',
    difficulties: Difficulty.values.toSet(),
    build: _polyIn,
  ),
  QuestionTemplate(
    id: 'poly.ex',
    nodeId: 'poly_angle',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _polyEx,
  ),
  QuestionTemplate(
    id: 'sec.arc',
    nodeId: 'sector_arc',
    difficulties: Difficulty.values.toSet(),
    build: _secArc,
  ),
  QuestionTemplate(
    id: 'sec.area',
    nodeId: 'sector_arc',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _secArea,
  ),
  QuestionTemplate(
    id: 'sym.x',
    nodeId: 'symmetry',
    difficulties: Difficulty.values.toSet(),
    build: _symX,
  ),
  QuestionTemplate(
    id: 'sym.origin',
    nodeId: 'symmetry',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _symOrigin,
  ),
  QuestionTemplate(
    id: 'net.area',
    nodeId: 'net_solid',
    difficulties: Difficulty.values.toSet(),
    build: _netArea,
  ),
  QuestionTemplate(
    id: 'net.faces',
    nodeId: 'net_solid',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _netFaces,
  ),
  QuestionTemplate(
    id: 'refl.len',
    nodeId: 'reflect_path',
    difficulties: Difficulty.values.toSet(),
    build: _reflLen,
  ),
  QuestionTemplate(
    id: 'refl.rise',
    nodeId: 'reflect_path',
    difficulties: Difficulty.values.toSet(),
    build: _reflRise,
  ),
  QuestionTemplate(
    id: 'sph.vol',
    nodeId: 'sphere_vol',
    difficulties: Difficulty.values.toSet(),
    build: _sphVol,
  ),
  QuestionTemplate(
    id: 'sph.surf',
    nodeId: 'sphere_vol',
    difficulties: Difficulty.values.toSet(),
    build: _sphSurf,
  ),
  QuestionTemplate(
    id: 'cperm.n',
    nodeId: 'circle_perm',
    difficulties: Difficulty.values.toSet(),
    build: _cpermN,
  ),
  QuestionTemplate(
    id: 'cperm.bead',
    nodeId: 'circle_perm',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _cpermBead,
  ),
  QuestionTemplate(
    id: 'rperm.one',
    nodeId: 'repeat_perm',
    difficulties: Difficulty.values.toSet(),
    build: _rpermOne,
  ),
  QuestionTemplate(
    id: 'rperm.word',
    nodeId: 'repeat_perm',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _rpermWord,
  ),
  QuestionTemplate(
    id: 'sb.zero',
    nodeId: 'stars_bars',
    difficulties: Difficulty.values.toSet(),
    build: _sbZero,
  ),
  QuestionTemplate(
    id: 'sb.pos',
    nodeId: 'stars_bars',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _sbPos,
  ),
  QuestionTemplate(
    id: 'inc3.union',
    nodeId: 'incl3',
    difficulties: Difficulty.values.toSet(),
    build: _inc3Union,
  ),
  QuestionTemplate(
    id: 'inc3.only',
    nodeId: 'incl3',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _inc3Only,
  ),
  QuestionTemplate(
    id: 'der.n',
    nodeId: 'derange',
    difficulties: Difficulty.values.toSet(),
    build: _derN,
  ),
  QuestionTemplate(
    id: 'der.hat',
    nodeId: 'derange',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _derHat,
  ),
  QuestionTemplate(
    id: 'nim.take',
    nodeId: 'nim_take',
    difficulties: Difficulty.values.toSet(),
    build: _nimTake,
  ),
  QuestionTemplate(
    id: 'nim.lose',
    nodeId: 'nim_take',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _nimLose,
  ),
  QuestionTemplate(
    id: 'sch.min',
    nodeId: 'schedule',
    difficulties: Difficulty.values.toSet(),
    build: _schMin,
  ),
  QuestionTemplate(
    id: 'sch.who',
    nodeId: 'schedule',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _schWho,
  ),
  QuestionTemplate(
    id: 'que.wait',
    nodeId: 'queue_wait',
    difficulties: Difficulty.values.toSet(),
    build: _queWait,
  ),
  QuestionTemplate(
    id: 'que.self',
    nodeId: 'queue_wait',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _queSelf,
  ),
  QuestionTemplate(
    id: 'cut.pcs',
    nodeId: 'cut_rope',
    difficulties: Difficulty.values.toSet(),
    build: _cutPcs,
  ),
  QuestionTemplate(
    id: 'cut.n',
    nodeId: 'cut_rope',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _cutN,
  ),
  QuestionTemplate(
    id: 'load.max',
    nodeId: 'load_pack',
    difficulties: Difficulty.values.toSet(),
    build: _loadMax,
  ),
  QuestionTemplate(
    id: 'load.left',
    nodeId: 'load_pack',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _loadLeft,
  ),
  QuestionTemplate(
    id: 'sq.judge',
    nodeId: 'perfect_square',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _sqJudge,
  ),
  QuestionTemplate(
    id: 'sq.count',
    nodeId: 'perfect_square',
    difficulties: Difficulty.values.toSet(),
    build: _sqCount,
  ),
  QuestionTemplate(
    id: 'end.judge',
    nodeId: 'square_end',
    difficulties: Difficulty.values.toSet(),
    build: _endJudge,
  ),
  QuestionTemplate(
    id: 'end.list',
    nodeId: 'square_end',
    difficulties: Difficulty.values.toSet(),
    build: _endList,
  ),
  QuestionTemplate(
    id: 'plast.val',
    nodeId: 'power_last',
    difficulties: Difficulty.values.toSet(),
    build: _plastVal,
  ),
  QuestionTemplate(
    id: 'plast.cyc',
    nodeId: 'power_last',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _plastCyc,
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

GeneratedQuestion _fracOfPart(int seed, Difficulty d) {
  final rng = Random(seed);
  final den = [2, 3, 4, 5, 8][rng.nextInt(5)];
  final num = _rand(rng, 1, den - 1);
  final unit = _rand(rng, 3, 12);
  final total = unit * den;
  final ans = Calculation.fracOf(total: total, num: num, den: den);
  return _q(
    templateId: 'fracof.part',
    seed: seed,
    nodeId: 'frac_of',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m(total)} 的 ${_m('\\frac{$num}{$den}')} 是多少。',
    answer: '$ans',
    hints: ['先求 ${_m('1/$den')}，再乘 ${_m(num)}。'],
    steps: ['${_m('$total \\times $num / $den = $ans')}。'],
    nodeRefs: ['frac_of'],
  );
}

GeneratedQuestion _fracOfWhole(int seed, Difficulty d) {
  final rng = Random(seed);
  final den = [2, 3, 4, 5][rng.nextInt(4)];
  final num = _rand(rng, 1, den - 1);
  final unit = _rand(rng, 4, 10);
  final part = unit * num;
  final whole = Calculation.fromFracOf(part: part, num: num, den: den);
  return _q(
    templateId: 'fracof.whole',
    seed: seed,
    nodeId: 'frac_of',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '一个数的 ${_m('\\frac{$num}{$den}')} 是 ${_m(part)}。这个数是多少？',
    answer: '$whole',
    hints: ['${_m('$part \\div $num')} 是一份，再乘 ${_m(den)}。'],
    steps: ['这个数是 ${_m(whole)}。'],
    nodeRefs: ['frac_of'],
  );
}

GeneratedQuestion _gaussN(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = switch (d) {
    Difficulty.basic => _rand(rng, 8, 20),
    Difficulty.medium => _rand(rng, 20, 50),
    Difficulty.contest => [100, 80, 99, 64][rng.nextInt(4)],
  };
  final ans = Calculation.gaussSum(n);
  return _q(
    templateId: 'gauss.n',
    seed: seed,
    nodeId: 'gauss_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('1+2+\\cdots+$n')}。',
    answer: '$ans',
    hints: ['${_m('S = n(n+1)/2')}。'],
    steps: ['${_m('$n \\times ${n + 1} / 2 = $ans')}。'],
    nodeRefs: ['gauss_sum'],
  );
}

GeneratedQuestion _gaussRange(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 5, 12);
  final b = a + _rand(rng, 5, 15);
  final ans = Calculation.gaussSum(b) - Calculation.gaussSum(a - 1);
  return _q(
    templateId: 'gauss.range',
    seed: seed,
    nodeId: 'gauss_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('$a + ${a + 1} + \\cdots + $b')}。',
    answer: '$ans',
    hints: ['用 ${_m('1+\\cdots+$b')} 减去 ${_m('1+\\cdots+${a - 1}')}。'],
    steps: ['和是 ${_m(ans)}。'],
    nodeRefs: ['gauss_sum'],
  );
}

GeneratedQuestion _estAdd(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 210, 890);
  final b = _rand(rng, 210, 890);
  final ans =
      Calculation.roundTo(value: a, place: 100) +
      Calculation.roundTo(value: b, place: 100);
  return _q(
    templateId: 'est.add',
    seed: seed,
    nodeId: 'est_round',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '把 ${_m(a)} 和 ${_m(b)} 都估成整百再相加。估算的和是多少？',
    answer: '$ans',
    hints: ['${_m(a)} 估成 ${_m(Calculation.roundTo(value: a, place: 100))}。'],
    steps: ['估算和是 ${_m(ans)}。'],
    nodeRefs: ['est_round'],
  );
}

GeneratedQuestion _estMul(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = [19, 21, 29, 31, 39, 41][rng.nextInt(6)];
  final b = [19, 21, 29, 31][rng.nextInt(4)];
  final ra = Calculation.roundTo(value: a, place: 10);
  final rb = Calculation.roundTo(value: b, place: 10);
  return _q(
    templateId: 'est.mul',
    seed: seed,
    nodeId: 'est_round',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '估算 ${_m('$a \\times $b')}：两因数都估成整十再乘。',
    answer: '${ra * rb}',
    hints: ['${_m('$a \\approx $ra')}，${_m('$b \\approx $rb')}。'],
    steps: ['${_m('$ra \\times $rb = ${ra * rb}')}。'],
    nodeRefs: ['est_round'],
  );
}

GeneratedQuestion _powVal(int seed, Difficulty d) {
  final rng = Random(seed);
  final pairs = [(2, 5), (2, 6), (3, 4), (4, 3), (5, 3), (6, 3), (2, 8)];
  final p = pairs[rng.nextInt(pairs.length)];
  final ans = Calculation.powInt(p.$1, p.$2);
  return _q(
    templateId: 'pow.val',
    seed: seed,
    nodeId: 'pow_value',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '计算 ${_m('${p.$1}^{${p.$2}}')}。',
    answer: '$ans',
    hints: ['乘方是相同因数连乘 ${_m(p.$2)} 次。'],
    steps: ['${_m('${p.$1}^{${p.$2}} = $ans')}。'],
    nodeRefs: ['pow_value'],
  );
}

GeneratedQuestion _powSame(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 5);
  final n = _rand(rng, 3, 5);
  final ans = Calculation.powInt(a, n);
  return _q(
    templateId: 'pow.same',
    seed: seed,
    nodeId: 'pow_value',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 个 ${_m(a)} 相乘，结果是多少？',
    answer: '$ans',
    hints: ['就是 ${_m('$a^{$n}')}。'],
    steps: ['结果是 ${_m(ans)}。'],
    nodeRefs: ['pow_value'],
  );
}

GeneratedQuestion _oddSum(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, d == Difficulty.contest ? 15 : 10);
  final last = 2 * n - 1;
  final ans = Calculation.oddSum(n);
  return _q(
    templateId: 'odd.sum',
    seed: seed,
    nodeId: 'odd_square_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求 ${_m('1+3+5+\\cdots+$last')}。',
    answer: '$ans',
    hints: ['前 ${_m(n)} 个奇数的和等于 ${_m('$n^2')}。'],
    steps: ['${_m('$n^2 = $ans')}。'],
    nodeRefs: ['odd_square_sum'],
  );
}

GeneratedQuestion _oddWhich(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 5, 12);
  return _q(
    templateId: 'odd.which',
    seed: seed,
    nodeId: 'odd_square_sum',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('1+3+\\cdots')} 一直加到和等于 ${_m(n * n)}。最后一项是多少？',
    answer: '${2 * n - 1}',
    hints: ['和是 ${_m('$n^2')}，共 ${_m(n)} 个奇数，最后一项 ${_m('2n-1')}。'],
    steps: ['最后一项是 ${_m(2 * n - 1)}。'],
    nodeRefs: ['odd_square_sum'],
  );
}

GeneratedQuestion _boatDown(int seed, Difficulty d) {
  final rng = Random(seed);
  final still = _rand(rng, 6, 12);
  final current = _rand(rng, 1, still - 3);
  final hours = _rand(rng, 2, 6);
  final dist = (still + current) * hours;
  return _q(
    templateId: 'boat.down',
    seed: seed,
    nodeId: 'stream_boat',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '船在静水时速 ${_m(still)} 千米，水流时速 ${_m(current)} 千米。顺水走 ${_m(dist)} 千米要几小时？',
    answer: '$hours',
    hints: ['顺水速度 ${_m(still + current)}。'],
    steps: ['${_m('$dist / ${still + current} = $hours')} 小时。'],
    nodeRefs: ['stream_boat', 'travel'],
  );
}

GeneratedQuestion _boatUp(int seed, Difficulty d) {
  final rng = Random(seed);
  final still = _rand(rng, 8, 14);
  final current = _rand(rng, 1, 4);
  final hours = _rand(rng, 2, 5);
  final dist = (still - current) * hours;
  return _q(
    templateId: 'boat.up',
    seed: seed,
    nodeId: 'stream_boat',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '静水 ${_m(still)} 千米/时，水流 ${_m(current)} 千米/时。逆水 ${_m(dist)} 千米要几小时？',
    answer: '$hours',
    hints: ['逆水速度 ${_m(still - current)}。'],
    steps: ['${_m(hours)} 小时。'],
    nodeRefs: ['stream_boat'],
  );
}

GeneratedQuestion _trainTime(int seed, Difficulty d) {
  final rng = Random(seed);
  final speed = [40, 50, 60, 80][rng.nextInt(4)];
  final hours = _rand(rng, 2, 5);
  final train = speed * _rand(rng, 1, 3);
  final bridge = speed * hours - train;
  if (bridge <= 0) return _trainTime(seed + 1, d);
  return _q(
    templateId: 'train.time',
    seed: seed,
    nodeId: 'train_bridge',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '火车长 ${_m(train)} 米，桥长 ${_m(bridge)} 米，时速 ${_m(speed)} 米。过桥要多少时间单位？',
    answer: '$hours',
    hints: ['过桥路程是车长加桥长。'],
    steps: ['${_m('${train + bridge} / $speed = $hours')}。'],
    nodeRefs: ['train_bridge'],
  );
}

GeneratedQuestion _trainLen(int seed, Difficulty d) {
  final rng = Random(seed);
  final speed = 50;
  final hours = _rand(rng, 2, 4);
  final bridge = 100 * _rand(rng, 1, 3);
  final train = speed * hours - bridge;
  if (train <= 0) return _trainTime(seed, d);
  return _q(
    templateId: 'train.len',
    seed: seed,
    nodeId: 'train_bridge',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '火车时速 ${_m(speed)} 米，过 ${_m(bridge)} 米的桥用 ${_m(hours)} 个时间单位。火车长多少米？',
    answer: '$train',
    hints: ['${_m('车长 + 桥长 = 速度 \\times 时间')}。'],
    steps: ['车长 ${_m(train)} 米。'],
    nodeRefs: ['train_bridge'],
  );
}

GeneratedQuestion _geoTerm(int seed, Difficulty d) {
  final rng = Random(seed);
  final a1 = _rand(rng, 1, 4);
  final q = [2, 3][rng.nextInt(2)];
  final n = _rand(rng, 3, 6);
  final ans = Algebra.geoTerm(a1, q, n);
  return _q(
    templateId: 'geo.term',
    seed: seed,
    nodeId: 'geo_seq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '等比数列 ${_m('a_1=$a1')}，公比 ${_m(q)}。求 ${_m('a_{$n}')}。',
    answer: '$ans',
    hints: ['${_m('a_n = a_1 q^{n-1}')}。'],
    steps: ['${_m('a_{$n} = $ans')}。'],
    nodeRefs: ['geo_seq'],
  );
}

GeneratedQuestion _geoRatio(int seed, Difficulty d) {
  final rng = Random(seed);
  final q = [2, 3, 4][rng.nextInt(3)];
  final a1 = _rand(rng, 2, 6);
  final a2 = a1 * q;
  return _q(
    templateId: 'geo.ratio',
    seed: seed,
    nodeId: 'geo_seq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '等比数列前两项是 ${_m(a1)}、${_m(a2)}。公比是多少？',
    answer: '$q',
    hints: ['后项除以前项。'],
    steps: ['${_m('$a2 / $a1 = $q')}。'],
    nodeRefs: ['geo_seq'],
  );
}

GeneratedQuestion _loopMeet(int seed, Difficulty d) {
  final rng = Random(seed);
  final v1 = _rand(rng, 4, 10);
  final v2 = _rand(rng, 3, 8);
  final hours = _rand(rng, 2, 6);
  final circ = (v1 + v2) * hours;
  return _q(
    templateId: 'loop.meet',
    seed: seed,
    nodeId: 'track_loop',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '环形跑道 ${_m(circ)} 米，两人相向跑，时速 ${_m(v1)} 与 ${_m(v2)} 米。多少时间单位后相遇？',
    answer: '$hours',
    hints: ['相对速度是速度和，路程是一圈。'],
    steps: ['${_m('$circ / ${v1 + v2} = $hours')}。'],
    nodeRefs: ['track_loop', 'travel'],
  );
}

GeneratedQuestion _loopLap(int seed, Difficulty d) {
  final rng = Random(seed);
  final slow = _rand(rng, 3, 6);
  final fast = slow + _rand(rng, 2, 5);
  final hours = _rand(rng, 2, 5);
  final circ = (fast - slow) * hours;
  return _q(
    templateId: 'loop.lap',
    seed: seed,
    nodeId: 'track_loop',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '环形跑道 ${_m(circ)} 米。快的 ${_m(fast)}、慢的 ${_m(slow)} 同向。多少时间单位后快的追上慢的一圈？',
    answer: '$hours',
    hints: ['同向追及用速度差。'],
    steps: ['${_m(hours)}。'],
    nodeRefs: ['track_loop'],
  );
}

GeneratedQuestion _salePrice(int seed, Difficulty d) {
  final rng = Random(seed);
  final price = [40, 60, 80, 100, 120][rng.nextInt(5)];
  final off = [10, 20, 25, 30][rng.nextInt(4)];
  if (price * (100 - off) % 100 != 0) return _salePrice(seed + 1, d);
  final ans = Algebra.salePrice(price: price, off: off);
  return _q(
    templateId: 'sale.price',
    seed: seed,
    nodeId: 'percent_app',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '原价 ${_m(price)} 元，减价 ${_m('$off\\%')}。现价多少元？',
    answer: '$ans',
    hints: ['现价 ${_m('原价 \\times (100-折扣)/100')}。'],
    steps: ['现价 ${_m(ans)} 元。'],
    nodeRefs: ['percent_app'],
  );
}

GeneratedQuestion _saleProfit(int seed, Difficulty d) {
  final rng = Random(seed);
  final cost = [50, 80, 100, 200][rng.nextInt(4)];
  // 进价 50 元按 25% 算利润是 12.5 元；money answers stay whole, so only keep
  // the rates that come out to whole yuan for this cost.
  final rates = [
    for (final r in [10, 20, 25])
      if (cost * r % 100 == 0) r,
  ];
  final rate = rates[rng.nextInt(rates.length)];
  final ans = Algebra.profitAmount(cost: cost, rate: rate);
  return _q(
    templateId: 'sale.profit',
    seed: seed,
    nodeId: 'percent_app',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '进价 ${_m(cost)} 元，按进价的 ${_m('$rate\\%')} 利润出售。利润是多少元？',
    answer: '$ans',
    hints: ['利润 ${_m('进价 \\times 利润率')}。'],
    steps: ['利润 ${_m(ans)} 元。'],
    nodeRefs: ['percent_app'],
  );
}

GeneratedQuestion _sysX(int seed, Difficulty d) {
  final rng = Random(seed);
  final x = _rand(rng, 2, 9);
  final y = _rand(rng, 1, 8);
  final s = x + y;
  final t = 2 * x + y;
  return _q(
    templateId: 'sys.x',
    seed: seed,
    nodeId: 'linear_sys',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '解方程组 ${_m('x+y=$s')}，${_m('2x+y=$t')}。求 x。',
    answer: '$x',
    hints: ['两式相减消去 y。'],
    steps: ['${_m('x = $x')}。'],
    nodeRefs: ['linear_sys'],
  );
}

GeneratedQuestion _sysY(int seed, Difficulty d) {
  final rng = Random(seed);
  final x = _rand(rng, 1, 7);
  final y = _rand(rng, 2, 9);
  final s = x + y;
  final p = 3 * x + y;
  return _q(
    templateId: 'sys.y',
    seed: seed,
    nodeId: 'linear_sys',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '已知 ${_m('x+y=$s')}，${_m('3x+y=$p')}。求 y。',
    answer: '$y',
    hints: ['相减得 ${_m('2x = ${p - s}')}。'],
    steps: ['${_m('y = $y')}。'],
    nodeRefs: ['linear_sys'],
  );
}

GeneratedQuestion _polyIn(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, d == Difficulty.contest ? 10 : 8);
  final ans = Geometry.polygonInterior(n);
  return _q(
    templateId: 'poly.in',
    seed: seed,
    nodeId: 'poly_angle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 边形的内角和是多少度？只写数字。',
    answer: '$ans',
    hints: ['${_m('(n-2)\\times 180')}。'],
    steps: ['${_m('($n-2)\\times 180 = $ans')}。'],
    figure: PolygonFigure(sides: n, fan: true),
    nodeRefs: ['poly_angle'],
  );
}

GeneratedQuestion _polyEx(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [5, 6, 8, 9, 10, 12][rng.nextInt(6)];
  final ans = Geometry.regularExterior(n);
  return _q(
    templateId: 'poly.ex',
    seed: seed,
    nodeId: 'poly_angle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '正 ${_m(n)} 边形的一个外角是多少度？只写数字。',
    answer: '$ans',
    hints: ['外角和 360 度，每个 ${_m('360/n')}。'],
    steps: ['${_m('360 / $n = $ans')}。'],
    figure: PolygonFigure(sides: n, exterior: true, angle: '?'),
    nodeRefs: ['poly_angle'],
    answerRange: (min: 1, max: 179),
  );
}

/// Radius/angle pairs that leave the answer whole with π = 22/7. The arc is
/// `44r/7 · deg/360`, the area `22r²/7 · deg/360`; both want the division to
/// come out, so the pairs are filtered rather than hand-picked.
List<(int r, int deg)> _sectorPairs(bool Function(int r, int deg) whole) => [
  for (final r in const [7, 14, 21, 28])
    for (final deg in const [45, 60, 90, 120, 135, 180, 270])
      if (whole(r, deg)) (r, deg),
];

final _arcPairs = _sectorPairs((r, deg) => 44 * r * deg % (7 * 360) == 0);
final _sectorAreaPairs = _sectorPairs(
  (r, deg) => 22 * r * r * deg % (7 * 360) == 0,
);

/// Right angles and small radii first; the harder bands open the rest up.
(int r, int deg) _sectorPick(Random rng, Difficulty d, List<(int, int)> pairs) {
  final band = switch (d) {
    Difficulty.basic => pairs.where((p) => p.$1 <= 14 && p.$2 % 90 == 0),
    Difficulty.medium => pairs.where((p) => p.$1 <= 21),
    Difficulty.contest => pairs.where((p) => p.$1 >= 14),
  }.toList();
  final from = band.isEmpty ? pairs : band;
  return from[rng.nextInt(from.length)];
}

GeneratedQuestion _secArc(int seed, Difficulty d) {
  final rng = Random(seed);
  final (r, deg) = _sectorPick(rng, d, _arcPairs);
  final ans = Geometry.sectorArc22(r, deg);
  return _q(
    templateId: 'sec.arc',
    seed: seed,
    nodeId: 'sector_arc',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '半径 ${_m(r)}，圆心角 ${_m('$deg^\\circ')}，取 ${_m('\\pi=22/7')}。弧长是多少？',
    answer: '$ans',
    hints: ['弧长是周长的 ${_m('$deg/360')}。'],
    steps: ['弧长 ${_m(ans)}。'],
    figure: SectorFigure(radius: '$r', degrees: deg, angle: '$deg', arc: '?'),
    nodeRefs: ['sector_arc', 'circle_measure'],
  );
}

GeneratedQuestion _secArea(int seed, Difficulty d) {
  final rng = Random(seed);
  final (r, deg) = _sectorPick(rng, d, _sectorAreaPairs);
  final ans = Geometry.sectorArea22(r, deg);
  return _q(
    templateId: 'sec.area',
    seed: seed,
    nodeId: 'sector_arc',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '半径 ${_m(r)}，圆心角 ${_m('$deg^\\circ')}，取 ${_m('\\pi=22/7')}。扇形面积是多少？',
    answer: '$ans',
    hints: ['扇形面积是圆面积的 ${_m('$deg/360')}。'],
    steps: ['面积 ${_m(ans)}。'],
    figure: SectorFigure(radius: '$r', degrees: deg, angle: '$deg'),
    nodeRefs: ['sector_arc'],
  );
}

GeneratedQuestion _symX(int seed, Difficulty d) {
  final rng = Random(seed);
  final x = _rand(rng, 1, 9);
  final y = _rand(rng, 1, 9);
  return _q(
    templateId: 'sym.x',
    seed: seed,
    nodeId: 'symmetry',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '点 ${_m('($x,$y)')} 关于 x 轴对称，对称点的纵坐标是多少？',
    answer: '${-y}',
    hints: ['关于 x 轴，纵坐标变号。'],
    steps: ['纵坐标是 ${_m(-y)}。'],
    figure: SymmetryFigure(kind: SymmetryKind.xAxis, x: x, y: y),
    nodeRefs: ['symmetry'],
  );
}

GeneratedQuestion _symOrigin(int seed, Difficulty d) {
  final rng = Random(seed);
  final x = _rand(rng, 2, 9);
  final y = _rand(rng, 1, 8);
  return _q(
    templateId: 'sym.origin',
    seed: seed,
    nodeId: 'symmetry',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '点 ${_m('($x,$y)')} 关于原点对称，对称点的横坐标是多少？',
    answer: '${-x}',
    hints: ['关于原点，横纵坐标都变号。'],
    steps: ['横坐标是 ${_m(-x)}。'],
    figure: SymmetryFigure(kind: SymmetryKind.origin, x: x, y: y),
    nodeRefs: ['symmetry'],
  );
}

GeneratedQuestion _netArea(int seed, Difficulty d) {
  final rng = Random(seed);
  final l = _rand(rng, 2, 6);
  final w = _rand(rng, 2, 5);
  final h = _rand(rng, 2, 5);
  final ans = Geometry.boxSurface(l, w, h);
  return _q(
    templateId: 'net.area',
    seed: seed,
    nodeId: 'net_solid',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '长 ${_m(l)}、宽 ${_m(w)}、高 ${_m(h)} 的长方体展开图面积是多少？',
    answer: '$ans',
    hints: ['展开图面积等于表面积。'],
    steps: ['面积 ${_m(ans)}。'],
    figure: const NetFigure(cube: false),
    nodeRefs: ['net_solid', 'surface_box'],
  );
}

GeneratedQuestion _netFaces(int seed, Difficulty d) {
  final rng = Random(seed);
  final cube = rng.nextBool();
  return _q(
    templateId: 'net.faces',
    seed: seed,
    nodeId: 'net_solid',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: cube ? '正方体的展开图由几个正方形拼成？' : '长方体的展开图由几个长方形拼成？',
    answer: '6',
    hints: ['六个面摊平，既不重叠也不缺少。'],
    steps: ['6 个面。'],
    figure: NetFigure(cube: cube),
    nodeRefs: ['net_solid'],
  );
}

/// Legs and whole hypotenuse: the unfolded path is the hypotenuse, so the
/// pair has to be a Pythagorean triple.
const _pathTriples = [
  (3, 4, 5),
  (6, 8, 10),
  (5, 12, 13),
  (9, 12, 15),
  (8, 15, 17),
  (12, 16, 20),
  (7, 24, 25),
  (20, 21, 29),
];

List<(int, int, int)> _pathBand(Difficulty d) => switch (d) {
  Difficulty.basic => _pathTriples.take(5).toList(),
  Difficulty.medium => _pathTriples.skip(1).take(5).toList(),
  Difficulty.contest => _pathTriples.skip(3).toList(),
};

GeneratedQuestion _reflLen(int seed, Difficulty d) {
  final rng = Random(seed);
  final triples = _pathBand(d);
  final t = triples[rng.nextInt(triples.length)];
  return _q(
    templateId: 'refl.len',
    seed: seed,
    nodeId: 'reflect_path',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '走廊宽 ${_m(t.$1)}。两侧墙上高度差之和是 ${_m(t.$2)}。沿地面墙壁反射的最短路长是多少？（展开成直线）',
    answer: '${t.$3}',
    hints: ['展开后是直角边 ${_m(t.$1)}、${_m(t.$2)} 的斜边。'],
    steps: ['最短路 ${_m(t.$3)}。'],
    figure: ReflectPathFigure(width: '${t.$1}', rise: '${t.$2}', path: '?'),
    nodeRefs: ['reflect_path', 'pythagorean'],
  );
}

GeneratedQuestion _reflRise(int seed, Difficulty d) {
  final rng = Random(seed);
  final triples = _pathBand(d);
  final t = triples[rng.nextInt(triples.length)];
  return _q(
    templateId: 'refl.rise',
    seed: seed,
    nodeId: 'reflect_path',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '展开后直角边是宽 ${_m(t.$1)} 与高度和 x，斜边 ${_m(t.$3)}。求 x。',
    answer: '${t.$2}',
    hints: ['${_m('x^2 = ${t.$3}^2 - ${t.$1}^2')}。'],
    steps: ['x 是 ${_m(t.$2)}。'],
    figure: ReflectPathFigure(width: '${t.$1}', rise: '?', path: '${t.$3}'),
    nodeRefs: ['reflect_path'],
  );
}

GeneratedQuestion _sphVol(int seed, Difficulty d) {
  final rng = Random(seed);
  // (4/3)r³ stays whole only when 3 divides r.
  final radii = switch (d) {
    Difficulty.basic => const [3, 6],
    Difficulty.medium => const [3, 6, 9],
    Difficulty.contest => const [6, 9, 12],
  };
  final r = radii[rng.nextInt(radii.length)];
  final ans = Geometry.sphereVolPi(r);
  return _q(
    templateId: 'sph.vol',
    seed: seed,
    nodeId: 'sphere_vol',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '球半径 ${_m(r)}。体积是 ${_m('k\\pi')}，求 k。',
    answer: '$ans',
    hints: ['${_m('\\frac{4}{3}\\pi r^3')}。'],
    steps: ['k 是 ${_m(ans)}。'],
    figure: SphereFigure(radius: '$r'),
    nodeRefs: ['sphere_vol'],
  );
}

GeneratedQuestion _sphSurf(int seed, Difficulty d) {
  final rng = Random(seed);
  final r = _rand(rng, 2, 8);
  final ans = Geometry.sphereSurfPi(r);
  return _q(
    templateId: 'sph.surf',
    seed: seed,
    nodeId: 'sphere_vol',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '球半径 ${_m(r)}。表面积是 ${_m('k\\pi')}，求 k。',
    answer: '$ans',
    hints: ['${_m('4\\pi r^2')}。'],
    steps: ['k 是 ${_m(ans)}。'],
    figure: SphereFigure(radius: '$r'),
    nodeRefs: ['sphere_vol'],
  );
}

GeneratedQuestion _cpermN(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, d == Difficulty.contest ? 7 : 6);
  final ans = Counting.circlePerm(n);
  return _q(
    templateId: 'cperm.n',
    seed: seed,
    nodeId: 'circle_perm',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 人围圆桌坐下（旋转相同算一种）。有多少种坐法？',
    answer: '$ans',
    hints: ['圆形排列 ${_m('(n-1)!')}。'],
    steps: ['${_m('${n - 1}! = $ans')}。'],
    nodeRefs: ['circle_perm', 'factorial_count'],
  );
}

GeneratedQuestion _cpermBead(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, 6);
  final ans = Counting.circlePerm(n);
  return _q(
    templateId: 'cperm.bead',
    seed: seed,
    nodeId: 'circle_perm',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 颗不同的珠子穿成圆环（只看相对位置）。有多少种穿法？',
    answer: '$ans',
    hints: ['固定一颗再排其余，仍是 ${_m('(n-1)!')}。'],
    steps: ['${_m(ans)} 种。'],
    nodeRefs: ['circle_perm'],
  );
}

GeneratedQuestion _rpermOne(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 4, 7);
  final k = 2;
  final ans = Counting.permWithRepeat(n, k);
  return _q(
    templateId: 'rperm.one',
    seed: seed,
    nodeId: 'repeat_perm',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 个字母排成一排，其中有 ${_m(k)} 个相同，其余各不相同。有多少种排法？',
    answer: '$ans',
    hints: ['${_m('$n! / $k!')}。'],
    steps: ['${_m(ans)} 种。'],
    nodeRefs: ['repeat_perm'],
  );
}

GeneratedQuestion _rpermWord(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [4, 5, 6][rng.nextInt(3)];
  final k = 2;
  final ans = Counting.permWithRepeat(n, k);
  return _q(
    templateId: 'rperm.word',
    seed: seed,
    nodeId: 'repeat_perm',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '用 ${_m(n)} 张卡片排单词，其中 2 张字母一样。不同单词多少个？',
    answer: '$ans',
    hints: ['相同字母交换不产生新词，要除以 ${_m('2!')}。'],
    steps: ['${_m(ans)} 个。'],
    nodeRefs: ['repeat_perm'],
  );
}

GeneratedQuestion _sbZero(int seed, Difficulty d) {
  final rng = Random(seed);
  final items = _rand(rng, 4, 8);
  final bins = _rand(rng, 2, 4);
  final ans = Counting.starsBars(items: items, bins: bins);
  return _q(
    templateId: 'sb.zero',
    seed: seed,
    nodeId: 'stars_bars',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '把 ${_m(items)} 颗相同的糖分给 ${_m(bins)} 个小朋友，允许有人分到 0 颗。有多少种分法？',
    answer: '$ans',
    hints: ['隔板法 ${_m('C(${items + bins - 1}, ${bins - 1})')}。'],
    steps: ['${_m(ans)} 种。'],
    nodeRefs: ['stars_bars', 'combination'],
  );
}

GeneratedQuestion _sbPos(int seed, Difficulty d) {
  final rng = Random(seed);
  final bins = _rand(rng, 2, 4);
  final items = bins + _rand(rng, 2, 6);
  final ans = Counting.starsBarsPositive(items: items, bins: bins);
  return _q(
    templateId: 'sb.pos',
    seed: seed,
    nodeId: 'stars_bars',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '把 ${_m(items)} 颗相同的糖分给 ${_m(bins)} 人，每人至少 1 颗。有多少种分法？',
    answer: '$ans',
    hints: ['先各给 1 颗，再隔板；或 ${_m('C(${items - 1}, ${bins - 1})')}。'],
    steps: ['${_m(ans)} 种。'],
    nodeRefs: ['stars_bars'],
  );
}

GeneratedQuestion _inc3Union(int seed, Difficulty d) {
  final rng = Random(seed);
  final onlyA = _rand(rng, 2, 8);
  final onlyB = _rand(rng, 2, 8);
  final onlyC = _rand(rng, 2, 6);
  final ab = _rand(rng, 1, 4);
  final ac = _rand(rng, 1, 4);
  final bc = _rand(rng, 1, 4);
  final abc = _rand(rng, 1, 3);
  final a = onlyA + ab + ac + abc;
  final b = onlyB + ab + bc + abc;
  final c = onlyC + ac + bc + abc;
  final ans = Counting.inclusion3(
    a: a,
    b: b,
    c: c,
    ab: ab + abc,
    ac: ac + abc,
    bc: bc + abc,
    abc: abc,
  );
  return _q(
    templateId: 'inc3.union',
    seed: seed,
    nodeId: 'incl3',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '会 A ${_m(a)} 人，会 B ${_m(b)} 人，会 C ${_m(c)} 人；AB ${_m(ab + abc)}，AC ${_m(ac + abc)}，BC ${_m(bc + abc)}，三者都会 ${_m(abc)}。至少会一项的有多少人？',
    answer: '$ans',
    hints: ['${_m('|A\\cup B\\cup C|=|A|+|B|+|C|-|AB|-|AC|-|BC|+|ABC|')}。'],
    steps: ['${_m(ans)} 人。'],
    nodeRefs: ['incl3', 'inclusion'],
  );
}

GeneratedQuestion _inc3Only(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 8, 16);
  final ab = _rand(rng, 2, 5);
  final ac = _rand(rng, 1, 4);
  final abc = _rand(rng, 1, 3);
  final only = a - ab - ac + abc;
  return _q(
    templateId: 'inc3.only',
    seed: seed,
    nodeId: 'incl3',
    difficulty: d,
    kind: QuestionKind.fill,
    stem:
        '会游泳 ${_m(a)} 人，其中也会打球 ${_m(ab)}，也会跑步 ${_m(ac)}，三项都会 ${_m(abc)}。只会游泳的有多少人？',
    answer: '$only',
    hints: ['只在 A：${_m('|A|-|AB|-|AC|+|ABC|')}。'],
    steps: ['${_m(only)} 人。'],
    nodeRefs: ['incl3'],
  );
}

GeneratedQuestion _derN(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = _rand(rng, 3, 6);
  final ans = Counting.derange(n);
  return _q(
    templateId: 'der.n',
    seed: seed,
    nodeId: 'derange',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '求错排数 ${_m('!$n')}（n 个物件没有一个在原位）。',
    answer: '$ans',
    hints: ['错排：2 项为 1，3 项为 2，4 项为 9，5 项为 44，6 项为 265。'],
    steps: ['${_m('!$n = $ans')}。'],
    nodeRefs: ['derange'],
  );
}

GeneratedQuestion _derHat(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = [3, 4, 5][rng.nextInt(3)];
  final ans = Counting.derange(n);
  return _q(
    templateId: 'der.hat',
    seed: seed,
    nodeId: 'derange',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m(n)} 人各拿一顶帽子，每人都拿错。有多少种拿法？',
    answer: '$ans',
    hints: ['这就是 ${_m('!$n')}。'],
    steps: ['${_m(ans)} 种。'],
    nodeRefs: ['derange'],
  );
}

GeneratedQuestion _nimTake(int seed, Difficulty d) {
  final rng = Random(seed);
  final takeMax = _rand(rng, 2, 4);
  var n = _rand(rng, takeMax + 2, 20);
  var first = OlympiadLogic.nimFirstTake(n, takeMax);
  if (first == 0) n += 1;
  first = OlympiadLogic.nimFirstTake(n, takeMax);
  return _q(
    templateId: 'nim.take',
    seed: seed,
    nodeId: 'nim_take',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '有 ${_m(n)} 颗石子，每次取 1 到 ${_m(takeMax)} 颗。先手第一次应取几颗才能保证赢？',
    answer: '$first',
    hints: ['把石子数做成 ${_m(takeMax + 1)} 的倍数留给对方。'],
    steps: ['先取 ${_m(first)} 颗。'],
    nodeRefs: ['nim_take'],
  );
}

GeneratedQuestion _nimLose(int seed, Difficulty d) {
  final rng = Random(seed);
  final takeMax = _rand(rng, 2, 4);
  final k = _rand(rng, 2, 5);
  final n = k * (takeMax + 1);
  return _q(
    templateId: 'nim.lose',
    seed: seed,
    nodeId: 'nim_take',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '有 ${_m(n)} 颗石子，每次 1 到 ${_m(takeMax)} 颗。先手是否必败（双方都最优）？回答「是」或「否」。',
    answer: '是',
    hints: ['${_m(n)} 恰是 ${_m(takeMax + 1)} 的倍数，先手必败。'],
    steps: ['是，先手必败。'],
    nodeRefs: ['nim_take'],
  );
}

GeneratedQuestion _schMin(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 2, 6);
  final b = _rand(rng, 2, 6);
  final c = _rand(rng, 2, 8);
  final ans = OlympiadLogic.twoWorkerMin(a, b, c);
  return _q(
    templateId: 'sch.min',
    seed: seed,
    nodeId: 'schedule',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '三件事分别要 ${_m(a)}、${_m(b)}、${_m(c)} 小时，不能拆开。两个人同时做，最少几小时做完？',
    answer: '$ans',
    hints: ['一个人做两件、另一个做一件，取三种分法里较短的。'],
    steps: ['最少 ${_m(ans)} 小时。'],
    nodeRefs: ['schedule'],
  );
}

GeneratedQuestion _schWho(int seed, Difficulty d) {
  final a = 2;
  final b = 3;
  final c = 5;
  final ans = OlympiadLogic.twoWorkerMin(a, b, c);
  return _q(
    templateId: 'sch.who',
    seed: seed,
    nodeId: 'schedule',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '工时 ${_m(a)}、${_m(b)}、${_m(c)}。两人合作且一事不拆，最短工期是多少？',
    answer: '$ans',
    hints: ['把 ${_m(a)} 与 ${_m(b)} 给同一人，另一人做 ${_m(c)}，两边都是 ${_m(5)}。'],
    steps: ['最短 ${_m(ans)}。'],
    nodeRefs: ['schedule'],
  );
}

GeneratedQuestion _queWait(int seed, Difficulty d) {
  final rng = Random(seed);
  final ahead = _rand(rng, 3, 12);
  final minutes = _rand(rng, 2, 6);
  final ans = OlympiadLogic.queueWait(ahead: ahead, minutes: minutes);
  return _q(
    templateId: 'que.wait',
    seed: seed,
    nodeId: 'queue_wait',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '前面有 ${_m(ahead)} 人，每人办理 ${_m(minutes)} 分钟。还要等多少分钟才轮到你（你尚未开始）？',
    answer: '$ans',
    hints: ['等待时间是前面人数乘每人用时。'],
    steps: ['${_m('$ahead \\times $minutes = $ans')}。'],
    nodeRefs: ['queue_wait'],
  );
}

GeneratedQuestion _queSelf(int seed, Difficulty d) {
  final rng = Random(seed);
  final ahead = _rand(rng, 2, 8);
  final minutes = _rand(rng, 2, 5);
  final ans = (ahead + 1) * minutes;
  return _q(
    templateId: 'que.self',
    seed: seed,
    nodeId: 'queue_wait',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '前面 ${_m(ahead)} 人，每人 ${_m(minutes)} 分钟。从现在到你办完，一共多少分钟？',
    answer: '$ans',
    hints: ['把你自己也算进去，共 ${_m(ahead + 1)} 人。'],
    steps: ['${_m(ans)} 分钟。'],
    nodeRefs: ['queue_wait'],
  );
}

GeneratedQuestion _cutPcs(int seed, Difficulty d) {
  final rng = Random(seed);
  final cuts = _rand(rng, 2, 12);
  final ans = OlympiadLogic.ropePieces(cuts);
  return _q(
    templateId: 'cut.pcs',
    seed: seed,
    nodeId: 'cut_rope',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '一根绳子锯 ${_m(cuts)} 刀（不折叠）。得到几段？',
    answer: '$ans',
    hints: ['每刀多一段，段数 = 刀数 + 1。'],
    steps: ['${_m('$cuts + 1 = $ans')}。'],
    nodeRefs: ['cut_rope'],
  );
}

GeneratedQuestion _cutN(int seed, Difficulty d) {
  final rng = Random(seed);
  final pieces = _rand(rng, 3, 12);
  final ans = OlympiadLogic.ropeCuts(pieces);
  return _q(
    templateId: 'cut.n',
    seed: seed,
    nodeId: 'cut_rope',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '要把绳子锯成 ${_m(pieces)} 段（不折叠）。至少锯几刀？',
    answer: '$ans',
    hints: ['刀数 = 段数 − 1。'],
    steps: ['${_m('$pieces - 1 = $ans')}。'],
    nodeRefs: ['cut_rope'],
  );
}

GeneratedQuestion _loadMax(int seed, Difficulty d) {
  final rng = Random(seed);
  final each = _rand(rng, 3, 9);
  final count = _rand(rng, 4, 12);
  final extra = _rand(rng, 0, each - 1);
  final cap = each * count + extra;
  return _q(
    templateId: 'load.max',
    seed: seed,
    nodeId: 'load_pack',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '箱子能装 ${_m(cap)} 千克，每件 ${_m(each)} 千克。最多装几件？',
    answer: '$count',
    hints: ['整除取商 ${_m('\\lfloor $cap/$each \\rfloor')}。'],
    steps: ['最多 ${_m(count)} 件。'],
    nodeRefs: ['load_pack'],
  );
}

GeneratedQuestion _loadLeft(int seed, Difficulty d) {
  final rng = Random(seed);
  final each = _rand(rng, 4, 9);
  final count = _rand(rng, 3, 10);
  final extra = _rand(rng, 1, each - 1);
  final cap = each * count + extra;
  return _q(
    templateId: 'load.left',
    seed: seed,
    nodeId: 'load_pack',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '容量 ${_m(cap)}，每件 ${_m(each)}。装满整数件后还剩多少？',
    answer: '$extra',
    hints: ['余数 ${_m('$cap \\bmod $each')}。'],
    steps: ['剩下 ${_m(extra)}。'],
    nodeRefs: ['load_pack'],
  );
}

GeneratedQuestion _sqJudge(int seed, Difficulty d) {
  final rng = Random(seed);
  final k = _rand(rng, 4, 15);
  final n = rng.nextBool() ? k * k : k * k + _rand(rng, 1, 6);
  final yes = NumberTheory.isPerfectSquare(n);
  return _q(
    templateId: 'sq.judge',
    seed: seed,
    nodeId: 'perfect_square',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '判断：${_m(n)} 是完全平方数吗？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: ['看它是否等于某个整数的平方。'],
    steps: [yes ? '${_m(n)} 是平方数。' : '${_m(n)} 不是平方数。'],
    nodeRefs: ['perfect_square'],
  );
}

GeneratedQuestion _sqCount(int seed, Difficulty d) {
  final rng = Random(seed);
  final n = d == Difficulty.contest ? _rand(rng, 40, 100) : _rand(rng, 10, 40);
  var count = 0;
  for (var k = 1; k * k <= n; k++) {
    count++;
  }
  return _q(
    templateId: 'sq.count',
    seed: seed,
    nodeId: 'perfect_square',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '1 到 ${_m(n)} 中有多少个完全平方数？',
    answer: '$count',
    hints: ['最大的 k 满足 ${_m('k^2 \\le $n')}，个数就是 k。'],
    steps: ['有 ${_m(count)} 个。'],
    nodeRefs: ['perfect_square'],
  );
}

GeneratedQuestion _endJudge(int seed, Difficulty d) {
  final rng = Random(seed);
  final digit = rng.nextInt(10);
  final yes = NumberTheory.canBeSquareEnding(digit);
  return _q(
    templateId: 'end.judge',
    seed: seed,
    nodeId: 'square_end',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '判断：完全平方数的个位可以是 ${_m(digit)} 吗？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: ['平方个位只能是 0,1,4,5,6,9。'],
    steps: [yes ? '可以。' : '不可以。'],
    nodeRefs: ['square_end'],
  );
}

GeneratedQuestion _endList(int seed, Difficulty d) {
  return _q(
    templateId: 'end.list',
    seed: seed,
    nodeId: 'square_end',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '完全平方数可能出现的个位数字有几个（0–9 中数一数）？',
    answer: '6',
    hints: ['0,1,4,5,6,9 共 6 个。'],
    steps: ['6 个。'],
    nodeRefs: ['square_end'],
  );
}

GeneratedQuestion _plastVal(int seed, Difficulty d) {
  final rng = Random(seed);
  final base = [2, 3, 4, 7, 8, 9][rng.nextInt(6)];
  final exp = _rand(rng, 4, d == Difficulty.contest ? 20 : 12);
  final ans = NumberTheory.powerLast(base, exp);
  return _q(
    templateId: 'plast.val',
    seed: seed,
    nodeId: 'power_last',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('$base^{$exp}')} 的个位数字是多少？',
    answer: '$ans',
    hints: ['个位按 4 或更短的循环节转。'],
    steps: ['个位是 ${_m(ans)}。'],
    nodeRefs: ['power_last'],
  );
}

GeneratedQuestion _plastCyc(int seed, Difficulty d) {
  final rng = Random(seed);
  final base = [2, 3, 4, 5, 6, 7, 8, 9][rng.nextInt(8)];
  // Work the period out instead of assuming 4: base 4 repeats every 2, and
  // bases 5 and 6 never move off their own last digit.
  final first = NumberTheory.powerLast(base, 1);
  var cycle = 1;
  while (NumberTheory.powerLast(base, 1 + cycle) != first) {
    cycle++;
  }
  return _q(
    templateId: 'plast.cyc',
    seed: seed,
    nodeId: 'power_last',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('$base^n')} 的个位循环节长度是多少？',
    answer: '$cycle',
    hints: [
      '写出 ${_m('$base^1')}、${_m('$base^2')}、${_m('$base^3')}… 的个位，看它什么时候回到 ${_m(first)}。',
    ],
    steps: ['循环节长 ${_m(cycle)}。'],
    nodeRefs: ['power_last'],
  );
}
