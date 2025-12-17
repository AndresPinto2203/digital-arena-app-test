import 'dart:async';

import 'package:digital_arena_test/ui/components/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';
import '../../../../models/item_model.dart';
import '../../../../repository/api_list_repository.dart';
import '../../../../repository/prefs_list_repository.dart';
import '../../../../utils/form_utils.dart';
import '../../../layouts/loading/loading_cubit.dart';

class ApiListCubit extends Cubit<List<ItemModel>> {
  final BuildContext _context;
  final LoadingCubit _loading;
  final _repository = ApiListRepository();
  final _prefsRepository = PrefsListRepository();
  StreamSubscription<List<ItemModel>>? _searchSub;
  Timer? _debounce;
  int _requestSeq = 0;

  ApiListCubit(this._context, this._loading) : super([]);

  void fetchItems() {
    _loading.show();
    _searchSub?.cancel();
    final seq = ++_requestSeq;

    _searchSub = _repository.fetchItems().listen(
      (items) {
        if (seq == _requestSeq) emit(items);
      },
      onError: (error) {
        if (seq == _requestSeq) _loading.hide();
        addError(error);
      },
      onDone: () {
        if (seq == _requestSeq) _loading.hide();
      },
    );
  }

  void filterItems(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _searchSub?.cancel();
      final seq = ++_requestSeq;
      _loading.show();
      _searchSub = _repository.fetchItems().listen(
        (items) {
          if (seq == _requestSeq) {
            final filtered = items
                .where(
                  (item) =>
                      item.name.toLowerCase().contains(query.toLowerCase()) ||
                      item.description.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
            emit(filtered);
          }
        },
        onError: (error) {
          if (seq == _requestSeq) _loading.hide();
          addError(error);
        },
        onDone: () {
          if (seq == _requestSeq) _loading.hide();
        },
      );
    });
  }

  void manageItem(BuildContext context, int index) async {
    ItemModel? item;
    item = await _prefsRepository.getPrefByCloudId(state[index].id);
    item ??= state[index];
    final storeNameController = TextEditingController();
    final nameController = TextEditingController(text: item.name);
    final descriptionController = TextEditingController(text: item.description);

    FormUtils.showBottomSheet(
      context,
      Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 8, left: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Manage Item ID: ${item.id}'),
            const SizedBox(height: 16),
            InputField(controller: storeNameController, hintText: 'Store Name'),
            const SizedBox(height: 8),
            InputField(controller: nameController, hintText: 'Item Name'),
            const SizedBox(height: 8),
            InputField(
              controller: descriptionController,
              hintText: 'Item Description',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cerrar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _loading.show();
                      _prefsRepository
                          .insertPref(
                            item!.copyWith(
                              storeName: storeNameController.text,
                              name: nameController.text,
                              description: descriptionController.text,
                            ),
                          )
                          .then((_) {
                            _loading.hide();
                          });
                      Navigator.pop(context);
                    },
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onError(error, StackTrace stackTrace) {
    if (error is ApiException) {
      FormUtils.showBottomSheet(
        _context,
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(right: 8, left: 8),
          decoration: BoxDecoration(
            color: Theme.of(_context).canvasColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: ${error.message}'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(_context);
                      },
                      child: const Text('Cerrar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        fetchItems();
                        Navigator.pop(_context);
                      },
                      child: const Text('Reintentar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    super.onError(error, stackTrace);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    _searchSub?.cancel();
    return super.close();
  }
}
