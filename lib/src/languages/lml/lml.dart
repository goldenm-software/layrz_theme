library lml;

import 'package:flutter/painting.dart';
import 'package:highlight/highlight.dart';
import 'package:layrz_theme/src/inputs/inputs.dart';

part 'src/functions.dart';
part 'src/theme.dart';

final lml = Mode(
  contains: [
    lclFunctions,
    Mode(
      className: "string",
      begin: "\"",
      end: "\"",
    ),
    Mode(
      className: "string",
      begin: "'",
      end: "'",
    ),
    Mode(
      className: "constant",
      begin: "\\b(True|true|False|false|None|none)\\b",
    ),
    Mode(
      className: "number",
      begin: "\\b\\d+(\\.\\d+)?",
      relevance: 0,
    ),
  ],
);
