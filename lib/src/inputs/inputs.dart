library inputs;

// Dependencies
import 'dart:async';
import 'package:code_text_field/code_text_field.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:humanize_duration/humanize_duration.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

// Code editor
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/python.dart' as python_lang;
import 'package:highlight/languages/javascript.dart' as javascript_lang;

// General inputs
part 'src/checkbox_input.dart';
part 'src/code_editor.dart';
part 'src/duallist_input.dart';
part 'src/duration_input.dart';
part 'src/dynamic_avatar_input.dart';
part 'src/dynamic_credentials_input.dart';
part 'src/field_error.dart';
part 'src/file_input.dart';
part 'src/internal_date_draw.dart';
part 'src/multiselect_input.dart';
part 'src/radio_input.dart';
part 'src/search_input.dart';
part 'src/select_input.dart';
part 'src/select_item.dart';
part 'src/text_input.dart';
part 'src/time_picker.dart';
part 'src/number_input.dart';

// Utilities
part 'src/utilities/input_like_container.dart';

// Pickers
part 'src/pickers/month/single.dart';
part 'src/pickers/month/range.dart';

part 'src/pickers/datetime_picker.dart';
part 'src/pickers/avatar_input.dart';
part 'src/pickers/color_picker.dart';
part 'src/pickers/datetime_range_picker_variant.dart';
part 'src/pickers/datetime_range_picker.dart';
part 'src/pickers/emoji_picker.dart';
part 'src/pickers/icon_picker.dart';
