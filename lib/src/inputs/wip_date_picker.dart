part of inputs;

class ThemedWipDatePicker extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final IconData? prefixIcon;
  final String? prefixText;
  final void Function()? onPrefixTap;
  final void Function(DateTime)? onChanged;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final bool showTime;
  final EdgeInsets padding;
  final double heightFactor;
  final double maxHeight;
  final bool forceMobile;
  final Locale? locale;

  const ThemedWipDatePicker({
    super.key,
    this.labelText,
    this.label,
    this.disabled = false,
    this.prefixIcon,
    this.prefixText,
    this.onPrefixTap,
    this.onChanged,
    this.errors = const [],
    this.hideDetails = false,
    this.showTime = false,
    this.padding = const EdgeInsets.all(10),
    this.heightFactor = 0.7,
    this.maxHeight = 300,
    this.forceMobile = false,
    this.locale,
  }) : assert(label == null || labelText == null);

  @override
  State<ThemedWipDatePicker> createState() => _ThemedWipDatePickerState();
}

class _ThemedWipDatePickerState extends State<ThemedWipDatePicker> with TickerProviderStateMixin {
  final GlobalKey key = GlobalKey();
  late AnimationController animationController;
  OverlayEntry? overlayEntry;
  final FocusNode focusNode = FocusNode();
  Duration get duration => const Duration(milliseconds: 150);
  final TextEditingController _controller = TextEditingController();
  bool get forceMobile => widget.forceMobile;
  String dateStr = '';
  DateTime focusDay = DateTime.now();
  List<DateTime> daysInMonth = [];
  List<String> daysOfWeek = [];
  List allDays = [];
  late Function(void Function()) overlaySetState;
  List<DateTime> initialAndFinalDay = [];
  List<DateTime> datesSelected = [];
  ThemeData get theme => Theme.of(context);
  Size get size => MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: duration);
  }

  @override
  Widget build(BuildContext context) {
    return ThemedTextInput(
      key: key,
      label: widget.label,
      labelText: widget.labelText,
      prefixIcon: widget.prefixIcon,
      prefixText: widget.prefixText,
      onPrefixTap: widget.onPrefixTap,
      suffixIcon: MdiIcons.calendar,
      disabled: widget.disabled,
      value: dateStr,
      onTap: _handleTap,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
      controller: _controller,
      readonly: true,
    );
  }

  _updateDate() {
    daysInMonth = _getDaysInMonth(focusDay);
    daysOfWeek = size.width <= kSmallGrid
        ? DateFormat.EEEE(widget.locale?.toString()).dateSymbols.SHORTWEEKDAYS
        : DateFormat.EEEE(widget.locale?.toString()).dateSymbols.STANDALONEWEEKDAYS;
    allDays = [...daysOfWeek, ...daysInMonth];
  }

  void _handleTap() {
    if (overlayEntry == null) {
      _updateDate();
      _buildOverlay();
    } else {
      _destroyOverlay();
    }
  }

  void _buildOverlay() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    Size widgetSize = renderBox.size;
    double top = offset.dy;
    double left = offset.dx;
    double? right;
    double? width;

    if (forceMobile) {
      left = 15;
      right = 15;
    } else {
      width = widgetSize.width;
    }

    overlayEntry = OverlayEntry(
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context1, setState1) {
            overlaySetState = setState1;
            return Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned.fill(child: GestureDetector(onTap: _destroyOverlay)),
                  Positioned(
                    top: top,
                    left: left,
                    right: right,
                    width: width,
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: animationController.value,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: widget.maxHeight,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            _buildToolBar(),
                            Expanded(
                              child: _buildCalendar(items: allDays),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    animationController.forward();
    Overlay.of(context).insert(overlayEntry!);
  }

  void _destroyOverlay() async {
    await animationController.reverse();
    overlayEntry?.remove();
    overlayEntry = null;
  }

  Widget _buildToolBar() {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${DateFormat('MMMM').format(focusDay)} ${focusDay.year}",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: validateColor(color: theme.cardColor),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const SizedBox(height: 20, child: VerticalDivider()),
        const SizedBox(width: 10),
        Tooltip(
          message: "Chao",
          child: InkWell(
            child: Icon(
              MdiIcons.calendar,
              color: validateColor(color: theme.cardColor),
            ),
            onTap: () {
              overlaySetState(() {
                focusDay = DateTime.now();
                _updateDate();
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        const SizedBox(height: 20, child: VerticalDivider()),
        const SizedBox(width: 10),
        ThemedButton(
          labelText: "Previous",
          icon: MdiIcons.chevronLeft,
          style: ThemedButtonStyle.fab,
          onTap: () {
            overlaySetState(() {
              focusDay = focusDay.subtract(Duration(days: focusDay.day + 1));
              debugPrint("Dates Selected: $datesSelected");
              _updateDate();
            });
          },
        ),
        ThemedButton(
          labelText: "Previous",
          icon: MdiIcons.chevronRight,
          style: ThemedButtonStyle.fab,
          onTap: () {
            overlaySetState(() {
              DateTime newSearch = focusDay.add(Duration(days: focusDay.day + 1));
              if (newSearch.month == focusDay.month) {
                focusDay = newSearch.add(const Duration(days: 2));
              } else {
                focusDay = newSearch;
              }
              _updateDate();
            });
          },
        ),
      ],
    );
  }

  Widget _buildCalendar({required List items}) {
    return GridView.builder(
      gridDelegate: const ThemedGridDelegateWithFixedHeight(
        crossAxisCount: 7,
        height: 40,
      ),
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final day = items[index];
        return _buildDay(day: day, isString: day is String);
      },
    );
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    return List.generate(daysInMonth, (index) => DateTime(month.year, month.month, index + 1));
  }

  Widget _buildDay({required var day, required bool isString}) {
    return isString
        ? Center(child: Text(day))
        : Builder(builder: (dayContext) {
            Color textContainer = _getTextContainerColor(day);
            Color textColor = _getLabelTextColor(day);
            return Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    debugPrint("daysOfWeek: $day - ${day.runtimeType}");
                    _selectInitialAndFinalDay(day);
                    datesSelected = _setDateSelected();
                    overlaySetState(() {});
                    debugPrint("initialAndFinalDay: $initialAndFinalDay");
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: textContainer,
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
  }

  Color _getTextContainerColor(DateTime day) {
    if (initialAndFinalDay.contains(day)) {
      return theme.primaryColor;
    } else {
      if (datesSelected.contains(day)) {
        return theme.primaryColor.withOpacity(0.2);
      }
    }
    return theme.cardColor;
  }

  Color _getLabelTextColor(DateTime day) {
    if (initialAndFinalDay.contains(day)) {
      return Colors.white;
    } else {
      if (datesSelected.contains(day)) {
        return theme.primaryColor;
      }
    }

    return Colors.black;
  }

  void _selectInitialAndFinalDay(DateTime day) {
    if (initialAndFinalDay.isEmpty) {
      initialAndFinalDay.add(day);
    } else if (initialAndFinalDay.length == 1) {
      initialAndFinalDay.add(day);
      if (initialAndFinalDay.first.isAfter(initialAndFinalDay.last)) {
        initialAndFinalDay = initialAndFinalDay.reversed.toList();
      }
    } else {
      initialAndFinalDay = [day];
    }
    debugPrint("initialAndFinalDay: $initialAndFinalDay");
  }

  List<DateTime> _setDateSelected() {
    List<DateTime> list = [];
    if (initialAndFinalDay.isNotEmpty) {
      DateTime initialDay = initialAndFinalDay.first;
      DateTime finalDay = initialAndFinalDay.last;
      // find all days between initial and final day
      for (int i = 0; i <= finalDay.difference(initialDay).inDays; i++) {
        list.add(initialDay.add(Duration(days: i)));
      }
    }
    debugPrint("list: $list");
    return list;
  }
}
