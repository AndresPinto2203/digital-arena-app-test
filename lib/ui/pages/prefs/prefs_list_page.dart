import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/item_model.dart';
import '../../../utils/form_utils.dart';
import '../../layouts/loading/loading_cubit.dart';
import '../api_list/api_list_page.dart';
import 'cubit/prefs_list_cubit.dart';

class PrefsListPage extends StatefulWidget {
  static String name = '/prefs-list';

  const PrefsListPage({super.key});

  @override
  State createState() => _PrefsListPageState();
}

class _PrefsListPageState extends State<PrefsListPage> {
  late final PrefsListCubit _cubit;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _cubit = PrefsListCubit(context.read<LoadingCubit>())..fetchItems();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prefs List Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                ApiListPage.name,
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PrefsListCubit, List<ItemModel>>(
        bloc: _cubit,
        builder: (context, items) {
          if (items.isEmpty) {
            return const Center(child: Text('No hay items guardados.'));
          }
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (ctx, idx) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text('Local name: ${item.storeName}'),
                            ),
                            Expanded(child: Text('Cloud name: ${item.name}')),
                          ],
                        ),
                        subtitle: Text(
                          '${item.description}\nCreated at: ${FormUtils.dateToStrLong(item.createdAt)}\nUpdated at: ${FormUtils.dateToStrLong(item.updatedAt)}',
                        ),
                        onTap: () {
                          _cubit.manageItem(context, index);
                        },
                        trailing: InkWell(
                          onTap: () {
                            _cubit.deleteItem(index);
                          },
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
