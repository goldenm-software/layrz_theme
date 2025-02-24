library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/src/helpers/helpers.dart';
import 'package:layrz_theme/src/inputs/inputs.dart';
import 'package:layrz_theme/src/theme/theme.dart';
import 'package:layrz_icons/layrz_icons.dart';

part 'src/about.dart';

class ThemedLicense {
  final String package;
  final String excerpt;

  ThemedLicense({
    required this.package,
    required this.excerpt,
  });
}
