part of inputs;

class ThemedCodeEditor extends StatefulWidget {
  /// Is the label of the field, you should use or [label] or [labelText] but not both. Also, [labelText] helps you
  /// to handle dark mode or related things
  final String? labelText;

  /// Is the label of the field, you should use or [label] or [labelText] but not both. Also, [labelText] helps you
  /// to handle dark mode or related things
  final Widget? label;

  /// [onChanged] is the function that will be called when the text changes
  final void Function(String)? onChanged;

  /// The [value] of the text field
  /// If you don't provide a value, the widget will create one for you.
  /// Important: Is you perform changes on the value of this field, consider using the controller, because when the
  /// widget is build again, the value will not propagate to internal variables.
  final String? value;

  /// [disabled] indicates if the field is disabled or not
  final bool disabled;

  /// [errors] is the list of strings with the errors of the field
  final List<String> errors;

  /// [padding] is the padding of the field
  final EdgeInsets padding;

  /// The [focusNode] of the field
  /// If you don't provide a focus node, the widget will create one for you.
  final FocusNode? focusNode;

  /// [onSubmitted]  is the function that will be called when the user submits the field
  /// This is useful when you want to perform an action when the user press enter.
  final VoidCallback? onSubmitted;

  /// [language] is the language of the editor
  final LayrzSupportedLanguage language;

  /// [constraints] is the constraints of the editor
  final BoxConstraints? constraints;

  /// [lintErrors] is the list of errors of the editor
  final List<LintError> lintErrors;

  /// [i18n] is the i18n of the editor
  final LayrzAppLocalizations? i18n;

  /// [customInsers] is a list of Strings to add a shurtcut to insert them in the editor
  final List<String> customInserts;

  const ThemedCodeEditor({
    super.key,
    this.labelText,
    this.label,
    this.onChanged,
    this.value,
    this.disabled = false,
    this.errors = const [],
    this.padding = const EdgeInsets.all(10),
    this.focusNode,
    this.onSubmitted,
    this.language = LayrzSupportedLanguage.lcl,
    this.constraints,
    this.lintErrors = const [],
    this.i18n,
    this.customInserts = const [],
  });

  @override
  State<ThemedCodeEditor> createState() => _ThemedCodeEditorState();
}

class _ThemedCodeEditorState extends State<ThemedCodeEditor> {
  late CodeController controller;
  final ScrollController shortcutsController = ScrollController();

  Mode getInterpreter(LayrzSupportedLanguage language) {
    switch (language) {
      case LayrzSupportedLanguage.javascript:
        return javascript_lang.javascript;
      case LayrzSupportedLanguage.lml:
        return lmlLang;
      case LayrzSupportedLanguage.lcl:
        return lclLang;
      case LayrzSupportedLanguage.txt:
        return Mode(refs: {}, disableAutodetect: true);
      case LayrzSupportedLanguage.mjml:
        return mjmlLang;
      case LayrzSupportedLanguage.dart:
        return dartLang;
      case LayrzSupportedLanguage.python:
      default:
        return python_lang.python;
    }
  }

  Map<String, TextStyle> getTheme(LayrzSupportedLanguage language) {
    return draculaTheme;
  }

