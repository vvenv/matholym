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
  });
}
