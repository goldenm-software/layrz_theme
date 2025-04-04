// import 'package:flutter/foundation.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/router.dart';
import 'package:layrz_theme_example/store/store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vxstate/vxstate.dart';

const font = AppFont(source: FontSource.google, name: 'Ubuntu');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ThemedFontHandler.preloadFont(font);

  String? mapboxToken;
  String? googleToken;
  String? hereToken;

  // if (kDebugMode) {
  //   await dotenv.load(fileName: ".env");
  //   mapboxToken = dotenv.env['MAPBOX_TOKEN'];
  //   googleToken = dotenv.env['GOOGLE_TOKEN'];
  //   hereToken = dotenv.env['HERE_TOKEN'];
  // }

  final prefs = await SharedPreferences.getInstance();
  final rawThemeMode = prefs.getString('layrz.theme.mode');
  ThemeMode? themeMode;
  if (rawThemeMode != null) {
    themeMode =
        ThemeMode.values.firstWhereOrNull((e) => e.name == rawThemeMode);
  }

  double colorblindStrength =
      prefs.getDouble('layrz.colorblind.strength') ?? 1.0;
  final rawColorblindMode = prefs.getString('layrz.colorblind.mode');
  ColorblindMode? colorblindMode;
  if (rawColorblindMode != null) {
    colorblindMode = ColorblindMode.values
        .firstWhereOrNull((e) => e.name == rawColorblindMode);
  }

  runApp(VxState(
    store: AppStore(
      themeMode: themeMode ?? ThemeMode.system,
      mapboxToken: mapboxToken,
      googleToken: googleToken,
      hereToken: hereToken,
      colorblindMode: colorblindMode ?? ColorblindMode.normal,
      colorblindStrength: colorblindStrength,
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
      mutations: const {SetColorblindMode, SetColorblindStrength, SetTheme},
      notifications: {
        SetTheme: (context, mutation, {status}) {
          if (status == VxStatus.success) {
            setState(() {});
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final mut = mutation as SetTheme;
              bool isDark = mut.themeMode == ThemeMode.dark;
              if (mut.themeMode == ThemeMode.system) {
                isDark = MediaQuery.of(context).platformBrightness ==
                    Brightness.dark;
              }

              overrideAppBarStyle(isDark: isDark);
            });
          }
        },
      },
      builder: (context, store, status) {
        return ColorFiltered(
          colorFilter: store.colorblindMode.filter(store.colorblindStrength),
          child: MaterialApp.router(
            title: 'Layrz Theme Example',
            themeMode: store.themeMode,
            theme: generateLightTheme(titleFont: font, bodyFont: font),
            darkTheme: generateDarkTheme(titleFont: font, bodyFont: font),
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            builder: (context, child) {
              return ThemedSnackbarMessenger(
                child: child ?? const SizedBox(),
              );
            },
          ),
        );
      },
    );
  }
}
