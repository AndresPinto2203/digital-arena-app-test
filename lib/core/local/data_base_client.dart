import 'package:drift/drift.dart';
import 'app_data_base.dart';

class DataBaseClient {
  DataBaseClient._internal() : _database = AppDatabase();

  static final DataBaseClient _instance = DataBaseClient._internal();
  factory DataBaseClient() => _instance;
  static DataBaseClient get instance => _instance;

  final AppDatabase _database;

  Future<int> insertItem(
    int cloudId,
    String storeName,
    String name,
    String description,
  ) => _database
      .into(_database.itemsTable)
      .insert(
        ItemsTableCompanion.insert(
          cloudId: cloudId,
          storeName: storeName,
          name: name,
          description: description,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

  Future<List<ItemsTableData>> getAllItems() =>
      _database.select(_database.itemsTable).get();

  Future<ItemsTableData?> getItemById(int id) => (_database.select(
    _database.itemsTable,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<ItemsTableData?> getItemByCloudId(int cloudId) => (_database.select(
    _database.itemsTable,
  )..where((t) => t.cloudId.equals(cloudId))).getSingleOrNull();

  Future<int> deleteItemById(int id) => (_database.delete(
    _database.itemsTable,
  )..where((t) => t.id.equals(id))).go();

  Future<int> updateItemByStoreId(
    int id,
    int cloudId,
    String storeName,
    String name,
    String description,
  ) => (_database.update(_database.itemsTable)..where((t) => t.id.equals(id)))
      .write(
        ItemsTableCompanion(
          cloudId: Value(cloudId),
          storeName: Value(storeName),
          name: Value(name),
          description: Value(description),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<int> updateItemByCloudId(
    int cloudId,
    String storeName,
    String name,
    String description,
  ) =>
      (_database.update(
        _database.itemsTable,
      )..where((t) => t.cloudId.equals(cloudId))).write(
        ItemsTableCompanion(
          storeName: Value(storeName),
          name: Value(name),
          description: Value(description),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> close() => _database.close();
}
