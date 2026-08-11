part of '../tokenizer.dart';

extension SpacerTokenizer on LayrzTokenizer {
  /// [spacing] is the default spacer used in the system.
  double get spacing => 8;

  /// [spacingSize] is the default spacer size used in the system.
  Size get spacingSize => Size(spacing, spacing);

  /// [sizedBox] is the default spacer box used in the system.
  Widget get sizedBox => SizedBox.fromSize(size: spacingSize);

  /// [margin] is the default margin used in the system.
  EdgeInsets get margin => EdgeInsets.all(spacing);

  /// [reducedMargin] is the default reduced margin divided by 2 used in the system.
  EdgeInsets get reducedMargin => EdgeInsets.all(spacing / 2);

  /// [padding] is the default padding used in the system.
  EdgeInsets get padding => EdgeInsets.all(spacing);
}
