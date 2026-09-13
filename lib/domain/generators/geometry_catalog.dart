import 'dart:math';

import '../figure.dart';
import '../geometry.dart';
import 'build.dart';
import 'question.dart';

final List<QuestionTemplate> geometryTemplates = [
  QuestionTemplate(
    id: 'angle.comp',
    nodeId: 'angle_basic',
    difficulties: Difficulty.values.toSet(),
    build: _angleComp,
  ),
  QuestionTemplate(
    id: 'angle.supp',
    nodeId: 'angle_basic',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _angleSupp,
  ),
  QuestionTemplate(
    id: 'perim.rect',
    nodeId: 'perimeter',
    difficulties: Difficulty.values.toSet(),
    build: _perimRect,
  ),
  QuestionTemplate(
    id: 'perim.square',
    nodeId: 'perimeter',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _perimSquare,
  ),
  QuestionTemplate(
    id: 'area.rect',
    nodeId: 'rect_area',
    difficulties: Difficulty.values.toSet(),
    build: _areaRect,
  ),
  QuestionTemplate(
    id: 'area.square',
    nodeId: 'rect_area',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _areaSquare,
  ),
  QuestionTemplate(
    id: 'area.tri',
    nodeId: 'triangle_area',
    difficulties: Difficulty.values.toSet(),
    build: _areaTri,
  ),
  QuestionTemplate(
    id: 'area.tri_half',
    nodeId: 'triangle_area',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _areaTriFromRect,
  ),
  QuestionTemplate(
    id: 'area.trap',
    nodeId: 'trap_area',
    difficulties: Difficulty.values.toSet(),
    build: _areaTrap,
  ),
  QuestionTemplate(
    id: 'area.para',
    nodeId: 'trap_area',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _areaPara,
  ),
  QuestionTemplate(
    id: 'circ.circ',
    nodeId: 'circle_measure',
    difficulties: Difficulty.values.toSet(),
    build: _circLen,
  ),
  QuestionTemplate(
    id: 'circ.area',
    nodeId: 'circle_measure',
    difficulties: Difficulty.values.toSet(),
    build: _circArea,
  ),
  QuestionTemplate(
    id: 'par.corr',
    nodeId: 'parallel_angle',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _parCorr,
  ),
  QuestionTemplate(
    id: 'par.co',
    nodeId: 'parallel_angle',
    difficulties: Difficulty.values.toSet(),
    build: _parCo,
  ),
  QuestionTemplate(
    id: 'tri.third',
    nodeId: 'triangle_angle',
    difficulties: Difficulty.values.toSet(),
    build: _triThird,
  ),
  QuestionTemplate(
    id: 'tri.right',
    nodeId: 'triangle_angle',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _triRight,
  ),
  QuestionTemplate(
    id: 'sides.judge',
    nodeId: 'triangle_ineq',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _sidesJudge,
  ),
  QuestionTemplate(
    id: 'sides.range',
    nodeId: 'triangle_ineq',
    difficulties: Difficulty.values.toSet(),
    build: _sidesRange,
  ),
  QuestionTemplate(
    id: 'pyth.hyp',
    nodeId: 'pythagorean',
    difficulties: Difficulty.values.toSet(),
    build: _pythHyp,
  ),
  QuestionTemplate(
    id: 'pyth.leg',
    nodeId: 'pythagorean',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _pythLeg,
  ),
  QuestionTemplate(
    id: 'sim.side',
    nodeId: 'similar_tri',
    difficulties: Difficulty.values.toSet(),
    build: _simSide,
  ),
  QuestionTemplate(
    id: 'sim.area',
    nodeId: 'similar_tri',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _simArea,
  ),
  QuestionTemplate(
    id: 'box.vol',
    nodeId: 'box_volume',
    difficulties: Difficulty.values.toSet(),
    build: _boxVol,
  ),
  QuestionTemplate(
    id: 'box.cube',
    nodeId: 'box_volume',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _boxCube,
  ),
  QuestionTemplate(
    id: 'cut.square',
    nodeId: 'cut_fill',
    difficulties: Difficulty.values.toSet(),
    build: _cutSquare,
  ),
  QuestionTemplate(
    id: 'cut.frame',
    nodeId: 'cut_fill',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _cutFrame,
  ),
  QuestionTemplate(
    id: 'surf.box',
    nodeId: 'surface_box',
    difficulties: Difficulty.values.toSet(),
    build: _surfBox,
  ),
  QuestionTemplate(
    id: 'surf.cube',
    nodeId: 'surface_box',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _surfCube,
  ),
  QuestionTemplate(
    id: 'cang.inscribed',
    nodeId: 'circle_angle',
    difficulties: Difficulty.values.toSet(),
    build: _cangInscribed,
  ),
  QuestionTemplate(
    id: 'cang.diameter',
    nodeId: 'circle_angle',
    difficulties: {Difficulty.basic, Difficulty.medium},
    build: _cangDiameter,
  ),
  QuestionTemplate(
    id: 'solid.cyl',
    nodeId: 'solid_adv',
    difficulties: Difficulty.values.toSet(),
    build: _solidCyl,
  ),
  QuestionTemplate(
    id: 'solid.cone',
    nodeId: 'solid_adv',
    difficulties: {Difficulty.medium, Difficulty.contest},
    build: _solidCone,
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
  List<String> choices = const [],
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
    choices: choices,
    figure: figure,
    answerRange: answerRange,
  );
}

