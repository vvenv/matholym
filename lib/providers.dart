import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/db/app_database.dart';
import 'data/repositories/app_repository.dart';
import 'data/seeds/seed_store.dart';
import 'domain/knowledge/area.dart';
import 'domain/mastery.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final seedStoreProvider = FutureProvider<SeedStore>((ref) => SeedStore.load());

final repositoryProvider = FutureProvider<AppRepository>((ref) async {
  final db = ref.watch(databaseProvider);
  final seeds = await ref.watch(seedStoreProvider.future);
  return AppRepository(db, seeds);
});

final profileProvider = FutureProvider<Profile?>((ref) async {
  final repo = await ref.watch(repositoryProvider.future);
  return repo.currentProfile();
});

enum TreeLayoutMode { graph, list }

final treeLayoutModeProvider = StateProvider<TreeLayoutMode>(
  (ref) => TreeLayoutMode.list,
);

final selectedAreaIdProvider = StateProvider<String>(
  (ref) => KnowledgeArea.numberTheoryId,
);

/// One subject tree with this profile's progress on it. Invalidate the family
/// (`ref.invalidate(areaViewProvider)`) after recording an attempt: the tree on
/// screen and the card behind it may be two different subjects.
final areaViewProvider = FutureProvider.family<GraphView, String>((
  ref,
  areaId,
) async {
  final repo = await ref.watch(repositoryProvider.future);
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) {
    final graph = repo.graphFor(areaId);
    return GraphView(graph: graph, mastered: const {}, progress: const {});
  }
  return repo.loadGraph(profile.id, areaId: areaId);
});

/// The tree on screen.
final graphViewProvider = FutureProvider<GraphView>((ref) {
  return ref.watch(areaViewProvider(ref.watch(selectedAreaIdProvider)).future);
});

/// The tree that carries [nodeId], whichever subject is on screen. A card or a
/// practice run opened from the wrong book can be about another subject.
final nodeViewProvider = FutureProvider.family<GraphView, String>((
  ref,
  nodeId,
) async {
  final seeds = await ref.watch(seedStoreProvider.future);
  final String areaId =
      seeds.areaIdOf(nodeId) ?? ref.watch(selectedAreaIdProvider);
  return ref.watch(areaViewProvider(areaId).future);
});

final wrongOpenCountProvider = FutureProvider<int>((ref) async {
  final repo = await ref.watch(repositoryProvider.future);
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) return 0;
  return repo.openWrongCount(profile.id);
});
