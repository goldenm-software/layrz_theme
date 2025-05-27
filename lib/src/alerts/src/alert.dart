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

  /// [ThemedAlert] is a widget that displays an alert with a specific type, title, and description.
  ///
  /// Uses internally a [Row] widget to layout the alert content, so, it is required to have dimensions
  /// defined by the parent widget.
  const ThemedAlert({
    super.key,
    this.type = ThemedAlertType.info,
    required this.title,
    required this.description,
    this.maxLines = 3,
    this.style = ThemedAlertStyle.layrz,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? borderColor;
    Color? textColor;

    if (style == ThemedAlertStyle.filledTonal) {
      backgroundColor = type.color.withAlpha((255 * 0.2).toInt());
      borderColor = Colors.transparent;
      textColor = type.color;
    } else if (style == ThemedAlertStyle.filled) {
      backgroundColor = type.color;
      borderColor = type.color;
      textColor = validateColor(color: type.color);
    } else if (style == ThemedAlertStyle.outlined) {
      backgroundColor = Colors.transparent;
      borderColor = type.color;
      textColor = type.color;
    }

    bool isLayrzStyle = style == ThemedAlertStyle.layrz;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor ?? Colors.transparent, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (!isLayrzStyle) ...[
                const SizedBox(width: 5),
              ],
              Container(
                padding: EdgeInsets.all(isLayrzStyle ? 5 : 0),
                decoration: BoxDecoration(
                  color: isLayrzStyle ? type.color.withAlpha((255 * 0.2).toInt()) : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  type.icon,
                  color: isLayrzStyle ? type.color : textColor,
                  size: 20,
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
          ),
        ],
      ),
    );
  }
}
