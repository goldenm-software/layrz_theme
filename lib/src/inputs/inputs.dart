library inputs;

// Dependencies
import 'dart:async';
import 'dart:math';
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

// Code editor
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/python.dart' as python_lang;
import 'package:highlight/languages/javascript.dart' as javascript_lang;

// General inputs
part 'src/general/checkbox_input.dart';
part 'src/general/duallist_input.dart';
part 'src/general/duration_input.dart';
part 'src/general/dynamic_avatar_input.dart';
part 'src/general/dynamic_credentials_input.dart';
part 'src/general/number_input.dart';
part 'src/general/text_input.dart';
part 'src/general/radio_input.dart';
part 'src/general/search_input.dart';
part 'src/general/select_input.dart';
part 'src/general/multiselect_input.dart';

// Not-reviewed inputs (Basically not documented and/or upgraded to new format)
part 'src/code_editor.dart';

// Utilities
part 'src/utilities/select_item.dart';
part 'src/utilities/field_error.dart';
part 'src/utilities/input_like_container.dart';

/// Pickers
// Month Pickers
part 'src/pickers/month/single.dart';
part 'src/pickers/month/range.dart';

// General pickers
part 'src/pickers/general/file.dart';
part 'src/pickers/general/avatar.dart';
part 'src/pickers/general/color.dart';
part 'src/pickers/general/emoji.dart';
part 'src/pickers/general/icon.dart';

// Date Pickers
part 'src/pickers/date/single.dart';
part 'src/pickers/date/range.dart';

// Time Pickers
part 'src/pickers/time/single.dart';
part 'src/pickers/time/range.dart';
part 'src/pickers/time/utility.dart';

// Date Time Pickers
part 'src/pickers/datetime/single.dart';
part 'src/pickers/datetime/range.dart';
