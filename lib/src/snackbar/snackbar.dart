library snackbar;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

part 'src/snackbar.dart';
part 'src/messenger.dart';

const kSnackbarAnimationDuration = Duration(milliseconds: 300);

bool debugCheckHasThemedSnackbarMessenger(BuildContext context) {
  assert(() {
    if (context.findAncestorWidgetOfExactType<ThemedSnackbarMessenger>() == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('No ThemedSnackbarMessenger widget found.'),
        ErrorDescription(
          'ThemedSnackbar.of() was called with a context that does not contain a ThemedSnackbarMessenger.\n',
        ),
        ErrorHint(
          'No ThemedSnackbarMessenger ancestor could be found starting from the context that was passed to ThemedSnackbar.of().\n'
          'This can happen because you do not have a WidgetsApp or MaterialApp widget (those widgets introduce '
          'a ThemedSnackbarMessenger), or it can happen if the context you use comes from a widget above those widgets.\n'
          'The context used was:\n'
          '  $context',
        ),
      ]);
    }
    return true;
  }());
  return true;
}

@Deprecated('showThemedSnackbar was deprecated.' 'Use ThemedSnackbarMessenger.of(context).showThemedSnackbar instead')
void showThemedSnackbar(ThemedSnackbar item) {}

@Deprecated('setThemedSnackbarScaffoldKey was deprecated.')
void setThemedSnackbarScaffoldKey(GlobalKey<ScaffoldState> key) {}
