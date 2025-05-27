part of '../../../inputs.dart';

class ThemedMonthPicker extends StatefulWidget {
  /// [value] is the value of the input.
  final ThemedMonth? value;

  /// [onChanged] is the callback function when the input is changed.
  final void Function(ThemedMonth)? onChanged;

  /// [labelText] is the label text of the input. Avoid submit [label] and [labelText] at the same time.
  final String? labelText;

  /// [label] is the label widget of the input. Avoid submit [label] and [labelText] at the same time.
  final Widget? label;

  /// [placeholder] is the placeholder of the input.
  final String? placeholder;

  /// [prefixText] is the prefix text of the input.
  final String? prefixText;

  /// [prefixIcon] is the prefix icon of the input. Avoid submit [prefixIcon] and [prefixWidget] at the same time.
  final IconData? prefixIcon;

  /// [prefixWidget] is the prefix widget of the input. Avoid submit [prefixIcon] and [prefixWidget] at the same time.
  final Widget? prefixWidget;

  /// [onPrefixTap] is the callback function when the prefix is tapped.
  final VoidCallback? onPrefixTap;

  /// [customChild] is the custom child of the input.
  /// If it is submitted, the input will be ignored.
  final Widget? customChild;

  /// [disabled] is the disabled state of the input.
  final bool disabled;

  /// [translations] is the translations of the input. By default we use [LayrzAppLocalizations] for translations,
  /// but you can submit your own translations using this property. Consider when [LayrzAppLocalizations] is present,
  /// is the default value of this property.
  /// Required translations:
  /// - `actions.cancel` (Cancel)
  /// - `actions.save` (Save)
  /// - `layrz.monthPicker.year` (Year {year})
  /// - `layrz.monthPicker.back` (Previous year)
  /// - `layrz.monthPicker.next` (Next year)
  final Map<String, String> translations;

  /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
  final bool overridesLayrzTranslations;

  /// [minimum] is the minimum value of the input.
  final ThemedMonth? minimum;

  /// [maximum] is the maximum value of the input.
  final ThemedMonth? maximum;

  /// [disabledMonths] is the list of disabled months.
  final List<ThemedMonth> disabledMonths;

  /// [hoverColor] is the hover color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color hoverColor;

  /// [focusColor] is the focus color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color focusColor;

  /// [splashColor] is the splash color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color splashColor;

  /// [highlightColor] is the highlight color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color highlightColor;

  /// [borderRadius] is the border radius of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `BorderRadius.circular(10)`.
  final BorderRadius borderRadius;

  /// [errors] is the list of errors of the input.
  final List<String> errors;

  /// [hideDetails] is the state of hiding the details of the input.
  final bool hideDetails;

  /// [padding] is the padding of the input.
  final EdgeInsets? padding;

  /// [ThemedMonthPicker] is a input to select a month and year.
  const ThemedMonthPicker({
    super.key,
    this.value,
    this.onChanged,
    this.labelText,
    this.label,
    this.placeholder,
    this.prefixText,
    this.prefixIcon,
    this.prefixWidget,
    this.onPrefixTap,
    this.customChild,
    this.disabled = false,
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
      'layrz.monthPicker.year': 'Year {year}',
      'layrz.monthPicker.back': 'Previous year',
      'layrz.monthPicker.next': 'Next year',
    },
    this.overridesLayrzTranslations = false,
    this.minimum,
    this.maximum,
    this.disabledMonths = const [],
    this.hoverColor = Colors.transparent,
    this.focusColor = Colors.transparent,
    this.splashColor = Colors.transparent,
    this.highlightColor = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.errors = const [],
    this.hideDetails = false,
    this.padding,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedMonthPicker> createState() => _ThemedMonthPickerState();
}

class _ThemedMonthPickerState extends State<ThemedMonthPicker> {
  final TextEditingController _controller = TextEditingController();
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.text = _parsedName ?? '';
    });
  }

  @override
  void didUpdateWidget(ThemedMonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _overrideFocusMonth();

    if (widget.value != oldWidget.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.text = _parsedName ?? '';
      });
    }
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
      controller: _controller,
      value: _parsedName ?? '',
      labelText: widget.labelText,
      label: widget.label,
      placeholder: widget.placeholder,
      prefixText: widget.prefixText,
      prefixIcon: widget.prefixIcon,
      prefixWidget: widget.prefixWidget,
      onPrefixTap: widget.onPrefixTap,
      suffixIcon: LayrzIcons.solarOutlineCalendar,
      disabled: widget.disabled,
      readonly: true,
      onTap: widget.disabled ? null : _showPicker,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
      padding: widget.padding,
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
                          child:
                              widget.label ??
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
                          icon: LayrzIcons.solarOutlineAltArrowLeft,
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
                          icon: LayrzIcons.solarOutlineAltArrowRight,
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
                          bool isActive = _validateSelection(_focusYear, index);
                          Color backgroundColor = isActive ? primaryColor : Theme.of(context).cardColor;
                          BoxDecoration decoration = BoxDecoration(
                            color: backgroundColor.withAlpha((255 * 0.2).toInt()),
                            borderRadius: BorderRadius.circular(5),
                          );

                          Color? textColor = isActive ? backgroundColor : null;

                          bool isDisabled = _validateIfIsDisabled(_focusYear, index);

                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Opacity(
                              opacity: isDisabled ? 0.5 : 1,
                              child: Container(
                                decoration: decoration,
                                clipBehavior: Clip.antiAlias,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    mouseCursor: isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
                                    onTap: isDisabled
                                        ? null
                                        : () {
                                            Navigator.of(context).pop(
                                              ThemedMonth(
                                                year: _focusYear,
                                                month: Month.values[index],
                                              ),
                                            );
                                          },
                                    child: Center(
                                      child: Text(
                                        DateTime(2023, index + 1, 1).format(pattern: '%B', i18n: i18n),
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: textColor,
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
                        ThemedButton.cancel(
                          isMobile: isMobile,
                          labelText: t('actions.cancel'),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        ThemedButton.save(
                          isMobile: isMobile,
                          labelText: t('actions.save'),
                          onTap: () => Navigator.of(context).pop(),
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
    String result = LayrzAppLocalizations.maybeOf(context)?.t(key, args) ?? widget.translations[key] ?? key;

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
