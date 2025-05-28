library;

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:layrz_icons/layrz_icons.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/layrz_theme.dart';
export 'src/save_file/native.dart' if (dart.library.js_interop) 'src/save_file/web.dart';
export 'src/pick_file/native.dart' if (dart.library.js_interop) 'src/pick_file/web.dart';

part 'src/about_dialog.dart';
part 'src/colors.dart';
part 'src/container_shadow.dart';
part 'src/draw_avatar.dart';
part 'src/generate_swatch.dart';
part 'src/get_image.dart';
part 'src/get_theme_color.dart';
part 'src/parse_file.dart';
