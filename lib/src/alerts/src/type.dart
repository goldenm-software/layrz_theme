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
  custom
  ;

  IconData? get icon {
    switch (this) {
      case .info:
        return LayrzIcons.solarOutlineInfoSquare;
      case .success:
        return LayrzIcons.solarOutlineCheckSquare;
      case .warning:
        return LayrzIcons.solarOutlineDangerSquare;
      case .danger:
        return LayrzIcons.solarOutlineCloseSquare;
      case .context:
        return LayrzIcons.solarOutlineMenuDotsSquare;
      default:
        return null; // For custom type, no default icon is provided
    }
  }

  Color? get color {
    switch (this) {
      case .info:
        return Colors.blue;
      case .success:
        return Colors.green;
      case .warning:
        return Colors.orange;
      case .danger:
        return Colors.red;
      case .context:
        return Colors.grey;
      default:
        return null; // For custom type, no default color is provided
    }
  }
}
