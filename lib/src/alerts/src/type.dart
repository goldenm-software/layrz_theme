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
  context;

  IconData get icon {
    switch (this) {
      case ThemedAlertType.info:
        return LayrzIcons.solarOutlineInfoSquare;
      case ThemedAlertType.success:
        return LayrzIcons.solarOutlineCheckSquare;
      case ThemedAlertType.warning:
        return LayrzIcons.solarOutlineDangerSquare;
      case ThemedAlertType.danger:
        return LayrzIcons.solarOutlineCloseSquare;
      case ThemedAlertType.context:
        return LayrzIcons.solarOutlineMenuDotsSquare;
    }
  }

  Color get color {
    switch (this) {
      case ThemedAlertType.info:
        return Colors.blue;
      case ThemedAlertType.success:
        return Colors.green;
      case ThemedAlertType.warning:
        return Colors.orange;
      case ThemedAlertType.danger:
        return Colors.red;
      case ThemedAlertType.context:
        return Colors.grey;
    }
  }
}
