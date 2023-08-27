part of inputs;

class ThemedMonthRangePicker extends StatefulWidget {
  final List<ThemedMonth> value;
  final void Function(List<ThemedMonth>)? onChanged;
  final bool consecutive;
  final String? labelText;
  final Widget? label;
  final String? placeholder;
  final String? prefixText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final VoidCallback? onPrefixTap;
  final Widget? customChild;
  final bool disabled;
  final Map<String, String> translations;
  final bool overridesLayrzTranslations;
  final ThemedMonth? minimum;
  final ThemedMonth? maximum;
  final List<ThemedMonth> disabledMonths;
  final Color hoverColor;
  final Color focusColor;
  final Color splashColor;
  final Color highlightColor;
  final BorderRadius borderRadius;

  /// Creates a [ThemedMonthRangePicker] input.
  const ThemedMonthRangePicker({
    super.key,

    /// [value] is the value of the input.
    this.value = const [],

    /// [consecutive] is the flag to allow only consecutive months.
    /// If it is false, the user can select any month.
    this.consecutive = false,

    /// [onChanged] is the callback function when the input is changed.
    this.onChanged,

    /// [labelText] is the label text of the input. Avoid submit [label] and [labelText] at the same time.
    this.labelText,

    /// [label] is the label widget of the input. Avoid submit [label] and [labelText] at the same time.
    this.label,

    /// [placeholder] is the placeholder of the input.
    this.placeholder,

    /// [prefixText] is the prefix text of the input.
    this.prefixText,

    /// [prefixIcon] is the prefix icon of the input. Avoid submit [prefixIcon] and [prefixWidget] at the same time.
    this.prefixIcon,

    /// [prefixWidget] is the prefix widget of the input. Avoid submit [prefixIcon] and [prefixWidget] at the same time.
    this.prefixWidget,

    /// [onPrefixTap] is the callback function when the prefix is tapped.
    this.onPrefixTap,

    /// [customChild] is the custom child of the input.
    /// If it is submitted, the input will be ignored.
    this.customChild,

    /// [disabled] is the disabled state of the input.
    this.disabled = false,

    /// [translations] is the translations of the input. By default we use [LayrzAppLocalizations] for translations,
    /// but you can submit your own translations using this property. Consider when [LayrzAppLocalizations] is present,
    /// is the default value of this property.
    /// Required translations:
    /// - `actions.cancel` (Cancel)
    /// - `actions.save` (Save)
    /// - `actions.reset` (Reset)
    /// - `layrz.monthPicker.year` (Year {year})
    /// - `layrz.monthPicker.back` (Previous year)
    /// - `layrz.monthPicker.next` (Next year)
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
      'actions.reset': 'Reset',
      'layrz.monthPicker.year': 'Year {year}',
      'layrz.monthPicker.back': 'Previous year',
      'layrz.monthPicker.next': 'Next year',
    },

    /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
    this.overridesLayrzTranslations = false,

    /// [minimum] is the minimum value of the input.
    this.minimum,

    /// [maximum] is the maximum value of the input.
    this.maximum,

    /// [disabledMonths] is the list of disabled months.
    this.disabledMonths = const [],

    /// [hoverColor] is the hover color of the input. Only will affect when [customChild] is submitted.
    /// By default, it will use `Colors.transparent`.
    this.hoverColor = Colors.transparent,

    /// [focusColor] is the focus color of the input. Only will affect when [customChild] is submitted.
    /// By default, it will use `Colors.transparent`.
    this.focusColor = Colors.transparent,

    /// [splashColor] is the splash color of the input. Only will affect when [customChild] is submitted.
    /// By default, it will use `Colors.transparent`.
    this.splashColor = Colors.transparent,

    /// [highlightColor] is the highlight color of the input. Only will affect when [customChild] is submitted.
    /// By default, it will use `Colors.transparent`.
    this.highlightColor = Colors.transparent,

    /// [borderRadius] is the border radius of the input. Only will affect when [customChild] is submitted.
    /// By default, it will use `BorderRadius.circular(10)`.
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedMonthRangePicker> createState() => _ThemedMonthRangePickerState();
}

class _ThemedMonthRangePickerState extends State<ThemedMonthRangePicker> {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);
  late int _focusYear;
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get primaryColor => isDark ? Colors.white : Theme.of(context).primaryColor;

  String? get _parsedName {
    if (widget.value.isEmpty) {
      return null;
    }

    final sortedValues = List<ThemedMonth>.from(widget.value)..sort(_sortMonths);

    return sortedValues.map((e) {
      return "${DateTime(2023, e.month.index + 1, 1).format(pattern: '%B', i18n: i18n)} ${e.year}";
    }).join(', ');
  }

