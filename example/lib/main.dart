import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/router.dart';
import 'package:layrz_theme_example/store/store.dart';
import 'package:vxstate/vxstate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(VxState(
    store: AppStore(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return VxBuilder<AppStore>(
      mutations: const {SetTheme},
      builder: (context, store, status) {
        return MaterialApp.router(
          title: 'Layrz Theme Example',
          themeMode: store.themeMode,
          theme: generateLightTheme(),
          darkTheme: generateDarkTheme(),
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
      },
    );
  }
}
