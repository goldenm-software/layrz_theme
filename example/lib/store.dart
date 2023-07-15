import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';

class AppStore extends VxStore {
  ThemeMode themeMode = ThemeMode.light;
}

class ToggleTheme extends VxMutation<AppStore> {
  @override
  perform() {
    store!.themeMode = store!.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