  @override
  void initState() {
    super.initState();
    _overrideFocusMonth(isInit: true);
  }

  @override
  void didUpdateWidget(ThemedMonthRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _overrideFocusMonth();
  }

  void _overrideFocusMonth({bool isInit = false}) {
    late int newYear;
    if (widget.value.isEmpty) {
      newYear = DateTime.now().year;
    } else {
      newYear = widget.value.first.year;
    }

    if (isInit || _focusYear != newYear) {
      setState(() => _focusYear = newYear);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customChild != null) {
      return InkWell(
        hoverColor: widget.hoverColor,
        focusColor: widget.focusColor,
        splashColor: widget.splashColor,
        highlightColor: widget.highlightColor,
        borderRadius: widget.borderRadius,
        onTap: widget.disabled ? null : _showPicker,
        child: widget.customChild!,
      );
    }

    return ThemedTextInput(
      value: _parsedName ?? '',
      labelText: widget.labelText,
      label: widget.label,
      placeholder: widget.placeholder,
      prefixText: widget.prefixText,
      prefixIcon: widget.prefixIcon,
      prefixWidget: widget.prefixWidget,
      onPrefixTap: widget.onPrefixTap,
      suffixIcon: MdiIcons.calendar,
      disabled: widget.disabled,
      readonly: true,
      onTap: widget.disabled ? null : _showPicker,
    );
  }

