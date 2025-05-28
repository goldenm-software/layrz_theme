part of '../snackbar.dart';

class ThemedSnackbar {
  /// [title] helps to build the title widget. If null, the title will not be displayed
  final String? title;

  /// [message] helps to build the message widget.
  final String message;

  /// [icon] helps to build the icon widget. If null, the icon will not be displayed
  final IconData? icon;

  /// [color] helps to build the background color of the snackbar
  final Color? color;

  /// [duration] helps to build the duration of the snackbar
  final Duration duration;

  /// [width] helps to build the width of the snackbar
  final double? width;

  /// [maxLines] helps to build the max lines of the message
  final int maxLines;

  /// [isDismissible] helps to build the dismissible behavior of the snackbar
  /// If true, the snackbar will render a close icon on the top right
  final bool isDismissible;

  /// [ThemedSnackbar] helps to build a snackbar with the current theme.
  /// It will be displayed on the top right of the screen and has the ability to stack multiple snackbars.
  ThemedSnackbar({
    this.title,
    required this.message,
    this.icon,
    this.color,
    this.duration = const Duration(seconds: 5),
    @Deprecated(
      'This property will be removed in favor of the messenger maxWidth property, '
      'and it will be removed on version 8.0.0',
    )
    this.width,
    @Deprecated('This property will not be used anymore, and it will be removed on version 8.0.0') this.maxLines = 2,
    this.isDismissible = true,
  }) : assert(message.isNotEmpty, 'Message must not be empty'),
       assert(duration.inSeconds > 0, 'Duration must be greater than 0 seconds');

  @override
  String toString() {
    Map<String, dynamic> toJson() {
      return {
        'title': title,
        'message': message,
        'icon': icon,
        'color': color?.hex,
        'duration': duration.inSeconds,
        'width': width,
        'maxLines': maxLines,
        'isDismissible': isDismissible,
      };
    }

    return 'ThemedSnackbar(${toJson().entries.map((e) => '${e.key}: ${e.value}').join(', ')})';
  }
}
