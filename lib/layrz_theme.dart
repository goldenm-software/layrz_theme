// ignore_for_file: implementation_imports

library layrz_theme;

// Dependencies
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:code_text_field/code_text_field.dart';
import 'package:collection/collection.dart';
import 'package:confetti/confetti.dart';
import 'package:emojis/emoji.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:get_it/get_it.dart';
import 'package:humanize_duration/humanize_duration.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mime/mime.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

// Code editor
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/python.dart' as python_lang;
import 'package:highlight/languages/javascript.dart' as javascript_lang;
import 'package:shared_preferences/shared_preferences.dart';

export 'package:emojis/emoji.dart' show Emoji, EmojiGroup;
export 'package:file_picker/file_picker.dart' show FileType;

// Constructors and constants
part 'src/theme/constants.dart';
part 'src/theme/light_theme.dart';
part 'src/theme/dark_theme.dart';

// Buittons and actions
part 'src/buttons/button.dart';
part 'src/buttons/actions_buttons.dart';
part 'src/buttons/checkbox.dart';

// Inputs
part 'src/inputs/radio_input.dart';
part 'src/inputs/multiselect_input.dart';
part 'src/inputs/select_input.dart';
part 'src/inputs/text_input.dart';
part 'src/inputs/file_input.dart';
part 'src/inputs/time_picker.dart';
part 'src/inputs/duallist_input.dart';
part 'src/inputs/select_item.dart';
part 'src/inputs/checkbox_input.dart';
part 'src/inputs/color_picker.dart';
part 'src/inputs/avatar_input.dart';
part 'src/inputs/field_error.dart';
part 'src/inputs/icon_picker.dart';
part 'src/inputs/datetime_picker.dart';
part 'src/inputs/datetime_range_picker.dart';
part 'src/inputs/internal_date_draw.dart';
part 'src/inputs/code_editor.dart';
part 'src/inputs/emoji_picker.dart';
part 'src/inputs/dynamic_avatar_input.dart';
part 'src/inputs/datetime_range_picker_variant.dart';
part 'src/inputs/dynamic_credentials_input.dart';
part 'src/inputs/search_input.dart';
part 'src/inputs/duration_input.dart';
part 'src/inputs/input_like_container.dart';

// Views
part 'src/views/wip.dart';
part 'src/views/about.dart';

// Responsive grid
part 'src/responsive/sizes.dart';
part 'src/responsive/row.dart';
part 'src/responsive/col.dart';

// Layout
part 'src/layout/view.dart';
part 'src/layout/appbar.dart';
part 'src/layout/taskbar.dart';
part 'src/layout/drawer.dart';
part 'src/layout/menu.dart';
part 'src/layout/sidebar.dart';

// ORM
part 'src/orm/orm.dart';

// Extensions
part 'src/extensions/datetime.dart';
part 'src/extensions/color.dart';

// Snackbar
part 'src/snackbar/snackbar.dart';
part 'src/snackbar/function.dart';
part 'src/snackbar/controller.dart';

// Language theme
part 'src/languages/layrz_compute_language.dart';
part 'src/languages/layrz_markup_language.dart';
part 'src/languages/mjml_language.dart';

// Scaffolds
part 'src/scaffolds/sidebar.dart';
part 'src/scaffolds/table/table.dart';
part 'src/scaffolds/table/column.dart';
part 'src/scaffolds/table/action.dart';
part 'src/scaffolds/table/avatar.dart';
part 'src/scaffolds/cell.dart';

// Delegates
part 'src/delegates/grid_fixed_height.dart';

// Helpers
part 'src/helpers/get_image.dart';
part 'src/helpers/draw_avatar.dart';
part 'src/helpers/generate_swatch.dart';
part 'src/helpers/get_theme_color.dart';
part 'src/helpers/colors.dart';
part 'src/helpers/fonts.dart';
part 'src/helpers/container_shadow.dart';
part 'src/helpers/parse_file.dart';
part 'src/helpers/about_dialog.dart';
