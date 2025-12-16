import 'dart:convert';
import '../core/network/api_client.dart';
import '../models/item_model.dart';

class ApiListRepository {
  final _apiClient = ApiClient();

  Stream<List<ItemModel>> fetchItems() {
    return _apiClient
        .get('/')
        .map((response) {
          try {
            final List<dynamic> data = response.body.isNotEmpty
                ? jsonDecode(response.body)
                : [];
            final items = data
                .map((itemJson) => ItemModel.fromJson(itemJson))
                .toList();
            return items;
          } on FormatException catch (e) {
            throw ApiException(
              kind: ApiErrorKind.parse,
              message: 'Error de parseo de datos: $e',
            );
          } catch (e) {
            throw ApiException(
              kind: ApiErrorKind.unknown,
              message: 'Error al parsear items: $e',
            );
          }
        })
        .handleError((error) {
          if (error is ApiException) {
            throw error;
          } else {
            throw ApiException(
              kind: ApiErrorKind.unknown,
              message: 'Error desconocido al obtener items: $error',
            );
          }
        });
  }
}
