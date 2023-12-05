part of '../grid.dart';

///
/// Sizes is enum
///
/// each col represents the number of columns that your widget will occupy,
/// with a maximum of 12 columns,
/// represented by [col12]
///
///
enum Sizes { col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12 }

extension SizesExt on Sizes {
  ///
  /// returns the screen size divided by the number of columns your widget will occupy
  ///
  double boxWidth(double width) {
    double size = (width / 12) * gridSize;
    return size;
  }

  // Get size of the container in col number
  int get gridSize {
    switch (this) {
      case Sizes.col1:
        return 1;
      case Sizes.col2:
        return 2;
      case Sizes.col3:
        return 3;
      case Sizes.col4:
        return 4;
      case Sizes.col5:
        return 5;
      case Sizes.col6:
        return 6;
      case Sizes.col7:
        return 7;
      case Sizes.col8:
        return 8;
      case Sizes.col9:
        return 9;
      case Sizes.col10:
        return 10;
      case Sizes.col11:
        return 11;
      case Sizes.col12:
        return 12;
    }
  }
}
