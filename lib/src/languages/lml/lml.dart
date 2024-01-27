library lml;

import 'package:flutter/painting.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/highlight.dart';

part 'src/functions.dart';
part 'src/theme.dart';
part 'src/analyzer.dart';

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
