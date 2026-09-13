import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/generators/catalog.dart';
import 'package:matholym/domain/generators/choices.dart';
import 'package:matholym/domain/generators/question.dart';
import 'package:matholym/domain/number_theory.dart';

const _seeds = [1, 2, 3, 7, 11, 17, 23, 42, 99, 123, 555, 2024];

/// Sweeps the whole catalogue. A distractor has to be a wrong answer a
/// student could believe — not a typo, not the answer with a digit stuck on.
void main() {
  test('a bounded answer never shows an impossible option', () {
    final bad = <String>[];
    for (final t in questionTemplates) {
      for (final d in t.difficulties) {
        for (final seed in _seeds) {
          final q = t.build(seed, d);
          final range = q.answerRange;
          if (range == null) continue;
          for (final o in QuestionOptions.of(q)) {
            final v = int.parse(o);
            if (v < range.min || v > range.max) {
              bad.add('${t.id} seed=$seed :: $o outside '
                  '${range.min}..${range.max}');
            }
          }
        }
      }
    }
    expect(bad, isEmpty);
  });

  test('every answer has a shape the choice bank understands', () {
    final blind = <String>{};
    for (final t in questionTemplates) {
      for (final d in t.difficulties) {
        for (final seed in _seeds) {
          final q = t.build(seed, d);
          if (q.kind == QuestionKind.judge || q.choices.isNotEmpty) continue;
          if (QuestionOptions.bankFor(q.answer).length < 3) {
            blind.add('${t.id} -> ${q.answer}');
          }
        }
      }
    }
    expect(blind, isEmpty);
  });

  test('four distinct options, one of them the answer', () {
    final bad = <String>[];
    for (final t in questionTemplates) {
      for (final d in t.difficulties) {
        for (final seed in _seeds) {
          final q = t.build(seed, d);
          final opts = QuestionOptions.of(q);
          if (q.kind == QuestionKind.judge) {
            expect(opts, ['是', '否'], reason: t.id);
            continue;
          }
          final where = '${t.id} ${d.name} seed=$seed :: $opts';
          // Four options, unless the answer space itself is smaller — a
          // residue mod 3 has three candidates and inventing a fourth would
          // mean printing something that cannot be an answer.
          final range = q.answerRange;
          final room = range == null ? 4 : range.max - range.min + 1;
          if (opts.length != (room < 4 ? room : 4)) bad.add('count $where');
          if (!opts.contains(q.answer)) bad.add('missing answer $where');
          for (var i = 0; i < opts.length; i++) {
            for (var j = i + 1; j < opts.length; j++) {
              if (NumberTheory.answersEqual(opts[i], opts[j])) {
                bad.add('same value $where');
              }
            }
          }
        }
      }
    }
    expect(bad, isEmpty);
  });

  test('options share the answer shape and never leak it', () {
    final bad = <String>[];
    for (final t in questionTemplates) {
      for (final d in t.difficulties) {
        for (final seed in _seeds) {
          final q = t.build(seed, d);
          if (q.kind == QuestionKind.judge) continue;
          final opts = QuestionOptions.of(q);
          final want = _shape(q.answer);
          final where = '${t.id} ${d.name} seed=$seed :: ${q.answer} $opts';
          for (final o in opts) {
            if (_shape(o) != want) bad.add('shape $where');
            if (o.endsWith('.') || o.trim() != o) bad.add('junk $where');
            // A count is never negative; a signed answer may keep its sign.
            if (!q.answer.startsWith('-') && o.startsWith('-')) {
              bad.add('sign $where');
            }
          }
        }
      }
    }
    expect(bad, isEmpty);
  });

  test('fraction answers are reduced and never written over 1', () {
    final bad = <String>[];
    for (final t in questionTemplates) {
      for (final d in t.difficulties) {
        for (final seed in _seeds) {
          final q = t.build(seed, d);
          for (final s in [q.answer, ...QuestionOptions.of(q)]) {
            final m = RegExp(r'^(-?\d+)/(\d+)$').firstMatch(s);
            if (m == null) continue;
            final n = int.parse(m.group(1)!).abs();
            final den = int.parse(m.group(2)!);
            if (den == 1 || NumberTheory.gcd(n, den) != 1) {
              bad.add('${t.id} seed=$seed :: $s');
            }
          }
        }
      }
    }
    expect(bad, isEmpty);
  });

  test('factorisations stay canonical: primes ascending, no bare exponent 1', () {
    final bad = <String>[];
    for (final t in questionTemplates) {
      for (final d in t.difficulties) {
        for (final seed in _seeds) {
          final q = t.build(seed, d);
          for (final s in [q.answer, ...QuestionOptions.of(q)]) {
            if (!s.contains('*') && !s.contains('^')) continue;
            final parts = s.split('*');
            var previous = 1;
            for (final part in parts) {
              final m = RegExp(r'^(\d+)(?:\^(\d+))?$').firstMatch(part);
              if (m == null) {
                bad.add('${t.id} seed=$seed :: $s');
                break;
              }
              final base = int.parse(m.group(1)!);
              if (base <= previous) bad.add('${t.id} order :: $s');
              if (!NumberTheory.isPrime(base)) bad.add('${t.id} composite :: $s');
              if (part.endsWith('^1')) bad.add('${t.id} exponent :: $s');
              previous = base;
            }
          }
        }
      }
    }
    expect(bad, isEmpty);
  });

  test('a bank leads with the mistake a student makes', () {
    expect(QuestionOptions.bankFor('12'), contains('11'));
    expect(QuestionOptions.bankFor('12'), contains('13'));
    // The sign slip is the whole point of a negative answer.
    expect(QuestionOptions.bankFor('-5'), contains('5'));
    // Fractions stay fractions; the flip is a real error, `4/4` is not.
    expect(QuestionOptions.bankFor('3/4'), contains('4/3'));
    expect(QuestionOptions.bankFor('3/4').every((e) => e.contains('/')), isTrue);
    // 商,余数: swapping the two is the classic slip.
    expect(QuestionOptions.bankFor('7,3'), contains('3,7'));
    // Counting 1 as a prime.
    expect(QuestionOptions.bankFor('2,3,5,7'), contains('1,2,3,5,7'));
    // Wrong exponent, missing factor — still a factorisation.
    expect(QuestionOptions.bankFor('2^2*7'), contains('2^3*7'));
    expect(QuestionOptions.bankFor('2^2*7'), contains('2*7'));
  });
}

String _shape(String s) {
  if (RegExp(r'^-?\d+$').hasMatch(s)) return 'int';
  if (RegExp(r'^-?\d+/\d+$').hasMatch(s)) return 'frac';
  if (RegExp(r'^-?\d+(\.\d+)$').hasMatch(s)) return 'decimal';
  if (RegExp(r'^-?\d+(,-?\d+)+$').hasMatch(s)) return 'list';
  if (RegExp(r'^\d+(\^\d+)?(\*\d+(\^\d+)?)*$').hasMatch(s)) return 'factored';
  return 'text';
}
