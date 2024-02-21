import 'package:flutter/cupertino.dart';

import '../../../code_editor.dart';

class IndentIntent extends Intent {
  const IndentIntent();
}

class IndentIntentAction extends Action<IndentIntent> {
  final CodeController controller;

  IndentIntentAction({
    required this.controller,
  });

  @override
  Object? invoke(IndentIntent intent) {
    controller.indentSelection();
    return null;
  }
}
