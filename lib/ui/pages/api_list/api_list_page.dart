import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/item_model.dart';
import '../../../utils/form_utils.dart';
import '../../components/input_field.dart';
import '../../layouts/loading/loading_cubit.dart';
import '../prefs/prefs_list_page.dart';
import 'api_list_cubit.dart';

class ApiListPage extends StatefulWidget {
  static String name = '/api-list';

  const ApiListPage({super.key});

  @override
  State createState() => _ApiListPageState();
}

class _ApiListPageState extends State<ApiListPage> {
  late final ApiListCubit _cubit;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _cubit = ApiListCubit(context.read<LoadingCubit>())..fetchItems();
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
        title: const Text('API List Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.storage_rounded),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                PrefsListPage.name,
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ApiListCubit, List<ItemModel>>(
        bloc: _cubit,
        builder: (context, items) {
          if (items.isEmpty) {
            return const Center(child: Text('No items'));
          }
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                InputField(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  onChanged: (value) {
                    _cubit.filterItems(value);
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (ctx, idx) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text('${item.name} (${item.id})'),
                        subtitle: Text(
                          '${item.description}\nCreated at: ${FormUtils.dateToStr(item.createdAt)}\nUpdated at: ${FormUtils.dateToStr(item.updatedAt)}',
                        ),
                        onTap: () {
                          _cubit.manageItem(context, index);
                        },
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
