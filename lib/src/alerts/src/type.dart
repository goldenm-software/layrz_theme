part of '../alerts.dart';

/// [ThemedAlertType] defines the type of the alert.
enum ThemedAlertType {
  /// [info] is the type of alert that displays information. The background color is blue and the icon is an info icon.
  info,

  /// [success] is the type of alert that displays success messages. The background color is green and the
  /// icon is a check icon.
  success,

  /// [warning] is the type of alert that displays warning messages. The background color is orange and the
  /// icon is a warning icon.
  warning,

  /// [danger] is the type of alert that displays danger messages. The background color is red and the
  /// icon is a close icon.
  danger,

  /// [context] is the type of alert that displays contextual messages. The background color is grey and the
  /// icon is a menu dots icon.
  context,

  /// [custom] is the type of alert that allows for custom icons and colors.
  custom;

  IconData? get icon {
    switch (this) {
      case .info:
        return MdiIcons.informationBoxOutline;
      case .success:
        return MdiIcons.checkboxMarkedOutline;
      case .warning:
        return MdiIcons.alertBoxOutline;
      case .danger:
        return MdiIcons.closeBoxOutline;
      case .context:
        return MdiIcons.dotsHorizontalCircleOutline;
      default:
        return null; // For custom type, no default icon is provided
    }
  }

  Color? color(BuildContext context) {
    final t = LayrzTokenizer.of(context);
    switch (this) {
      case .info:
        return t.info;
      case .success:
        return t.success;
      case .warning:
        return t.warning;
      case .danger:
        return t.danger;
      case .context:
        return t.context;
      default:
        return null; // For custom type, no default color is provided
    }
  }
}
