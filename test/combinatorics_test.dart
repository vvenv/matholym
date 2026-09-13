import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/combinatorics.dart';

void main() {
  test('permutations, combinations, and lattice paths', () {
    expect(Counting.factorial(0), 1);
    expect(Counting.factorial(6), 720);
    expect(Counting.perm(7, 3), 210);
    expect(Counting.comb(8, 3), 56);
    expect(Counting.comb(10, 3), Counting.comb(10, 7));
    expect(Counting.latticePaths(3, 2), 10);
    expect(Counting.pigeonholeGuarantee(holes: 5, perHole: 3), 11);
    expect(Counting.stairWays(1), 1);
    expect(Counting.stairWays(2), 2);
    expect(Counting.stairWays(5), 8);
    expect(Counting.handshake(6), 15);
    expect(Counting.colorings(4, 2), 16);
    expect(Counting.chessBlack(3, 3), 5);
    expect(Counting.chessBlack(8, 8), 32);
    expect(Counting.circlePerm(5), 24);
    expect(Counting.starsBars(items: 7, bins: 3), 36);
    expect(Counting.starsBarsPositive(items: 7, bins: 3), 15);
    expect(Counting.derange(4), 9);
    expect(Counting.permWithRepeat(5, 2), 60);
    expect(Counting.nonAdjacent(7, 3), 10);
    expect(Counting.lineTwoApart(5), 72);
    expect(Counting.unlabeledHalves(3), 10);
    expect(Counting.adjColor(4, 3), 24);
    expect(Counting.binomRow(5), 32);
    expect(Counting.catalan(3), 5);
    expect(Counting.catalan(4), 14);
    expect(Counting.cycleColor(3, 3), 6);
    expect(Counting.partition(4), 5);
    expect(Counting.splitTwo(6), 3);
    expect(Counting.latticeAvoid(right: 2, up: 2, blockR: 1, blockU: 1), 2);
    expect(Counting.hockeyRight(5, 2), 20);
    expect(Counting.atLeast(5, 4), 6);
    expect(Counting.atLeastOne(4), 15);
  });
}
