library;

import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';

part 'src/colors.dart';
part 'src/shadows.dart';
part 'src/radius.dart';
part 'src/spacers.dart';

/// [LayrzTokenizer] defines the rules and colors applied to the entire system
class LayrzTokenizer {
  final BuildContext ctx;

  /// [LayrzTokenizer] defines the rules and colors applied to the entire system
  LayrzTokenizer(this.ctx);

  /// [of] returns the current instance of [LayrzTokenizer] from the context
  static LayrzTokenizer of(BuildContext ctx) {
    return LayrzTokenizer(ctx);
  }
}
