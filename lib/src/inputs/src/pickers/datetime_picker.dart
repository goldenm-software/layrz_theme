part of inputs;

class ThemedDateTimePicker extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final DateTime? value;
  final String? placeholder;
  final IconData? prefixIcon;
  final String? prefixText;
  final void Function()? onPrefixTap;
  final void Function(DateTime)? onChanged;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final LayrzAppLocalizations? i18n;
  final bool showTime;
  final List<DateTime> disabledDates;
  final EdgeInsets padding;
  final double heightFactor;
  final double maxHeight;

  const ThemedDateTimePicker({
    super.key,
    this.i18n,
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
    this.showTime = false,
    this.disabledDates = const [],
    this.padding = const EdgeInsets.all(10),
    this.heightFactor = 0.7,
    this.maxHeight = 485,
  }) : assert(label == null || labelText == null);

  @override
  State<ThemedDateTimePicker> createState() => _ThemedDateTimePickerState();
}

class _ThemedDateTimePickerState extends State<ThemedDateTimePicker> with TickerProviderStateMixin {
  final GlobalKey key = GlobalKey();
  late AnimationController animation;
  OverlayEntry? overlayEntry;
  final FocusNode focusNode = FocusNode();
  Duration get duration => const Duration(milliseconds: 150);

  late DateTime _value;
  late DateTime _search;
  final TextEditingController _controller = TextEditingController();

  Map<String, String> get _internalTranslations => {
        'calendar.weekdays.monday': 'Monday',
        'calendar.weekdays.tuesday': 'Tuesday',
        'calendar.weekdays.wednesday': 'Wednesday',
        'calendar.weekdays.thursday': 'Thursday',
        'calendar.weekdays.friday': 'Friday',
        'calendar.weekdays.saturday': 'Saturday',
        'calendar.weekdays.sunday': 'Sunday',
        'calendar.months.1': 'January',
        'calendar.months.2': 'February',
        'calendar.months.3': 'March',
        'calendar.months.4': 'April',
        'calendar.months.5': 'May',
        'calendar.months.6': 'June',
        'calendar.months.7': 'July',
        'calendar.months.8': 'August',
        'calendar.months.9': 'September',
        'calendar.months.10': 'October',
        'calendar.months.11': 'November',
        'calendar.months.12': 'December',
        'calendar.actions.save': 'Save',
        'calendar.actions.cancel': 'Cancel',
        'calendar.actions.today': 'Today',
        'calendar.time.hour': 'Hour',
        'calendar.time.minute': 'Minute',
      };

  List<DateTime> get disabledDates => widget.disabledDates;
  List<ThemedSelectItem<int>> get _hours => List.generate(24, (i) {
        return ThemedSelectItem<int>(
          value: i,
          label: i.toString().padLeft(2, '0'),
        );
      }).toList();

  List<ThemedSelectItem<int>> get _minutes => List.generate(60, (i) {
        return ThemedSelectItem<int>(
          value: i,
          label: i.toString().padLeft(2, '0'),
        );
      }).toList();
  bool get showTime => widget.showTime;

