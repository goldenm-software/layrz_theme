library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/src/helpers/helpers.dart';
import 'package:dio/dio.dart';
import 'dart:math' as math;

import 'package:layrz_icons/layrz_icons.dart';

part 'src/platform.dart';
part 'src/constants.dart';
part 'src/font.dart';
part 'src/utilities.dart';

// Generators
part 'src/generators/light.dart';
part 'src/generators/dark.dart';
part 'src/generators/wear_or.dart';
