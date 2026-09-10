import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/db/app_database.dart';
import 'data/repositories/app_repository.dart';
import 'data/seeds/seed_store.dart';
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

final graphViewProvider = FutureProvider<GraphView>((ref) async {
  final repo = await ref.watch(repositoryProvider.future);
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) {
    return GraphView(
      graph: repo.graph,
      unlocked: {repo.graph.rootId},
      mastered: {},
      progress: const {},
    );
  }
  return repo.loadGraph(profile.id);
});

final wrongOpenCountProvider = FutureProvider<int>((ref) async {
  final repo = await ref.watch(repositoryProvider.future);
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) return 0;
  return repo.openWrongCount(profile.id);
});

final totalAttemptsProvider = FutureProvider<int>((ref) async {
  final repo = await ref.watch(repositoryProvider.future);
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) return 0;
  return repo.totalAttempts(profile.id);
});
