import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/knowledge/graph.dart';
import 'package:matholym/domain/mastery.dart';
import 'package:matholym/domain/wrong_book.dart';

void main() {
  test('only root unlocked until prereqs mastered', () {
    final unlocked = MasteryRules.unlockedIds(
      graph: knowledgeGraph,
      masteredIds: {},
    );
    expect(unlocked, {kRootNodeId});
    expect(unlocked.contains('division_algorithm'), isFalse);
    expect(unlocked.contains('primes_composites'), isFalse);
  });

  test('mastering root unlocks its direct dependents', () {
    final unlocked = MasteryRules.unlockedIds(
      graph: knowledgeGraph,
      masteredIds: {kRootNodeId},
    );
    expect(unlocked.contains('division_algorithm'), isTrue);
    expect(unlocked.contains('primes_composites'), isTrue);
    expect(unlocked.contains('gcd'), isFalse);
  });

  test('gcd unlocks only after both prereqs mastered', () {
    final incomplete = MasteryRules.unlockedIds(
      graph: knowledgeGraph,
      masteredIds: {kRootNodeId, 'division_algorithm'},
    );
    expect(incomplete.contains('gcd'), isFalse);

    final ready = MasteryRules.unlockedIds(
      graph: knowledgeGraph,
      masteredIds: {
        kRootNodeId,
        'division_algorithm',
        'primes_composites',
      },
    );
    expect(ready.contains('gcd'), isTrue);
  });

  test('challenge pass threshold is 80% of 5', () {
    expect(MasteryRules.challengePassed(correct: 4, total: 5), isTrue);
    expect(MasteryRules.challengePassed(correct: 3, total: 5), isFalse);
    expect(MasteryRules.challengePassed(correct: 4, total: 4), isFalse);
  });

  test('recent accuracy uses last 20', () {
    final results = List<bool>.filled(25, false)..setAll(15, List.filled(10, true));
    expect(MasteryRules.recentAccuracy(results), 0.5);
  });

  test('attribution prefers weaker prerequisite for concept errors', () {
    final result = WrongBookRules.attribute(
      const AttributionInput(
        nodeId: 'gcd',
        prerequisites: ['division_algorithm', 'primes_composites'],
        correctAnswer: '6',
        userAnswer: '1',
        nodeAccuracy: 0.8,
        prereqAccuracy: {
          'division_algorithm': 0.3,
          'primes_composites': 0.9,
        },
        userCause: ErrorCause.concept,
      ),
    );
    expect(result.attributedNodeId, 'division_algorithm');
    expect(result.cause, ErrorCause.concept);
  });

  test('close numeric miss infers calculation', () {
    final result = WrongBookRules.attribute(
      const AttributionInput(
        nodeId: 'gcd',
        prerequisites: ['division_algorithm'],
        correctAnswer: '12',
        userAnswer: '11',
        nodeAccuracy: 0.7,
        prereqAccuracy: {'division_algorithm': 0.9},
      ),
    );
    expect(result.cause, ErrorCause.calculation);
    expect(result.attributedNodeId, 'gcd');
  });
}
