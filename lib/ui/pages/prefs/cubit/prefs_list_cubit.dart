import 'dart:async';

import 'package:digital_arena_test/ui/components/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/item_model.dart';
import '../../../../repository/prefs_list_repository.dart';
import '../../../../utils/form_utils.dart';
import '../../../layouts/loading/loading_cubit.dart';

class PrefsListCubit extends Cubit<List<ItemModel>> {
  final LoadingCubit _loading;
  final _repository = PrefsListRepository();

  PrefsListCubit(this._loading) : super([]);

  void fetchItems() {
    _loading.show();

    _repository
        .getAllPrefs()
        .then((items) {
          emit(items);
          _loading.hide();
        })
        .catchError((error) {
          print('Error fetching items: $error');
          _loading.hide();
        });
  }

  void manageItem(BuildContext context, int index) {
    var item = state[index];
    final storeNameController = TextEditingController(text: item.storeName);
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
            Text('Manage Item local ID: ${item.storeId}'),
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
                      _repository
                          .updatePrefById(
                            item.id,
                            item.storeId,
                            storeNameController.text,
                            nameController.text,
                            descriptionController.text,
                          )
                          .then((_) {
                            _loading.hide();
                            fetchItems();
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

  void deleteItem(int index) {
    var item = state[index];
    _loading.show();
    _repository.deletePrefById(item.storeId).then((_) {
      _loading.hide();
      fetchItems();
    });
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
