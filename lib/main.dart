import 'package:digital_arena_test/ui/pages/api_list/api_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'ui/layouts/loading/loading_cubit.dart';
import 'ui/layouts/main_layout.dart';
import 'ui/pages/prefs/prefs_add_page.dart';
import 'ui/pages/prefs/prefs_list_page.dart';
import 'ui/pages/prefs/prefs_view_page.dart';

void main() async {
  await dotenv.load(fileName: 'enviroment/dotenv.prod');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routes = <String, WidgetBuilder>{
    ApiListPage.name: (_) => const ApiListPage(),
    PrefsAddPage.name: (_) => const PrefsAddPage(),
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
        onGenerateRoute: (settings) {
          final name = settings.name ?? '';
          final uri = Uri.parse(name);

          // Soporta "PrefsViewPage.name/:id"
          if (uri.pathSegments.length == 2 &&
              uri.pathSegments.first == PrefsViewPage.name) {
            final id = int.tryParse(uri.pathSegments[1]);
            if (id != null) {
              return MaterialPageRoute(
                builder: (_) => PrefsViewPage(id: id),
                settings: settings,
              );
            }
            // id inválido → 404 simple
            return MaterialPageRoute(builder: (_) => const _NotFoundPage());
          }

          // Rutas estáticas
          final builder = routes[name];
          if (builder != null) {
            return MaterialPageRoute(builder: builder, settings: settings);
          }

          // Fallback
          return MaterialPageRoute(builder: (_) => const _NotFoundPage());
        },
        builder: (context, child) {
          return MainLayout(child: child!);
        },
      ),
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Ruta no encontrada')));
  }
}
