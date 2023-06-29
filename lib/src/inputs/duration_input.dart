part of layrz_theme;

enum ThemedDurationInputVisibleValues {
  days,
  hours,
  minutes,
  seconds;

  Units toUnit() {
    switch (this) {
      case ThemedDurationInputVisibleValues.days:
        return Units.day;
      case ThemedDurationInputVisibleValues.hours:
        return Units.hour;
      case ThemedDurationInputVisibleValues.minutes:
        return Units.minute;
      case ThemedDurationInputVisibleValues.seconds:
        return Units.second;
    }
  }
}

class ThemedDurationInput extends StatefulWidget {
  final Duration? value;
  final Function(Duration?)? onChanged;

  /// A list of errors to display
  final List<String> errors;

  /// The label text
  final String? labelText;

  /// The label widget
  final Widget? label;

  /// The suffix icon
  final IconData? suffixIcon;

  /// The prefix icon
  final IconData? prefixIcon;

  final bool disabled;

  final EdgeInsets padding;

  final double? containerHeight;

  final List<ThemedDurationInputVisibleValues> visibleValues;

  const ThemedDurationInput({
    super.key,
    this.value,
    this.onChanged,
    this.labelText,
    this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.padding = const EdgeInsets.all(10.0),
    this.errors = const [],
    this.disabled = false,
    this.containerHeight,
    this.visibleValues = const [
      ThemedDurationInputVisibleValues.days,
      ThemedDurationInputVisibleValues.hours,
      ThemedDurationInputVisibleValues.minutes,
      ThemedDurationInputVisibleValues.seconds,
    ],
  });

  @override
  State<ThemedDurationInput> createState() => _ThemedDurationInputState();
}

