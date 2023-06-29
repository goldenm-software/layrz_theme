part of layrz_theme;

class ThemedTimePicker extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final String? placeholder;
  final IconData? prefixIcon;
  final String? prefixText;
  final void Function()? onPrefixTap;
  final void Function(TimeOfDay)? onChanged;
  final TimeOfDay? value;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final DateTime? startAt;
  final DateTime? endAt;
  final bool use24HourFormat;

  const ThemedTimePicker({
    Key? key,
    this.value,
    this.labelText,
    this.label,
    this.disabled = false,
    this.placeholder,
    this.prefixIcon,
    this.prefixText,
    this.onPrefixTap,
    this.onChanged,
    this.errors = const [],
    this.hideDetails = false,
    this.startAt,
    this.endAt,
    this.use24HourFormat = true,
  })  : assert(label == null || labelText == null),
        super(key: key);

  @override
  State<ThemedTimePicker> createState() => _ThemedTimePickerState();
}

class _ThemedTimePickerState extends State<ThemedTimePicker> {
  final TextEditingController _controller = TextEditingController();
  late TimeOfDay _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? TimeOfDay.now();
    if (widget.use24HourFormat) {
      _fillInput24HourFormat();
    } else {
      _fillInput12HourFormat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedTextInput(
      key: widget.key,
      label: widget.label,
      labelText: widget.labelText,
      prefixIcon: widget.prefixIcon,
      prefixText: widget.prefixText,
      onPrefixTap: widget.onPrefixTap,
      suffixIcon: MdiIcons.clock,
      disabled: widget.disabled,
      onTap: _drawModal,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
      controller: _controller,
      readonly: true,
    );
  }

  void _drawModal() async {
    TimeOfDay? newDate = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: _value,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: widget.use24HourFormat,
          ),
          child: child!,
        );
      },
    );

    if (newDate != null) {
      setState(() {
        _value = newDate;
        if (widget.use24HourFormat) {
          _fillInput24HourFormat();
        } else {
          _fillInput12HourFormat();
        }
      });

      widget.onChanged?.call(newDate);
    }
  }

  void _fillInput24HourFormat() {
    _controller.text = "${_value.hour.toString().padLeft(2, '0')}:${_value.minute.toString().padLeft(2, '0')}";
  }

  /// prepares the input the 12 hour am pm format
  void _fillInput12HourFormat() {
    _controller.text =
        "${_value.hourOfPeriod.toString().padLeft(2, '0')}:${_value.minute.toString().padLeft(2, '0')} ${_value.period.toString().split('.').last}";
  }
}
