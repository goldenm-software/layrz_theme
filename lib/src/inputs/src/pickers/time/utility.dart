part of '../../../inputs.dart';

class _ThemedTimeUtility extends StatefulWidget {
  /// [value] is the value of the input.
  final TimeOfDay? value;

  /// [onChanged] is the callback function when the input is changed.
  final void Function(TimeOfDay)? onChanged;

  /// [use24HourFormat] is the flag to use 24 hour format. By default is true, so it will use 24 hour format.
  final bool use24HourFormat;

  /// [titleText] is the title text of the input. Avoid submit [label] and [labelText] at the same time.
  final String titleText;

  /// [hoursText] is the hours text of the input.
  final String hoursText;

  /// [minutesText] is the minutes text of the input.
  final String minutesText;

  /// [saveText] is the text that will be displayed on the save button.
  final String saveText;

  /// [cancelText] is the text that will be displayed on the cancel button.
  final String cancelText;

  /// [inDialog] is the flag to display the input in a dialog.
  final bool inDialog;

  final bool disableBlink;

  /// [_ThemedTimeUtility] is a time utility input.
  const _ThemedTimeUtility({
    // ignore: unused_element_parameter
    super.key,
    this.value,
    this.onChanged,
    this.use24HourFormat = true,
    this.titleText = '',
    this.hoursText = 'Hours',
    this.minutesText = 'Minutes',
    this.saveText = 'Save',
    this.cancelText = 'Cancel',
    this.inDialog = true,
    this.disableBlink = false,
  });

  @override
  State<_ThemedTimeUtility> createState() => __ThemedTimeUtilityState();
}

