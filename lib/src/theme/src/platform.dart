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

  /// [ThemedPlatform.unknown] is the unknown platform.
  unknown,
}

/// [kThemedPlatform] is the platform of the app.
///
/// Uses `Platform` from `dart:io` to get the platform in native
/// and uses `kIsWeb` to get the platform in web.
ThemedPlatform get kThemedPlatform {
  if (kIsWeb) return ThemedPlatform.web;
  if (Platform.isAndroid) return ThemedPlatform.android;
  if (Platform.isIOS) return ThemedPlatform.iOS;
  if (Platform.isMacOS) return ThemedPlatform.macOS;
  if (Platform.isWindows) return ThemedPlatform.windows;
  if (Platform.isLinux) return ThemedPlatform.linux;
  if (Platform.isFuchsia) return ThemedPlatform.fuchsia;
  return ThemedPlatform.unknown;
}
