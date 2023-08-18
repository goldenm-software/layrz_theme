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
    this.maxHeight = 485,
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
  late List<DateTime> daysInMonth = _getDaysInMonth(focusDay);
  late List<String> daysOfWeek = DateFormat.EEEE(widget.locale?.toString()).dateSymbols.STANDALONEWEEKDAYS;
  late List allDays = [...daysOfWeek, ...daysInMonth];

  late Function(void Function()) overlaySetState;

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

  void _handleTap() {
    if (overlayEntry == null) {
      _updateDate();
      _buildOverlay();
    } else {
      _destroyOverlay();
    }
  }

  _updateDate() {
    daysInMonth = _getDaysInMonth(focusDay);
    daysOfWeek = DateFormat.EEEE(widget.locale?.toString()).dateSymbols.STANDALONEWEEKDAYS;
    allDays = [...daysOfWeek, ...daysInMonth];
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
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: widget.maxHeight,
                        child: Column(
                          children: [
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Text(
                            //         DateFormat('MMMM').format(focusDay),
                            //         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            //               color: validateColor(color: Theme.of(context).cardColor),
                            //               fontWeight: FontWeight.bold,
                            //             ),
                            //       ),
                            //     ),
                            //     const SizedBox(width: 10),
                            //     const SizedBox(height: 20, child: VerticalDivider()),
                            //     const SizedBox(width: 10),
                            //     Tooltip(
                            //       message: "Chao",
                            //       child: InkWell(
                            //         child: Icon(
                            //           MdiIcons.calendar,
                            //           color: validateColor(color: Theme.of(context).cardColor),
                            //         ),
                            //         onTap: () {
                            //           setState(() {
                            //             focusDay = DateTime.now();
                            //             _updateDate();
                            //           });
                            //         },
                            //       ),
                            //     ),
                            //     const SizedBox(width: 10),
                            //     const SizedBox(height: 20, child: VerticalDivider()),
                            //     const SizedBox(width: 10),
                            //     ThemedButton(
                            //       labelText: "hola",
                            //       icon: MdiIcons.chevronLeft,
                            //       style: ThemedButtonStyle.fab,
                            //       onTap: () {
                            //         setState(() {
                            //           focusDay = focusDay.subtract(Duration(days: focusDay.day + 1));
                            //           _updateDate();
                            //         });
                            //       },
                            //     ),
                            //     ThemedButton(
                            //       labelText: "chao",
                            //       icon: MdiIcons.chevronRight,
                            //       style: ThemedButtonStyle.fab,
                            //       onTap: () {
                            //         setState(() {
                            //           DateTime newSearch = focusDay.add(Duration(days: focusDay.day + 1));
                            //           if (newSearch.month == focusDay.month) {
                            //             focusDay = newSearch.add(const Duration(days: 2));
                            //           } else {
                            //             focusDay = newSearch;
                            //           }
                            //           _updateDate();
                            //         });
                            //       },
                            //     ),
                            //   ],
                            // ),
                            _buildToolBar(),
                            Expanded(
                              child: _buildCalendar(items: allDays),
                            ),
                            // Expanded(
                            //   child: GridView.builder(
                            //     gridDelegate: const ThemedGridDelegateWithFixedHeight(
                            //       crossAxisCount: 7,
                            //       height: 40,
                            //     ),
                            //     itemCount: allDays.length,
                            //     shrinkWrap: true,
                            //     itemBuilder: (context, index) {
                            //       final day = allDays[index];
                            //       debugPrint('an item was created $day');
                            //       return _buildDay(day: day, isString: day is String);
                            //     },
                            //   ),
                            // ),
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
            DateFormat('MMMM').format(focusDay),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: validateColor(color: Theme.of(context).cardColor),
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
              color: validateColor(color: Theme.of(context).cardColor),
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
        // ThemedButton(
        //   labelText: "Previous",
        //   icon: MdiIcons.chevronLeft,
        //   style: ThemedButtonStyle.fab,
        //   onTap: () {
        //     overlaySetState(() {
        //       focusDay = focusDay.subtract(Duration(days: focusDay.day + 1));
        //       _updateDate();
        //     });
        //   },
        // ),
        Tooltip(
          message: "Previous",
          child: InkWell(
            child: Icon(
              MdiIcons.chevronLeft,
              color: validateColor(color: Theme.of(context).cardColor),
            ),
            onTap: () {
              overlaySetState(() {
                focusDay = focusDay.subtract(Duration(days: focusDay.day + 1));
                _updateDate();
              });
            },
          ),
        ),

        Builder(builder: (context) {
          return ThemedButton(
            labelText: "chao",
            icon: MdiIcons.chevronRight,
            style: ThemedButtonStyle.fab,
            onTap: () {
              // setState1;
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
          );
        }),
      ],
    );
  }

  Widget _buildCalendar({required List items}) {
    // final List<DateTime> daysInMonth = _getDaysInMonth(focusDay);
    // final List<String> daysOfWeek = DateFormat.EEEE(widget.locale?.toString()).dateSymbols.STANDALONEWEEKDAYS;
    // final List allDays = [...daysOfWeek, ...daysInMonth];

    return GridView.builder(
      gridDelegate: const ThemedGridDelegateWithFixedHeight(
        crossAxisCount: 7,
        height: 40,
      ),
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final day = items[index];
        debugPrint('an item was created $day');
        return _buildDay(day: day, isString: day is String);
      },
    );
  }

  // List<DateTime> _getDaysInMonth(DateTime month) {
  //   final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  //   return List.generate(daysInMonth, (index) => DateTime(month.year, month.month, index + 1));
  // }
  List<DateTime> _getDaysInMonth(DateTime month) {
    final daysInMonth = DateTime.utc(month.year, month.month + 1, 0).day;
    return List<DateTime?>.filled(daysInMonth, null, growable: false)
        .asMap()
        .map((index, value) => MapEntry(index, DateTime.utc(month.year, month.month, index + 1)))
        .values
        .toList();
  }

  Widget _buildDay({required var day, required bool isString}) {
    return isString
        ? Center(child: Text(day))
        : Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  debugPrint("daysOfWeek: $day - ${day.runtimeType}");
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 30,
                  height: 30,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
