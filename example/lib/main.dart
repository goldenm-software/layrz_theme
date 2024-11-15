// import 'package:flutter/foundation.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/router.dart';
import 'package:layrz_theme_example/store/store.dart';
import 'package:vxstate/vxstate.dart';

const titleFont = AppFont(
  source: FontSource.google,
  name: 'Cabin',
);

const bodyFont = AppFont(
  source: FontSource.google,
  name: 'Ubuntu',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ThemedFontHandler.preloadFont(titleFont);
  await ThemedFontHandler.preloadFont(bodyFont);

  String? mapboxToken;
  String? googleToken;
  String? hereToken;

  // if (kDebugMode) {
  //   await dotenv.load(fileName: ".env");
  //   mapboxToken = dotenv.env['MAPBOX_TOKEN'];
  //   googleToken = dotenv.env['GOOGLE_TOKEN'];
  //   hereToken = dotenv.env['HERE_TOKEN'];
  // }

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
    return VxConsumer<AppStore>(
      mutations: const {},
      notifications: {
        SetTheme: (context, mutation, {status}) {
          if (status == VxStatus.success) {
            setState(() {});
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final mut = mutation as SetTheme;
              bool isDark = mut.themeMode == ThemeMode.dark;
              if (mut.themeMode == ThemeMode.system) {
                isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
              }

              overrideAppBarStyle(isDark: isDark);
            });
          }
        },
      },
      builder: (context, store, status) {
        return MaterialApp.router(
          title: 'Layrz Theme Example',
          themeMode: store.themeMode,
          theme: generateLightTheme(titleFont: titleFont, bodyFont: bodyFont),
          darkTheme: generateDarkTheme(titleFont: titleFont, bodyFont: bodyFont),
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
