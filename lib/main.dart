import 'package:digital_arena_test/ui/pages/api_list/api_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'ui/layouts/loading/loading_cubit.dart';
import 'ui/layouts/main_layout.dart';
import 'ui/pages/prefs/prefs_list_page.dart';

void main() async {
  await dotenv.load(fileName: 'enviroment/dotenv.prod');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routes = <String, WidgetBuilder>{
    ApiListPage.name: (_) => const ApiListPage(),
    PrefsListPage.name: (_) => const PrefsListPage(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => LoadingCubit())],
      child: MaterialApp(
        title: 'Digital Arena Test',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        initialRoute: ApiListPage.name,
        routes: routes,
        builder: (context, child) {
          return MainLayout(child: child!);
        },
      ),
    );
  }
}
