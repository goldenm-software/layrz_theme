part of '../extensions.dart';

extension NumToSizedBox on num {
  /// [w] returns a [SizedBox] with the width set to the value of the [num].
  SizedBox get w => SizedBox(width: toDouble());

  /// [width] is an alias for [w]. returns a [SizedBox] with the width set to the value of the [num].
  SizedBox get width => w;

  /// [h] returns a [SizedBox] with the height set to the value of the [num].
  SizedBox get h => SizedBox(height: toDouble());

  /// [height] is an alias for [h]. returns a [SizedBox] with the height set to the value of the [num].
  SizedBox get height => h;

  /// [wh] returns a [SizedBox] with the width and height set to the value of the [num].
  SizedBox get wh => SizedBox(width: toDouble(), height: toDouble());

  /// [square] is an alias for [wh]. returns a [SizedBox] with the width and height set to the value of the [num].
  SizedBox get square => wh;
}
