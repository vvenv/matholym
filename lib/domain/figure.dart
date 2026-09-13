/// Drawable study figures. Keep this file free of Flutter so generators can
/// attach a figure to a question the same way they attach a stem.
library;

sealed class MathFigure {
  const MathFigure({this.caption = ''});

  final String caption;

  String get semantics;
}

enum AnglePairKind { complement, supplement }

enum ParallelMark { corresponding, coInterior }

enum AxesKind { line, inverse, parabola }

class AnglePairFigure extends MathFigure {
  const AnglePairFigure({
    required this.given,
    required this.kind,
    super.caption,
  });

  final int given;
  final AnglePairKind kind;

  @override
  String get semantics => kind == AnglePairKind.complement
      ? '余角示意图，已知 $given 度'
      : '补角示意图，已知 $given 度';
}

class TriangleFigure extends MathFigure {
  const TriangleFigure({
    this.a = 'A',
    this.b = 'B',
    this.c = 'C',
    this.angleA,
    this.angleB,
    this.angleC,
    this.sideAB,
    this.sideBC,
    this.sideCA,
    this.rightAt,
    this.isoVertex,
    this.exteriorAt,
    this.exteriorLabel,
    this.heightLabel,
    this.midline = false,
    this.bisector = false,
    this.incircle = false,
    super.caption,
  });

  final String a;
  final String b;
  final String c;
  final String? angleA;
  final String? angleB;
  final String? angleC;
  final String? sideAB;
  final String? sideBC;
  final String? sideCA;
  final String? rightAt;
  final String? isoVertex;
  final String? exteriorAt;
  final String? exteriorLabel;
  final String? heightLabel;
  final bool midline;
  final bool bisector;
  final bool incircle;

  @override
  String get semantics => '三角形 $a$b$c 示意图';
}

class RectFigure extends MathFigure {
  const RectFigure({
    this.length,
    this.width,
    this.square = false,
    this.diagonal = false,
    super.caption,
  });

  final String? length;
  final String? width;
  final bool square;
  final bool diagonal;

  @override
  String get semantics => square ? '正方形示意图' : '长方形示意图';
}

class TrapezoidFigure extends MathFigure {
  const TrapezoidFigure({
    this.top,
    this.bottom,
    this.height,
    this.midline,
    this.parallelogram = false,
    super.caption,
  });

  final String? top;
  final String? bottom;
  final String? height;
  final String? midline;
  final bool parallelogram;

  @override
  String get semantics => parallelogram ? '平行四边形示意图' : '梯形示意图';
}

class ParallelFigure extends MathFigure {
  const ParallelFigure({
    this.angle,
    this.mark = ParallelMark.corresponding,
    super.caption,
  });

  final String? angle;
  final ParallelMark mark;

  @override
  String get semantics => '平行线截线示意图';
}

class CircleMeasureFigure extends MathFigure {
  const CircleMeasureFigure({this.radius = 'r', super.caption});

  final String radius;

  @override
  String get semantics => '圆，半径 $radius';
}

class CircleAngleFigure extends MathFigure {
  const CircleAngleFigure({
    this.central,
    this.inscribed,
    this.secondInscribed,
    this.diameter = false,
    this.acuteAtA,
    super.caption,
  });

  final String? central;
  final String? inscribed;
  final String? secondInscribed;
  final bool diameter;
  final String? acuteAtA;

  @override
  String get semantics => diameter ? '直径所对圆周角示意图' : '圆心角与圆周角示意图';
}

class CyclicQuadFigure extends MathFigure {
  const CyclicQuadFigure({
    this.interior,
    this.exterior,
    this.showExterior = false,
    super.caption,
  });

  final String? interior;
  final String? exterior;
  final bool showExterior;

  @override
  String get semantics => showExterior ? '圆内接四边形外角示意图' : '圆内接四边形示意图';
}

class ChordsFigure extends MathFigure {
  const ChordsFigure({this.a, this.b, this.c, this.d, super.caption});

  final String? a;
  final String? b;
  final String? c;
  final String? d;

  @override
  String get semantics => '相交弦示意图';
}

class TangentFigure extends MathFigure {
  const TangentFigure({
    this.twoTangents = false,
    this.tangentialQuad = false,
    this.length,
    this.external,
    this.whole,
    this.sides = const [],
    super.caption,
  });

  final bool twoTangents;
  final bool tangentialQuad;
  final String? length;
  final String? external;
  final String? whole;

  /// Side labels AB, BC, CD, DA for a tangential quadrilateral.
  final List<String?> sides;

  @override
  String get semantics => twoTangents
      ? '圆外一点两切线示意图'
      : tangentialQuad
      ? '圆外切四边形示意图'
      : '切割线示意图';
}

class SimilarPairFigure extends MathFigure {
  const SimilarPairFigure({
    this.ratio = '2:3',
    this.smallSide,
    this.congruent = false,
    super.caption,
  });

  final String ratio;
  final String? smallSide;
  final bool congruent;

  @override
  String get semantics => congruent ? '全等三角形示意图' : '相似三角形示意图';
}

