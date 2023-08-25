part of inputs;

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
  final List<String> errors;
  final String? labelText;
  final Widget? label;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool disabled;
  final EdgeInsets padding;
  final List<ThemedDurationInputVisibleValues> visibleValues;

  /// [ThemedDurationInput] is a duration input.
  const ThemedDurationInput({
    super.key,

    /// [value] is the value of the input
    this.value,

    /// [onChanged] is the callback when the value of the input change
    this.onChanged,

    /// [errors] is the list of errors to display under the input
    this.errors = const [],

    /// [labelText] is the text of the label
    this.labelText,

    /// [label] is the widget of the label
    this.label,

    /// [suffixIcon] is the icon to display at the end of the input
    this.suffixIcon,

    /// [prefixIcon] is the icon to display at the start of the input
    this.prefixIcon,

    /// [padding] is the padding of the input
    this.padding = const EdgeInsets.all(10.0),

    /// [disabled] is the state of the input
    this.disabled = false,

    /// [visibleValues] is the list of values to display in the input
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

class _ThemedDurationInputState extends State<ThemedDurationInput> {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);
  Duration? get value => widget.value;

  List<ThemedDurationInputVisibleValues> get visibleValues => widget.visibleValues;

  OverlayEntry? overlayEntry;
  late OverlayState overlayState;

  late AnimationController animation;
  final GlobalKey key = GlobalKey();
  double get defaultHeight => 120;

  @override
  void initState() {
    super.initState();
    overlayState = Overlay.of(context, rootOverlay: true);
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
      onTap: widget.disabled ? null : _handleTap,
    );
  }

  void _handleTap() async {
    Duration? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        int days = value?.inDays ?? 0;
        int hours = value == null ? 0 : value!.inHours % 24;
        int minutes = value == null ? 0 : value!.inMinutes % 60;
        int seconds = value == null ? 0 : value!.inSeconds % 60;

        double height = 0;

        if (visibleValues.contains(ThemedDurationInputVisibleValues.days)) height += 80 + 10;
        if (visibleValues.contains(ThemedDurationInputVisibleValues.hours)) height += 80 + 10;
        if (visibleValues.contains(ThemedDurationInputVisibleValues.minutes)) height += 80 + 10;
        if (visibleValues.contains(ThemedDurationInputVisibleValues.seconds)) height += 80;

        height += 100;

        bool isMobile = MediaQuery.of(context).size.width < kSmallGrid;

        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: height,
              width: MediaQuery.of(context).size.width * 0.8,
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(20),
              decoration: generateContainerElevation(context: context, elevation: 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.label ??
                      Text(
                        widget.labelText ?? '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (visibleValues.contains(ThemedDurationInputVisibleValues.days)) ...[
                            ThemedNumberInput(
                              labelText: i18n?.t('helpers.days') ?? 'Days',
                              value: days,
                              hideDetails: true,
                              onChanged: (value) {
                                if (value == null) return;
                                if (value < 0) return;
                                setState(() => days = value.toInt());
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (visibleValues.contains(ThemedDurationInputVisibleValues.hours)) ...[
                            ThemedNumberInput(
                              labelText: i18n?.t('helpers.hours') ?? 'Hours',
                              value: hours,
                              hideDetails: true,
                              onChanged: (value) {
                                if (value == null) return;
                                if (value < 0) return;
                                setState(() => hours = value.toInt());
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (visibleValues.contains(ThemedDurationInputVisibleValues.minutes)) ...[
                            ThemedNumberInput(
                              labelText: i18n?.t('helpers.minutes') ?? 'Minutes',
                              value: minutes,
                              hideDetails: true,
                              onChanged: (value) {
                                if (value == null) return;
                                if (value < 0) return;
                                setState(() => minutes = value.toInt());
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (visibleValues.contains(ThemedDurationInputVisibleValues.seconds))
                            ThemedNumberInput(
                              labelText: i18n?.t('helpers.seconds') ?? 'Seconds',
                              value: seconds,
                              hideDetails: true,
                              onChanged: (value) {
                                if (value == null) return;
                                if (value < 0) return;
                                setState(() => seconds = value.toInt());
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ThemedButton(
                          style: isMobile ? ThemedButtonStyle.filledFab : ThemedButtonStyle.filledTonal,
                          icon: MdiIcons.close,
                          color: Colors.red,
                          labelText: i18n?.t('actions.cancel') ?? 'Cancel',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 10),
                        ThemedButton(
                          style: isMobile ? ThemedButtonStyle.filledFab : ThemedButtonStyle.filledTonal,
                          icon: MdiIcons.refresh,
                          color: Colors.blue,
                          labelText: i18n?.t('actions.reset') ?? 'Reset',
                          onTap: () {
                            setState(() {
                              days = 0;
                              hours = 0;
                              minutes = 0;
                              seconds = 0;
                            });
                          },
                        ),
                        const Spacer(),
                        ThemedButton(
                          style: isMobile ? ThemedButtonStyle.filledFab : ThemedButtonStyle.filledTonal,
                          icon: MdiIcons.contentSave,
                          color: Colors.green,
                          labelText: i18n?.t('actions.save') ?? 'Save',
                          onTap: () {
                            Navigator.of(context).pop(_parseDuration(
                              days: days,
                              hours: hours,
                              minutes: minutes,
                              seconds: seconds,
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );

    if (result != null) {
      widget.onChanged?.call(result);
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

  /// Change inner value of duration from the input values
  Duration _parseDuration({
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
  }) {
    return Duration(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
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
