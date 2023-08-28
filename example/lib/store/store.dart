library store;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vxstate/vxstate.dart';

part 'src/wrapper.dart';

class AppStore extends VxStore {
  ThemeMode themeMode = ThemeMode.light;
  ThemedLayoutStyle layoutStyle = ThemedLayoutStyle.modern;
}

class SetTheme extends VxMutation<AppStore> {
  final ThemeMode themeMode;

  SetTheme(this.themeMode);

  @override
  Future<void> perform() async {
    store!.themeMode = themeMode;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('layrz.theme.mode', store!.themeMode.name);
  }
}

class GetTheme extends VxMutation<AppStore> {
  @override
  Future<void> perform() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString('layrz.theme.mode');
    if (themeMode != null) {
      store!.themeMode = ThemeMode.values.firstWhere(
        (e) => e.name == themeMode,
        orElse: () => ThemeMode.system,
      );
    }
  }
}

class SetLayout extends VxMutation<AppStore> {
  final ThemedLayoutStyle layoutStyle;

  SetLayout(this.layoutStyle);

  @override
  Future<void> perform() async {
    store!.layoutStyle = layoutStyle;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('layrz.layout.style', store!.layoutStyle.name);
  }
}

class GetLayout extends VxMutation<AppStore> {
  @override
  Future<void> perform() async {
    final prefs = await SharedPreferences.getInstance();
    final layoutStyle = prefs.getString('layrz.layout.style');
    if (layoutStyle != null) {
      store!.layoutStyle = ThemedLayoutStyle.values.firstWhere(
        (e) => e.name == layoutStyle,
        orElse: () => ThemedLayoutStyle.modern,
      );
    }
  }
}
