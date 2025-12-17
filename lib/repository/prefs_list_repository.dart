import '../core/local/data_base_client.dart';
import '../models/item_model.dart';

class PrefsListRepository {
  final DataBaseClient _dbClient = DataBaseClient.instance;

  PrefsListRepository();

  Future<List<ItemModel>> getAllPrefs() {
    return _dbClient.getAllItems().then(
      (itemsData) => itemsData
          .map(
            (itemData) => ItemModel(
              id: itemData.cloudId,
              storeId: itemData.id,
              storeName: itemData.storeName,
              name: itemData.name,
              description: itemData.description,
              createdAt: itemData.createdAt,
              updatedAt: itemData.updatedAt,
            ),
          )
          .toList(),
    );
  }

  Future<ItemModel?> getPrefById(int id) {
    return _dbClient.getItemById(id).then((itemData) {
      if (itemData == null) return null;
      return ItemModel(
        id: itemData.cloudId,
        storeId: itemData.id,
        storeName: itemData.storeName,
        name: itemData.name,
        description: itemData.description,
        createdAt: itemData.createdAt,
        updatedAt: itemData.updatedAt,
      );
    });
  }

  Future<ItemModel?> getPrefByCloudId(int id) {
    return _dbClient.getItemByCloudId(id).then((itemData) {
      if (itemData == null) return null;
      return ItemModel(
        id: itemData.cloudId,
        storeId: itemData.id,
        storeName: itemData.storeName,
        name: itemData.name,
        description: itemData.description,
        createdAt: itemData.createdAt,
        updatedAt: itemData.updatedAt,
      );
    });
  }

  Future<int> insertPref(ItemModel item) {
    return _dbClient.insertItem(
      item.id,
      item.storeName,
      item.name,
      item.description,
    );
  }

  Future<int> deletePrefById(int id) {
    return _dbClient.deleteItemById(id);
  }

  Future<int> updatePrefById(
    int cloudId,
    int storeId,
    String storeName,
    String name,
    String description,
  ) {
    return _dbClient.updateItemByStoreId(
      storeId,
      cloudId,
      storeName,
      name,
      description,
    );
  }

  Future<int> updatePrefByCloudId(
    int cloudId,
    String storeName,
    String name,
    String description,
  ) {
    return _dbClient.updateItemByCloudId(cloudId, storeName, name, description);
  }
}