class _ThemedDurationInputState extends State<ThemedDurationInput> with TickerProviderStateMixin {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);

  /// inner value of the input for the changes
  Duration? _duration;

  /// The value of the input given from the value param
  Duration? get value => widget.value;

  List<ThemedDurationInputVisibleValues> get visibleValues => widget.visibleValues;

  OverlayEntry? overlayEntry;
  late OverlayState overlayState;

  late AnimationController animation;
  final GlobalKey key = GlobalKey();
  double get defaultHeight => 120;

  int _days = 0;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    overlayState = Overlay.of(context, rootOverlay: true);

    animation = AnimationController(vsync: this, duration: kHoverDuration);
  }

  @override
  Widget build(BuildContext context) {
    return ThemedTextInput(
      key: key,
      labelText: widget.labelText,
      label: widget.label,
      suffixIcon: widget.suffixIcon,
      prefixIcon: widget.prefixIcon,
      padding: widget.padding,
      errors: widget.errors,
      value: _formatedDuration,
      disabled: widget.disabled,
      readonly: true,
      onTap: _handleTap,
    );
  }

  void _handleTap() {
    if (widget.disabled) return;
    if (overlayEntry != null) {
      _destroyOverlay();
    } else {
      _buildOverlay();
    }
  }

  String get _formatedDuration {
    if (value == null) return '';

    try {
      return humanizeDuration(
        value!,
        language: ThemedHumanizedDuration(i18n: i18n),
        options: HumanizeOptions(
          conjunction: i18n?.t('helpers.and') ?? ' and ',
          units: visibleValues.map((e) => e.toUnit()).toList(),
        ),
      );
    } catch (e) {
      return '';
    }
  }

  void _destroyOverlay({VoidCallback? callback}) async {
    await animation.reverse();
    overlayEntry?.remove();
    overlayEntry = null;

    callback?.call();
  }

  void _buildOverlay() {
    Size screenSize = MediaQuery.of(context).size;
    double height = widget.containerHeight ?? defaultHeight;
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;

    Offset offset = renderBox.localToGlobal(Offset.zero);

    double? top;
    double? bottom;
    if (value != null) {
      _days = value!.inDays;
      _hours = value!.inHours % 24;
      _minutes = value!.inMinutes % 60;
      _seconds = value!.inSeconds % 60;

      _duration = Duration(
        days: _days,
        hours: _hours,
        minutes: _minutes,
        seconds: _seconds,
      );
    }

    if (screenSize.height - offset.dy > height) {
      top = offset.dy + widget.padding.top;
    } else {
      bottom = screenSize.height - offset.dy - renderBox.size.height - widget.padding.bottom;
    }

    double right = screenSize.width - (offset.dx + renderBox.size.width - widget.padding.right);

    overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _destroyOverlay,
              ),
            ),
            Positioned(
              top: top,
              bottom: bottom,
              left: offset.dx + widget.padding.left,
              right: right,
              child: FadeTransition(
                opacity: animation,
                child: StatefulBuilder(
                  builder: (context, innerSetState) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
                        height = widget.containerHeight ?? defaultHeight;

                        if (renderBox.size.width < kExtraSmallGrid && visibleValues.length > 2) {
                          height = (widget.containerHeight ?? defaultHeight) + 60;
                        }
                        return Container(
                          height: height,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          constraints: BoxConstraints(maxHeight: height),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  0.2,
                                ),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(
                                  0,
                                  3,
                                ),
                              ),
                            ],
                          ),
                          child: ResponsiveRow(
                            children: [
                              if (visibleValues.contains(ThemedDurationInputVisibleValues.days))
                                ResponsiveCol(
                                  xs: inputXsSizes(),
                                  sm: inputSmSizes(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ThemedNumberInput(
                                      labelText: i18n?.t('helpers.days') ?? 'Days',
                                      value: _days,
                                      onChanged: (int value) {
                                        if (value < 0) return;
                                        innerSetState(() {
                                          _days = value;
                                        });
                                        setState(() {
                                          _changeDuration();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              if (visibleValues.contains(ThemedDurationInputVisibleValues.hours))
                                ResponsiveCol(
                                  xs: inputXsSizes(),
                                  sm: inputSmSizes(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ThemedNumberInput(
                                      labelText: i18n?.t('helpers.hours') ?? 'Hours',
                                      value: _hours,
                                      onChanged: (int value) {
                                        if (value < 0) return;
                                        innerSetState(() {
                                          _hours = value;
                                        });
                                        setState(() {
                                          _changeDuration();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              if (visibleValues.contains(ThemedDurationInputVisibleValues.minutes))
                                ResponsiveCol(
                                  xs: inputXsSizes(),
                                  sm: inputSmSizes(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ThemedNumberInput(
                                      labelText: i18n?.t('helpers.minutes') ?? 'Minutes',
                                      value: _minutes,
                                      onChanged: (int value) {
                                        if (value < 0) return;
                                        innerSetState(() {
                                          _minutes = value;
                                        });
                                        setState(() {
                                          _changeDuration();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              if (visibleValues.contains(ThemedDurationInputVisibleValues.seconds))
                                ResponsiveCol(
                                  xs: inputXsSizes(),
                                  sm: inputSmSizes(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ThemedNumberInput(
                                      labelText: i18n?.t('helpers.seconds') ?? 'Seconds',
                                      value: _seconds,
                                      onChanged: (int value) {
                                        if (value < 0) return;
                                        innerSetState(() {
                                          _seconds = value;
                                        });
                                        setState(() {
                                          _changeDuration();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ResponsiveCol(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// cancel button
                                      ThemedButton(
                                        style: ThemedButtonStyle.fab,
                                        icon: MdiIcons.close,
                                        color: Colors.red,
                                        labelText: i18n?.t('actions.cancel') ?? 'Cancel',
                                        onTap: _destroyOverlay,
                                      ),

                                      /// Reset button
                                      ThemedButton(
                                        style: ThemedButtonStyle.fab,
                                        icon: MdiIcons.refresh,
                                        color: Colors.blue,
                                        labelText: i18n?.t('actions.reset') ?? 'Reset',
                                        onTap: () {
                                          innerSetState(() {
                                            _days = 0;
                                            _hours = 0;
                                            _minutes = 0;
                                            _seconds = 0;
                                          });
                                          setState(() {
                                            _changeDuration();
                                          });
                                        },
                                      ),

                                      const Spacer(),

                                      /// save button
                                      ThemedButton(
                                        style: ThemedButtonStyle.fab,
                                        icon: MdiIcons.contentSave,
                                        color: Colors.green,
                                        labelText: i18n?.t('actions.save') ?? 'Save',
                                        onTap: () {
                                          _destroyOverlay(callback: () {
                                            widget.onChanged?.call(_duration);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });

    Overlay.of(context, rootOverlay: true).insert(overlayEntry!);
    animation.forward();
  }

  /// Change inner value of duration from the input values
  void _changeDuration() {
    _duration = Duration(
      days: _days,
      hours: _hours,
      minutes: _minutes,
      seconds: _seconds,
    );
  }

  Sizes inputSmSizes() {
    if (visibleValues.length == 1) {
      return Sizes.col12;
    } else if (visibleValues.length == 2) {
      return Sizes.col6;
    } else if (visibleValues.length == 3) {
      return Sizes.col4;
    } else {
      return Sizes.col3;
    }
  }

  Sizes inputXsSizes() {
    if (visibleValues.length == 1) {
      return Sizes.col12;
    } else {
      return Sizes.col6;
    }
  }
}

class ThemedNumberInput extends StatelessWidget {
  final String labelText;
  final int value;
  final Function(int)? onChanged;

  const ThemedNumberInput({
    Key? key,
    this.labelText = "",
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: ThemedTextInput(
            labelText: labelText,
            value: value.toString(),
            keyboardType: TextInputType.number,
            padding: EdgeInsets.zero,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'(^\d*)'),
              ),
            ],
            onChanged: (String value) {
              onChanged?.call(int.tryParse(value) ?? 0);
            },
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ThemedButton(
              style: ThemedButtonStyle.text,
              label: const Text(
                "+",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                onChanged?.call(value + 1);
              },
            ),
            ThemedButton(
              style: ThemedButtonStyle.text,
              label: const Text(
                "-",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                onChanged?.call(value - 1);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ThemedHumanizedDuration implements HumanizeLanguage {
  final LayrzAppLocalizations? i18n;
  const ThemedHumanizedDuration({
    this.i18n,
  });

  @override
  String name() => 'layrz';

  @override
  String day(int value) => i18n?.tc('helpers.dynamic.days', value) ?? (value == 1 ? 'day' : 'days');

  @override
  String hour(int value) => i18n?.tc('helpers.dynamic.hours', value) ?? (value == 1 ? 'hour' : 'hours');

  @override
  String millisecond(int value) =>
      i18n?.tc('helpers.dynamic.milliseconds', value) ?? (value == 1 ? 'millisecond' : 'milliseconds');

  @override
  String minute(int value) => i18n?.tc('helpers.dynamic.minutes', value) ?? (value == 1 ? 'minute' : 'minutes');

  @override
  String month(int value) => i18n?.tc('helpers.dynamic.months', value) ?? (value == 1 ? 'month' : 'months');

  @override
  String second(int value) => i18n?.tc('helpers.dynamic.seconds', value) ?? (value == 1 ? 'second' : 'seconds');

  @override
  String week(int value) => i18n?.tc('helpers.dynamic.weeks', value) ?? (value == 1 ? 'week' : 'weeks');

  @override
  String year(int value) => i18n?.tc('helpers.dynamic.years', value) ?? (value == 1 ? 'year' : 'years');
}
