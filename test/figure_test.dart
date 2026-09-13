import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/core/widgets/math_figure.dart';
import 'package:matholym/domain/figure.dart';
import 'package:matholym/domain/figure_geom.dart';
import 'package:matholym/domain/generators/catalog.dart';
import 'package:matholym/domain/generators/question.dart';
import 'package:matholym/domain/knowledge/geometry_graph.dart';

void main() {
  test('spatial nodes have a card figure', () {
    const ids = [
      'angle_basic',
      'pythagorean',
      'thales',
      'parallel_angle',
      'magic_sq',
      'lattice_path',
      'light_sq',
      'lin_zero',
      'inv_graph',
      'cyclic_out',
      'ext_quad',
      'tangent_len',
      'power_pt',
      'similar_tri',
      'cong_tri',
      'bisector',
      'solid_adv',
      'poly_angle',
      'sector_arc',
      'symmetry',
      'net_solid',
      'reflect_path',
      'sphere_vol',
      'cone_slant',
      'intercept',
    ];
    for (final id in ids) {
      expect(cardFigureFor(id), isNotNull, reason: id);
    }
  });

  test('every geometry node has a card figure', () {
    for (final node in geometryGraph.nodes) {
      expect(cardFigureFor(node.id), isNotNull, reason: node.id);
    }
  });

  test('geometry stems that describe a figure carry one', () {
    for (final id in [
      'tri.third',
      'pyth.hyp',
      'par.corr',
      'cang.inscribed',
      'tha.right',
      'mag.cell',
      'path.grid',
      'exq.side',
      'exq.sum',
      'tan.inc',
      'tan.eq',
      'ppt.chord',
      'ppt.tan',
      'sim.side',
      'cong.side',
      'cyc.ex',
      'bis.seg',
      'solid.cyl',
      'solid.cone',
      'poly.in',
      'poly.ex',
      'sec.arc',
      'sym.x',
      'net.faces',
      'refl.len',
      'sph.vol',
      'cone.l',
      'icp.seg',
    ]) {
      final q = questionEngine.generate(
        templateId: id,
        seed: 7,
        difficulty: Difficulty.basic,
      );
      expect(q.figure, isNotNull, reason: id);
    }
  });

  test('tangential quadrilateral sides are tangent to the incircle', () {
    final g = figStandardTangentialQuad();
    expect(g.vertices, hasLength(4));
    expect(g.touch, hasLength(4));
    for (final t in g.touch) {
      expect(figOnCircle(t, g.o, g.r), isTrue);
    }
    for (var i = 0; i < 4; i++) {
      final a = g.vertices[i];
      final b = g.vertices[(i + 1) % 4];
      expect(figPointLineDist(g.o, a, b), closeTo(g.r, 1e-9));
      expect(figOnCircle(g.touch[i], g.o, g.r), isTrue);
    }
  });

  test('two tangents meet the circle at right angles', () {
    final g = figStandardTwoTangents();
    expect(figOnCircle(g.a, g.o, g.r), isTrue);
    expect(figOnCircle(g.b, g.o, g.r), isTrue);
    expect(figPerp(g.a - g.o, g.a - g.p), isTrue);
    expect(figPerp(g.b - g.o, g.b - g.p), isTrue);
    expect((g.p.dist(g.a) - g.p.dist(g.b)).abs(), lessThan(1e-9));
  });

  test('tangent-secant is a true secant plus a tangent', () {
    final g = figStandardSecant();
    expect(figOnCircle(g.a, g.o, g.r), isTrue);
    expect(figOnCircle(g.b, g.o, g.r), isTrue);
    expect(figOnCircle(g.t, g.o, g.r), isTrue);
    expect(figCollinear(g.p, g.a, g.b), isTrue);
    expect(g.p.dist(g.a), lessThan(g.p.dist(g.b)));
    expect(figPerp(g.t - g.o, g.t - g.p), isTrue);
  });

  test('intersecting chords have endpoints on the circle', () {
    const o = FigPt(0, 0);
    const r = 1.0;
    final pts = figStandardChords(o, r);
    for (final p in pts) {
      expect(figOnCircle(p, o, r), isTrue);
    }
    final hit = figIntersect(pts[0], pts[1], pts[2], pts[3]);
    expect(hit, isNotNull);
    expect(hit!.dist(o), lessThan(r));
  });

  test('similar pair is a scaled copy; congruent pair is the same size', () {
    final small = figPlace(figSimilarShape, const FigPt(0, 0), 2);
    final large = figPlace(figSimilarShape, const FigPt(3, 0), 3);
    final ab = small[0].dist(small[1]);
    final de = large[0].dist(large[1]);
    final ac = small[0].dist(small[2]);
    final df = large[0].dist(large[2]);
    expect(de / ab, closeTo(3 / 2, 1e-9));
    expect(df / ac, closeTo(3 / 2, 1e-9));
    final one = figPlace(figSimilarShape, const FigPt(0, 0), 5);
    final two = figPlace(figSimilarShape, const FigPt(6, 0), 5);
    expect(one[0].dist(one[1]), closeTo(two[0].dist(two[1]), 1e-9));
  });

  test('angle bisector foot splits the opposite side in the adjacent ratio', () {
    const a = FigPt(0, 0);
    const b = FigPt(9, 0);
    const c = FigPt(2, 6);
    final f = figBisectorFoot(a, b, c);
    expect(figCollinear(a, f, b), isTrue);
    expect(f.dist(a) / f.dist(b), closeTo(c.dist(a) / c.dist(b), 1e-9));
  });

  test('regular polygon vertices lie on a circle', () {
    const o = FigPt(0, 0);
    const r = 2.0;
    final pts = figRegularPolygon(o, r, 6);
    expect(pts, hasLength(6));
    for (final q in pts) {
      expect(figOnCircle(q, o, r), isTrue);
    }
  });

  test('intercept cut is parallel to the base', () {
    const a = FigPt(0, 0);
    const b = FigPt(-4, 6);
    const c = FigPt(5, 6);
    const t = 2 / 5;
    final d = FigPt(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t);
    final e = FigPt(a.x + (c.x - a.x) * t, a.y + (c.y - a.y) * t);
    final de = e - d;
    final bc = c - b;
    expect(de.x * bc.y - de.y * bc.x, closeTo(0, 1e-9));
  });

  test('right triangle incircle touches all three sides', () {
    const a = FigPt(0, 0);
    const b = FigPt(8, 0);
    const c = FigPt(0, 6);
    final i = figIncenter(a, b, c);
    final rho = figInradius(a, b, c);
    expect(figPointLineDist(i, a, b), closeTo(rho, 1e-9));
    expect(figPointLineDist(i, b, c), closeTo(rho, 1e-9));
    expect(figPointLineDist(i, c, a), closeTo(rho, 1e-9));
  });

  testWidgets('every figure kind paints without throwing', (tester) async {
    final figures = <MathFigure>[
      const AnglePairFigure(given: 35, kind: AnglePairKind.complement),
      const TriangleFigure(rightAt: 'C', sideAB: '5', heightLabel: 'h'),
      const TriangleFigure(rightAt: 'C', incircle: true),
      const TriangleFigure(bisector: true, sideCA: '6', sideBC: '3'),
      const RectFigure(length: '8', width: '5', diagonal: true),
      const TrapezoidFigure(top: '3', bottom: '7', height: '4', midline: 'm'),
      const ParallelFigure(angle: '70', mark: ParallelMark.coInterior),
      const CircleMeasureFigure(radius: '7'),
      const CircleAngleFigure(central: '80', inscribed: '40'),
      const CircleAngleFigure(diameter: true),
      const CyclicQuadFigure(interior: '70', exterior: '?', showExterior: true),
      const ChordsFigure(a: '3', b: '8', c: '4', d: '?'),
      const TangentFigure(twoTangents: true, length: '6'),
      const TangentFigure(external: '4', whole: '9', length: '?'),
      const TangentFigure(tangentialQuad: true, sides: ['5', '6', '7', '?']),
      const SimilarPairFigure(ratio: '2:3', smallSide: '4'),
      const SimilarPairFigure(congruent: true, smallSide: '5'),
      const FrameFigure(outer: '10', border: '2'),
      const BoxFigure(length: '5', width: '4', height: '3'),
      const GridFigure(rows: 3, cols: 3, cells: ['2', '7', '6', '9', '5', '1', '4', '3', '?']),
      const CrossFigure(center: '5', up: '2', down: '4', left: '3', right: '?'),
      const AxesFigure(kind: AxesKind.line, k: 2, b: -4),
      const AxesFigure(kind: AxesKind.inverse, k: 6),
      const AxesFigure(kind: AxesKind.parabola, h: 2, m: 3),
      const LightsFigure(count: 9, onSquares: true),
      const LatticeFigure(right: 3, up: 2, blockRight: 1, blockUp: 1),
      const RevolutionFigure(kind: RevolutionKind.cylinder, radius: '7', height: '3'),
      const RevolutionFigure(kind: RevolutionKind.cone, radius: '3', height: '4', slant: '?'),
      const SphereFigure(radius: '5'),
      const PolygonFigure(sides: 6, fan: true),
      const PolygonFigure(sides: 8, exterior: true, angle: '?'),
      const SectorFigure(radius: '14', degrees: 90, angle: '90', arc: '?'),
      const SymmetryFigure(kind: SymmetryKind.xAxis, x: 3, y: 5),
      const NetFigure(),
      const ReflectPathFigure(width: '3', rise: '4', path: '?'),
      const InterceptFigure(ad: '4', db: '?', ratioLeft: 2, ratioRight: 3),
    ];
    for (final fig in figures) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MathFigureView(figure: fig)),
        ),
      );
      expect(find.byType(MathFigureView), findsOneWidget, reason: fig.semantics);
    }
  });
}
