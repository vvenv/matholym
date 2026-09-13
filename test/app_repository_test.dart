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

  test('create profile, master after challenge, record wrong item', () async {
    expect(await repo.currentProfile(), isNull);

    final profile = await repo.createProfile(
      nickname: '同学',
      stage: StudentStage.junior,
    );
    var view = await repo.loadGraph(profile.id);
    expect(view.statusOf('divisibility_def'), NodeStatus.learning);
    expect(view.statusOf('division_algorithm'), NodeStatus.learning);
    expect(view.progress, hasLength(knowledgeGraph.nodes.length));
    expect(view.graph.area.id, 'number_theory');

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
    expect(view.mastered, {'divisibility_def'});
    // Mastering one node leaves the rest where they were: no gate to open.
    expect(view.statusOf('division_algorithm'), NodeStatus.learning);
    expect(view.recommended()?.id, 'division_algorithm');
  });

  test('combinatorics nodes are seeded when the store has both trees', () async {
    repo = AppRepository(
      db,
      SeedStore(
        graphs: {
          knowledgeGraph.area.id: knowledgeGraph,
          combinatoricsGraph.area.id: combinatoricsGraph,
        },
        cards: const {},
      ),
    );
    final profile = await repo.createProfile(
      nickname: '同学',
      stage: StudentStage.junior,
    );
    final combo = await repo.loadGraph(
      profile.id,
      areaId: KnowledgeArea.combinatoricsId,
    );
    expect(combo.graph.nodes, hasLength(31));
    expect(combo.statusOf('count_add'), NodeStatus.learning);
    // Progress rows are seeded for every tree, this one included.
    expect(combo.progress.keys, contains('pigeonhole'));
  });
}
