import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/calculation.dart';
import 'package:matholym/domain/olympiad_logic.dart';

void main() {
  test('fraction, page, and new-operation identities', () {
    expect(Calculation.addFrac(1, 2, 1, 3), (n: 5, d: 6));
    expect(Calculation.mulFrac(2, 3, 9, 4), (n: 3, d: 2));
    expect(Calculation.compareFrac(3, 4, 2, 3) > 0, isTrue);
    expect(Calculation.repeatingOne(3), (n: 1, d: 3));
    expect(Calculation.repeatingTwo(12), (n: 4, d: 33));
    expect(Calculation.star(2, 3), 11);
    expect(Calculation.telescoping(2, 5), (n: 3, d: 10));
    expect(Calculation.pageDigits(11), 13);
    expect(Calculation.pageDigits(100), 192);
    expect(Calculation.complexFrac(1, 2, 1, 3), (n: 3, d: 2));
    expect(Calculation.mean([4, 8, 12]), 8);
    expect(Calculation.fracOf(total: 24, num: 3, den: 4), 18);
    expect(Calculation.fromFracOf(part: 10, num: 2, den: 5), 25);
    expect(Calculation.gaussSum(100), 5050);
    expect(Calculation.oddSum(4), 16);
    expect(Calculation.powInt(2, 5), 32);
    expect(Calculation.roundTo(value: 398, place: 100), 400);
    expect(Calculation.weightedMean([80, 90, 70], [2, 2, 1]), 82);
    expect(Calculation.sqDiff(100, 3), 9991);
    expect(Calculation.completeSq(10, 3), 169);
    expect(Calculation.periodSum([2, 5], 5), 16);
    expect(Calculation.squareSum(5), 55);
    expect(Calculation.magicLine(3), 15);
    expect(Calculation.egyptMate(5), 30);
    expect(Calculation.harmonicSpeed(3, 6), 4);
    expect(Calculation.digitSwapDiff(7, 2), 45);
    expect(Calculation.magic3(0)[1][1], 5);
    expect(Calculation.cubeSum(5), 225);
    expect(Calculation.shiftTenths(35, 2), 350);
    expect(Calculation.timesTenPow(3, 3), 3000);
  });

  test('logic weighings, clock, digits, and invariants', () {
    expect(OlympiadLogic.weighings(9), 2);
    expect(OlympiadLogic.weighings(27), 3);
    expect(OlympiadLogic.weekdayShift(3, 10), 6);
    expect(OlympiadLogic.clockAngle(3, 0), 90);
    expect(OlympiadLogic.clockAngle(2, 20), 50);
    expect(OlympiadLogic.largestWithDigitSum(digits: 3, sum: 5), 500);
    expect(OlympiadLogic.smallestWithDigitSum(digits: 3, sum: 5), 104);
    expect(OlympiadLogic.cycleReport(12, 5), 2);
    expect(OlympiadLogic.canClearTails(3), isFalse);
    expect(OlympiadLogic.canClearTails(4), isTrue);
    expect(OlympiadLogic.nimFirstTake(10, 3), 2);
    expect(OlympiadLogic.twoWorkerMin(2, 3, 4), 5);
    expect(OlympiadLogic.queueWait(ahead: 7, minutes: 3), 21);
    expect(OlympiadLogic.ropePieces(5), 6);
    expect(OlympiadLogic.maxLoad(cap: 100, each: 8), 12);
    expect(OlympiadLogic.boatTrips(4), 5);
    expect(OlympiadLogic.knockoutMatches(8), 7);
    expect(OlympiadLogic.roundRobin(6), 15);
    expect(OlympiadLogic.oppositeSeat(8, 3), 7);
    expect(OlympiadLogic.fromRight(7, 3), 5);
    expect(OlympiadLogic.weighIfBalance(27), 9);
    expect(OlympiadLogic.liarTriple(3), 5);
    expect(OlympiadLogic.wolfTrips, 7);
    expect(OlympiadLogic.goatOnBoat, 3);
    expect(OlympiadLogic.threeSay(5), 7);
    expect(OlympiadLogic.lightsOn(100), 10);
    expect(OlympiadLogic.exactlyKTrueIndex(), 1);
  });
}
