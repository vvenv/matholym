import 'package:drift/drift.dart';

import 'connect.dart';

part 'app_database.g.dart';

class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nickname => text()();
  TextColumn get stage => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class NodeProgressRows extends Table {
  IntColumn get profileId => integer()();
  TextColumn get nodeId => text()();
  BoolColumn get unlocked => boolean()();
  BoolColumn get mastered => boolean().withDefault(const Constant(false))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get correctCount => integer().withDefault(const Constant(0))();
  IntColumn get consecutive => integer().withDefault(const Constant(0))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();
  DateTimeColumn get masteredAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {profileId, nodeId};
}

class Attempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer()();
  TextColumn get nodeId => text()();
  TextColumn get templateId => text()();
  IntColumn get seed => integer()();
  TextColumn get userAnswer => text()();
  BoolColumn get isCorrect => boolean()();
  IntColumn get hintsUsed => integer()();
  TextColumn get errorCause => text().nullable()();
  TextColumn get attributedNodeId => text().nullable()();
  TextColumn get sessionId => text()();
  TextColumn get mode => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class WrongItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get attemptId => integer()();
  IntColumn get profileId => integer()();
  TextColumn get nodeId => text()();
  TextColumn get attributedNodeId => text()();
  TextColumn get errorCause => text()();
  BoolColumn get digested => boolean().withDefault(const Constant(false))();
  TextColumn get snapshotStem => text()();
  TextColumn get snapshotAnswer => text()();
  TextColumn get templateId => text()();
  IntColumn get seed => integer()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Profiles, NodeProgressRows, Attempts, WrongItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  @override
  int get schemaVersion => 1;
}
