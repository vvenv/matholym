import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/data/db/app_database.dart';
import 'package:matholym/data/repositories/app_repository.dart';
import 'package:matholym/data/seeds/seed_store.dart';
import 'package:matholym/domain/generators/catalog.dart';
import 'package:matholym/domain/generators/question.dart';
import 'package:matholym/domain/knowledge/graph.dart';
import 'package:matholym/domain/knowledge/models.dart';

void main() {
  late AppDatabase db;
  late AppRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = AppRepository(db, SeedStore(graph: knowledgeGraph, cards: const {}));
  });

  tearDown(() async {
    await db.close();
  });

  test('create profile, unlock after challenge, record wrong item', () async {
    expect(await repo.currentProfile(), isNull);

    final profile = await repo.createProfile(
      nickname: '同学',
      stage: StudentStage.junior,
    );
    var view = await repo.loadGraph(profile.id);
    expect(view.statusOf('divisibility_def'), NodeStatus.learning);
    expect(view.statusOf('division_algorithm'), NodeStatus.locked);

    final miss = questionEngine.generate(
      templateId: 'div_def.divides',
      seed: 3,
    );
    await repo.recordAttempt(
      profileId: profile.id,
      question: miss,
      userAnswer: '不对',
      isCorrect: false,
      hintsUsed: 1,
      mode: PracticeMode.special,
      sessionId: 's1',
    );
    final wrongs = await repo.listWrongItems(profileId: profile.id);
    expect(wrongs, hasLength(1));
    expect(wrongs.single.nodeId, 'divisibility_def');

    for (var i = 0; i < 5; i++) {
      final q = questionEngine.generate(
        templateId: 'div_def.divides',
        seed: 20 + i,
      );
      await repo.recordAttempt(
        profileId: profile.id,
        question: q,
        userAnswer: q.answer,
        isCorrect: true,
        hintsUsed: 0,
        mode: PracticeMode.challenge,
        sessionId: 's2',
        markChallengeMastered: i == 4,
        challengeCorrect: i + 1,
        challengeTotal: 5,
      );
    }

    view = await repo.loadGraph(profile.id);
    expect(view.statusOf('divisibility_def'), NodeStatus.mastered);
    expect(view.unlocked.contains('division_algorithm'), isTrue);
    expect(view.unlocked.contains('primes_composites'), isTrue);
  });
}
