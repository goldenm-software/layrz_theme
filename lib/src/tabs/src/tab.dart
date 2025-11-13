part of '../tabs.dart';

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
    this.style = ThemedTabStyle.filledTonal,
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

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    Color backgroundColor = color ?? DefaultTextStyle.of(context).style.color ?? primary;
    final bool redMatch = primary.r == backgroundColor.r;
    final bool greenMatch = primary.g == backgroundColor.g;
    final bool blueMatch = primary.b == backgroundColor.b;

    final isActive = redMatch && greenMatch && blueMatch;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: padding,
      decoration: style == ThemedTabStyle.filledTonal
          ? BoxDecoration(
              color: isActive ? backgroundColor.withAlpha((255 * 0.2).toInt()) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: RichText(
          text: TextSpan(
            children: [
              if (leading != null || leadingIcon != null) ...[
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: leading ?? Icon(leadingIcon!, size: iconSize, color: backgroundColor),
                ),
                const WidgetSpan(child: SizedBox(width: 10)),
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
                const WidgetSpan(child: SizedBox(width: 10)),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
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
