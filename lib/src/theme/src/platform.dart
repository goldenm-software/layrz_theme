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
  unknown
  ;

  /// [isWeb] is `true` if the platform is web.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.web`.
  static bool get isWeb => kThemedPlatform == .web;

  /// [isAndroid] is `true` if the platform is Android.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.android`.
  static bool get isAndroid => kThemedPlatform == .android;

  /// [isIOS] is `true` if the platform is iOS.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.iOS`.
  static bool get isIOS => kThemedPlatform == .iOS;

  /// [isMacOS] is `true` if the platform is macOS.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.macOS`.
  static bool get isMacOS => kThemedPlatform == .macOS;

  /// [isWindows] is `true` if the platform is Windows.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.windows`.
  static bool get isWindows => kThemedPlatform == .windows;

  /// [isLinux] is `true` if the platform is Linux.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.linux`.
  static bool get isLinux => kThemedPlatform == .linux;

  /// [isFuchsia] is `true` if the platform is Fuchsia OS.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.fuchsia`.
  static bool get isFuchsia => kThemedPlatform == .fuchsia;

  /// [isWebWasm] is `true` if the platform is web built with WebAssembly.
  /// This getter is a shortcut to `kThemedPlatform == ThemedPlatform.webWasm`.
  static bool get isWebWasm => kThemedPlatform == .webWasm;

  @override
  String toString() {
    switch (this) {
      case .web:
        return 'Web compiled on CanvasKit';
      case .webWasm:
        return 'Web compiled on WASM';
      case .android:
        return 'Google Android';
      case .iOS:
        return 'Apple iOS';
      case .macOS:
        return 'Apple macOS';
      case .windows:
        return 'Microsoft Windows';
      case .linux:
        return 'GNU/Linux';
      case .fuchsia:
        return 'Google Fuchsia';
      default:
        return 'Unknown $name';
    }
  }
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

  if (defaultTargetPlatform == TargetPlatform.android) return ThemedPlatform.android;
  if (defaultTargetPlatform == TargetPlatform.iOS) return ThemedPlatform.iOS;
  if (defaultTargetPlatform == TargetPlatform.macOS) return ThemedPlatform.macOS;
  if (defaultTargetPlatform == TargetPlatform.windows) return ThemedPlatform.windows;
  if (defaultTargetPlatform == TargetPlatform.linux) return ThemedPlatform.linux;
  if (defaultTargetPlatform == TargetPlatform.fuchsia) return ThemedPlatform.fuchsia;
  return ThemedPlatform.unknown;
}
