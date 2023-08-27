part of inputs;

class ThemedMonthPicker extends StatefulWidget {
  final ThemedMonth? value;
  final void Function(ThemedMonth)? onChanged;
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

  /// [ThemedMonthPicker] is a input to select a month and year.
  const ThemedMonthPicker({
    super.key,

    /// [value] is the value of the input.
    this.value,

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
    /// - `layrz.monthPicker.year` (Year {year})
    /// - `layrz.monthPicker.back` (Previous year)
    /// - `layrz.monthPicker.next` (Next year)
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
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
  State<ThemedMonthPicker> createState() => _ThemedMonthPickerState();
}

class _ThemedMonthPickerState extends State<ThemedMonthPicker> {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);
  late int _focusYear;
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get primaryColor => isDark ? Colors.white : Theme.of(context).primaryColor;

  String? get _parsedName {
    if (widget.value == null) {
      return null;
    }

    return '${DateTime(2023, widget.value!.month.index + 1, 1).format(pattern: '%B', i18n: i18n)} '
        '${widget.value!.year}';
  }

  @override
  void initState() {
    super.initState();
    _overrideFocusMonth(isInit: true);
  }

  @override
  void didUpdateWidget(ThemedMonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _overrideFocusMonth();
  }

  void _overrideFocusMonth({bool isInit = false}) {
    late int newYear;
    if (widget.value != null) {
      newYear = widget.value!.year;
    } else {
      newYear = DateTime.now().year;
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

    ThemedMonth? result = await showDialog(
      context: context,
      builder: (context) {
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
                            color: _validateSelection(_focusYear, index) ? primaryColor : Theme.of(context).cardColor,
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
                                    mouseCursor: isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
                                    onTap: isDisabled
                                        ? null
                                        : () {
                                            Navigator.of(context).pop(ThemedMonth(
                                              year: _focusYear,
                                              month: Month.values[index],
                                            ));
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
                        const Spacer(),
                        ThemedButton(
                          style: isMobile ? ThemedButtonStyle.filledFab : ThemedButtonStyle.filledTonal,
                          icon: MdiIcons.contentSave,
                          color: Colors.green,
                          labelText: t('actions.save'),
                          onTap: () {
                            Navigator.of(context).pop();
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

    if (result != null) widget.onChanged?.call(result);
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

  bool _validateSelection(int year, int month) {
    if (widget.value == null) {
      return false;
    }

    return widget.value!.year == year && widget.value!.month.index == month;
  }

  bool _validateIfIsDisabled(int year, int month) {
    if (widget.disabledMonths.contains(ThemedMonth(year: year, month: Month.values[month]))) {
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
}

enum Month {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december,
}

class ThemedMonth {
  final Month month;
  final int year;

  /// [ThemedMonth] is a definition of the month and year combined.
  const ThemedMonth({
    /// [month] is the month of the date. It is a number between 0 and 11.
    required this.month,

    /// [year] is the year of the date. It is a number greater than 0.
    required this.year,
  }) : assert(year >= 0);

  @override
  String toString() {
    return '$year-$month';
  }

  // Override comparison operators to allow sorting
  @override
  bool operator ==(Object other) {
    if (other is ThemedMonth) {
      return month.index == other.month.index && year == other.year;
    }

    return false;
  }

  bool operator <(Object other) {
    if (other is ThemedMonth) {
      if (year < other.year) {
        return true;
      } else if (year == other.year) {
        return month.index < other.month.index;
      }
    }

    return false;
  }

  bool operator >(Object other) {
    if (other is ThemedMonth) {
      if (year > other.year) {
        return true;
      } else if (year == other.year) {
        return month.index > other.month.index;
      }
    }

    return false;
  }

  bool operator <=(Object other) {
    if (other is ThemedMonth) {
      if (year < other.year) {
        return true;
      } else if (year == other.year) {
        return month.index <= other.month.index;
      }
    }

    return false;
  }

  bool operator >=(Object other) {
    if (other is ThemedMonth) {
      if (year > other.year) {
        return true;
      } else if (year == other.year) {
        return month.index >= other.month.index;
      }
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(month.index, year);

  int compareTo(ThemedMonth other) {
    if (year == other.year) {
      return month.index.compareTo(other.month.index);
    }

    return year.compareTo(other.year);
  }
}
