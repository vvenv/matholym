import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/algebra.dart';
import 'package:matholym/domain/geometry.dart';

void main() {
  test('algebra word-problem identities', () {
    expect(Algebra.linearRoot(3, 5, 17), 4);
    expect(Algebra.fromSumDiff(30, 8), (larger: 19, smaller: 11));
    expect(
      Algebra.peopleFromExcessDeficit(
        perMore: 3,
        leftover: 2,
        perLess: 4,
        short: 2,
      ),
      4,
    );
    expect(Algebra.shareByRatio(total: 60, part: 2, other: 3), 24);
    expect(Algebra.meetTime(dist: 120, v1: 20, v2: 10), 4);
    expect(Algebra.catchTime(lead: 12, fast: 8, slow: 5), 4);
    expect(Algebra.togetherDays(6, 3), 2);
    expect(Algebra.largestIntLess(2, 3, 11), 3);
    expect(Algebra.arithTerm(3, 2, 5), 11);
    expect(Algebra.arithSum(3, 2, 5), 35);
    expect(Algebra.mixPercent(w1: 2, p1: 10, w2: 3, p2: 20), 16);
    expect(
      Algebra.chickenRabbit(heads: 10, legs: 28),
      (chickens: 6, rabbits: 4),
    );
    expect(Algebra.treesOnLine(length: 20, gap: 5), 5);
    expect(Algebra.treesOnCircle(length: 30, gap: 5), 6);
    expect(Algebra.yearsUntil(older: 30, younger: 6, times: 2), 18);
    expect(Algebra.formationEdge(5), 16);
    expect(Algebra.grassDays(stock: 80, grow: 4, cows: 8), 20);
    expect(Algebra.amGmMin(4), 4);
    expect(Algebra.downstream(still: 8, current: 2, dist: 30), 3);
    expect(Algebra.upstream(still: 8, current: 2, dist: 30), 5);
    expect(Algebra.trainPass(trainLen: 100, bridgeLen: 200, speed: 50), 6);
    expect(Algebra.salePrice(price: 80, off: 25), 60);
    expect(Algebra.geoTerm(3, 2, 5), 48);
    expect(Algebra.solveTwo(a1: 1, b1: 1, c1: 8, a2: 2, b2: 1, c2: 11), (x: 3, y: 5));
    expect(Algebra.simpleInterest(principal: 200, rate: 10, years: 3), 60);
    expect(Algebra.compoundAmount(principal: 100, rate: 10, years: 2), 121);
    expect(Algebra.directY(knownX: 2, knownY: 8, askX: 5), 20);
    expect(Algebra.inverseY(knownX: 6, knownY: 8, askX: 4), 12);
    expect(Algebra.taxiFare(baseKm: 3, baseFare: 10, extraPer: 2, dist: 8), 20);
    expect(Algebra.openCount(3, 8), 4);
    expect(Algebra.vertexX(1, -6), 3);
    expect(Algebra.vertexY(1, -6, 8), -1);
    expect(Algebra.discriminant(1, 5, 6), 1);
    expect(Algebra.absLarger(3, 5), 8);
    expect(Algebra.nextWithRemainder(after: 20, modulus: 6, residue: 2), 26);
    expect(Algebra.chainShare(total: 18, part: 2, parts: 9), 4);
    expect(Algebra.yInterceptQuad(8), 8);
    expect(Algebra.invK(3, 4), 12);
    expect(Algebra.quadMinWhenAPos(1, -6, 8), -1);
  });

  test('geometry measure identities', () {
    expect(Geometry.complement(35), 55);
    expect(Geometry.supplement(35), 145);
    expect(Geometry.rectPerimeter(8, 5), 26);
    expect(Geometry.triangleArea(10, 6), 30);
    expect(Geometry.trapArea(5, 9, 4), 28);
    expect(Geometry.circleCirc22(7), 44);
    expect(Geometry.circleArea22(7), 154);
    expect(Geometry.canTriangle(3, 5, 7), isTrue);
    expect(Geometry.canTriangle(3, 5, 8), isFalse);
    expect(Geometry.boxVolume(5, 4, 3), 60);
    expect(Geometry.boxSurface(5, 4, 3), 94);
    expect(Geometry.cutSquare(10, 4), 84);
    expect(Geometry.inscribedFromCentral(80), 40);
    expect(Geometry.cylinderVol22(7, 3), 462);
    expect(Geometry.coneVol22(7, 3), 154);
    expect(Geometry.polygonInterior(6), 720);
    expect(Geometry.regularExterior(8), 45);
    expect(Geometry.sectorArc22(14, 90), 22);
    expect(Geometry.sphereVolPi(3), 36);
    expect(Geometry.sphereSurfPi(5), 100);
    expect(Geometry.unfoldHypot(3, 4), 5);
    expect(Geometry.hypotInt(3, 4), 5);
    expect(Geometry.coneUnfoldDeg(3, 5), 216);
    expect(Geometry.incircleTangent(5, 4, 3), 1);
    expect(Geometry.trapMidline(5, 9), 7);
    expect(
      Geometry.similarArea(knownArea: 8, knownRatio: 2, askRatio: 3),
      18,
    );
    expect(
      Geometry.similarSide(known: 4, knownRatio: 2, askRatio: 3),
      6,
    );
    expect(Geometry.chordMate(a: 3, b: 8, c: 4), 6);
    expect(Geometry.tanSecant(external: 4, whole: 9), 6);
    expect(Geometry.bisectSegment(side: 12, adjLeft: 6, adjRight: 3), 8);
    expect(Geometry.tangentialFourth(6, 8, 7), 5);
    expect(Geometry.altitudeArea(knownArea: 12, knownBase: 4, askBase: 6), 18);
    expect(Geometry.exteriorAngle(40, 60), 100);
    expect(Geometry.isoBaseAngle(80), 50);
    expect(Geometry.isoVertex(50), 80);
    expect(Geometry.cyclicExterior(70), 70);
  });
}
