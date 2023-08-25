library layrz_theme;

// Package dependencies
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:highlight/highlight.dart';

// Internal dependencies
import 'src/helpers/helpers.dart';
import 'src/inputs/inputs.dart';
import 'src/tooltips/tooltips.dart';

// Library exports
export 'package:emojis/emoji.dart' show Emoji, EmojiGroup;
export 'package:file_picker/file_picker.dart' show FileType;
export 'package:flex_color_picker/flex_color_picker.dart' show ColorPickerType;

// Sub-libraries exports
export 'src/tooltips/tooltips.dart';
export 'src/layout/layout.dart';
export 'src/inputs/inputs.dart';
export 'src/helpers/helpers.dart';
export 'src/file.dart';
export 'src/layo.dart';

/// Parts
// Constructors and constants
part 'src/theme/constants.dart';
part 'src/theme/light_theme.dart';
part 'src/theme/dark_theme.dart';

// Buittons and actions
part 'src/buttons/button.dart';
part 'src/buttons/actions_buttons.dart';
part 'src/buttons/checkbox.dart';

// Views
part 'src/views/about.dart';

// General widgets
part 'src/widgets/wip.dart';
part 'src/widgets/calendar.dart';

// Responsive grid
part 'src/responsive/sizes.dart';
part 'src/responsive/row.dart';
part 'src/responsive/col.dart';

// ORM
part 'src/orm/orm.dart';

// Extensions
part 'src/extensions/datetime.dart';
part 'src/extensions/color.dart';
part 'src/extensions/page_builder.dart';

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
