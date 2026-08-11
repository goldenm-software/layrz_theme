part of '../snackbar.dart';

enum ThemedSnackbarType {
  /// [custom] is the default type of the snackbar.
  custom,

  /// [success] is the success type of the snackbar.
  success,

  /// [error] is the error type of the snackbar.
  error,

  /// [warning] is the warning type of the snackbar.
  warning,

  /// [info] is the info type of the snackbar.
  info,

  /// [context] is the context type of the snackbar.
  context,
  ;

  Color? color(Color? color) {
    switch (this) {
      case ThemedSnackbarType.custom:
        return color;
      case ThemedSnackbarType.success:
        return LayrzTokenizer.of(null).success;
      case ThemedSnackbarType.error:
        return LayrzTokenizer.of(null).error;
      case ThemedSnackbarType.warning:
        return LayrzTokenizer.of(null).warning;
      case ThemedSnackbarType.info:
        return LayrzTokenizer.of(null).info;
      case ThemedSnackbarType.context:
        return LayrzTokenizer.of(null).context;
    }
  }
}
