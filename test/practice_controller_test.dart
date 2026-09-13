import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/data/db/app_database.dart';
import 'package:matholym/data/seeds/seed_store.dart';
import 'package:matholym/domain/generators/choices.dart';
import 'package:matholym/domain/generators/question.dart';
import 'package:matholym/domain/knowledge/graph.dart';
import 'package:matholym/domain/knowledge/models.dart';
import 'package:matholym/domain/mastery.dart';
import 'package:matholym/features/practice/practice_controller.dart';
import 'package:matholym/providers.dart';

void main() {
  late ProviderContainer container;
  late PracticeNotifier practice;

  PracticeSession session() => container.read(practiceProvider)!;
  String wrongOf(GeneratedQuestion q) =>
      QuestionOptions.of(q).firstWhere((o) => !q.check(o));
  String rightOf(GeneratedQuestion q) => QuestionOptions.of(q).firstWhere(q.check);

  setUp(() async {
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWith((ref) {
          final db = AppDatabase(NativeDatabase.memory());
          ref.onDispose(db.close);
          return db;
        }),
        seedStoreProvider.overrideWith(
          (ref) async => SeedStore(graph: knowledgeGraph, cards: const {}),
        ),
      ],
    );
    final repo = await container.read(repositoryProvider.future);
    await repo.createProfile(nickname: '同学', stage: StudentStage.junior);
    practice = container.read(practiceProvider.notifier);
    final error = await practice.start(
      const PracticeArgs(mode: PracticeMode.challenge, nodeId: 'divisibility_def'),
    );
    expect(error, isNull);
  });

  tearDown(() => container.dispose());

  test('a miss opens one retry; the retry never changes the score', () async {
    final q = session().current;
    final miss = wrongOf(q);
    await practice.submit(miss);

    expect(session().results, [false]);
    expect(session().correctCount, 0);
    expect(session().tried, [miss]);

    if (QuestionOptions.of(q).length <= 2) {
      // 是/否: the only other option is the answer, so no retry.
      expect(session().phase, PracticePhase.solution);
      return;
    }
    expect(session().phase, PracticePhase.wrong);

    practice.retry(miss);
    expect(session().phase, PracticePhase.wrong, reason: 'a crossed-out pick is inert');

    practice.retry(rightOf(q));
    expect(session().phase, PracticePhase.solution);
    expect(session().recovered, isTrue);
    expect(session().correctCount, 0);
    expect(session().results, [false]);
  });

  test('a second miss opens the solution without recovery', () async {
    final q = session().current;
    final options = QuestionOptions.of(q);
    if (options.length <= 2) return;
    final misses = options.where((o) => !q.check(o)).toList();
    await practice.submit(misses[0]);
    practice.retry(misses[1]);

    expect(session().phase, PracticePhase.solution);
    expect(session().recovered, isFalse);
    expect(session().tried, misses.take(2).toList());
  });

  test('a drill runs the drill length at the difficulty asked', () async {
    final error = await practice.start(
      const PracticeArgs(
        mode: PracticeMode.special,
        nodeId: 'gcd',
        difficulty: Difficulty.medium,
      ),
    );
    expect(error, isNull);
    expect(session().total, MasteryRules.drillSize);
    expect(session().items.every((i) => i.question.nodeId == 'gcd'), isTrue);
    // The last slot leans on the band above, so only the body is checked.
    expect(
      session().items.take(4).every(
        (i) => i.question.difficulty == Difficulty.medium,
      ),
      isTrue,
    );

    // A drill never marks the node mastered, however it goes.
    for (var i = 0; i < MasteryRules.drillSize; i++) {
      await practice.submit(rightOf(session().current));
    }
    expect(session().phase, PracticePhase.finished);
    final view = await container.read(graphViewProvider.future);
    expect(view.statusOf('gcd'), NodeStatus.learning);
  });

  test('a passed challenge masters the node', () async {
    for (var i = 0; i < MasteryRules.challengeSize; i++) {
      await practice.submit(rightOf(session().current));
    }
    expect(session().phase, PracticePhase.finished);
    expect(session().correctCount, MasteryRules.challengeSize);
    final view = await container.read(graphViewProvider.future);
    expect(view.statusOf('divisibility_def'), NodeStatus.mastered);
  });

  test('results follow first picks and moving on clears the retry', () async {
    await practice.submit(rightOf(session().current));
    expect(session().index, 1);

    await practice.submit(wrongOf(session().current));
    await practice.nextAfterWrong();

    expect(session().index, 2);
    expect(session().phase, PracticePhase.answering);
    expect(session().results, [true, false]);
    expect(session().tried, isEmpty);
    expect(session().recovered, isFalse);
  });
}
