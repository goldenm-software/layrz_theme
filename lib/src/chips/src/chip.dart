part of '../chips.dart';

class ThemedChip extends StatelessWidget {
  /// [content] is the content of the chip, only text.
  final String content;

  /// [color] is the color of the chip.
  final Color color;

  /// [padding] is the padding of the chip.
  /// By default, it is set to `EdgeInsets.symmetric(horizontal: 10, vertical: 5)`.
  final EdgeInsetsGeometry padding;

  /// [labelText] is the text label of the chip.
  final String? labelText;

  /// [style] defines the style of the chip.
  final ThemedChipStyle style;

  /// [borderRadius] is the border radius of the chip.
  final double borderRadius;

  /// [onDismiss] is the callback when the chip is dismissed.
  ///
  /// If null, the chip is not dismissable.
  final VoidCallback? onDismiss;

  /// [leadingIcon] is the leading icon of the chip.
  final IconData? leadingIcon;

  /// [ThemedChip] is a widget that displays a content in the chip style.
  const ThemedChip({
    super.key,
    @Deprecated('Use labelText property') this.content = '',
    this.color = Colors.blue,
    this.padding = const .symmetric(horizontal: 10, vertical: 5),
    this.labelText,
    this.style = .filledTonal,
    this.borderRadius = 10,
    this.onDismiss,
    this.leadingIcon,
  }) : assert(
         labelText != null || content.length > 0,
         'Either labelText or content must be provided',
       );

  double computeWidth(BuildContext context) {
    double width = 0;
    TextPainter painter;
    painter = TextPainter(
      text: TextSpan(
        text: labelText ?? content,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      maxLines: 1,
      textDirection: .ltr,
    )..layout();
    width += painter.width;
    if (onDismiss != null) {
      width += 18 + 10; // Icon size + spacing
    }

    if (leadingIcon != null) {
      width += 18 + 5; // Icon size + spacing
    }

    // debugPrint("Computed width before padding: $width");
    width += padding.horizontal;
    // debugPrint("Computed width after padding: $width");

    return width;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    BoxDecoration decoration;
    TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;

    switch (style) {
      case .outlined:
        decoration = BoxDecoration(
          border: Border.all(color: color),
          borderRadius: .circular(borderRadius),
        );
        textStyle = textStyle?.copyWith(color: color);
        break;
      case .elevated:
        decoration = BoxDecoration(
          color: color,
          borderRadius: .circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.2).toInt()),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        );
        textStyle = textStyle?.copyWith(color: validateColor(color: color));
        break;
      case .filled:
        decoration = BoxDecoration(
          color: color,
          borderRadius: .circular(borderRadius),
        );
        textStyle = textStyle?.copyWith(color: validateColor(color: color));
        break;
      case .filledTonal:
      // ignore: unreachable_switch_default
      default:
        decoration = BoxDecoration(
          color: color.withAlpha((255 * 0.2).toInt()),
          borderRadius: .circular(borderRadius),
        );
        textStyle = textStyle?.copyWith(color: color);
        break;
    }

    if (onDismiss != null) {
      child = RichText(
        overflow: .ellipsis,
        text: TextSpan(
          children: [
            if (leadingIcon != null) ...[
              WidgetSpan(
                alignment: .middle,
                child: Icon(
                  leadingIcon,
                  color: textStyle?.color,
                  size: 18,
                ),
              ),
              WidgetSpan(child: 5.w),
            ],
            TextSpan(
              text: labelText ?? content,
              style: textStyle,
            ),
            WidgetSpan(child: 10.w),
            WidgetSpan(
              alignment: .middle,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: .circular(20),
                  onTap: onDismiss,
                  child: Icon(
                    LayrzIcons.solarBoldCloseCircle,
                    color: textStyle?.color,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      child = RichText(
        overflow: .ellipsis,
        text: TextSpan(
          children: [
            if (leadingIcon != null) ...[
              WidgetSpan(
                alignment: .middle,
                child: Icon(
                  leadingIcon,
                  color: textStyle?.color,
                  size: 18,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 5)),
            ],
            TextSpan(
              text: labelText ?? content,
              style: textStyle,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: padding,
      decoration: decoration,
      child: child,
    );
  }
}

enum ThemedChipStyle {
  /// [filledTonal] is a filled tonal chip style.
  filledTonal,

  /// [outlined] is an outlined chip style.
  outlined,

  /// [filled] is a filled chip style.
  filled,

  /// [elevated] is an elevated chip style.
  elevated,
}