  @override
  void initState() {
    super.initState();
    controller = CodeController(
      text: widget.value ?? '',
      language: getInterpreter(widget.language),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const OutlineInputBorder().borderSide.color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: ConstrainedBox(
          constraints: widget.constraints ?? const BoxConstraints(maxHeight: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: widget.label ??
                    Text(
                      widget.labelText ?? '',
                      style: Theme.of(context).inputDecorationTheme.labelStyle,
                    ),
              ),
              Expanded(
                child: Theme(
                  data: ThemeData.dark(useMaterial3: true).copyWith(
                    textTheme: ThemeData.dark().textTheme.apply(fontFamily: GoogleFonts.firaCode().fontFamily),
                  ),
                  child: CodeTheme(
                    data: const CodeThemeData(styles: draculaTheme),
                    child: CodeField(
                      wrap: true,
                      enabled: !widget.disabled,
                      controller: controller,
                      onChanged: widget.onChanged,
                      cursorColor: Colors.white,
                      lineNumberBuilder: (line, textStyle) {
                        final errors = widget.lintErrors.where((e) => e.line == line).toList();

                        if (errors.isEmpty) {
                          return TextSpan(
                            text: "$line",
                            style: textStyle,
                          );
                        }

                        return TextSpan(
                          text: "$line",
                          style: textStyle?.copyWith(color: Colors.white, backgroundColor: Colors.red),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (_hasInserts())
                Row(children: [
                  // button to scroll left
                  IconButton(
                    onPressed: () {
                      setState(() {
                        num position = shortcutsController.offset - 200 < 0 ? 0 : shortcutsController.offset - 200;
                        shortcutsController.animateTo(
                          position.toDouble(),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    icon: Icon(MdiIcons.chevronLeft),
                  ),
                  Expanded(
                    child: _buildInsertOptions(),
                  ),
                  // button to scroll right
                  IconButton(
                    onPressed: () {
                      setState(() {
                        num position = shortcutsController.offset + 200 > shortcutsController.position.maxScrollExtent
                            ? shortcutsController.position.maxScrollExtent
                            : shortcutsController.offset + 200;
                        shortcutsController.animateTo(
                          position.toDouble(),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    icon: Icon(MdiIcons.chevronRight),
                  ),
                ]),
              if (widget.errors.isNotEmpty) ThemedFieldDisplayError(errors: widget.errors),
              if (widget.lintErrors.isNotEmpty)
                ThemedFieldDisplayError(
                    errors: widget.lintErrors.map<String>((error) {
                  return "${error.line ?? 1}: ${t(
                    'larzLanguage.errors.${error.code}',
                    {
                      'function': error.function,
                      'element': error.element,
                      'required': error.req,
                      'given': error.given,
                    },
                  )}";
                }).toList()),
            ],
          ),
        ),
      ),
    );
  }

  String t(String key, [Map<String, dynamic> args = const {}]) {
    return widget.i18n?.t(key, args) ?? "I18n missing $key";
  }

  Widget _buildInsertOptions() {
    if (widget.customInserts.isNotEmpty && !widget.disabled && widget.language == LayrzSupportedLanguage.txt) {
      return SingleChildScrollView(
        controller: shortcutsController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.customInserts.map<Widget>((insert) {
            return InkWell(
              onTap: () {
                _insertTextAtCursor(controller, insert);
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const OutlineInputBorder().borderSide.color.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  insert,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
    if (widget.language == LayrzSupportedLanguage.lcl && !widget.disabled) {
      return SingleChildScrollView(
        controller: shortcutsController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: kLayrzComputeLanguageFormulas.map<Widget>((formula) {
            return InkWell(
              onTap: () {
                String formulaStr = formula['formula'] +
                    '(' +
                    formula['arguments'].map((e) => t('lcl.functions.arguments.$e')).join(', ') +
                    ')';
                _insertTextAtCursor(controller, formulaStr);
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const OutlineInputBorder().borderSide.color.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Tooltip(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  richMessage: WidgetSpan(
                    child: Text(
                      """${t('lcl.functions.function.${formula['formula']}.description')}
                      <br>
                      ${t('lcl.functions.function.${formula['formula']}.example')}""",
                    ),
                  ),
                  child: Text(formula['formula']),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
    if (widget.language == LayrzSupportedLanguage.lml && !widget.disabled) {
      return SingleChildScrollView(
        controller: shortcutsController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: kLayrzMarkupLanguageVariables.map<Widget>((formula) {
            return Tooltip(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              richMessage: WidgetSpan(
                child: Text(
                  t('layrzLanguage.markup.editor.details.$formula'),
                ),
              ),
              child: InkWell(
                onTap: () {
                  _insertTextAtCursor(controller, "{{$formula}}");
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const OutlineInputBorder().borderSide.color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(formula),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
    if (widget.language == LayrzSupportedLanguage.mjml && !widget.disabled) {
      return SingleChildScrollView(
        controller: shortcutsController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...widget.customInserts.map<Widget>((insert) {
              return InkWell(
                onTap: () {
                  _insertTextAtCursor(controller, insert);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const OutlineInputBorder().borderSide.color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    insert,
                  ),
                ),
              );
            }),
            ...mjmlTags.map<Widget>((tag) {
              return InkWell(
                onTap: () {
                  String htmlTag = """<$tag>\n\n</$tag>""";
                  _insertTextAtCursor(controller, htmlTag);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const OutlineInputBorder().borderSide.color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(tag),
                ),
              );
              // return Tooltip(
              //   decoration: BoxDecoration(
              //     color: Colors.grey.shade200,
              //   ),
              //   richMessage: WidgetSpan(
              //     child: HtmlWidget(
              //       t('mjml.editor.details.$tag'),
              //     ),
              //   ),
              //   child: InkWell(
              //     onTap: () {
              //       String htmlTag = """<$tag>\n</$tag>""";
              //       _insertTextAtCursor(controller, htmlTag);
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.all(5),
              //       decoration: BoxDecoration(
              //         border: Border.all(
              //           color: const OutlineInputBorder().borderSide.color.withOpacity(0.2),
              //           width: 1,
              //         ),
              //       ),
              //       child: Text(tag),
              //     ),
              //   ),
              // );
            }),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  bool _hasInserts() {
    return !widget.disabled &&
        (widget.customInserts.isNotEmpty ||
            widget.language == LayrzSupportedLanguage.lcl ||
            widget.language == LayrzSupportedLanguage.lml ||
            widget.language == LayrzSupportedLanguage.mjml);
  }

  void _insertTextAtCursor(TextEditingController controller, String insert) {
    if (controller.selection.start == -1) {
      controller.text = "${controller.text}$insert";
      return;
    }
    final start = controller.selection.start;
    final end = controller.selection.end;
    final text = controller.text;
    final newText = text.replaceRange(start, end, insert);
    final newSelection = TextSelection.collapsed(offset: start + insert.length);
    controller.value = controller.value.copyWith(
      text: newText,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

enum LayrzSupportedLanguage {
  /// Javascript support for sensors.
  javascript,

  /// Python support for charts and sensors.
  python,

  /// Layrz compute language!.
  lcl,

  /// Layrz markup language!.
  lml,

  /// TXT
  txt,

  /// MJML
  mjml,

  /// dart
  dart,
  ;
}
