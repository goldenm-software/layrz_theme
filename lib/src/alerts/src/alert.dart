part of '../alerts.dart';

class ThemedAlert extends StatelessWidget {
  /// [type] defines the type of alert to display.
  final ThemedAlertType type;

  /// [title] is the title of the alert.
  final String title;

  /// [description] is the description of the alert.
  final String description;

  /// [maxLines] is the maximum number of lines for the description text.
  final int maxLines;

  /// [style] is the style of the alert.
  final ThemedAlertStyle style;

  /// [color] is the color of the alert, used only for [.custom].
  /// If not provided, the default color for the alert type will be used.
  final Color? color;

  /// [icon] is the icon of the alert, used only for [.custom].
  /// If not provided, the default icon for the alert type will be used.
  final IconData? icon;

  /// [iconSize] is the size of the icon inside the alert.
  ///
  /// By default, on [.filledIcon] it is set to 25 and on
  /// [.layrz] it is set to 22.
  final double? iconSize;

  /// [ThemedAlert] is a widget that displays an alert with a specific type, title, and description.
  ///
  /// Uses internally a [Row] widget to layout the alert content, so, it is required to have dimensions
  /// defined by the parent widget.
  const ThemedAlert({
    super.key,
    this.type = .info,
    required this.title,
    required this.description,
    this.maxLines = 3,
    this.style = .layrz,
    this.color,
    this.icon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    Color typeColor = type.color ?? Colors.blue;
    if (type == .custom) {
      typeColor = color ?? type.color ?? Colors.blue;
    }

    IconData typeIcon = type.icon ?? LayrzIcons.solarOutlineInfoSquare;
    if (type == .custom) {
      typeIcon = icon ?? type.icon ?? LayrzIcons.solarOutlineInfoSquare;
    }

    if (style == .filledIcon) {
      return Container(
        decoration: BoxDecoration(
          color: typeColor,
          border: Border.all(
            color: typeColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: .antiAlias,
        child: Row(
          children: [
            Container(
              padding: const .all(10),
              child: Center(
                child: Icon(
                  typeIcon,
                  color: validateColor(color: typeColor),
                  size: iconSize ?? 25,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: .only(topRight: .circular(8), bottomRight: .circular(8)),
                ),
                padding: const .all(10),
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      title,
                      style: context.subtitleStyle,
                    ),
                    Text(
                      description,
                      style: context.bodyStyle,
                      maxLines: maxLines,
                      textAlign: .justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Color? backgroundColor;
    Color? borderColor;
    Color? textColor;

    if (style == .filledTonal) {
      backgroundColor = typeColor.withAlpha((255 * 0.2).toInt());
      borderColor = Colors.transparent;
      textColor = typeColor;
    } else if (style == .filled) {
      backgroundColor = typeColor;
      borderColor = typeColor;
      textColor = validateColor(color: typeColor);
    } else if (style == .outlined) {
      backgroundColor = Colors.transparent;
      borderColor = typeColor;
      textColor = typeColor;
    }

    bool isLayrzStyle = style == .layrz;

    return Container(
      padding: const .all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: .all(color: borderColor ?? Colors.transparent, width: 1),
        borderRadius: .circular(10),
      ),
      child: Column(
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          Row(
            children: [
              if (!isLayrzStyle) ...[
                const SizedBox(width: 5),
              ],
              Container(
                padding: .all(isLayrzStyle ? 5 : 0),
                decoration: BoxDecoration(
                  color: isLayrzStyle ? typeColor.withAlpha((255 * 0.2).toInt()) : null,
                  borderRadius: .circular(10),
                ),
                child: Icon(
                  typeIcon,
                  color: isLayrzStyle ? typeColor : textColor,
                  size: iconSize ?? 22,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: context.subtitleStyle?.copyWith(color: textColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: context.bodyStyle?.copyWith(color: textColor),
            maxLines: maxLines,
            textAlign: .justify,
          ),
        ],
      ),
    );
  }
}
