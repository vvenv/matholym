import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/generators/catalog.dart';

import 'support/tex_arithmetic.dart';

/// A wrong step teaches the wrong thing, so every equation the catalogue can
/// print is evaluated, over every difficulty and a wide band of seeds.
void main() {
  test('the evaluator catches a false equation and clears a true one', () {
    expect(faultsIn(r'$2 + 2 = 5$'), hasLength(1));
    expect(faultsIn(r'$54 = 9 \times 6 + 0$'), isEmpty);
    expect(faultsIn(r'$-7 = 5 \times (-2) + 3$'), isEmpty);
    expect(faultsIn(r'$-7 = 5 \times (-1) + 3$'), hasLength(1));
    expect(faultsIn(r'$\frac{1}{2} + \frac{1}{3} = \frac{5}{6}$'), isEmpty);
    expect(faultsIn(r'$4! = 24$'), isEmpty);
    expect(faultsIn(r'$2^{5} = 32$'), isEmpty);
    expect(faultsIn(r'$\lfloor -7 / 2 \rfloor = -4$'), isEmpty);
    expect(faultsIn(r'$3 \times 4 \times 5 = 60$'), isEmpty);
    // Not arithmetic: left alone rather than guessed at.
    expect(faultsIn(r'$a \equiv b \pmod{m}$'), isEmpty);
    expect(faultsIn(r'$C_{5}^{3} = 10$'), isEmpty);
  });

  test('every equation the catalogue prints holds', () {
    final bad = <String>[];
    for (final t in questionTemplates) {
      for (final d in t.difficulties) {
        for (var seed = 1; seed <= 150; seed++) {
          final q = t.build(seed, d);
          for (final text in [q.stem, ...q.hints, ...q.steps]) {
            for (final fault in faultsIn(text)) {
              bad.add('${t.id} ${d.name} seed=$seed :: ${fault.span} '
                  '(${fault.left} vs ${fault.right})');
            }
          }
        }
      }
    }
    expect(bad, isEmpty, reason: '${bad.length} false equations');
  });
}