class FrameFigure extends MathFigure {
  const FrameFigure({
    required this.outer,
    required this.border,
    this.cutInner,
    super.caption,
  });

  final String outer;
  final String border;
  final String? cutInner;

  @override
  String get semantics => '挖空正方形示意图';
}

class BoxFigure extends MathFigure {
  const BoxFigure({
    this.length,
    this.width,
    this.height,
    this.cube = false,
    super.caption,
  });

  final String? length;
  final String? width;
  final String? height;
  final bool cube;

  @override
  String get semantics => cube ? '正方体示意图' : '长方体示意图';
}

class GridFigure extends MathFigure {
  const GridFigure({
    required this.rows,
    required this.cols,
    this.cells = const [],
    super.caption,
  });

  final int rows;
  final int cols;
  final List<String?> cells;

  @override
  String get semantics => '$rows 行 $cols 列数表示意图';
}

class CrossFigure extends MathFigure {
  const CrossFigure({
    this.center,
    this.up,
    this.down,
    this.left,
    this.right,
    super.caption,
  });

  final String? center;
  final String? up;
  final String? down;
  final String? left;
  final String? right;

  @override
  String get semantics => '十字数阵示意图';
}

class AxesFigure extends MathFigure {
  const AxesFigure({
    required this.kind,
    this.k,
    this.b,
    this.h,
    this.m,
    this.point,
    super.caption,
  });

  final AxesKind kind;
  final int? k;
  final int? b;
  final int? h;
  final int? m;
  final (int, int)? point;

  @override
  String get semantics => switch (kind) {
    AxesKind.line => '一次函数示意图',
    AxesKind.inverse => '反比例函数示意图',
    AxesKind.parabola => '抛物线示意图',
  };
}

class LightsFigure extends MathFigure {
  const LightsFigure({
    required this.count,
    this.highlight,
    this.onSquares = false,
    super.caption,
  });

  final int count;
  final int? highlight;
  final bool onSquares;

  @override
  String get semantics => '开关灯示意图，$count 盏';
}

class LatticeFigure extends MathFigure {
  const LatticeFigure({
    required this.right,
    required this.up,
    this.blockRight,
    this.blockUp,
    super.caption,
  });

  final int right;
  final int up;
  final int? blockRight;
  final int? blockUp;

  @override
  String get semantics => '格点路径示意图';
}

enum RevolutionKind { cylinder, cone }

enum SymmetryKind { xAxis, origin }

class RevolutionFigure extends MathFigure {
  const RevolutionFigure({
    required this.kind,
    this.radius = 'r',
    this.height = 'h',
    this.slant,
    super.caption,
  });

  final RevolutionKind kind;
  final String radius;
  final String height;
  final String? slant;

  @override
  String get semantics => kind == RevolutionKind.cylinder ? '圆柱示意图' : '圆锥示意图';
}

class SphereFigure extends MathFigure {
  const SphereFigure({this.radius = 'r', super.caption});

  final String radius;

  @override
  String get semantics => '球示意图，半径 $radius';
}

class PolygonFigure extends MathFigure {
  const PolygonFigure({
    required this.sides,
    this.exterior = false,
    this.fan = false,
    this.angle,
    super.caption,
  });

  final int sides;
  final bool exterior;
  final bool fan;
  final String? angle;

  @override
  String get semantics => exterior ? '正多边形外角示意图' : '$sides 边形示意图';
}

class SectorFigure extends MathFigure {
  const SectorFigure({
    this.radius = 'r',
    this.degrees = 90,
    this.angle,
    this.arc,
    super.caption,
  });

  final String radius;
  final int degrees;
  final String? angle;
  final String? arc;

  @override
  String get semantics => '扇形示意图，圆心角 $degrees 度';
}

class SymmetryFigure extends MathFigure {
  const SymmetryFigure({
    required this.kind,
    required this.x,
    required this.y,
    super.caption,
  });

  final SymmetryKind kind;
  final int x;
  final int y;

  @override
  String get semantics =>
      kind == SymmetryKind.xAxis ? '关于 x 轴的对称示意图' : '关于原点的对称示意图';
}

class NetFigure extends MathFigure {
  const NetFigure({this.cube = true, super.caption});

  final bool cube;

  @override
  String get semantics => cube ? '正方体展开图' : '长方体展开图';
}

class ReflectPathFigure extends MathFigure {
  const ReflectPathFigure({this.width, this.rise, this.path, super.caption});

  final String? width;
  final String? rise;
  final String? path;

  @override
  String get semantics => '镜面最短路示意图';
}

class InterceptFigure extends MathFigure {
  const InterceptFigure({
    this.ad,
    this.db,
    this.ae,
    this.ec,
    this.ratioLeft = 2,
    this.ratioRight = 3,
    super.caption,
  });

  final String? ad;
  final String? db;
  final String? ae;
  final String? ec;
  final int ratioLeft;
  final int ratioRight;

  @override
  String get semantics => '平行截线示意图';
}

