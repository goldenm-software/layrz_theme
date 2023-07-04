part of layout;

class NotificationShape extends ShapeBorder {
  final double radius;
  final double arrowSize;

  const NotificationShape({
    required this.radius,
    this.arrowSize = 10,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path()
      ..moveTo(rect.left, rect.top + radius)
      ..lineTo(rect.left, rect.bottom - radius)
      ..quadraticBezierTo(rect.left, rect.bottom, rect.left + radius, rect.bottom)
      ..lineTo(rect.right - radius, rect.bottom)
      ..lineTo(rect.right, rect.bottom + arrowSize)
      ..lineTo(rect.right, rect.top)
      ..quadraticBezierTo(rect.right, rect.top, rect.right - radius, rect.top)
      ..lineTo(rect.left + radius, rect.top)
      ..quadraticBezierTo(rect.left, rect.top, rect.left, rect.top + radius)
      ..close();
    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return getInnerPath(rect, textDirection: textDirection);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    canvas.drawPaint(BorderSide.none.toPaint());
  }

  @override
  ShapeBorder scale(double t) {
    return NotificationShape(radius: radius * t, arrowSize: arrowSize * t);
  }
}