GeneratedQuestion _angleComp(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 15, d == Difficulty.basic ? 70 : 80);
  final ans = Geometry.complement(a);
  return _q(
    templateId: 'angle.comp',
    seed: seed,
    nodeId: 'angle_basic',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('$a^\\circ')} 的余角是多少度？只写数字。',
    answer: '$ans',
    hints: ['余角之和是 90 度。', '${_m('90 - $a')}。'],
    steps: ['余角是 ${_m(ans)} 度。'],
    figure: AnglePairFigure(given: a, kind: AnglePairKind.complement),
    nodeRefs: ['angle_basic'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _angleSupp(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 20, 150);
  final ans = Geometry.supplement(a);
  return _q(
    templateId: 'angle.supp',
    seed: seed,
    nodeId: 'angle_basic',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '${_m('$a^\\circ')} 的补角是多少度？只写数字。',
    answer: '$ans',
    hints: ['补角之和是 180 度。', '${_m('180 - $a')}。'],
    steps: ['补角是 ${_m(ans)} 度。'],
    figure: AnglePairFigure(given: a, kind: AnglePairKind.supplement),
    nodeRefs: ['angle_basic'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _perimRect(int seed, Difficulty d) {
  final rng = Random(seed);
  final l = _rand(rng, 4, d == Difficulty.contest ? 20 : 12);
  final w = _rand(rng, 2, l);
  final ans = Geometry.rectPerimeter(l, w);
  return _q(
    templateId: 'perim.rect',
    seed: seed,
    nodeId: 'perimeter',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '长 ${_m(l)}、宽 ${_m(w)} 的长方形，周长是多少？',
    answer: '$ans',
    hints: ['周长 ${_m('2(长 + 宽)')}。', '${_m('2($l + $w)')}。'],
    steps: ['周长是 ${_m(ans)}。'],
    figure: RectFigure(length: '$l', width: '$w'),
    nodeRefs: ['perimeter'],
  );
}

GeneratedQuestion _perimSquare(int seed, Difficulty d) {
  final rng = Random(seed);
  final s = _rand(rng, 3, 15);
  return _q(
    templateId: 'perim.square',
    seed: seed,
    nodeId: 'perimeter',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '边长 ${_m(s)} 的正方形，周长是多少？',
    answer: '${4 * s}',
    hints: ['正方形周长是边长的 4 倍。'],
    steps: ['${_m('4 \\times $s = ${4 * s}')}。'],
    figure: RectFigure(length: '$s', width: '$s', square: true),
    nodeRefs: ['perimeter'],
  );
}

GeneratedQuestion _areaRect(int seed, Difficulty d) {
  final rng = Random(seed);
  final l = _rand(rng, 4, 16);
  final w = _rand(rng, 2, 12);
  final ans = Geometry.rectArea(l, w);
  return _q(
    templateId: 'area.rect',
    seed: seed,
    nodeId: 'rect_area',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '长 ${_m(l)}、宽 ${_m(w)} 的长方形，面积是多少？',
    answer: '$ans',
    hints: ['面积 ${_m('长 \\times 宽')}。'],
    steps: ['${_m('$l \\times $w = $ans')}。'],
    figure: RectFigure(length: '$l', width: '$w'),
    nodeRefs: ['rect_area'],
  );
}

GeneratedQuestion _areaSquare(int seed, Difficulty d) {
  final rng = Random(seed);
  final s = _rand(rng, 3, 12);
  return _q(
    templateId: 'area.square',
    seed: seed,
    nodeId: 'rect_area',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '边长 ${_m(s)} 的正方形，面积是多少？',
    answer: '${s * s}',
    hints: ['正方形面积是边长乘边长。'],
    steps: ['${_m('$s \\times $s = ${s * s}')}。'],
    figure: RectFigure(length: '$s', width: '$s', square: true),
    nodeRefs: ['rect_area'],
  );
}

GeneratedQuestion _areaTri(int seed, Difficulty d) {
  final rng = Random(seed);
  final b = _rand(rng, 4, 16);
  var h = _rand(rng, 3, 12);
  if ((b * h).isOdd) h += 1;
  final ans = Geometry.triangleArea(b, h);
  return _q(
    templateId: 'area.tri',
    seed: seed,
    nodeId: 'triangle_area',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '底 ${_m(b)}、高 ${_m(h)} 的三角形，面积是多少？',
    answer: '$ans',
    hints: ['面积 ${_m('\\frac{1}{2} \\times 底 \\times 高')}。'],
    steps: ['${_m('\\frac{1}{2} \\times $b \\times $h = $ans')}。'],
    figure: TriangleFigure(sideAB: '$b', heightLabel: '$h'),
    nodeRefs: ['triangle_area'],
  );
}

GeneratedQuestion _areaTriFromRect(int seed, Difficulty d) {
  final rng = Random(seed);
  final l = _rand(rng, 6, 14);
  var w = _rand(rng, 4, 10);
  // An odd-by-odd rectangle halves to something ending in .5; nudge the width
  // so each triangle has a whole area.
  if (l * w % 2 != 0) w++;
  // Through the helper, so its exactness precondition covers this too.
  final ans = Geometry.triangleArea(l, w);
  return _q(
    templateId: 'area.tri_half',
    seed: seed,
    nodeId: 'triangle_area',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '长 ${_m(l)}、宽 ${_m(w)} 的长方形沿对角线分成两个三角形。其中一个三角形面积是多少？',
    answer: '$ans',
    hints: ['两个三角形面积相等，各占长方形一半。', '长方形面积 ${_m(l * w)}。'],
    steps: ['${_m('${l * w} / 2 = $ans')}。'],
    figure: RectFigure(length: '$l', width: '$w', diagonal: true),
    nodeRefs: ['triangle_area', 'rect_area'],
  );
}

GeneratedQuestion _areaTrap(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 3, 10);
  final b = a + _rand(rng, 1, 8);
  var h = _rand(rng, 2, 10);
  if (((a + b) * h).isOdd) h += 1;
  final ans = Geometry.trapArea(a, b, h);
  return _q(
    templateId: 'area.trap',
    seed: seed,
    nodeId: 'trap_area',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '梯形上底 ${_m(a)}、下底 ${_m(b)}、高 ${_m(h)}。面积是多少？',
    answer: '$ans',
    hints: ['面积 ${_m('\\frac{(上底 + 下底)\\times 高}{2}')}。'],
    steps: ['${_m('($a + $b) \\times $h / 2 = $ans')}。'],
    figure: TrapezoidFigure(top: '$a', bottom: '$b', height: '$h'),
    nodeRefs: ['trap_area'],
  );
}

GeneratedQuestion _areaPara(int seed, Difficulty d) {
  final rng = Random(seed);
  final b = _rand(rng, 5, 14);
  final h = _rand(rng, 3, 10);
  return _q(
    templateId: 'area.para',
    seed: seed,
    nodeId: 'trap_area',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '平行四边形底 ${_m(b)}、高 ${_m(h)}。面积是多少？',
    answer: '${b * h}',
    hints: ['平行四边形面积是底乘高，也等于两底相等的梯形。'],
    steps: ['${_m('$b \\times $h = ${b * h}')}。'],
    figure: TrapezoidFigure(bottom: '$b', height: '$h', parallelogram: true),
    nodeRefs: ['trap_area'],
  );
}

/// π = 22/7 keeps the answer whole only for radii that are multiples of 7.
List<int> _piRadii(Difficulty d) => switch (d) {
  Difficulty.basic => const [7, 14, 21],
  Difficulty.medium => const [14, 21, 28],
  Difficulty.contest => const [21, 28, 35],
};

GeneratedQuestion _circLen(int seed, Difficulty d) {
  final rng = Random(seed);
  final radii = _piRadii(d);
  final r = radii[rng.nextInt(radii.length)];
  final ans = Geometry.circleCirc22(r);
  return _q(
    templateId: 'circ.circ',
    seed: seed,
    nodeId: 'circle_measure',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '半径 ${_m(r)}，取 ${_m('\\pi = 22/7')}。圆周长是多少？',
    answer: '$ans',
    hints: ['周长 ${_m('2\\pi r')}。', '${_m('2 \\times 22/7 \\times $r')}。'],
    steps: ['周长是 ${_m(ans)}。'],
    figure: CircleMeasureFigure(radius: '$r'),
    nodeRefs: ['circle_measure'],
  );
}

GeneratedQuestion _circArea(int seed, Difficulty d) {
  final rng = Random(seed);
  final radii = _piRadii(d);
  final r = radii[rng.nextInt(radii.length)];
  final ans = Geometry.circleArea22(r);
  return _q(
    templateId: 'circ.area',
    seed: seed,
    nodeId: 'circle_measure',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '半径 ${_m(r)}，取 ${_m('\\pi = 22/7')}。圆面积是多少？',
    answer: '$ans',
    hints: ['面积 ${_m('\\pi r^2')}。'],
    steps: ['${_m('22/7 \\times $r^2 = $ans')}。'],
    figure: CircleMeasureFigure(radius: '$r'),
    nodeRefs: ['circle_measure'],
  );
}

GeneratedQuestion _parCorr(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 35, 140);
  return _q(
    templateId: 'par.corr',
    seed: seed,
    nodeId: 'parallel_angle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '两平行线被第三条线所截，一个同位角是 ${_m('$a^\\circ')}。另一个同位角是多少度？只写数字。',
    answer: '$a',
    hints: ['平行线的同位角相等。'],
    steps: ['另一个同位角也是 ${_m(a)} 度。'],
    figure: ParallelFigure(angle: '$a', mark: ParallelMark.corresponding),
    nodeRefs: ['parallel_angle'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _parCo(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 50, 140);
  final ans = Geometry.supplement(a);
  return _q(
    templateId: 'par.co',
    seed: seed,
    nodeId: 'parallel_angle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '两平行线被第三条线所截，一个同旁内角是 ${_m('$a^\\circ')}。另一个同旁内角是多少度？只写数字。',
    answer: '$ans',
    hints: ['平行线的同旁内角互补。'],
    steps: ['${_m('180 - $a = $ans')}。'],
    figure: ParallelFigure(angle: '$a', mark: ParallelMark.coInterior),
    nodeRefs: ['parallel_angle', 'angle_basic'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _triThird(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 20, 80);
  final b = _rand(rng, 20, 90 - a ~/ 2);
  final c = 180 - a - b;
  return _q(
    templateId: 'tri.third',
    seed: seed,
    nodeId: 'triangle_angle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '三角形两个内角是 ${_m('$a^\\circ')} 和 ${_m('$b^\\circ')}。第三个内角是多少度？只写数字。',
    answer: '$c',
    hints: ['内角和是 180 度。', '${_m('180 - $a - $b')}。'],
    steps: ['第三个内角是 ${_m(c)} 度。'],
    figure: TriangleFigure(angleA: '$a', angleB: '$b', angleC: '?'),
    nodeRefs: ['triangle_angle'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _triRight(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 15, 70);
  final ans = Geometry.complement(a);
  return _q(
    templateId: 'tri.right',
    seed: seed,
    nodeId: 'triangle_angle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '直角三角形一个锐角是 ${_m('$a^\\circ')}。另一个锐角是多少度？只写数字。',
    answer: '$ans',
    hints: ['直角三角形两个锐角互余。'],
    steps: ['${_m('90 - $a = $ans')}。'],
    figure: TriangleFigure(rightAt: 'C', angleA: '$a', angleB: '?'),
    nodeRefs: ['triangle_angle', 'angle_basic'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _sidesJudge(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 3, 8);
  final b = _rand(rng, 3, 8);
  final c = rng.nextBool() ? a + b - 1 : a + b;
  final yes = Geometry.canTriangle(a, b, c);
  return _q(
    templateId: 'sides.judge',
    seed: seed,
    nodeId: 'triangle_ineq',
    difficulty: d,
    kind: QuestionKind.judge,
    stem: '判断：边长 ${_m(a)}、${_m(b)}、${_m(c)} 能否围成三角形？回答「是」或「否」。',
    answer: yes ? '是' : '否',
    hints: [
      '任意两边之和必须大于第三边。',
      '最短两边之和 ${_m(a + b <= c ? a + b : (a + c <= b ? a + c : b + c))} 与最长边比较。',
    ],
    steps: [yes ? '满足两边之和大于第三边，能围成。' : '存在两边之和不大于第三边，不能围成。'],
    nodeRefs: ['triangle_ineq'],
  );
}

GeneratedQuestion _sidesRange(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 4, 9);
  final b = _rand(rng, 5, 10);
  // integer third side x: |a-b| < x < a+b
  final lo = (a - b).abs() + 1;
  final hi = a + b - 1;
  final count = hi - lo + 1;
  return _q(
    templateId: 'sides.range',
    seed: seed,
    nodeId: 'triangle_ineq',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '三角形两边为 ${_m(a)} 和 ${_m(b)}。第三边是正整数时，有多少种可能？',
    answer: '$count',
    hints: ['第三边 x 满足 ${_m('|a-b| < x < a+b')}。', 'x 从 ${_m(lo)} 到 ${_m(hi)}。'],
    steps: ['共 ${_m(count)} 种。'],
    nodeRefs: ['triangle_ineq'],
  );
}

GeneratedQuestion _pythHyp(int seed, Difficulty d) {
  final rng = Random(seed);
  final triples = [
    (3, 4, 5),
    (5, 12, 13),
    (6, 8, 10),
    (9, 12, 15),
    (8, 15, 17),
  ];
  final t = triples[rng.nextInt(triples.length)];
  return _q(
    templateId: 'pyth.hyp',
    seed: seed,
    nodeId: 'pythagorean',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '直角三角形两直角边是 ${_m(t.$1)} 和 ${_m(t.$2)}。斜边是多少？',
    answer: '${t.$3}',
    hints: ['${_m('a^2 + b^2 = c^2')}。', '${_m('${t.$1}^2 + ${t.$2}^2')}。'],
    steps: ['斜边是 ${_m(t.$3)}。'],
    figure: TriangleFigure(
      rightAt: 'C',
      sideCA: '${t.$1}',
      sideBC: '${t.$2}',
      sideAB: '?',
    ),
    nodeRefs: ['pythagorean'],
  );
}

GeneratedQuestion _pythLeg(int seed, Difficulty d) {
  final rng = Random(seed);
  final triples = [(3, 4, 5), (5, 12, 13), (6, 8, 10), (9, 12, 15)];
  final t = triples[rng.nextInt(triples.length)];
  return _q(
    templateId: 'pyth.leg',
    seed: seed,
    nodeId: 'pythagorean',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '直角三角形斜边 ${_m(t.$3)}，一条直角边 ${_m(t.$1)}。另一条直角边是多少？',
    answer: '${t.$2}',
    hints: ['${_m('b^2 = c^2 - a^2')}。'],
    steps: ['另一条直角边是 ${_m(t.$2)}。'],
    figure: TriangleFigure(
      rightAt: 'C',
      sideCA: '${t.$1}',
      sideAB: '${t.$3}',
      sideBC: '?',
    ),
    nodeRefs: ['pythagorean'],
  );
}

GeneratedQuestion _simSide(int seed, Difficulty d) {
  final rng = Random(seed);
  final drawn = _rand(rng, 2, 5);
  final pair = ratioPair(drawn, drawn + _rand(rng, 1, 4));
  final r1 = pair.a;
  final r2 = pair.b;
  final known = r1 * _rand(rng, 2, 6);
  final ans = Geometry.similarSide(known: known, knownRatio: r1, askRatio: r2);
  return _q(
    templateId: 'sim.side',
    seed: seed,
    nodeId: 'similar_tri',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '两个相似三角形对应边比为 ${_m('$r1:$r2')}。小三角形一条边是 ${_m(known)}，对应的大边是多少？',
    answer: '$ans',
    hints: ['对应边成比例：${_m('$known / x = $r1 / $r2')}。'],
    steps: ['${_m('$known \\times $r2 / $r1 = $ans')}。'],
    figure: SimilarPairFigure(ratio: '$r1:$r2', smallSide: '$known'),
    nodeRefs: ['similar_tri'],
  );
}

GeneratedQuestion _simArea(int seed, Difficulty d) {
  final rng = Random(seed);
  final drawn = _rand(rng, 1, 3);
  final pair = ratioPair(drawn, drawn + _rand(rng, 1, 3));
  final r1 = pair.a;
  final r2 = pair.b;
  final smallArea = r1 * r1 * _rand(rng, 2, 4);
  final ans = smallArea * r2 * r2 ~/ (r1 * r1);
  return _q(
    templateId: 'sim.area',
    seed: seed,
    nodeId: 'similar_tri',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '相似比为 ${_m('$r1:$r2')}。小三角形面积 ${_m(smallArea)}，大三角形面积是多少？',
    answer: '$ans',
    hints: ['面积比等于相似比的平方 ${_m('$r1^2 : $r2^2')}。'],
    steps: ['大三角形面积是 ${_m(ans)}。'],
    figure: SimilarPairFigure(ratio: '$r1:$r2'),
    nodeRefs: ['similar_tri'],
  );
}

GeneratedQuestion _boxVol(int seed, Difficulty d) {
  final rng = Random(seed);
  final l = _rand(rng, 3, 10);
  final w = _rand(rng, 2, 8);
  final h = _rand(rng, 2, 7);
  final ans = Geometry.boxVolume(l, w, h);
  return _q(
    templateId: 'box.vol',
    seed: seed,
    nodeId: 'box_volume',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '长方体长 ${_m(l)}、宽 ${_m(w)}、高 ${_m(h)}。体积是多少？',
    answer: '$ans',
    hints: ['体积 ${_m('长 \\times 宽 \\times 高')}。'],
    steps: ['${_m('$l \\times $w \\times $h = $ans')}。'],
    figure: BoxFigure(length: '$l', width: '$w', height: '$h'),
    nodeRefs: ['box_volume'],
  );
}

GeneratedQuestion _boxCube(int seed, Difficulty d) {
  final rng = Random(seed);
  final s = _rand(rng, 2, 8);
  return _q(
    templateId: 'box.cube',
    seed: seed,
    nodeId: 'box_volume',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '棱长 ${_m(s)} 的正方体，体积是多少？',
    answer: '${s * s * s}',
    hints: ['正方体体积是棱长的立方。'],
    steps: ['${_m('$s^3 = ${s * s * s}')}。'],
    figure: BoxFigure(length: '$s', width: '$s', height: '$s', cube: true),
    nodeRefs: ['box_volume'],
  );
}

GeneratedQuestion _cutSquare(int seed, Difficulty d) {
  final rng = Random(seed);
  final big = _rand(rng, 6, 14);
  final cut = _rand(rng, 2, big - 2);
  final ans = Geometry.cutSquare(big, cut);
  return _q(
    templateId: 'cut.square',
    seed: seed,
    nodeId: 'cut_fill',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '边长 ${_m(big)} 的大正方形挖去边长 ${_m(cut)} 的小正方形。剩下的面积是多少？',
    answer: '$ans',
    hints: ['大减小：${_m('$big^2 - $cut^2')}。'],
    steps: ['${_m('${big * big} - ${cut * cut} = $ans')}。'],
    figure: FrameFigure(outer: '$big', border: '1', cutInner: '$cut'),
    nodeRefs: ['cut_fill', 'rect_area'],
  );
}

GeneratedQuestion _cutFrame(int seed, Difficulty d) {
  final rng = Random(seed);
  final border = _rand(rng, 1, 3);
  final inner = _rand(rng, 4, d == Difficulty.medium ? 12 : 10);
  final outer = inner + 2 * border;
  final ans = Geometry.cutSquare(outer, inner);
  final once = outer * outer - (outer - border) * (outer - border);
  final holeAsBorder = outer * outer - border * border;
  final fatRim = 4 * outer * border;
  return _q(
    templateId: 'cut.frame',
    seed: seed,
    nodeId: 'cut_fill',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '一个正方形画框，外边长 ${_m(outer)}，边宽 ${_m(border)}。框本身的面积是多少？',
    answer: '$ans',
    hints: [
      '边宽在对边各占一段，内边长 ${_m('$outer-2\\times $border=$inner')}，不是 ${_m('$outer-$border')}。',
      '框面积 = 外框 ${_m('$outer^2')} 减去内孔 ${_m('$inner^2')}。',
    ],
    steps: ['${_m('${outer * outer} - ${inner * inner} = $ans')}。'],
    figure: FrameFigure(outer: '$outer', border: '$border'),
    nodeRefs: ['cut_fill'],
    choices: ['$ans', '$once', '$holeAsBorder', '$fatRim'],
  );
}

GeneratedQuestion _surfBox(int seed, Difficulty d) {
  final rng = Random(seed);
  final l = _rand(rng, 3, 10);
  final w = _rand(rng, 2, 8);
  final h = _rand(rng, 2, 7);
  final ans = Geometry.boxSurface(l, w, h);
  return _q(
    templateId: 'surf.box',
    seed: seed,
    nodeId: 'surface_box',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '长方体长 ${_m(l)}、宽 ${_m(w)}、高 ${_m(h)}。表面积是多少？',
    answer: '$ans',
    hints: ['表面积 ${_m('2(长宽 + 长高 + 宽高)')}。'],
    steps: ['表面积是 ${_m(ans)}。'],
    figure: BoxFigure(length: '$l', width: '$w', height: '$h'),
    nodeRefs: ['surface_box'],
  );
}

GeneratedQuestion _surfCube(int seed, Difficulty d) {
  final rng = Random(seed);
  final s = _rand(rng, 2, 9);
  return _q(
    templateId: 'surf.cube',
    seed: seed,
    nodeId: 'surface_box',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '棱长 ${_m(s)} 的正方体，表面积是多少？',
    answer: '${6 * s * s}',
    hints: ['六个面，每个 ${_m('$s^2')}。'],
    steps: ['${_m('6 \\times $s^2 = ${6 * s * s}')}。'],
    figure: BoxFigure(length: '$s', width: '$s', height: '$s', cube: true),
    nodeRefs: ['surface_box'],
  );
}

GeneratedQuestion _cangInscribed(int seed, Difficulty d) {
  final rng = Random(seed);
  final central = 2 * _rand(rng, 20, 80);
  final ans = Geometry.inscribedFromCentral(central);
  return _q(
    templateId: 'cang.inscribed',
    seed: seed,
    nodeId: 'circle_angle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '圆心角 ${_m('$central^\\circ')}，同弧所对的圆周角是多少度？只写数字。',
    answer: '$ans',
    hints: ['圆周角是同弧圆心角的一半。'],
    steps: ['圆周角 ${_m(ans)} 度。'],
    figure: CircleAngleFigure(central: '$central', inscribed: '?'),
    nodeRefs: ['circle_angle'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _cangDiameter(int seed, Difficulty d) {
  final rng = Random(seed);
  final a = _rand(rng, 20, 70);
  final other = 90 - a;
  return _q(
    templateId: 'cang.diameter',
    seed: seed,
    nodeId: 'circle_angle',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '直径所对的圆周角是直角。直角三角形斜边为直径，一个锐角 ${_m('$a^\\circ')}。另一个锐角多少度？只写数字。',
    answer: '$other',
    hints: ['直径所对圆周角 90 度，两锐角互余。'],
    steps: ['${_m('90 - $a = $other')}。'],
    figure: CircleAngleFigure(diameter: true, acuteAtA: '$a'),
    nodeRefs: ['circle_angle', 'triangle_angle'],
    answerRange: (min: 1, max: 179),
  );
}

GeneratedQuestion _solidCyl(int seed, Difficulty d) {
  final rng = Random(seed);
  final r = [7, 14][rng.nextInt(2)];
  final h = _rand(rng, 2, 6);
  final ans = Geometry.cylinderVol22(r, h);
  return _q(
    templateId: 'solid.cyl',
    seed: seed,
    nodeId: 'solid_adv',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '圆柱底半径 ${_m(r)}、高 ${_m(h)}，取 ${_m('\\pi = 22/7')}。体积是多少？',
    answer: '$ans',
    hints: ['体积 ${_m('\\pi r^2 h')}。'],
    steps: ['体积是 ${_m(ans)}。'],
    figure: RevolutionFigure(
      kind: RevolutionKind.cylinder,
      radius: '$r',
      height: '$h',
    ),
    nodeRefs: ['solid_adv', 'circle_measure'],
  );
}

GeneratedQuestion _solidCone(int seed, Difficulty d) {
  final rng = Random(seed);
  final r = 7;
  final h = [3, 6, 9][rng.nextInt(3)];
  final ans = Geometry.coneVol22(r, h);
  return _q(
    templateId: 'solid.cone',
    seed: seed,
    nodeId: 'solid_adv',
    difficulty: d,
    kind: QuestionKind.fill,
    stem: '圆锥底半径 ${_m(r)}、高 ${_m(h)}，取 ${_m('\\pi = 22/7')}。体积是多少？',
    answer: '$ans',
    hints: ['圆锥体积是等底等高圆柱的三分之一。'],
    steps: ['体积是 ${_m(ans)}。'],
    figure: RevolutionFigure(
      kind: RevolutionKind.cone,
      radius: '$r',
      height: '$h',
    ),
    nodeRefs: ['solid_adv'],
  );
}
