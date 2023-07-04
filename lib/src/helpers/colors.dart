part of helpers;

/// [useBlack] is a helper function to detect if the color should have the content
/// with [Colors.White] or [Colors.black] color.
/// Will return a [bool] indicating if the color should be [Colors.White] or [Colors.black].
bool useBlack({required Color color}) {
  double grayscale = (0.299 * color.red) + (0.587 * color.green) + (0.114 * color.blue);
  if (grayscale > 128) {
    // Use a light color
    return true;
  } else {
    // Use a dark color
    return false;
  }
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

Color getPrimaryColor({Color? primary}) {
  return primary ?? kPrimaryColor;
}

Color getAccentColor({Color? accent}) {
  return accent ?? kAccentColor;
}
