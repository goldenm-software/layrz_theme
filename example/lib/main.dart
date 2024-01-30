import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/router.dart';
import 'package:layrz_theme_example/store/store.dart';
import 'package:vxstate/vxstate.dart';

Future<void> main() async {
  String? mapboxToken;
  String? googleToken;
  String? hereToken;

  if (kDebugMode) {
    await dotenv.load(fileName: ".env");
    mapboxToken = dotenv.env['MAPBOX_TOKEN'];
    googleToken = dotenv.env['GOOGLE_TOKEN'];
    hereToken = dotenv.env['HERE_TOKEN'];
  }
  WidgetsFlutterBinding.ensureInitialized();

  runApp(VxState(
    store: AppStore(
      mapboxToken: mapboxToken,
      googleToken: googleToken,
      hereToken: hereToken,
    ),
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
          builder: (context, child) {
            return ThemedSnackbarMessenger(
              child: child ?? const SizedBox(),
            );
          },
        );
      },
    );
  }
}
