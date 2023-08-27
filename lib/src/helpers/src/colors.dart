part of helpers;

/// [useBlack] is a helper function to detect if the color should have the content
/// with [Colors.White] or [Colors.black] color.
/// Will return a [bool] indicating if the color should be [Colors.White] or [Colors.black].
bool useBlack({required Color color, double tolerance = 0.5}) {
  final luminance = color.computeLuminance();
  return luminance > tolerance;
}

/// [useBlack] is a helper function to detect if the color should have the content
/// with [Colors.White] or [Colors.black] color.
/// Will return a [Color] indicating if the color.
Color validateColor({required Color color}) {
  if (useBlack(color: color)) {
    return Colors.black;
  }
  return Colors.white;
}

/// [getPrimaryColor] is a helper function to get the primary color of the app.
///
/// If [primary] is not null, it will return [kPrimaryColor] instead.
Color getPrimaryColor({Color? primary}) {
  return primary ?? kPrimaryColor;
}

/// [getAccentColor] is a helper function to get the accent color of the app.
///
/// If [accent] is not null, it will return [kAccentColor] instead.
Color getAccentColor({Color? accent}) {
  return accent ?? kAccentColor;
}
