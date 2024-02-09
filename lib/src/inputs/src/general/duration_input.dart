part of '../../inputs.dart';

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
  final EdgeInsets padding;

  /// [visibleValues] is the list of values to display in the input
  final List<ThemedUnits> visibleValues;

  /// [ThemedDurationInput] is a duration input.
  const ThemedDurationInput({
    super.key,
    this.value,
    this.onChanged,
    this.errors = const [],
    this.labelText,
    this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.padding = const EdgeInsets.all(10.0),
    this.disabled = false,
    this.visibleValues = const [
      ThemedUnits.day,
      ThemedUnits.hour,
      ThemedUnits.minute,
      ThemedUnits.second,
    ],
  });

  @override
  State<ThemedDurationInput> createState() => _ThemedDurationInputState();
}

class _ThemedDurationInputState extends State<ThemedDurationInput> {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
  Duration? get value => widget.value;

  List<ThemedUnits> get visibleValues => widget.visibleValues;

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

        if (visibleValues.contains(ThemedUnits.day)) height += 80 + 10;
        if (visibleValues.contains(ThemedUnits.hour)) height += 80 + 10;
        if (visibleValues.contains(ThemedUnits.minute)) height += 80 + 10;
        if (visibleValues.contains(ThemedUnits.second)) height += 80;

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
                          if (visibleValues.contains(ThemedUnits.day)) ...[
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
                          if (visibleValues.contains(ThemedUnits.hour)) ...[
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
                          if (visibleValues.contains(ThemedUnits.minute)) ...[
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
                          if (visibleValues.contains(ThemedUnits.second))
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

    return value!.humanize(
      options: ThemedHumanizeOptions(
        units: visibleValues,
        spacer: ' ',
        conjunction: i18n?.t('helpers.and') ?? ' and ',
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