  void _showPicker() async {
    int gridSize = 4;
    double width = MediaQuery.of(context).size.width;
    if (width < kSmallGrid) {
      gridSize = 2;
    } else if (width < kMediumGrid) {
      gridSize = 3;
    } else if (width < kLargeGrid) {
      gridSize = 4;
    }

    bool isMobile = width < kSmallGrid;

    double itemHeight = 50;
    double height = itemHeight * (12 / gridSize);

    height += 80 + 60;

    List<ThemedMonth>? result = await showDialog(
      context: context,
      builder: (context) {
        List<ThemedMonth> selections = List<ThemedMonth>.from(widget.value);
        List<ThemedMonth> tempPicks = [];
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
                height: height,
                decoration: generateContainerElevation(context: context, elevation: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: widget.label ??
                              Text(
                                widget.labelText ?? '',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                        ),
                        const SizedBox(width: 10),
                        ThemedButton(
                          style: ThemedButtonStyle.fab,
                          labelText: t('layrz.monthPicker.back'),
                          color: isDark ? Colors.white : Colors.black,
                          icon: MdiIcons.chevronLeft,
                          onTap: () => setState(() => _focusYear--),
                        ),
                        Text(
                          t('layrz.monthPicker.year', {'year': _focusYear}),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        ThemedButton(
                          style: ThemedButtonStyle.fab,
                          labelText: t('layrz.monthPicker.next'),
                          color: isDark ? Colors.white : Colors.black,
                          icon: MdiIcons.chevronRight,
                          onTap: () => setState(() => _focusYear++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: ThemedGridDelegateWithFixedHeight(
                          crossAxisCount: gridSize,
                          height: itemHeight,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          BoxDecoration decoration = BoxDecoration(
                            color: _validateSelection(
                              _focusYear,
                              index,
                              selections: tempPicks.isEmpty ? selections : tempPicks,
                            )
                                ? primaryColor
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(5),
                          );

                          bool isDisabled = _validateIfIsDisabled(_focusYear, index);

                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Opacity(
                              opacity: isDisabled ? 0.5 : 1,
                              child: Container(
                                decoration: decoration,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    mouseCursor: isDisabled ||
                                            !_canRemove(
                                              _focusYear,
                                              index,
                                              selections: tempPicks.isEmpty ? selections : tempPicks,
                                            )
                                        ? SystemMouseCursors.forbidden
                                        : SystemMouseCursors.click,
                                    onTap: isDisabled ||
                                            !_canRemove(
                                              _focusYear,
                                              index,
                                              selections: tempPicks.isEmpty ? selections : tempPicks,
                                            )
                                        ? null
                                        : () {
                                            ThemedMonth itm = ThemedMonth(
                                              year: _focusYear,
                                              month: Month.values[index],
                                            );

                                            if (widget.consecutive) {
                                              if (tempPicks.isEmpty) {
                                                tempPicks.add(itm);
                                              } else {
                                                tempPicks.add(itm);
                                                tempPicks.sort(_sortMonths);
                                                selections = _generateConsecutive(tempPicks);
                                                tempPicks = [];
                                              }
                                            } else {
                                              selections = _checkSelection(itm, selections);
                                            }

                                            setState(() {});
                                          },
                                    child: Center(
                                      child: Text(
                                        DateTime(2023, index + 1, 1).format(pattern: '%B', i18n: i18n),
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: validateColor(color: decoration.color ?? Colors.white),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ThemedButton(
                          style: isMobile ? ThemedButtonStyle.filledFab : ThemedButtonStyle.filledTonal,
                          icon: MdiIcons.close,
                          color: Colors.red,
                          labelText: t('actions.cancel'),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        ThemedButton(
                          style: isMobile ? ThemedButtonStyle.filledFab : ThemedButtonStyle.filledTonal,
                          icon: MdiIcons.refresh,
                          color: Colors.orange,
                          labelText: t('actions.reset'),
                          onTap: () {
                            setState(() {
                              selections = [];
                              tempPicks = [];
                            });
                          },
                        ),
                        ThemedButton(
                          style: isMobile ? ThemedButtonStyle.filledFab : ThemedButtonStyle.filledTonal,
                          icon: MdiIcons.contentSave,
                          color: Colors.green,
                          labelText: t('actions.save'),
                          onTap: () {
                            Navigator.of(context).pop(selections);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (result != null) {
      result.sort(_sortMonths);
      widget.onChanged?.call(result);
    }
  }

  String t(String key, [Map<String, dynamic> args = const {}]) {
    String result = LayrzAppLocalizations.of(context)?.t(key, args) ?? widget.translations[key] ?? key;

    if (widget.overridesLayrzTranslations) {
      result = widget.translations[key] ?? key;
    }

    if (args.isNotEmpty) {
      args.forEach((key, value) {
        result = result.replaceAll('{$key}', value.toString());
      });
    }

    return result;
  }

  bool _validateSelection(int year, int month, {List<ThemedMonth>? selections}) {
    ThemedMonth selection = ThemedMonth(year: year, month: Month.values[month]);
    return (selections ?? widget.value).contains(selection);
  }

  bool _canRemove(int year, int month, {List<ThemedMonth>? selections}) {
    if (!widget.consecutive) return true;
    List<ThemedMonth> itms = selections ?? List<ThemedMonth>.from(widget.value);
    if (itms.isEmpty) {
      return true;
    }

    ThemedMonth selection = ThemedMonth(year: year, month: Month.values[month]);

    if (selection <= itms.first) {
      return true;
    }

    if (selection >= itms.last) {
      return true;
    }

    return false;
  }

  bool _validateIfIsDisabled(int year, int month) {
    if (!widget.consecutive && widget.disabledMonths.contains(ThemedMonth(year: year, month: Month.values[month]))) {
      return true;
    }

    if (widget.minimum != null) {
      if (widget.minimum!.year > year) {
        return true;
      } else if (widget.minimum!.year == year && widget.minimum!.month.index > month) {
        return true;
      }
    }

    if (widget.maximum != null) {
      if (widget.maximum!.year < year) {
        return true;
      } else if (widget.maximum!.year == year && widget.maximum!.month.index < month) {
        return true;
      }
    }

    return false;
  }

  List<ThemedMonth> _checkSelection(ThemedMonth item, List<ThemedMonth> selections) {
    if (selections.contains(item)) {
      selections.remove(item);
    } else {
      selections.add(item);
    }

    selections.sort(_sortMonths);

    if (widget.consecutive) {
      return _generateConsecutive(selections);
    }

    return selections;
  }

  List<ThemedMonth> _generateConsecutive(List<ThemedMonth> selections) {
    final first = selections.first;
    final last = selections.last;

    if (first == last) {
      return [first];
    }

    int yearDelta = last.year - first.year;
    if (yearDelta == 0) {
      int monthDelta = last.month.index - first.month.index;
      for (int i = 0; i < monthDelta; i++) {
        selections.add(ThemedMonth(year: first.year, month: Month.values[first.month.index + i + 1]));
      }
    } else {
      for (int i = 0; i <= yearDelta; i++) {
        final newYear = first.year + i;
        for (int j = 0; j < 12; j++) {
          final newMonth = ThemedMonth(year: newYear, month: Month.values[j]);
          if (newMonth > first && newMonth < last) {
            selections.add(newMonth);
          }
        }
      }
    }

    selections.sort(_sortMonths);
    return selections;
  }

  int _sortMonths(ThemedMonth a, ThemedMonth b) {
    return a.compareTo(b);
  }
}
