library views;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/src/buttons/buttons.dart';
import 'package:layrz_theme/src/helpers/helpers.dart';
import 'package:layrz_theme/src/inputs/inputs.dart';
import 'package:layrz_theme/src/theme/theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

part 'src/about.dart';
part 'src/license.dart';

class ThemedLicense {
  final String package;
  final String excerpt;

  ThemedLicense({
    required this.package,
    required this.excerpt,
  });
}
