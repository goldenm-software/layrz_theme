part of '../../../inputs.dart';

class ThemedIconPicker extends StatefulWidget {
  /// [labelText] is the label text of the icon picker. Avoid submit [label] and [labelText] at the same time.
  final String? labelText;

  /// [label] is the label widget of the icon picker. Avoid submit [label] and [labelText] at the same time.
  final Widget? label;

  /// [onChanged] is the callback function when the icon picker is changed.
  final void Function(LayrzIcon)? onChanged;

  /// [value] is the value of the icon picker.
  final LayrzIcon? value;

  /// [disabled] is the disabled state of the icon picker.
  final bool disabled;

  /// [errors] is the list of errors of the icon picker.
  final List<String> errors;

  /// [hideDetails] is the state of hiding the details of the icon picker.
  final bool hideDetails;

  /// [padding] is the padding of the icon picker.
  final EdgeInsets? padding;

  /// [dense] is the state of the icon picker being dense.
  final bool dense;

  /// [isRequired] is the state of the icon picker being required.
  final bool isRequired;

  /// [focusNode] is the focus node of the icon picker.
  final FocusNode? focusNode;

  /// [translations] is the translations of the input. By default we use [LayrzAppLocalizations] for translations,
  /// but you can submit your own translations using this property. Consider when [LayrzAppLocalizations] is present,
  /// is the default value of this property.
  /// Required translations:
  /// - `actions.cancel` (Cancel)
  /// - `actions.save` (Save)
  /// - `helpers.search` (Search an emoji or group)
  final Map<String, String> translations;

  /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
  final bool overridesLayrzTranslations;

  /// [allowedIcons] is the list of allowed icons to select from.
  /// If this property is not submitted, all icons will be allowed.
  final List<LayrzIcon> allowedIcons;

  /// [customChild] is the custom child of the icon picker.
  /// If it is submitted, the icon picker will be ignored.
  final Widget? customChild;

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

  /// [ThemedIconPicker] is an icon picker input. It is a text field that opens an [OverlayEntry]
  /// with a list of icons to select from.
  const ThemedIconPicker({
    super.key,
    this.labelText,
    this.label,
    this.disabled = false,
    this.onChanged,
    this.value,
    this.errors = const [],
    this.hideDetails = false,
    this.padding,
    this.dense = false,
    this.isRequired = false,
    this.focusNode,
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
      'helpers.search': 'Search an emoji or group',
    },
    this.overridesLayrzTranslations = false,
    this.allowedIcons = const [],
    this.customChild,
    this.hoverColor = Colors.transparent,
    this.focusColor = Colors.transparent,
    this.splashColor = Colors.transparent,
    this.highlightColor = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedIconPicker> createState() => _ThemedIconPickerState();
}

class _ThemedIconPickerState extends State<ThemedIconPicker> {
  final TextEditingController _textController = TextEditingController();
  LayrzIcon? _value;

  List<LayrzIcon>? selectedGroup;
  EdgeInsets get widgetPadding => widget.padding ?? ThemedTextInput.outerPadding;
  bool get isDense => widget.dense;
  Color get color => Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor;

  final GlobalKey key = GlobalKey();

  bool get disabled => widget.disabled;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(ThemedIconPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _value = widget.value;
      _textController.text = const IconOrNullConverter().toJson(_value) ?? '';
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
      key: key,
      prefixWidget: Padding(
        padding: const EdgeInsets.all(10),
        child: ThemedAvatar(
          icon: _value?.iconData,
          size: isDense ? 20 : 30,
        ),
      ),
      suffixIcon: widget.disabled ? MdiIcons.lockOutline : MdiIcons.selectGroup,
      labelText: widget.labelText,
      label: widget.label,
      controller: _textController,
      dense: isDense,
      disabled: widget.disabled,
      value: const IconOrNullConverter().toJson(_value) ?? '',
      onTap: widget.disabled ? null : _showPicker,
      padding: widget.padding,
    );
  }

  void _showPicker() async {
    if (widget.disabled) return;
    LayrzIcon? result = await showDialog(
      context: context,
      builder: (context) {
        IconData? icon;
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
            decoration: generateContainerElevation(context: context, elevation: 3),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.labelText ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return _IconGrid(
                            selected: _value,
                            constraints: constraints,
                            onTap: (icon) {
                              setState(() {
                                _value = icon;
                                _textController.text = const IconOrNullConverter().toJson(_value) ?? '';
                              });
                              Navigator.of(context).pop(icon);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ThemedButton.cancel(
                          labelText: t('actions.cancel'),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        ThemedButton.save(
                          labelText: t('actions.save'),
                          onTap: () => Navigator.of(context).pop(icon),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _value = result;
        _textController.text = const IconOrNullConverter().toJson(_value) ?? '';
      });
      widget.onChanged?.call(result);
    }
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
}

class _IconGrid extends StatefulWidget {
  final ValueChanged<LayrzIcon>? onTap;
  final LayrzIcon? selected;
  final BoxConstraints constraints;
  final List<IconData> allowedIcons;

  const _IconGrid({
    required this.constraints,
    this.onTap,
    this.selected,
    // ignore: unused_element
    this.allowedIcons = const [],
  });

  @override
  State<_IconGrid> createState() => __IconGridState();
}

class __IconGridState extends State<_IconGrid> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get activeColor => isDark ? Colors.grey.shade800 : Colors.grey.shade200;
  String search = '';

  BoxConstraints get constraints => widget.constraints;
  double get _iconHeight => 50;

  List<LayrzIcon> _icons = [];

  List<LayrzIcon> get _filteredIcons {
    if (search.isEmpty) return _icons;

    return _icons.where((element) => element.name.toLowerCase().contains(search.toLowerCase())).toList();
  }

  void _populateIcons() {
    _icons = iconMapping.values.toList()..sort((a, b) => a.name.compareTo(b.name));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _populateIcons();
      _relocateScroll();
    });
  }

  @override
  void didUpdateWidget(_IconGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _relocateScroll();
      final eq = const ListEquality().equals;
      if (!eq(oldWidget.allowedIcons, widget.allowedIcons)) {
        _populateIcons();
      }
    });
  }

  void _relocateScroll() {
    if (widget.selected == null) return;

    final index = _icons.indexWhere((element) => element == widget.selected);
    if (index == -1) return;

    final offset = index * _iconHeight;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThemedTextInput(
          padding: EdgeInsets.zero,
          dense: true,
          labelText: i18n?.t('helpers.search') ?? 'Search an icon',
          value: search,
          onChanged: (value) => setState(() => search = value),
          prefixIcon: MdiIcons.magnify,
        ),
        if (mounted)
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _filteredIcons.length,
              itemExtent: _iconHeight,
              itemBuilder: (context, index) {
                final icon = _filteredIcons[index];
                bool isSelected = widget.selected == icon;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: isSelected ? activeColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {
                        widget.onTap?.call(icon);

                        search = '';
                        _relocateScroll();
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              icon.iconData,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              icon.name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class NamedIcon {
  final IconData icon;
  final String name;

  NamedIcon({
    required this.icon,
    required this.name,
  });
}
