part of layrz_theme;

extension ColorToJson on Color {
  String toJson() {
    String red = this.red.toRadixString(16);
    String green = this.green.toRadixString(16);
    String blue = this.blue.toRadixString(16);

    return "#${red.padLeft(2, '0')}${green.padLeft(2, '0')}${blue.padLeft(2, '0')}".toUpperCase();
  }

  static Color fromJson(String json) {
    String red = json.substring(1, 3);
    String green = json.substring(3, 5);
    String blue = json.substring(5, 7);

    return Color.fromARGB(255, int.parse(red, radix: 16), int.parse(green, radix: 16), int.parse(blue, radix: 16));
  }
}
