part of '../tokenizer.dart';

extension ColorTokenizer on LayrzTokenizer {
  /// [info] is the color used for informational messages.
  Color get info => Colors.blue;

  /// [success] is the color used for success messages.
  Color get success => Colors.green;

  /// [warning] is the color used for warning messages.
  Color get warning => Colors.orange;

  /// [error] is the color used for error messages.
  Color get error => Colors.red;

  /// [danger] is an alias of [error], used for danger messages.
  Color get danger => error;

  /// [context] is the color used for contextual messages.
  Color get context => Colors.grey;

  /// [primary] is the primary color used for the system.
  Color get primary => Theme.of(ctx).primaryColor;
}
