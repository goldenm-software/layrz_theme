part of '../theme.dart';

/// [ThemedPlatform] is the platform of the app.
///
/// Uses `Platform` from `dart:io` to get the platform in native
/// and uses `kIsWeb` to get the platform in web.
enum ThemedPlatform {
  /// [ThemedPlatform.web] is the web platform.
  web,

  /// [ThemedPlatform.android] is the Android platform.
  android,

  /// [ThemedPlatform.iOS] is the iOS platform.
  iOS,

  /// [ThemedPlatform.macOS] is the macOS platform.
  macOS,

  /// [ThemedPlatform.windows] is the Windows platform.
  windows,

  /// [ThemedPlatform.linux] is the Linux platform.
  linux,

  /// [ThemedPlatform.fuchsia] is the Fuchsia platform.
  fuchsia,

  /// [ThemedPlatform.isWebWasm] is the web platform built with WebAssembly.
  /// This is only available in web.
  webWasm,

  /// [ThemedPlatform.unknown] is the unknown platform.
  unknown,
  ;

  /// [isWeb] is `true` if the platform is web.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.web`.
  static bool get isWeb => kThemedPlatform == ThemedPlatform.web;

  /// [isAndroid] is `true` if the platform is Android.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.android`.
  static bool get isAndroid => kThemedPlatform == ThemedPlatform.android;

  /// [isIOS] is `true` if the platform is iOS.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.iOS`.
  static bool get isIOS => kThemedPlatform == ThemedPlatform.iOS;

  /// [isMacOS] is `true` if the platform is macOS.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.macOS`.
  static bool get isMacOS => kThemedPlatform == ThemedPlatform.macOS;

  /// [isWindows] is `true` if the platform is Windows.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.windows`.
  static bool get isWindows => kThemedPlatform == ThemedPlatform.windows;

  /// [isLinux] is `true` if the platform is Linux.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.linux`.
  static bool get isLinux => kThemedPlatform == ThemedPlatform.linux;

  /// [isFuchsia] is `true` if the platform is Fuchsia OS.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.fuchsia`.
  static bool get isFuchsia => kThemedPlatform == ThemedPlatform.fuchsia;

  /// [isWebWasm] is `true` if the platform is web built with WebAssembly.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.webWasm`.
  static bool get isWebWasm => kThemedPlatform == ThemedPlatform.webWasm;
}

/// [kThemedPlatform] is the platform of the app.
///
/// Uses `Platform` from `dart:io` to get the platform in native
/// and uses `kIsWeb` to get the platform in web.
ThemedPlatform get kThemedPlatform {
  if (kIsWeb) {
    if (kIsWasm) return ThemedPlatform.webWasm;
    return ThemedPlatform.web;
  }

  if (Platform.isAndroid) return ThemedPlatform.android;
  if (Platform.isIOS) return ThemedPlatform.iOS;
  if (Platform.isMacOS) return ThemedPlatform.macOS;
  if (Platform.isWindows) return ThemedPlatform.windows;
  if (Platform.isLinux) return ThemedPlatform.linux;
  if (Platform.isFuchsia) return ThemedPlatform.fuchsia;
  return ThemedPlatform.unknown;
}
