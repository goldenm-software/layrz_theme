part of '../extensions.dart';

/// [ColorToJson] is an extension to convert a [Color] to a JSON string.
extension ColorToJson on Color {
  /// [toJson] is an extension to convert a [Color] to a JSON string using [toHex] function.
  String toJson() => toHex();

  /// [toHex] is an extension to convert a [Color] to a hex string without transparency.
  String toHex() {
    String red = this.red.toRadixString(16);
    String green = this.green.toRadixString(16);
    String blue = this.blue.toRadixString(16);

    return "#${red.padLeft(2, '0')}"
            "${green.padLeft(2, '0')}"
            "${blue.padLeft(2, '0')}"
        .toUpperCase();
  }

  /// [toHexWithAlpha] is an extension to convert a [Color] to a hex string with transparency.
  String toHexWithAlpha() {
    String red = this.red.toRadixString(16);
    String green = this.green.toRadixString(16);
    String blue = this.blue.toRadixString(16);
    String alpha = this.alpha.toRadixString(16);

    return "#${alpha.padLeft(2, '0')}"
            "${red.padLeft(2, '0')}"
            "${green.padLeft(2, '0')}"
            "${blue.padLeft(2, '0')}"
        .toUpperCase();
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
}
