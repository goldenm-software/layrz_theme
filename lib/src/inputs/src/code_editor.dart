// ignore_for_file: use_build_context_synchronously

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

  /// [customInsers] is a list of Strings to add a shurtcut to insert them in the editor
  final List<String> customInserts;

  /// [onLintTap] is the function that will be called when the user taps on a lint button
  final Future<List<ThemedCodeError>> Function(String)? onLintTap;

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
    this.customInserts = const [],
    this.onLintTap,
    this.onRunTap,
  });

  @override
  State<ThemedCodeEditor> createState() => _ThemedCodeEditorState();

  static AppFont get font => AppFont(
        source: FontSource.google,
        name: GoogleFonts.jetBrainsMono().fontFamily ?? 'Ubuntu',
      );
}

class _ThemedCodeEditorState extends State<ThemedCodeEditor> {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);

  String _value = '';
  bool get _isLoading => _isLinting || _isRunning;

  Map<int, List<ThemedCodeError>> _issues = {};

  List<String> get globalErrors {
    return _issues.entries
        .map((e) {
          final errors = e.value;

          return errors.map((error) {
            String msg = t(error.code, {
              'name': error.name,
              'expected': error.expected,
              'received': error.received,
            });

            return t('layrz.editor.lint.error', {
              'line': e.key,
              'error': msg,
            });
          }).toList();
        })
        .expand((element) => element)
        .toList();
  }

  bool _isRunning = false;
  bool _isLinting = false;

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

  Mode get _mode {
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
        return Mode();
    }
  }

  List<String> get _options {
    switch (widget.language) {
      case LayrzSupportedLanguage.lml:
        return lml.functions;
      case LayrzSupportedLanguage.lcl:
        return lcl.functions;
      case LayrzSupportedLanguage.mjml:
      case LayrzSupportedLanguage.python:
      default:
        return [];
    }
  }

  String? get _basePath {
    switch (widget.language) {
      case LayrzSupportedLanguage.lml:
        return 'https://developers.layrz.com/lml/variables';
      case LayrzSupportedLanguage.lcl:
        return 'https://developers.layrz.com/lcl/functions';
      case LayrzSupportedLanguage.mjml:
      case LayrzSupportedLanguage.python:
      default:
        return null;
    }
  }

  Color get backgroundColor => _theme['root']!.backgroundColor ?? Colors.black;
  Color get textColor => validateColor(color: backgroundColor);
  late CodeController _controller;

  TextStyle? get codeTextStyle => TextStyle(
        fontFamily: ThemedCodeEditor.font.name,
        color: textColor,
        fontSize: 18,
      );

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? '';
    _controller = CodeController(
      text: _value,
      language: _mode,
      params: const EditorParams(
        tabSpaces: 4,
      ),
    );
  }

  @override
  void didUpdateWidget(ThemedCodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      int previousCursorOffset = _controller.selection.extentOffset;

      // update the current value in the value
      _value = widget.value ?? "";
      // update the current value in the controller
      _controller.text = _value;
      // check that the cursor offset is not greater than the length of the value
      if (_value.length <= previousCursorOffset) {
        previousCursorOffset = _value.length;
      }

      // update the cursor offset
      _controller.selection = TextSelection.fromPosition(
        TextPosition(
          offset: previousCursorOffset,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                padding: const EdgeInsets.all(10),
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
                    if (!widget.disabled) ...[
                      if (widget.onLintTap != null) ...[
                        ThemedTooltip(
                          message: i18n?.t('actions.lint') ?? 'Lint',
                          color: Colors.white,
                          child: InkWell(
                            onTap: _isLoading
                                ? null
                                : () async {
                                    _issues = {};
                                    setState(() => _isLinting = true);
                                    await Future.delayed(const Duration(milliseconds: 500));
                                    final result = await widget.onLintTap?.call(_value);
                                    setState(() => _isLinting = false);

                                    if (result != null) {
                                      for (var error in result) {
                                        if (_issues.containsKey(error.line)) {
                                          _issues[error.line]!.add(error);
                                        } else {
                                          _issues[error.line] = [error];
                                        }
                                      }
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
                                        LayrzIcons.solarOutlineCodeSquare,
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
                      ],
                      if (widget.onLintTap != null && widget.onRunTap != null) const SizedBox(width: 10),
                      if (widget.onRunTap != null) ...[
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
                                    if (result != null && mounted) {
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
                                          LayrzIcons.solarOutlinePlay,
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
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: LinearProgressIndicator(
                  value: _isLoading ? null : 0,
                  minHeight: 1,
                  backgroundColor: textColor.withValues(alpha: 0.2),
                  color: textColor,
                ),
              ),
              Expanded(
                child: Theme(
                  data: ThemeData.dark(),
                  child: CodeTheme(
                    data: CodeThemeData(styles: _theme),
                    child: CodeField(
                      readOnly: widget.disabled,
                      controller: _controller,
                      lineNumberBuilder: (lineNumber, style) {
                        bool hasError = _issues.containsKey(lineNumber);

                        return TextSpan(
                          text: '$lineNumber',
                          style: style?.copyWith(
                            color: hasError ? Colors.red : textColor.withValues(alpha: 0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                      textStyle: TextStyle(fontFamily: ThemedCodeEditor.font.name),
                      expands: true,
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: textColor,
                        selectionColor: textColor.withValues(alpha: 0.1),
                        selectionHandleColor: textColor,
                      ),
                      onChanged: (value) {
                        widget.onChanged?.call(value);
                      },
                    ),
                  ),
                ),
              ),
              if (!widget.disabled) ...[
                ThemedFieldDisplayError(
                  padding: const EdgeInsets.all(10),
                  errors: widget.errors + globalErrors,
                  maxLines: 10,
                ),
                if (_options.isNotEmpty) ...[
                  _ThemedCodeSuggestions(
                    options: _options,
                    basePath: _basePath,
                    onTap: (suggestion) {
                      if (widget.language == LayrzSupportedLanguage.lml) {
                        suggestion = '{{$suggestion}}';
                      } else if (widget.language == LayrzSupportedLanguage.lcl) {
                        suggestion = '$suggestion()';
                      }
                      // Define cursor position
                      final cursorPosition = _controller.selection.extentOffset;
                      if (cursorPosition < 0) {
                        debugPrint('layrz_theme/ThemedCodeEditor: Cursor not found, aborting suggestion insertion');
                        return;
                      }
                      // Define the new value
                      String newValue = _controller.text.substring(0, cursorPosition);
                      newValue += suggestion;
                      newValue += _value.substring(cursorPosition);
                      // Update the value
                      _controller.text = newValue;
                      widget.onChanged?.call(newValue);
                    },
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  String t(String key, [Map<String, dynamic> args = const {}]) {
    if (i18n != null) {
      if (i18n!.hasTranslation(key)) return i18n!.t(key, args);
    }

    if (_defaultErrors.containsKey(key)) {
      String message = _defaultErrors[key]!;
      args.forEach((key, value) {
        message = message.replaceAll('{$key}', value.toString());
      });

      return message;
    }

    return key;
  }

  Map<String, String> get _defaultErrors => {
        'lcl.multiroot.found': 'Multiple root functions found, Layrz Compute Language only supports one '
            'root function',
        'lcl.unknown.typedef': 'Datatype {name} not found',
        'lcl.unsupported.typedef': 'Unsuported {name}',
        'lcl.unknown.node': '{name} not found',
        'lcl.arguments.mismatch': 'Function {name} has an arguments mismstch, required {expected} and '
            '{received} received',
        'lcl.function.not.found': 'Function {name} not found',
        'python.empty.code': 'Empty code not supported',
        'python.not.function': 'Only you can define functions in the root code',
        'python.main.function.not.found': 'The main function {name} not found',
        'python.function.arguments.mismatch': 'The function {name} doesn\'t have the right arguments, '
            'we expect {expected} as an arguments, and {received} was found.\nThe arguments must be exactly '
            'as the defined in our documentation',
        'python.unsupported.type': 'Python datatype {name} unsupported',
        'python.function.no.return': 'The function {name} doesn\'t have a return statement, '
            'you must return a value',
        'python.import.not.allowed': 'The statement import ... or from ... import ... cannot be used',
        'python.range.too.big': 'The range only can run {expected} iterations, your code iterates {received} times',
        'python.range.only.constant': 'The range function only can support constant values',
        'python.too.deep': 'Your code exceeds the maximum depth. Consider reducing the number of nested loops',
        'python.undefined.import': 'Module {name} not defined',
        'python.async.not.allowed': 'Async operations not allowed',
        'python.prohibed.element': 'The statement or function {name} is not allowed',
        'python.match.not.allowed': 'match/case statement not allowed',
        'python.global.not.allowed': 'The use of global variables is restricted',
        'python.nonlocal.not.allowed': 'The use of nonlocal variables is restricted',
        'layrz.editor.lint.error': 'Error at line {line}: {error}',
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

class ThemedCodeError {
  /// [code] is the error code, this should be a translation key
  /// If is not a translation key, the error will be displayed as it is
  final String code;

  /// [line] is the line of the error
  final int line;

  /// [name] is the name of the function or element
  final String? name;

  /// [expected] is a dynamic value to show in the error
  final dynamic expected;

  /// [received] is a dynamic value to show in the error
  final dynamic received;

  /// [ThemedCodeError] is the definition of each error that can be displayed in the editor
  const ThemedCodeError({
    required this.code,
    required this.line,
    this.name,
    this.expected,
    this.received,
  });
}

class _ThemedCodeSuggestions extends StatelessWidget {
  final List<String> options;
  final void Function(String) onTap;
  final String? basePath;
  const _ThemedCodeSuggestions({
    required this.options,
    required this.onTap,
    this.basePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        itemBuilder: (context, index) {
          Widget content = Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(options[index]),
              onLongPress: basePath == null ? null : () => _launchSite(options[index]),
              onSecondaryTap: basePath == null ? null : () => _launchSite(options[index]),
              hoverColor: Colors.white.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                child: Text(
                  options[index],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          );

          if (basePath == null) return content;

          return ThemedTooltip(
            position: ThemedTooltipPosition.top,
            color: Colors.white,
            message: LayrzAppLocalizations.maybeOf(context)?.t('layrz.editor.documentation') ??
                'Long press or right click to open documentation',
            child: content,
          );
        },
      ),
    );
  }

  void _launchSite(String option) {
    String subpath = option.replaceAll('_', '-').toLowerCase();
    launchUrlString(
      '$basePath#$subpath',
      mode: LaunchMode.externalApplication,
    );
  }
}
