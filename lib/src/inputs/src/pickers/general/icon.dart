part of inputs;

class ThemedIconPicker extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final void Function(IconData)? onChanged;
  final IconData? value;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final EdgeInsets padding;
  final bool dense;
  final bool isRequired;
  final FocusNode? focusNode;
  final double? borderRadius;
  final Map<String, String> translations;
  final bool overridesLayrzTranslations;
  final List<IconData> allowedIcons;
  final Widget? customChild;

  /// [ThemedIconPicker] is an icon picker input. It is a text field that opens an [OverlayEntry]
  /// with a list of icons to select from.
  const ThemedIconPicker({
    super.key,

    /// [labelText] is the label text of the icon picker. Avoid submit [label] and [labelText] at the same time.
    this.labelText,

    /// [label] is the label widget of the icon picker. Avoid submit [label] and [labelText] at the same time.
    this.label,

    /// [onChanged] is the callback function when the icon picker is changed.
    this.disabled = false,

    /// [value] is the value of the icon picker.
    this.onChanged,

    /// [disabled] is the disabled state of the icon picker.
    this.value,

    /// [errors] is the list of errors of the icon picker.
    this.errors = const [],

    /// [hideDetails] is the state of hiding the details of the icon picker.
    this.hideDetails = false,

    /// [padding] is the padding of the icon picker.
    this.padding = const EdgeInsets.all(10),

    /// [dense] is the state of the icon picker being dense.
    this.dense = false,

    /// [isRequired] is the state of the icon picker being required.
    this.isRequired = false,

    /// [focusNode] is the focus node of the icon picker.
    this.focusNode,

    /// [borderRadius] is the border radius of the icon picker.
    this.borderRadius,

    /// [translations] is the translations of the input. By default we use [LayrzAppLocalizations] for translations,
    /// but you can submit your own translations using this property. Consider when [LayrzAppLocalizations] is present,
    /// is the default value of this property.
    /// Required translations:
    /// - `actions.cancel` (Cancel)
    /// - `actions.save` (Save)
    /// - `helpers.search` (Search an emoji or group)
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
      'helpers.search': 'Search an emoji or group',
    },

    /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
    this.overridesLayrzTranslations = false,

    /// [allowedIcons] is the list of allowed icons to select from.
    /// If this property is not submitted, all icons will be allowed.
    this.allowedIcons = const [],

    /// [customChild] is the custom child of the icon picker.
    /// If it is submitted, the icon picker will be ignored.
    this.customChild,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedIconPicker> createState() => _ThemedIconPickerState();
}

class _ThemedIconPickerState extends State<ThemedIconPicker> {
  final TextEditingController _textController = TextEditingController();
  IconData? _value;

  List<IconData>? selectedGroup;
  EdgeInsets get widgetPadding => widget.padding;
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
        onTap: widget.disabled ? null : _showPicker,
        child: widget.customChild!,
      );
    }

    return ThemedTextInput(
      key: key,
      prefixWidget: Padding(
        padding: const EdgeInsets.all(10),
        child: drawAvatar(
          context: context,
          icon: _value,
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
    );
  }

  void _showPicker() async {
    if (widget.disabled) return;
    IconData? result = await showDialog(
      context: context,
      builder: (context) {
        IconData? icon;
        String search = '';

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
                    ThemedTextInput(
                      labelText: t('helpers.search'),
                      value: search,
                      prefixIcon: MdiIcons.magnify,
                      dense: true,
                      onChanged: (value) {
                        setState(() => search = value);
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return _IconGrid(
                            iconSize: 16,
                            selected: icon,
                            constraints: constraints,
                            allowedIcons: widget.allowedIcons,
                            onTap: (newIcon) {
                              setState(() => icon = newIcon);
                              Navigator.of(context).pop(icon);
                            },
                            search: search,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ThemedButton(
                          labelText: t('actions.cancel'),
                          color: Colors.red,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        ThemedButton(
                          labelText: t('actions.save'),
                          color: Colors.green,
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
}

typedef IconDataTapCallback = void Function(IconData icon);

class _IconGrid extends StatefulWidget {
  final IconDataTapCallback? onTap;
  final String search;
  final double iconSize;
  final IconData? selected;
  final BoxConstraints constraints;
  final List<IconData> allowedIcons;

  const _IconGrid({
    required this.iconSize,
    required this.constraints,
    this.onTap,
    this.search = '',
    this.selected,
    this.allowedIcons = const [],
  });

  @override
  State<_IconGrid> createState() => __IconGridState();
}

class __IconGridState extends State<_IconGrid> {
  BoxConstraints get constraints => widget.constraints;
  int get numOfColumns => (constraints.maxWidth / (widget.iconSize * 3)).floor();
  late ScrollController _scrollController;
  List<IconData> get icons {
    if (widget.allowedIcons.isNotEmpty) return widget.allowedIcons;
    return iconMap.entries.where((entry) {
      if (widget.search.isNotEmpty) {
        return entry.key.toLowerCase().contains(widget.search.toLowerCase());
      }
      return true;
    }).map<IconData>((entry) {
      return entry.value;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _postFrameCallback();
  }

  @override
  void didUpdateWidget(_IconGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    _postFrameCallback();
  }

  void _postFrameCallback() {
    if (widget.selected != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final index = icons.indexOf(widget.selected!);
        if (index != -1) {
          final lines = (index / numOfColumns).floor();
          /*
          lines * ((widget.iconSize * scale factor of width and height of button) + padding)
          */
          _scrollController.jumpTo(lines * ((widget.iconSize * 2.5) + 10));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: numOfColumns,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        return _IconButton(
          icon: icons[index],
          iconSize: widget.iconSize,
          onTap: () => widget.onTap?.call(icons[index]),
          isSelected: widget.selected == icons[index],
        );
      },
    );
  }
}

class _IconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double iconSize;
  final bool isSelected;

  const _IconButton({
    required this.icon,
    this.onTap,
    this.iconSize = 16,
    this.isSelected = false,
  });

  @override
  State<_IconButton> createState() => __IconButtonState();
}

class __IconButtonState extends State<_IconButton> {
  bool isHover = false;
  double get iconSize => widget.iconSize;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color hoverColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    return InkWell(
      onHover: (value) => setState(() {
        isHover = value;
      }),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: kHoverDuration,
        width: iconSize * 2.5,
        height: iconSize * 2.5,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: widget.isSelected || isHover ? hoverColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Icon(
            widget.icon,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
