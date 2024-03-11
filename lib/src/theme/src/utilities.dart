part of '../theme.dart';

class ThemedInputBorder extends InputBorder {
  const ThemedInputBorder({
    super.borderSide = BorderSide.none,
  });

  BorderRadius get borderRadius => BorderRadius.circular(10);

  @override
  InputBorder copyWith({BorderSide? borderSide}) => ThemedInputBorder(borderSide: borderSide ?? this.borderSide);

  @override
  EdgeInsetsGeometry get dimensions => throw UnimplementedError();

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRect(Rect.fromLTWH(rect.left, rect.top, rect.width, math.max(0.0, rect.height - borderSide.width)));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  bool get isOutline => false;

  /// Draw a horizontal line at the bottom of [rect].
  ///
  /// The [borderSide] defines the line's color and weight. The `textDirection`
  /// `gap` and `textDirection` parameters are ignored.
  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    canvas.drawLine(rect.bottomLeft, rect.bottomRight, borderSide.toPaint());
  }

  @override
  ThemedInputBorder scale(double t) {
    return ThemedInputBorder(borderSide: borderSide.scale(t));
  }
}
