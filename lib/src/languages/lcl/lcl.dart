library;

import 'package:flutter/painting.dart';
import 'package:highlight/highlight.dart';

part 'src/functions.dart';
part 'src/theme.dart';

final lcl = Mode(
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
