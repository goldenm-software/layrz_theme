part of inputs;

class ThemedDateTimeRangePicker extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final List<DateTime>? value;
  final String? placeholder;
  final IconData? prefixIcon;
  final String? prefixText;
  final void Function()? onPrefixTap;
  final void Function(List<DateTime>)? onChanged;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final LayrzAppLocalizations? i18n;
  final Widget? customWidget;
  final EdgeInsets padding;
  final double heightFactor;
  final double maxHeight;

  const ThemedDateTimeRangePicker({
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
    this.customWidget,
    this.padding = const EdgeInsets.all(10),
    this.heightFactor = 0.7,
    this.maxHeight = 615,
  })  : assert(label == null || labelText == null),
        assert(value == null || value.length == 2);

  @override
  State<ThemedDateTimeRangePicker> createState() => _ThemedDateTimeRangePickerState();
}

class _ThemedDateTimeRangePickerState extends State<ThemedDateTimeRangePicker> with SingleTickerProviderStateMixin {
  final GlobalKey key = GlobalKey();
  late AnimationController animation;
  late OverlayState overlayState;
  OverlayEntry? overlayEntry;
  final FocusNode focusNode = FocusNode();
  Duration get duration => const Duration(milliseconds: 150);

  final TextEditingController textEditingController = TextEditingController();

