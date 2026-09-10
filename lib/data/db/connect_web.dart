import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:sqlite3/wasm.dart';

QueryExecutor openConnection() {
  return DatabaseConnection.delayed(Future(() async {
    try {
      final result = await WasmDatabase.open(
        databaseName: 'matholym',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      ).timeout(const Duration(seconds: 8));
      return result.resolvedExecutor;
    } catch (_) {
      final sqlite3 = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'))
          .timeout(const Duration(seconds: 8));
      sqlite3.registerVirtualFileSystem(
        InMemoryFileSystem(),
        makeDefault: true,
      );
      return DatabaseConnection(WasmDatabase.inMemory(sqlite3));
    }
  }));
}
