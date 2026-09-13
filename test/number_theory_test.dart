import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/number_theory.dart';

void main() {
  group('NumberTheory', () {
    test('gcd / lcm / coprime', () {
      expect(NumberTheory.gcd(48, 18), 6);
      expect(NumberTheory.gcd(17, 13), 1);
      expect(NumberTheory.lcm(12, 18), 36);
      expect(NumberTheory.isCoprime(8, 15), isTrue);
      expect(NumberTheory.isCoprime(15, 25), isFalse);
    });

    test('divMod remainder is non-negative and less than divisor', () {
      final r = NumberTheory.divMod(17, 5);
      expect(r.q, 3);
      expect(r.r, 2);
      expect(NumberTheory.divides(12, 60), isTrue);
      expect(NumberTheory.divides(7, 16), isFalse);
    });

    test('primes and sieve', () {
      expect(NumberTheory.isPrime(1), isFalse);
      expect(NumberTheory.isPrime(2), isTrue);
      expect(NumberTheory.isPrime(91), isFalse);
      expect(NumberTheory.primesUpTo(10), [2, 3, 5, 7]);
      expect(NumberTheory.primeCountInRange(10, 20), 4);
      expect(NumberTheory.nextPrime(14), 17);
      expect(NumberTheory.smallestPrimeFactor(91), 7);
    });

    test('factorization and divisors', () {
      expect(NumberTheory.factorize(12), {2: 2, 3: 1});
      expect(NumberTheory.formatFactorization({2: 3, 3: 1, 5: 1}), '2^3*3*5');
      expect(NumberTheory.divisorCount(12), 6);
      expect(NumberTheory.positiveDivisors(12), [1, 2, 3, 4, 6, 12]);
    });

    test('divisibility rules', () {
      expect(NumberTheory.divisibleBy3(258), isTrue);
      expect(NumberTheory.divisibleBy9(258), isFalse);
      expect(NumberTheory.divisibleBy11(121), isTrue);
      expect(NumberTheory.divisibleBy2(14), isTrue);
      expect(NumberTheory.divisibleBy5(40), isTrue);
    });

    test('missing digit unique candidate', () {
      final hits = NumberTheory.missingDigitCandidates(
        digits: [1, 2, null, 5],
        divisor: 9,
      );
      expect(hits, [1]);
    });

    test('answer normalization', () {
      expect(NumberTheory.answersEqual('2^3*3', '2^3 * 3'), isTrue);
      expect(NumberTheory.answersEqual('是', 'yes'), isTrue);
      expect(NumberTheory.answersEqual('否', '不能'), isTrue);
      expect(NumberTheory.numericallyClose('100', '96'), isTrue);
    });

    test('a right value marks right however it is written', () {
      // Same factorisation, spelled out or reordered.
      expect(NumberTheory.answersEqual('2^2*7', '2*2*7'), isTrue);
      expect(NumberTheory.answersEqual('2^2*7', '7*2^2'), isTrue);
      expect(NumberTheory.answersEqual('2^2*7', '2^2*5'), isFalse);
      // Equal fractions, reduced or not, and the decimal for one.
      expect(NumberTheory.answersEqual('1/2', '2/4'), isTrue);
      expect(NumberTheory.answersEqual('1/2', '0.5'), isTrue);
      expect(NumberTheory.answersEqual('3', '6/2'), isTrue);
      expect(NumberTheory.answersEqual('1/2', '1/3'), isFalse);
      expect(NumberTheory.answersEqual('1/2', '0.51'), isFalse);
      expect(NumberTheory.answersEqual('-1/2', '1/2'), isFalse);
    });

    test('1 and 0 mean yes and no only where the answer is 是 or 否', () {
      expect(NumberTheory.answersEqual('是', '1'), isTrue);
      expect(NumberTheory.answersEqual('否', '0'), isTrue);
      // A count of 1 is the number one, not agreement.
      expect(NumberTheory.answersEqual('1', '是'), isFalse);
      expect(NumberTheory.answersEqual('0', '否'), isFalse);
      expect(NumberTheory.answersEqual('1', 'yes'), isFalse);
    });

    test('modular arithmetic and euler', () {
      expect(NumberTheory.mod(-7, 3), 2);
      expect(NumberTheory.congruent(17, 5, 12), isTrue);
      expect(NumberTheory.powMod(3, 4, 5), 1);
      expect(NumberTheory.phi(8), 4);
      expect(NumberTheory.phi(15), 8);
      expect(NumberTheory.crt2(2, 3, 3, 5), 8);
      expect(NumberTheory.factorialValuation(100, 5), 24);
      expect(NumberTheory.floorDiv(-7, 3), -3);
      expect(NumberTheory.divMod(-7, 3).r, 2);
    });

    test('perfect squares and last digits of powers', () {
      expect(NumberTheory.isPerfectSquare(49), isTrue);
      expect(NumberTheory.isPerfectSquare(50), isFalse);
      expect(NumberTheory.canBeSquareEnding(7), isFalse);
      expect(NumberTheory.canBeSquareEnding(6), isTrue);
      expect(NumberTheory.powerLast(2, 10), 4);
      expect(NumberTheory.powerLast(7, 5), 7);
      expect(NumberTheory.divisorSum(12), 28);
      expect(NumberTheory.digitRoot(38), 2);
      expect(NumberTheory.digitRoot(999), 9);
      expect(NumberTheory.countMultiples(100, 7), 14);
      expect(NumberTheory.oddDivisorCount(12), 2);
      expect(NumberTheory.powerLastTwo(2, 10), 24);
      expect(NumberTheory.parseShown(101, 2), 5);
      expect(NumberTheory.recipPeriod(7), 6);
      expect(NumberTheory.recipPeriod(2), 0);
      expect(NumberTheory.nextMultipleAbove(20, 6), 24);
      expect(NumberTheory.mulShown(11, 10, 2), 6);
      expect(NumberTheory.repunit(4), 1111);
      expect(NumberTheory.trailingZeros(25), 6);
    });

    test('linear diophantine positive counts', () {
      expect(NumberTheory.positiveSolutionCount(3, 5, 30), 1);
      expect(NumberTheory.positiveSolutionCount(3, 5, 45), 2);
      expect(NumberTheory.positiveSolutionCount(6, 9, 5), 0);
      final e = NumberTheory.egcd(3, 5);
      expect(e.g, 1);
      expect(3 * e.x + 5 * e.y, 1);
    });
  });
}
