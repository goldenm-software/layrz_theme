part of '../extensions.dart';

/// [ThemedColorExtensions] is an extension to convert a [Color] to add multiple helpers
/// to convert a [Color] to a hex string, JSON string, and integer.
extension ThemedColorExtensions on Color {
  /// [toJson] is an extension to convert a [Color] to a JSON string using [toHex] function.
  String toJson() => toHex();

  /// [toHex] is an extension to convert a [Color] to a hex string without transparency.
  String toHex() {
    String red = (255 * r).round().toRadixString(16);
    String green = (255 * g).round().toRadixString(16);
    String blue = (255 * b).round().toRadixString(16);

    return "#${red.padLeft(2, '0')}"
            "${green.padLeft(2, '0')}"
            "${blue.padLeft(2, '0')}"
        .toUpperCase();
  }

  /// [hex] is the alias for [toHex] to convert a [Color] to a hex string without transparency.
  String get hex => toHex();

  /// [toHexWithAlpha] is an extension to convert a [Color] to a hex string with transparency.
  String toHexWithAlpha() {
    String red = (255 * r).round().toRadixString(16);
    String green = (255 * g).round().toRadixString(16);
    String blue = (255 * b).round().toRadixString(16);
    String alpha = (255 * a).round().toRadixString(16);

    return "#${alpha.padLeft(2, '0')}"
            "${red.padLeft(2, '0')}"
            "${green.padLeft(2, '0')}"
            "${blue.padLeft(2, '0')}"
        .toUpperCase();
  }

  /// [hexWithAlpha] is the alias for [toHexWithAlpha] to convert a [Color] to a hex string with transparency.
  String get hexWithAlpha => toHexWithAlpha();

  /// [toInt] is an extension to convert a [Color] to an integer.
  int toInt() {
    return _floatToInt8(a) << 24 | _floatToInt8(r) << 16 | _floatToInt8(g) << 8 | _floatToInt8(b);
  }

  /// [fromJson] is an extension to convert a [Color] from a JSON string using [fromHex] function.
  static Color fromJson(String json) => fromHex(json);

  /// [fromHex] is an extension to convert a [Color] from a hex string without transparency.
  static Color fromHex(String hex) {
    String red = hex.substring(1, 3);
    String green = hex.substring(3, 5);
    String blue = hex.substring(5, 7);

    return Color.fromARGB(
      255,
      int.parse(red, radix: 16),
      int.parse(green, radix: 16),
      int.parse(blue, radix: 16),
    );
  }

  /// [fromHexWithAlpha] is an extension to convert a [Color] from a hex string with transparency.
  static Color fromHexWithAlpha(String hex) {
    String alpha = hex.substring(1, 3);
    String red = hex.substring(3, 5);
    String green = hex.substring(5, 7);
    String blue = hex.substring(7, 9);

    return Color.fromARGB(
      int.parse(alpha, radix: 16),
      int.parse(red, radix: 16),
      int.parse(green, radix: 16),
      int.parse(blue, radix: 16),
    );
  }

  static int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }
}
