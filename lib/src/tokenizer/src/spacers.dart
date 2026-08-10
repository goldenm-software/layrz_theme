part of '../tokenizer.dart';

extension SpacerTokenizer on LayrzTokenizer {
  /// [spacer] is the default spacer used in the system.
  double get spacer => 8;

  /// [spacerSize] is the default spacer size used in the system.
  Size get spacerSize => Size(spacer, spacer);

  /// [spacerBox] is the default spacer box used in the system.
  Widget get spacerBox => SizedBox.fromSize(size: spacerSize);

  /// [margin] is the default margin used in the system.
  EdgeInsets get margin => EdgeInsets.all(spacer);

  /// [padding] is the default padding used in the system.
  EdgeInsets get padding => EdgeInsets.all(spacer);
}