  late List<DateTime> _value;
  late DateTime _search;

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
        'calendar.startAt.time': 'Start time',
        'calendar.endAt.time': 'End time',
      };

  final List<DateTime> _temporalPicks = [];

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

  String get parsedDate {
    String start = "";
    String end = "";

    if (_temporalPicks.isNotEmpty) {
      start = _temporalPicks.first.format(pattern: '%Y-%m-%d %H:%M');
      end = "N/A";
    } else {
      if (_value.isNotEmpty) {
        start = _value.first.format(pattern: '%Y-%m-%d %H:%M');
      } else {
        start = "N/A";
      }

      if (_value.length > 1) {
        end = _value.last.format(pattern: '%Y-%m-%d %H:%M');
      } else {
        end = "N/A";
      }
    }

    return "$start - $end";
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _value = widget.value ?? [now, now.add(const Duration(hours: 1))];
    _search = _value.first;
    textEditingController.text = parsedDate;
    animation = AnimationController(vsync: this, duration: duration);
    overlayState = Overlay.of(context);
  }

  @override
  void didUpdateWidget(ThemedDateTimeRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value && _temporalPicks.isEmpty) {
      final now = DateTime.now();
      _value = widget.value ?? [now, now.add(const Duration(hours: 1))];
      _search = _value.first;
      textEditingController.text = parsedDate;
      Future.delayed(Duration.zero, () {
        widget.onChanged?.call(_value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customWidget != null) {
      return InkWell(
        key: key,
        onTap: widget.disabled ? null : _handleTap,
        child: widget.customWidget,
      );
    }

    return Actions(
      actions: {
        DismissIntent: CallbackAction<DismissIntent>(
          onInvoke: (intent) {
            return false;
          },
        ),
      },
      child: ThemedTextInput(
        onTap: widget.disabled ? null : _handleTap,
        key: key,
        label: widget.label,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        prefixText: widget.prefixText,
        onPrefixTap: widget.onPrefixTap,
        suffixIcon: MdiIcons.chevronDown,
        disabled: widget.disabled,
        errors: widget.errors,
        padding: widget.padding,
        hideDetails: widget.hideDetails,
        controller: textEditingController,
        focusNode: focusNode,
        readonly: true,
      ),
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

      if (widget.customWidget != null) {
        top -= widget.padding.top;
      }
    } else {
      bottom = screenSize.height - offset.dy - box.size.height + widget.padding.bottom;

      if (widget.customWidget != null) {
        bottom -= widget.padding.bottom;
      }
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
                              constraints: BoxConstraints(
                                maxHeight: calculateMaxHeight(height: height, bottom: bottom, screenSize: screenSize),
                                minHeight: box.size.height + widget.padding.vertical,
                              ),
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
                                                  _value = [DateTime.now(), DateTime.now()];
                                                  _search = _value.first;
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
                                                  selected: validateIfInside(e.value),
                                                  disabled: e.disabled,
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    const Divider(),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Text(t('calendar.startAt.time')),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ConstrainedBox(
                                                  constraints: const BoxConstraints(maxHeight: 100),
                                                  child: ThemedSelectInput<int>(
                                                    value: _value.first.hour,
                                                    items: _hours,
                                                    labelText: t('calendar.time.hour'),
                                                    onChanged: (value) {
                                                      if (value == null || value.value == null) {
                                                        return;
                                                      }

                                                      Future.delayed(Duration.zero, () {
                                                        setState(() {
                                                          _value[0] = DateTime(
                                                            _value.first.year,
                                                            _value.first.month,
                                                            _value.first.day,
                                                            value.value ?? _value.first.hour,
                                                            _value.first.minute,
                                                            0,
                                                          );
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
                                                    value: _value.first.minute,
                                                    items: _minutes,
                                                    labelText: t('calendar.time.minute'),
                                                    onChanged: (value) {
                                                      if (value == null || value.value == null) {
                                                        return;
                                                      }

                                                      Future.delayed(Duration.zero, () {
                                                        setState(() {
                                                          _value[0] = DateTime(
                                                            _value.first.year,
                                                            _value.first.month,
                                                            _value.first.day,
                                                            _value.first.hour,
                                                            value.value ?? _value.first.minute,
                                                            0,
                                                          );
                                                          updateAllDependencies();
                                                        });
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_temporalPicks.isEmpty)
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Text(t('calendar.endAt.time')),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ConstrainedBox(
                                                    constraints: const BoxConstraints(maxHeight: 100),
                                                    child: ThemedSelectInput<int>(
                                                      value: _value.last.hour,
                                                      items: _hours,
                                                      labelText: t('calendar.time.hour'),
                                                      onChanged: (value) {
                                                        if (value == null || value.value == null) {
                                                          return;
                                                        }

                                                        Future.delayed(Duration.zero, () {
                                                          setState(() {
                                                            _value[1] = DateTime(
                                                              _value.last.year,
                                                              _value.last.month,
                                                              _value.last.day,
                                                              value.value ?? _value.last.hour,
                                                              _value.last.minute,
                                                              0,
                                                            );
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
                                                      value: _value.last.minute,
                                                      items: _minutes,
                                                      labelText: t('calendar.time.minute'),
                                                      onChanged: (value) {
                                                        if (value == null || value.value == null) {
                                                          return;
                                                        }

                                                        Future.delayed(Duration.zero, () {
                                                          setState(() {
                                                            _value[1] = DateTime(
                                                              _value.last.year,
                                                              _value.last.month,
                                                              _value.last.day,
                                                              _value.last.hour,
                                                              value.value ?? _value.last.minute,
                                                              0,
                                                            );
                                                            updateAllDependencies();
                                                          });
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
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
    overlayState.insert(overlayEntry!);
  }

  void _destroyOverlay() async {
    await animation.reverse();
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void updateAllDependencies() {
    textEditingController.text = parsedDate;
    if (_temporalPicks.isEmpty) {
      _value.sort((a, b) => a.compareTo(b));
      Future.delayed(Duration.zero, () {
        widget.onChanged?.call(_value);
      });
    }
  }

  bool validateIfInside(DateTime day) {
    if (_temporalPicks.isEmpty) {
      bool contains = false;
      DateTime today = DateTime(day.year, day.month, day.day, 12, 0, 0);
      DateTime start = DateTime(_value.first.year, _value.first.month, _value.first.day, 0, 0, 0);
      contains = today.isAfter(start);
      DateTime end = DateTime(_value.last.year, _value.last.month, _value.last.day, 23, 59, 59);
      contains = contains && today.isBefore(end);

      return contains;
    }

    DateTime today = DateTime(day.year, day.month, day.day, 0, 0, 0);
    DateTime start = DateTime(_temporalPicks.first.year, _temporalPicks.first.month, _temporalPicks.first.day, 0, 0, 0);
    return today == start;
  }

  bool checkIsFirstOrLast(DateTime value) {
    if (_value.isNotEmpty) {
      final start = DateTime(_value.first.year, _value.first.month, _value.first.day, 0, 0, 0);
      final end = DateTime(_value.last.year, _value.last.month, _value.last.day, 0, 0, 0);
      return start == value || end == value;
    }
    return false;
  }

  bool checkIsFirst(DateTime value) {
    if (_temporalPicks.isNotEmpty) {
      return false;
    }
    if (_value.isNotEmpty) {
      final start = DateTime(_value.first.year, _value.first.month, _value.first.day, 0, 0, 0);
      return start == value;
    }
    return false;
  }

  bool checkIsLast(DateTime value) {
    if (_temporalPicks.isNotEmpty) {
      return false;
    }
    if (_value.isNotEmpty) {
      final end = DateTime(_value.last.year, _value.last.month, _value.last.day, 0, 0, 0);
      return end == value;
    }
    return false;
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
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (isHeader) {
      return AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  overflow: TextOverflow.ellipsis,
                  color: validateColor(color: Theme.of(context).cardColor),
                ),
          ),
        ),
      );
    }

    Color textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    if (obscure || disabled) {
      textColor = textColor.withOpacity(0.5);
    }

    Color highlightColor = selected
        ? isDark
            ? Colors.grey.shade700
            : Colors.grey.shade300
        : Theme.of(context).cardColor;

    if (selected) {
      textColor = validateColor(color: highlightColor);
    }

    Widget labelWidget = Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            overflow: TextOverflow.ellipsis,
            color: textColor,
          ),
    );

    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: setState == null || value == null || disabled
            ? null
            : () {
                setState(() {
                  if (_temporalPicks.length == 2) {
                    _temporalPicks.clear();
                  }

                  DateTime valueToSave = value;

                  if (_temporalPicks.isEmpty) {
                    valueToSave = DateTime(valueToSave.year, valueToSave.month, valueToSave.day, _value.first.hour,
                        _value.first.minute, 0);
                  } else {
                    valueToSave = DateTime(
                        valueToSave.year, valueToSave.month, valueToSave.day, _value.last.hour, _value.last.minute, 0);
                  }
                  _temporalPicks.add(valueToSave);

                  if (_temporalPicks.length == 2) {
                    _value = [..._temporalPicks];
                    _temporalPicks.clear();
                  }
                  updateAllDependencies();
                });
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Container(
            child: _temporalPicks.isEmpty && value != null && checkIsFirstOrLast(value)
                ? Padding(
                    padding: EdgeInsets.only(
                      left: checkIsFirst(value) ? 7 : 0,
                      right: checkIsLast(value) ? 7 : 0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7).subtract(EdgeInsets.only(
                        left: checkIsFirst(value) ? 7 : 0,
                        right: checkIsLast(value) ? 7 : 0,
                      )),
                      decoration: BoxDecoration(
                        color: highlightColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(checkIsFirst(value) ? 50 : 0),
                          topRight: Radius.circular(checkIsLast(value) ? 50 : 0),
                          bottomLeft: Radius.circular(checkIsFirst(value) ? 50 : 0),
                          bottomRight: Radius.circular(checkIsLast(value) ? 50 : 0),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                            child: Text(
                          label,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                overflow: TextOverflow.ellipsis,
                                color: validateColor(color: Theme.of(context).primaryColor),
                              ),
                        )),
                      ),
                    ),
                  )
                : Padding(
                    padding: _temporalPicks.isNotEmpty ? const EdgeInsets.symmetric(horizontal: 7) : EdgeInsets.zero,
                    child: Container(
                      decoration: BoxDecoration(
                        color: highlightColor,
                        borderRadius: _temporalPicks.isNotEmpty ? BorderRadius.circular(50) : BorderRadius.zero,
                      ),
                      child: Center(child: labelWidget),
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

  double calculateMaxHeight({
    required double height,
    double? bottom,
    required Size screenSize,
  }) {
    if (bottom == null) {
      return height;
    }

    final diff = screenSize.height - bottom - 10;

    if (diff < height) {
      return diff;
    }

    return height;
  }
}