class __ThemedTimeUtilityState extends State<_ThemedTimeUtility> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get primaryColor => isDark ? Colors.white : Theme.of(context).primaryColor;
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  Timer? _blink;
  late TimeOfDay _value;
  bool _blinkState = true;

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? TimeOfDay.now();

    _hoursController = TextEditingController();
    _minutesController = TextEditingController();
    _updateControllers();
    if (widget.disableBlink) {
      _blinkState = false;
    } else {
      _setTimer();
    }
  }

  @override
  void didUpdateWidget(_ThemedTimeUtility oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _value = widget.value ?? TimeOfDay.now();
      _updateControllers();
    }
    if (!widget.disableBlink && widget.disableBlink != oldWidget.disableBlink) {
      _setTimer();
    }
  }

  void _setTimer() {
    _blink?.cancel();
    _blink = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      _blinkState = !_blinkState;
      setState(() {});
    });
  }

  void _updateControllers() {
    if (widget.use24HourFormat) {
      _hoursController.text = _value.hour.toString();
    } else {
      _hoursController.text = _value.hourOfPeriod.toString();
    }
    _minutesController.text = _value.minute.toString();

    // Set cursor position
    _hoursController.selection = TextSelection.fromPosition(TextPosition(offset: _hoursController.text.length));
    _minutesController.selection = TextSelection.fromPosition(TextPosition(offset: _minutesController.text.length));
    setState(() {});
  }

  @override
  void dispose() {
    _blink?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < kSmallGrid;

    Widget content = Container(
      constraints: widget.inDialog ? const BoxConstraints(maxWidth: 400, maxHeight: 400) : null,
      decoration: widget.inDialog ? generateContainerElevation(context: context, elevation: 3) : null,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.inDialog) ...[
            Text(
              widget.titleText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _hoursController,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 40,
                    color: _blinkState ? Colors.grey.shade500 : null,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: isMobile
                      ? const InputDecoration()
                      : InputDecoration(
                          prefixIcon: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: _value.hour == 0
                                  ? null
                                  : () {
                                      if (_value.hour == 0) return;
                                      _value = _value.replacing(hour: _value.hour - 1);
                                      _updateControllers();
                                      widget.onChanged?.call(_value);
                                    },
                              child: Icon(
                                LayrzIcons.solarOutlineMinusSquare,
                                color: Theme.of(context).inputDecorationTheme.prefixIconColor,
                              ),
                            ),
                          ),
                          suffixIcon: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: _value.hour == 23
                                  ? null
                                  : () {
                                      if (_value.hour == 23) return;
                                      _value = _value.replacing(hour: _value.hour + 1);
                                      _updateControllers();
                                      widget.onChanged?.call(_value);
                                    },
                              child: Icon(
                                LayrzIcons.solarOutlineAddSquare,
                                color: Theme.of(context).inputDecorationTheme.prefixIconColor,
                              ),
                            ),
                          ),
                        ),
                  onChanged: (value) {
                    int? parsed = int.tryParse(value);
                    if (parsed == null) return;

                    if (widget.use24HourFormat) {
                      _value = _value.replacing(hour: parsed);
                    } else {
                      if (_value.period == DayPeriod.am) {
                        if (parsed >= 12) {
                          return;
                        }
                      } else {
                        if (parsed < 12) {
                          parsed += 12;
                        }
                      }
                      _value = _value.replacing(hour: parsed);
                    }
                    setState(() {});
                    widget.onChanged?.call(_value);
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LayrzIcons.mdiCircleSmall, size: 30),
                    Icon(LayrzIcons.mdiCircleSmall, size: 30),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _minutesController,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 40,
                    color: _blinkState ? Colors.grey.shade500 : null,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: isMobile
                      ? const InputDecoration()
                      : InputDecoration(
                          prefixIcon: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: _value.minute == 0
                                  ? null
                                  : () {
                                      if (_value.minute == 0) return;
                                      _value = _value.replacing(minute: _value.minute - 1);
                                      _updateControllers();
                                      widget.onChanged?.call(_value);
                                    },
                              child: Icon(
                                LayrzIcons.solarOutlineMinusSquare,
                                color: Theme.of(context).inputDecorationTheme.prefixIconColor,
                              ),
                            ),
                          ),
                          suffixIcon: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: _value.minute == 59
                                  ? null
                                  : () {
                                      if (_value.minute == 59) return;
                                      _value = _value.replacing(minute: _value.minute + 1);
                                      _updateControllers();
                                      widget.onChanged?.call(_value);
                                    },
                              child: Icon(
                                LayrzIcons.solarOutlineAddSquare,
                                color: Theme.of(context).inputDecorationTheme.prefixIconColor,
                              ),
                            ),
                          ),
                        ),
                  onChanged: (value) {
                    int? parsed = int.tryParse(value);
                    _value = _value.replacing(minute: parsed);
                    setState(() {});
                    widget.onChanged?.call(_value);
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.hoursText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 10 + 30 + 10),
              /* 10*2 of SizedBox and 30 of dots */
              Expanded(
                child: Text(
                  widget.minutesText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          if (!widget.use24HourFormat) ...[
            const SizedBox(height: 10),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: _value.period == DayPeriod.am ? primaryColor : Colors.transparent,
                      child: InkWell(
                        onTap: _value.period == DayPeriod.am
                            ? null
                            : () {
                                _value = TimeOfDay(
                                  hour: _value.hour - 12,
                                  minute: _value.minute,
                                );
                                setState(() {});
                                widget.onChanged?.call(_value);
                              },
                        child: Center(
                          child: Text(
                            'AM',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: _value.period == DayPeriod.am ? validateColor(color: primaryColor) : null,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: _value.period == DayPeriod.pm ? primaryColor : Colors.transparent,
                      child: InkWell(
                        onTap: _value.period == DayPeriod.pm
                            ? null
                            : () {
                                _value = TimeOfDay(
                                  hour: _value.hour + 12,
                                  minute: _value.minute,
                                );
                                setState(() {});
                                widget.onChanged?.call(_value);
                              },
                        child: Center(
                          child: Text(
                            'PM',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: _value.period == DayPeriod.pm ? validateColor(color: primaryColor) : null,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (widget.inDialog) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ThemedButton.cancel(
                  labelText: widget.cancelText,
                  onTap: () => Navigator.of(context).pop(),
                ),
                ThemedButton.save(
                  labelText: widget.saveText,
                  onTap: () => Navigator.of(context).pop(_value),
                ),
              ],
            ),
          ],
        ],
      ),
    );

    if (widget.inDialog) {
      return Dialog(
        child: PointerInterceptor(child: content),
      );
    }

    return PointerInterceptor(child: content);
  }
}
