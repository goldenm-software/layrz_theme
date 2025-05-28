part of '../alerts.dart';

class ThemedAlertIcon extends StatelessWidget {
  /// [type] defines the type of alert icon to display.
  final ThemedAlertType type;

  /// [size] is the size of the alert icon container.
  final double size;

  /// [iconSize] is the size of the icon inside the alert icon container.
  final double iconSize;

  /// [padding] is the padding around the icon inside the alert icon container.
  final EdgeInsetsGeometry padding;

  /// [color] is the color of the alert icon, used only for [ThemedAlertType.custom].
  /// If not provided, the default color for the alert type will be used.
  final Color? color;

  /// [icon] is the icon of the alert, used only for [ThemedAlertType.custom].
  /// If not provided, the default icon for the alert type will be used.
  final IconData? icon;

  const ThemedAlertIcon({
    super.key,
    this.type = ThemedAlertType.info,
    this.size = 30,
    this.iconSize = 20,
    this.padding = const EdgeInsets.all(5),
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color typeColor = type.color ?? Colors.blue;
    if (type == ThemedAlertType.custom) {
      typeColor = color ?? type.color ?? Colors.blue;
    }

    IconData typeIcon = type.icon ?? LayrzIcons.solarOutlineInfoSquare;
    if (type == ThemedAlertType.custom) {
      typeIcon = icon ?? type.icon ?? LayrzIcons.solarOutlineInfoSquare;
    }

    return Container(
      width: size,
      height: size,
      padding: padding,
      decoration: BoxDecoration(
        color: typeColor.withAlpha((255 * 0.2).toInt()),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        typeIcon,
        color: typeColor,
        size: iconSize,
      ),
    );
  }
}
