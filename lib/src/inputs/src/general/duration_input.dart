part of '../../inputs.dart';

const kThemedDurationSupported = [
  ThemedUnits.day,
  ThemedUnits.hour,
  ThemedUnits.minute,
  ThemedUnits.second,
];

class ThemedDurationInput extends StatefulWidget {
  /// [value] is the value of the input
  final Duration? value;

  /// [onChanged] is the callback when the value of the input change
  final Function(Duration?)? onChanged;

  /// [errors] is the list of errors to display under the input
  final List<String> errors;

  /// [labelText] is the text of the label
  final String? labelText;

  /// [label] is the widget of the label
  final Widget? label;

  /// [suffixIcon] is the icon to display at the end of the input
  final IconData? suffixIcon;

  /// [prefixIcon] is the icon to display at the start of the input
  final IconData? prefixIcon;

  /// [padding] is the padding of the input
  final bool disabled;

  /// [disabled] is the state of the input
  final EdgeInsets? padding;

  /// [visibleValues] is the list of values to display in the input
  final List<ThemedUnits> visibleValues;

  /// [ThemedDurationInput] is a duration input.
  ThemedDurationInput({
    super.key,
    this.value,
    this.onChanged,
    this.errors = const [],
    this.labelText,
    this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.padding,
    this.disabled = false,
    this.visibleValues = kThemedDurationSupported,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null)),
       assert(
         visibleValues.every(kThemedDurationSupported.contains),
         'The visible values provided has an unsupported value',
       );

  @override
  State<ThemedDurationInput> createState() => _ThemedDurationInputState();
}

class _ThemedDurationInputState extends State<ThemedDurationInput> {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
  Duration? get value => widget.value;

  final _controller = TextEditingController();

  List<ThemedUnits> get visibleValues => widget.visibleValues;

  late AnimationController animation;
  final GlobalKey key = GlobalKey();
  double get defaultHeight => 120;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.text = _getFormattedDuration(value);
    });
  }

  @override
  void didUpdateWidget(ThemedDurationInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _controller.text = _getFormattedDuration(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedTextInput(
      key: key,
      controller: _controller,
      labelText: widget.labelText,
      label: widget.label,
      suffixIcon: widget.suffixIcon,
      prefixIcon: widget.prefixIcon,
      padding: widget.padding,
      errors: widget.errors,
      value: _getFormattedDuration(value),
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

        bool isMobile = MediaQuery.of(context).size.width < kSmallGrid;

        return StatefulBuilder(
          builder: (context, setState) {
            List<ResponsiveCol> items = [];

            Sizes size = Sizes.col12;
            if (visibleValues.length >= 2) {
              size = Sizes.col6;
            }

            for (final entry in visibleValues.asMap().entries) {
              final visibleValue = entry.value;
              final index = entry.key;

              Sizes? overrideSize;
              if (index == visibleValues.length - 1 && index % 2 == 0) overrideSize = Sizes.col12;

              items.add(
                ResponsiveCol(
                  xs: overrideSize ?? size,
                  child: ThemedNumberInput(
                    padding: const EdgeInsets.all(5),
                    labelText: visibleValue.translate(i18n),
                    suffixText: visibleValue.translate(i18n),
                    value: switch (visibleValue) {
                      ThemedUnits.day => days,
                      ThemedUnits.hour => hours,
                      ThemedUnits.minute => minutes,
                      ThemedUnits.second => seconds,
                      _ => 0,
                    },
                    hideDetails: true,
                    onChanged: (value) {
                      if (value == null) return;
                      if (value < 0) return;
                      switch (visibleValue) {
                        case ThemedUnits.day:
                          days = value.toInt();
                          break;
                        case ThemedUnits.hour:
                          hours = value.toInt();
                          break;
                        case ThemedUnits.minute:
                          minutes = value.toInt();
                          break;
                        case ThemedUnits.second:
                          seconds = value.toInt();
                          break;
                        default:
                          break;
                      }
                      setState(() {});
                    },
                  ),
                ),
              );
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
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
                    ResponsiveRow(children: items),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ThemedButton.cancel(
                          isMobile: isMobile,
                          labelText: i18n?.t('actions.cancel') ?? 'Cancel',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        ThemedButton(
                          style: isMobile ? ThemedButtonStyle.fab : ThemedButtonStyle.text,
                          icon: LayrzIcons.solarOutlineRefreshSquare,
                          color: Colors.orange,
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
                        ThemedButton.save(
                          isMobile: isMobile,
                          labelText: i18n?.t('actions.save') ?? 'Save',
                          onTap: () {
                            Navigator.of(context).pop(
                              _parseDuration(
                                days: days,
                                hours: hours,
                                minutes: minutes,
                                seconds: seconds,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      widget.onChanged?.call(result);
      setState(() {
        _controller.text = _getFormattedDuration(result);
      });
    }
  }

  String _getFormattedDuration(Duration? durationValue) {
    if (durationValue == null) return '';

    String conjunction = i18n?.t('helpers.and') ?? 'and';
    conjunction = ' ${conjunction.trim()} ';
    return durationValue.humanize(
      options: ThemedHumanizeOptions(
        units: visibleValues,
        spacer: ' ',
        conjunction: conjunction,
      ),
      language: ThemedHumanizedDurationLanguage(i18n: i18n),
    );
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

extension ThemedUnitTranslation on ThemedUnits {
  String translate(LayrzAppLocalizations? i18n) {
    switch (this) {
      case ThemedUnits.year:
        return i18n?.t('helpers.year') ?? 'Year';
      case ThemedUnits.month:
        return i18n?.t('helpers.month') ?? 'Months';
      case ThemedUnits.week:
        return i18n?.t('helpers.weeks') ?? 'Weeks';
      case ThemedUnits.day:
        return i18n?.t('helpers.days') ?? 'Days';
      case ThemedUnits.hour:
        return i18n?.t('helpers.hours') ?? 'Hours';
      case ThemedUnits.minute:
        return i18n?.t('helpers.minutes') ?? 'Minutes';
      case ThemedUnits.second:
        return i18n?.t('helpers.seconds') ?? 'Seconds';
      case ThemedUnits.millisecond:
        return i18n?.t('helpers.milliseconds') ?? 'Milliseconds';
    }
  }
}
