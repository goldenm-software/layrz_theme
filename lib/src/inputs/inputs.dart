library;

// Dependencies
import 'dart:async';
import 'dart:math';

import 'package:code_text_field/code_text_field.dart';
import 'package:collection/collection.dart';
import 'package:emojis/emoji.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart' hide FlexPickerNoNullColorExtensions;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlight/highlight.dart';
import 'package:intl/intl.dart';
import 'package:layrz_icons/layrz_icons.dart';
import 'package:layrz_models/layrz_models.dart';

import 'package:layrz_theme/src/buttons/buttons.dart';
import 'package:layrz_theme/src/extensions/extensions.dart';
import 'package:layrz_theme/src/file.dart';
import 'package:layrz_theme/src/grid/grid.dart';
import 'package:layrz_theme/src/helpers/helpers.dart';
import 'package:layrz_theme/src/snackbar/snackbar.dart';
import 'package:layrz_theme/src/tabs/tabs.dart';
import 'package:layrz_theme/src/theme/theme.dart';
import 'package:layrz_theme/src/tooltips/tooltips.dart';
import 'package:layrz_theme/src/utilities/utilities.dart';
import 'package:layrz_theme/src/widgets/widgets.dart';

// Code editor
import 'package:layrz_theme/src/languages/lcl/lcl.dart' as lcl;
import 'package:layrz_theme/src/languages/lml/lml.dart' as lml;
import 'package:layrz_theme/src/languages/python/python.dart' as python;
import 'package:layrz_theme/src/languages/mjml/mjml.dart' as mjml;
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:url_launcher/url_launcher_string.dart';

export 'package:emojis/emoji.dart' show Emoji, EmojiGroup;
export 'package:flex_color_picker/flex_color_picker.dart' show ColorPickerType;
export 'package:intl/intl.dart' show NumberFormat;

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

// Blocks
part 'src/dynamic_configurable/block.dart';
part 'src/dynamic_configurable/dialog.dart';