/// Static illustration for a knowledge card, if that node is spatial.
MathFigure? cardFigureFor(String nodeId) {
  return switch (nodeId) {
    'angle_basic' => const AnglePairFigure(
      given: 35,
      kind: AnglePairKind.complement,
    ),
    'perimeter' => const RectFigure(length: '8', width: '5'),
    'rect_area' => const RectFigure(length: '8', width: '5'),
    'triangle_area' => const TriangleFigure(sideAB: 'a', heightLabel: 'h'),
    'trap_area' => const TrapezoidFigure(top: 'a', bottom: 'b', height: 'h'),
    'circle_measure' => const CircleMeasureFigure(),
    'parallel_angle' => const ParallelFigure(
      angle: 'α',
      mark: ParallelMark.corresponding,
    ),
    'triangle_angle' => const TriangleFigure(
      angleA: '70',
      angleB: '50',
      angleC: '60',
    ),
    'triangle_ineq' => const TriangleFigure(
      sideAB: 'c',
      sideBC: 'a',
      sideCA: 'b',
    ),
    'pythagorean' => const TriangleFigure(
      rightAt: 'C',
      sideCA: 'a',
      sideBC: 'b',
      sideAB: 'c',
    ),
    'similar_tri' => const SimilarPairFigure(ratio: '2:3'),
    'area_ratio' => const SimilarPairFigure(ratio: '2:3'),
    'cong_tri' => const SimilarPairFigure(congruent: true),
    'box_volume' => const BoxFigure(length: '5', width: '4', height: '3'),
    'surface_box' => const BoxFigure(length: '5', width: '4', height: '3'),
    'cut_fill' => const FrameFigure(outer: '10', border: '2'),
    'circle_angle' => const CircleAngleFigure(central: '80', inscribed: '40'),
    'same_arc' => const CircleAngleFigure(
      inscribed: '35',
      secondInscribed: '35',
    ),
    'thales' => const CircleAngleFigure(diameter: true),
    'midline' => const TrapezoidFigure(top: 'a', bottom: 'b', midline: 'm'),
    'tangent_len' => const TangentFigure(twoTangents: true, length: 't'),
    'cyclic_quad' => const CyclicQuadFigure(),
    'cyclic_out' => const CyclicQuadFigure(
      interior: '70',
      exterior: '70',
      showExterior: true,
    ),
    'power_pt' => const ChordsFigure(a: 'a', b: 'b', c: 'c', d: 'd'),
    'ext_quad' => const TangentFigure(tangentialQuad: true),
    'ext_angle' => const TriangleFigure(
      angleA: '40',
      angleB: '70',
      exteriorAt: 'C',
      exteriorLabel: '110',
    ),
    'iso_base' => const TriangleFigure(
      isoVertex: 'C',
      angleC: '80',
      angleA: '50',
      angleB: '50',
    ),
    'altitude' => const TriangleFigure(sideAB: 'a', heightLabel: 'h'),
    'intercept' => const InterceptFigure(ad: '2', db: '3'),
    'bisector' => const TriangleFigure(
      bisector: true,
      sideBC: 'a',
      sideCA: 'b',
    ),
    'magic_sq' => const GridFigure(
      rows: 3,
      cols: 3,
      cells: ['2', '7', '6', '9', '5', '1', '4', '3', '8'],
    ),
    'grid_fill' => const GridFigure(
      rows: 2,
      cols: 2,
      cells: ['7', '5', '8', '?'],
    ),
    'cross_sum' => const CrossFigure(
      center: '5',
      up: '2',
      down: '4',
      left: '3',
      right: '6',
    ),
    'lattice_path' => const LatticeFigure(right: 3, up: 2),
    'lattice_ban' => const LatticeFigure(
      right: 2,
      up: 2,
      blockRight: 1,
      blockUp: 1,
    ),
    'light_sq' => const LightsFigure(count: 9, onSquares: true),
    'function_intro' => const AxesFigure(kind: AxesKind.line, k: 1, b: 2),
    'lin_zero' => const AxesFigure(kind: AxesKind.line, k: 2, b: -4),
    'inv_graph' => const AxesFigure(kind: AxesKind.inverse, k: 6),
    'quad_fn' => const AxesFigure(kind: AxesKind.parabola, h: 3, m: -1),
    'axis_int' => const AxesFigure(kind: AxesKind.parabola, h: 3, m: -1),
    'quad_ext' => const AxesFigure(kind: AxesKind.parabola, h: 2, m: 3),
    'solid_adv' => const RevolutionFigure(kind: RevolutionKind.cylinder),
    'poly_angle' => const PolygonFigure(sides: 6, fan: true),
    'sector_arc' => const SectorFigure(radius: 'r', degrees: 90, angle: '90'),
    'symmetry' => const SymmetryFigure(kind: SymmetryKind.xAxis, x: 3, y: 5),
    'net_solid' => const NetFigure(),
    'reflect_path' => const ReflectPathFigure(width: '3', rise: '4', path: '5'),
    'sphere_vol' => const SphereFigure(),
    'cone_slant' => const RevolutionFigure(
      kind: RevolutionKind.cone,
      radius: 'r',
      height: 'h',
      slant: 'l',
    ),
    _ => null,
  };
}
