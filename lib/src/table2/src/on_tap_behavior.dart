part of '../table2.dart';

/// [ThemedTable2OnTapBehavior] defines the default behavior when a cell in the table is tapped.
enum ThemedTable2OnTapBehavior {
  /// [none] indicates that no action should be taken when a cell is tapped.
  none,

  /// [copyToClipboard] indicates that the content of the tapped cell should be copied to the clipboard.
  copyToClipboard,
}
