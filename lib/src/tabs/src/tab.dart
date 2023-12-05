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
  }) : assert(labelText != null || label != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (leading != null || leadingIcon != null) ...[
            leading ??
                Icon(
                  leadingIcon!,
                  size: iconSize,
                  color: color,
                ),
            const SizedBox(width: 10),
          ],
          label ?? Text(labelText ?? '', style: TextStyle(color: color)),
          if (trailing != null || trailingIcon != null) ...[
            const SizedBox(width: 10),
            trailing ??
                Icon(
                  trailingIcon!,
                  size: iconSize,
                  color: color,
                ),
          ],
        ],
      ),
    );
  }
}
