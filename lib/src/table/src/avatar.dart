part of '../table.dart';

class ThemedTableAvatar {
  /// Represents the name, label or identifier of the avatar.
  final String? label;

  /// Represents the icon of the avatar.
  final IconData? icon;

  /// Represents the color of the avatar.
  final Color? color;

  /// Represents the avatar URI or path of the avatar.
  final String? avatar;

  /// Represents the dynamic avatar configuration. This is used when you want to display a dynamic avatar
  /// using the Layrz configuration.
  final Avatar? dynamicAvatar;

  /// An avatar of the table when is in mobile mode.
  ThemedTableAvatar({
    this.label,
    this.dynamicAvatar,
    this.icon,
    this.color,
    this.avatar,
  });
}
