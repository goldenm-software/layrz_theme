part of '../inputs.dart';

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

  /// [onLintTap] is the function that will be called when the user taps on a lint button
  final Future<List<LintError>> Function(String)? onLintTap;

  /// [onRunTap] is the function that will be called when the user taps on the run button
  final Future<String?> Function(String)? onRunTap;

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
    @Deprecated('Now, if you want to append lintErrors, you should use `onLintTap` to perform the lint')
    this.lintErrors = const [],
    @Deprecated('The i18n will be extracted automatically from the context') this.i18n,
    this.customInserts = const [],
    this.onLintTap,
    this.onRunTap,
  });

  @override
  State<ThemedCodeEditor> createState() => _ThemedCodeEditorState();
}

class _ThemedCodeEditorState extends State<ThemedCodeEditor> {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);
  late CodeController controller;
  String _value = '';
  bool get _isLoading => _isLinting || _isRunning;

  bool _isRunning = false;
  bool _isLinting = false;

  Mode get _language {
    switch (widget.language) {
      case LayrzSupportedLanguage.lml:
        return lml.lml;
      case LayrzSupportedLanguage.lcl:
        return lcl.lcl;
      case LayrzSupportedLanguage.mjml:
        return mjml.mjml;
      case LayrzSupportedLanguage.python:
        return python.python;
      default:
        return Mode(refs: {}, disableAutodetect: true);
    }
  }

  Map<String, TextStyle> get _theme {
    switch (widget.language) {
      case LayrzSupportedLanguage.lml:
        return lml.theme;
      case LayrzSupportedLanguage.lcl:
        return lcl.theme;
      case LayrzSupportedLanguage.mjml:
        return mjml.theme;
      case LayrzSupportedLanguage.python:
        return python.theme;
      default:
        return const {
          'root': TextStyle(backgroundColor: Color(0xff1a1a1a), color: Color(0xffecf0f1)),
        };
    }
  }

  AbstractAnalyzer get _analyzer {
    switch (widget.language) {
      case LayrzSupportedLanguage.lml:
        return lml.LmlAnalizer();
      case LayrzSupportedLanguage.lcl:
        return lcl.LclAnalizer();
      case LayrzSupportedLanguage.mjml:
        return mjml.MjmlAnalizer();
      case LayrzSupportedLanguage.python:
        return python.PythonAnalizer();
      default:
        return EmptyAnalyzer();
    }
  }

  Color get backgroundColor => _theme['root']!.backgroundColor ?? Colors.black;
  Color get textColor => validateColor(color: backgroundColor);

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? '';
    controller = CodeController(
      text: _value,
      language: _language,
      analyzer: _analyzer,
    );
  }

  @override
  void didUpdateWidget(ThemedCodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.setLanguage(_language, analyzer: _analyzer);

    if (widget.value != null && widget.value != oldWidget.value) {
      _value = widget.value ?? '';
      controller.text = _value;
    }

    if (widget.lintErrors != oldWidget.lintErrors) {
      controller.analysisResult = AnalysisResult(issues: widget.lintErrors.map(_formatLintError).toList());
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Issue _formatLintError(LintError error) {
    String message = t(
      error.code,
      {
        'function': error.function,
        'element': error.element,
        'required': error.req,
        'given': error.given,
      },
    );
    return Issue(
      line: (error.line ?? 1) - 1,
      message: message,
      type: IssueType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: generateContainerElevation(context: context, color: backgroundColor, elevation: 2),
        child: ConstrainedBox(
          constraints: widget.constraints ?? const BoxConstraints(maxHeight: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: widget.label ??
                          Text(
                            widget.labelText ?? '',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: textColor,
                                  fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                                ),
                          ),
                    ),
                    const SizedBox(width: 10),
                    if (widget.onLintTap != null) ...[
                      ThemedTooltip(
                        message: i18n?.t('actions.lint') ?? 'Lint',
                        color: Colors.white,
                        child: InkWell(
                          onTap: _isLoading
                              ? null
                              : () async {
                                  setState(() => _isLinting = true);
                                  controller.analysisResult = const AnalysisResult(issues: []);
                                  await Future.delayed(const Duration(milliseconds: 500));
                                  final result = await widget.onLintTap?.call(_value);
                                  setState(() => _isLinting = false);

                                  if (result != null) {
                                    controller.analysisResult = AnalysisResult(
                                      issues: result.map(_formatLintError).toList(),
                                    );
                                  }
                                },
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Stack(
                              children: [
                                Center(
                                  child: AnimatedOpacity(
                                    opacity: _isLinting ? 0.5 : 1,
                                    duration: kHoverDuration,
                                    child: Icon(
                                      MdiIcons.bugOutline,
                                      color: textColor,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: AnimatedOpacity(
                                    opacity: _isLinting ? 1 : 0,
                                    duration: kHoverDuration,
                                    child: CircularProgressIndicator(
                                      color: textColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    if (widget.onRunTap != null)
                      ThemedTooltip(
                        message: i18n?.t('actions.run') ?? 'Run',
                        color: Colors.white,
                        child: InkWell(
                          onTap: _isLoading
                              ? null
                              : () async {
                                  setState(() => _isRunning = true);
                                  await Future.delayed(const Duration(milliseconds: 500));
                                  final result = await widget.onRunTap?.call(_value);
                                  setState(() => _isRunning = false);

                                  if (result != null) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          elevation: 0,
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                            decoration: generateContainerElevation(
                                              context: context,
                                              color: backgroundColor,
                                              elevation: 3,
                                            ),
                                            constraints: const BoxConstraints(maxWidth: 400),
                                            padding: const EdgeInsets.all(20),
                                            child: Text(
                                              result,
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: textColor,
                                                    fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                                                  ),
                                              maxLines: 4,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: Stack(
                              children: [
                                Center(
                                  child: AnimatedOpacity(
                                    opacity: _isRunning ? 0.5 : 1,
                                    duration: kHoverDuration,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2, bottom: 2),
                                      child: Icon(
                                        MdiIcons.playOutline,
                                        color: textColor,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: AnimatedOpacity(
                                    opacity: _isRunning ? 1 : 0,
                                    duration: kHoverDuration,
                                    child: CircularProgressIndicator(
                                      color: textColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(
                  value: _isLoading ? null : 0,
                  minHeight: 1,
                  backgroundColor: textColor.withOpacity(0.2),
                  color: textColor,
                ),
              ),
              Theme(
                data: ThemeData.dark().copyWith(
                  textTheme: GoogleFonts.jetBrainsMonoTextTheme(),
                ),
                child: CodeTheme(
                  data: CodeThemeData(styles: _theme),
                  child: Expanded(
                    child: CodeField(
                        controller: controller,
                        onChanged: (value) {
                          widget.onChanged?.call(value);
                          setState(() => _value = value);
                        }),
                  ),
                ),
              ),
              ThemedFieldDisplayError(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                errors: widget.errors,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String t(String key, [Map<String, dynamic> args = const {}]) {
    if (i18n != null) return i18n!.t(key, args);

    if (_defaultErrors.containsKey(key)) {
      String message = _defaultErrors[key]!;
      args.forEach((key, value) {
        message = message.replaceAll('{$key}', value.toString());
      });

      return message;
    }

    return "Translation missing $key";
  }

  Map<String, String> get _defaultErrors => {
        'linter.parse.syntax.error': 'Syntax error',

        // LCL errors
        'lcl.function.arguments.mismatch': 'Function {function} arguments mismatch, required {required} given {given}',
        'lcl.function.not.found': 'Function {function} not found',

        // Python errors
        'python.main.function.not.found': 'Main function not found',
        'python.main.function.arguments.mismatch': 'Main function arguments mismatch',
        'python.return.not.allowed.outside.function': 'Return not allowed outside function',
        'python.prohibited.element.used': 'Prohibited element {element} used',
        'python.async.function.not.allowed': 'Asyncronus functions are not allowed',
        'python.yield.not.allowed': 'Yield is not allowed',
        'python.infinite.value.not.allowed': 'Infinite value is not allowed',
        'python.print.not.allowed': 'Print statement is not allowed',
        'python.plpy.not.allowed': 'Plpy module is not allowed',
        'python.import.not.allowed': 'Import statement is not allowed',
        'python.while.not.allowed': 'While statement is not allowed',
        'python.raise.not.allowed': 'Raise statement is not allowed',
      };
}

enum LayrzSupportedLanguage {
  /// Python v3.10 language support for Sensors, Triggers, Reports and Charts.
  python,

  /// LCL or Layrz Compute Language support for Sensors and Triggers.
  lcl,

  /// LML or Layrz Markup Language support for Operations.
  lml,

  /// TXT or Plain text
  txt,

  /// MJML or MailJet Markup Language support for Emails.
  mjml,
  ;
}

class EmptyAnalyzer extends AbstractAnalyzer {
  @override
  Future<AnalysisResult> analyze(Code code) async {
    return const AnalysisResult(issues: []);
  }
}
