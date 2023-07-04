import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/avatars.dart';
import 'package:layrz_theme_example/buttons.dart';
import 'package:layrz_theme_example/dynamic_credentials.dart';
import 'package:layrz_theme_example/empty.dart';
import 'package:layrz_theme_example/home.dart';
import 'package:layrz_theme_example/inputs.dart';
import 'package:layrz_theme_example/login_example.dart';
import 'package:layrz_theme_example/tab_bar.dart';
import 'package:layrz_theme_example/table.dart';
import 'package:layrz_theme_example/text.dart';
import 'package:layrz_theme_example/cards.dart';

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
  ThemeMode theme = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      theme = theme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Layrz Theme Example',
      themeMode: theme,
      theme: generateLightTheme(),
      darkTheme: generateDarkTheme(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomeView(name: 'Home', toggleTheme: toggleTheme),
        '/table': (context) => TableView(name: 'Table', toggleTheme: toggleTheme),
        '/inputs': (context) => InputsView(name: 'Inputs', toggleTheme: toggleTheme),
        '/text': (context) => TextView(name: 'Text', toggleTheme: toggleTheme),
        '/cards': (context) => CardsView(name: 'Cards', toggleTheme: toggleTheme),
        '/tabBar': (context) => TabView(name: 'Tab Bar', toggleTheme: toggleTheme),
        '/buttons': (context) => ButtonsView(name: 'Empty', toggleTheme: toggleTheme),
        '/avatars': (context) => AvatarsView(name: 'Avatars', toggleTheme: toggleTheme),
        '/dynamic_credentials': (context) => DynamicCredentialsView(
              name: 'Dynamic Credentials',
              toggleTheme: toggleTheme,
            ),
        '/empty': (context) => EmptyView(name: 'Empty', toggleTheme: toggleTheme),
        '/home/test0': (context) => EmptyView(name: 'Test 0', toggleTheme: toggleTheme),
        '/home/test1': (context) => EmptyView(name: 'Test 1', toggleTheme: toggleTheme),
        '/home/test2': (context) => EmptyView(name: 'Test 2', toggleTheme: toggleTheme),
        '/home/test3': (context) => EmptyView(name: 'Test 3', toggleTheme: toggleTheme),
        '/home/test4': (context) => EmptyView(name: 'Test 4', toggleTheme: toggleTheme),
        '/login_example': (context) => LoginExampleView(name: 'Login Example', toggleTheme: toggleTheme),
      },
      initialRoute: '/home',
    );
  }
}
