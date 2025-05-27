part of '../alerts.dart';

class ThemedAlertIcon extends StatelessWidget {
  final ThemedAlertType type;
  final double size;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  const ThemedAlertIcon({
    super.key,
    this.type = ThemedAlertType.info,
    this.size = 30,
    this.iconSize = 20,
    this.padding = const EdgeInsets.all(5),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: padding,
      decoration: BoxDecoration(
        color: type.color.withAlpha((255 * 0.2).toInt()),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        type.icon,
        color: type.color,
        size: iconSize,
      ),
    );
  }
}
