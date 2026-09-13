import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/domain/knowledge/graph.dart';
import 'package:matholym/domain/knowledge/models.dart';
import 'package:matholym/domain/mastery.dart';
import 'package:matholym/domain/wrong_book.dart';

void main() {
  test('a node is being learnt until it is mastered', () {
    expect(
      MasteryRules.status(nodeId: 'gcd', masteredIds: {}),
      NodeStatus.learning,
    );
    expect(
      MasteryRules.status(nodeId: kRootNodeId, masteredIds: {kRootNodeId}),
      NodeStatus.mastered,
    );
  });

  test('the tree recommends the first node still being learnt', () {
    final view = GraphView(
      graph: knowledgeGraph,
      mastered: {kRootNodeId},
      progress: const {},
    );
    expect(view.recommended()?.id, knowledgeGraph.nodes[1].id);
    final done = GraphView(
      graph: knowledgeGraph,
      mastered: {for (final node in knowledgeGraph.nodes) node.id},
      progress: const {},
    );
    expect(done.recommended()?.id, kRootNodeId, reason: 'nothing left to learn');
  });

  test('challenge pass threshold is 80% of 5', () {
    expect(MasteryRules.challengePassed(correct: 4, total: 5), isTrue);
    expect(MasteryRules.challengePassed(correct: 3, total: 5), isFalse);
    expect(MasteryRules.challengePassed(correct: 4, total: 4), isFalse);
    expect(MasteryRules.passCount, 4);
    expect(
      MasteryRules.challengePassed(
        correct: MasteryRules.passCount,
        total: MasteryRules.challengeSize,
      ),
      isTrue,
    );
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
