part of '../tabs.dart';

// Constants for ThemedTab styling
const double _kTabContainerBorderRadius = 8.0;
const double _kTabActiveAlpha = 0.2;
const double _kTabInternalPadding = 10.0;
const Duration _kTabAnimationDuration = Duration(milliseconds: 200);

class ThemedTab extends StatelessWidget {
  /// [labelText] is the label text of the input.
  /// Avoid submit [label] and [labelText] at the same time.
  final String? labelText;

  /// [label] is the label widget of the input.
  /// Avoid submit [label] and [labelText] at the same time.
  final Widget? label;

  /// [iconSize] is the size of the icon
  final double iconSize;

  /// [leading] is the widget to be displayed before the [labelText] or [label]
  /// Avoid using [leading] and [leadingIcon] together
  final Widget? leading;

  /// [leadingIcon] is the icon to be displayed before the [labelText] or [label]
  /// Avoid using [leading] and [leadingIcon] together
  final IconData? leadingIcon;

  /// [trailing] is the widget to be displayed after the [labelText] or [label]
  /// Avoid using [trailing] and [trailingIcon] together
  final Widget? trailing;

  /// [trailingIcon] is the icon to be displayed after the [labelText] or [label]
  /// Avoid using [trailing] and [trailingIcon] together
  final IconData? trailingIcon;

  /// [padding] is the Padding of the tab
  final EdgeInsets padding;

  /// [color] is the color of the tab
  final Color? color;

  /// [child] is the child of the tab
  /// This information is only used when the tab is a child of a [ThemedTabView]
  final Widget child;

  /// [style] is the style of the tab
  final ThemedTabStyle style;

  /// [ThemedTab] is a tab for the [TabBar] widget
  const ThemedTab({
    super.key,
    this.labelText,
    this.label,
    this.iconSize = 30,
    this.leading,
    this.leadingIcon,
    this.trailing,
    this.trailingIcon,
    this.padding = const EdgeInsets.all(10),
    this.color,
    this.child = const SizedBox(),
    this.style = .filledTonal,
  }) : assert(labelText != null || label != null);

  ThemedTab overrideStyle(ThemedTabStyle newStyle) {
    return ThemedTab(
      key: key,
      labelText: labelText,
      label: label,
      iconSize: iconSize,
      leading: leading,
      leadingIcon: leadingIcon,
      trailing: trailing,
      trailingIcon: trailingIcon,
      padding: padding,
      color: color,
      style: newStyle,
      child: child,
    );
  }

  /// Compares two colors for equality (RGB + Alpha)
  static bool _colorsAreEqual(Color a, Color b) {
    return a.r == b.r && a.g == b.g && a.b == b.b && a.a == b.a;
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final fallbackColor = DefaultTextStyle.of(context).style.color ?? primary;
    final backgroundColor = color ?? fallbackColor;

    // Determine if active by comparing colors
    // Note: This is a heuristic since the tab doesn't have direct access to TabController.index
    final isActive = _colorsAreEqual(backgroundColor, primary);

    return AnimatedContainer(
      duration: _kTabAnimationDuration,
      padding: padding,
      decoration: style == .filledTonal
          ? BoxDecoration(
              color: isActive ? backgroundColor.withAlpha((255 * _kTabActiveAlpha).toInt()) : Colors.transparent,
              borderRadius: BorderRadius.circular(_kTabContainerBorderRadius),
            )
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _kTabInternalPadding),
        child: RichText(
          text: TextSpan(
            children: [
              if (leading != null || leadingIcon != null) ...[
                WidgetSpan(
                  alignment: .middle,
                  child: leading ?? Icon(leadingIcon!, size: iconSize, color: backgroundColor),
                ),
                WidgetSpan(child: SizedBox(width: _kTabInternalPadding)),
              ],
              if (label != null) ...[
                WidgetSpan(child: label!),
              ] else ...[
                TextSpan(
                  text: labelText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: backgroundColor),
                ),
              ],
              if (trailing != null || trailingIcon != null) ...[
                WidgetSpan(child: SizedBox(width: _kTabInternalPadding)),
                WidgetSpan(
                  alignment: .middle,
                  child: trailing ?? Icon(trailingIcon!, size: iconSize, color: backgroundColor),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
