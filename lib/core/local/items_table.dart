import 'package:drift/drift.dart';

class ItemsTable extends Table {
  IntColumn get id => integer()();
  IntColumn get cloudId => integer()();
  TextColumn get storeName => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
