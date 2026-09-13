import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matholym/core/theme/app_theme.dart';
import 'package:matholym/data/db/app_database.dart';
import 'package:matholym/data/seeds/seed_store.dart';
import 'package:matholym/domain/generators/catalog.dart';
import 'package:matholym/domain/generators/question.dart';
import 'package:matholym/domain/knowledge/graph.dart';
import 'package:matholym/domain/knowledge/models.dart';
import 'package:matholym/features/card/card_page.dart';
import 'package:matholym/providers.dart';

/// Two trees loaded, number theory selected — the state you are in after a
/// restart, with algebra wrong answers still in the book.
ProviderContainer _container() {
  return ProviderContainer(
    overrides: [
      databaseProvider.overrideWith((ref) {
        final db = AppDatabase(NativeDatabase.memory());
        ref.onDispose(db.close);
        return db;
      }),
      seedStoreProvider.overrideWith(
        (ref) async => SeedStore(
          graphs: {
            knowledgeGraph.area.id: knowledgeGraph,
            algebraGraph.area.id: algebraGraph,
          },
          cards: const {},
        ),
      ),
    ],
  );
}

Future<void> _pump(WidgetTester tester, ProviderContainer container, String nodeId) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(theme: buildAppTheme(), home: CardPage(nodeId: nodeId)),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a card opens for a node outside the selected tree', (tester) async {
    final container = _container();
    addTearDown(container.dispose);
    final repo = await container.read(repositoryProvider.future);
    await repo.createProfile(nickname: '同学', stage: StudentStage.junior);
    expect(container.read(selectedAreaIdProvider), KnowledgeArea.numberTheoryId);

    final algebraNode = algebraGraph.nodes.first;
    await _pump(tester, container, algebraNode.id);

    expect(find.text(algebraNode.title), findsOneWidget);
    expect(find.text('找不到这一节'), findsNothing);
    // The dock reads the algebra tree's progress, not number theory's.
    expect(find.text('闯关'), findsOneWidget);
    expect(find.text('先练一组'), findsOneWidget);
  });

  testWidgets('the dock fits a phone-width card', (tester) async {
    final container = _container();
    addTearDown(container.dispose);
    final repo = await container.read(repositoryProvider.future);
    final profile = await repo.createProfile(
      nickname: '同学',
      stage: StudentStage.junior,
    );
    // A started node shows the longest note: accuracy plus the pass rule.
    final question = questionEngine.generate(
      templateId: 'div_def.divides',
      seed: 3,
    );
    await repo.recordAttempt(
      profileId: profile.id,
      question: question,
      userAnswer: question.answer,
      isCorrect: true,
      hintsUsed: 0,
      mode: PracticeMode.challenge,
      sessionId: 's1',
    );

    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await _pump(tester, container, kRootNodeId);

    expect(find.text('闯关'), findsOneWidget);
    expect(find.textContaining('正确率'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a card for an unknown node says so instead of throwing', (tester) async {
    final container = _container();
    addTearDown(container.dispose);
    final repo = await container.read(repositoryProvider.future);
    await repo.createProfile(nickname: '同学', stage: StudentStage.junior);

    await _pump(tester, container, 'no_such_node');

    expect(find.text('找不到这一节'), findsOneWidget);
  });
}
