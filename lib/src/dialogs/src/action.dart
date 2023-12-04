part of '../dialogs.dart';

class ThemedDialogAction {
  /// [labelText] is the text of the action.
  /// If [labelText] is null, [label] will be used instead.
  final String? labelText;

  /// [label] is the text of the action.
  /// Avoid using this property if [labelText] is not null.
  final Widget? label;

  /// [onTap] is the callback of the action.
  final VoidCallback? onTap;

  /// [isLoading] is the loading state of the action.
  final bool isLoading;

  /// [isCooldown] is the cooldown state of the action.
  final bool isCooldown;

  /// [onCooldown] is the callback of the cooldown state of the action.
  final VoidCallback? onCooldown;

  /// [isDisabled] is the disabled state of the action.
  final bool isDisabled;

  /// [style] is the style of the action.
  final ThemedButtonStyle style;

  /// [color] is the color of the action.
  /// If [color] is null, the primary color will be used instead.
  final Color? color;

  /// [icon] is the icon of the action.
  final IconData? icon;

  /// [ThemedDialogAction] is an action of a dialog with a theme.
  /// This class is a wrapper of [ThemedButton], so, in the widget tree, it will be a [ThemedButton].
  const ThemedDialogAction({
    this.labelText,
    this.label,
    this.onTap,
    this.isLoading = false,
    this.isCooldown = false,
    this.onCooldown,
    this.isDisabled = false,
    this.style = ThemedButtonStyle.filledTonal,
    this.color,
    this.icon,
  });
}