  String get parsedDate => showTime ? _value.format(pattern: "%Y-%m-%d %H:%M") : _value.format(pattern: "%Y-%m-%d");

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: duration);
    _value = widget.value ?? DateTime.now();
    _search = _value;

    _controller.text = parsedDate;
  }

  @override
  void didUpdateWidget(ThemedDateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      _value = widget.value ?? DateTime.now();
      _search = _value;
      _controller.text = parsedDate;
      Future.delayed(Duration.zero, () {
        widget.onChanged?.call(_value);
      });
    }
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
      onTap: _handleTap,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
      controller: _controller,
      readonly: true,
    );
  }

  void _handleTap() {
    if (overlayEntry == null) {
      _buildOverlay();
    } else {
      _destroyOverlay();
    }
  }

  void _buildOverlay() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }

    double scrollOffset = 0;
    ScrollController scrollController = ScrollController(initialScrollOffset: scrollOffset);

    RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero);

    Size screenSize = MediaQuery.of(context).size;
    double width = 400;

    if (width > (box.size.width - widget.padding.horizontal)) {
      width = box.size.width - widget.padding.horizontal;
    }

    double height = screenSize.height * widget.heightFactor;

    double? top;
    double? bottom;

    if (screenSize.height - offset.dy > height) {
      top = offset.dy + widget.padding.top;
    } else {
      bottom = screenSize.height - offset.dy - box.size.height + widget.padding.bottom;
    }

    if (height > widget.maxHeight) {
      height = widget.maxHeight;
    }

    overlayEntry = OverlayEntry(
      builder: (context) {
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
                child: SizedBox(
                  width: width,
                  child: Column(
                    children: [
                      FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: StatefulBuilder(
                          builder: (BuildContext context, setState) {
                            List<List<_InternalDateDraw>> month = generateMonth(_search);
                            return Container(
                              height: height,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20).subtract(const EdgeInsets.only(bottom: 10)),
                                      color: Theme.of(context).cardColor,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              t('calendar.months.${_search.month}'),
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                    color: validateColor(color: Theme.of(context).cardColor),
                                                  ),
                                            ),
                                          ),
                                          VerticalDivider(
                                            color: validateColor(color: Theme.of(context).cardColor),
                                          ),
                                          Tooltip(
                                            message: t('calendar.actions.today'),
                                            child: InkWell(
                                              child: Icon(
                                                MdiIcons.calendar,
                                                color: validateColor(color: Theme.of(context).cardColor),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  _value = DateTime.now();
                                                });
                                              },
                                            ),
                                          ),
                                          VerticalDivider(
                                            color: validateColor(color: Theme.of(context).cardColor),
                                          ),
                                          InkWell(
                                            child: Icon(
                                              MdiIcons.chevronLeft,
                                              color: validateColor(color: Theme.of(context).cardColor),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _search = _search.subtract(Duration(days: _search.day + 1));
                                              });
                                            },
                                          ),
                                          InkWell(
                                            child: Icon(
                                              MdiIcons.chevronRight,
                                              color: validateColor(color: Theme.of(context).cardColor),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                DateTime newSearch = _search.add(Duration(days: _search.day + 1));
                                                if (newSearch.month == _search.month) {
                                                  _search = newSearch.add(const Duration(days: 2));
                                                } else {
                                                  _search = newSearch;
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          'sunday',
                                          'monday',
                                          'tuesday',
                                          'wednesday',
                                          'thursday',
                                          'friday',
                                          'saturday'
                                        ].map((e) {
                                          return Expanded(
                                            child: drawDay(t('calendar.weekdays.$e').substring(0, 1), isHeader: true),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        children: month.map((week) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: week.map((e) {
                                              return Expanded(
                                                child: drawDay(
                                                  e.value.day.toString().padLeft(2, '0'),
                                                  setState: setState,
                                                  value: e.value,
                                                  obscure: e.obscure,
                                                  selected: e.value.year == _value.year &&
                                                      e.value.month == _value.month &&
                                                      e.value.day == _value.day,
                                                  disabled: e.disabled,
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    if (showTime) ...[
                                      const Divider(),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ConstrainedBox(
                                                constraints: const BoxConstraints(maxHeight: 100),
                                                child: ThemedSelectInput<int>(
                                                  value: _value.hour,
                                                  items: _hours,
                                                  labelText: t('calendar.time.hour'),
                                                  onChanged: (value) {
                                                    if (value == null || value.value == null) {
                                                      return;
                                                    }

                                                    Future.delayed(Duration.zero, () {
                                                      setState(() {
                                                        _value = DateTime(_value.year, _value.month, _value.day,
                                                            value.value ?? _value.hour, _value.minute, 0);
                                                        updateAllDependencies();
                                                      });
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ConstrainedBox(
                                                constraints: const BoxConstraints(maxHeight: 100),
                                                child: ThemedSelectInput<int>(
                                                  value: _value.minute,
                                                  items: _minutes,
                                                  labelText: t('calendar.time.minute'),
                                                  onChanged: (value) {
                                                    if (value == null || value.value == null) {
                                                      return;
                                                    }

                                                    Future.delayed(Duration.zero, () {
                                                      setState(() {
                                                        _value = DateTime(_value.year, _value.month, _value.day,
                                                            _value.hour, value.value!, 0);
                                                        updateAllDependencies();
                                                      });
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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

    animation.forward();
    Overlay.of(context).insert(overlayEntry!);
  }

  void updateAllDependencies() {
    _controller.text = parsedDate;
    Future.delayed(Duration.zero, () {
      widget.onChanged?.call(_value);
    });
  }

  void _destroyOverlay() async {
    await animation.reverse();
    overlayEntry?.remove();
    overlayEntry = null;
  }

  Widget drawDay(
    String label, {
    DateTime? value,
    bool obscure = false,
    bool selected = false,
    bool disabled = false,
    dynamic setState,
    bool isHeader = false,
  }) {
    Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    if (obscure || disabled) {
      textColor = textColor.withOpacity(0.5);
    }

    if (selected) {
      textColor = validateColor(color: Theme.of(context).primaryColor);
    }

    if (isHeader) {
      textColor = validateColor(color: Theme.of(context).primaryColor);
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: setState == null || value == null || disabled
              ? null
              : () {
                  setState(() {
                    if (showTime) {
                      _value = DateTime(value.year, value.month, value.day, _value.hour, _value.minute, 0);
                    } else {
                      _value = DateTime(value.year, value.month, value.day, 0, 0, 0);
                    }
                    updateAllDependencies();
                  });
                },
          child: Container(
            decoration: BoxDecoration(
              color: selected ? Theme.of(context).primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String t(String key) {
    return widget.i18n?.t(key) ?? _internalTranslations[key] ?? key;
  }
}
