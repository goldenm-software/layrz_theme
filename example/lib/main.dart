import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode theme = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      theme = theme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Layrz Theme Example',
      themeMode: theme,
      theme: generateLightTheme(),
      darkTheme: generateDarkTheme(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
    // return MaterialApp(
    //   title: 'Layrz Theme Example',
    //   themeMode: theme,
    //   theme: generateLightTheme(),
    //   darkTheme: generateDarkTheme(),
    //   debugShowCheckedModeBanner: false,
    //   initialRoute: '/home',
    //   routes: nativeRoutes,
    // );
  }
}
