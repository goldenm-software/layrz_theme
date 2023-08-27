part of inputs;

class ThemedEmojiPicker extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final void Function(String)? onChanged;
  final String? value;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final EdgeInsets padding;
  final bool dense;
  final bool isRequired;
  final FocusNode? focusNode;
  final void Function()? onSubmitted;
  final bool readonly;
  final double? borderRadius;
  final int maxLines;
  final double? buttomSize;
  final List<EmojiGroup> enabledGroups;
  final Map<String, String> translations;
  final bool overridesLayrzTranslations;
  final Widget? customChild;

  /// [ThemedEmojiPicker] is a widget that allows the user to pick an emoji.
  const ThemedEmojiPicker({
    super.key,

    /// [labelText] is the label text of the input. Avoid submit [label] and [labelText] at the same time.
    this.labelText,

    /// [label] is the label widget of the input. Avoid submit [label] and [labelText] at the same time.
    this.label,

    /// [value] is the current value of the input. This value should be a base64 string or an URL.
    this.value,

    /// [onChanged] is the callback that is called when the value of the input changes.
    this.onChanged,

    /// [disabled] is a flag that indicates if the input is disabled.
    this.disabled = false,

    /// [errors] is a list of errors that will be displayed below the input.
    this.errors = const [],

    /// [hideDetails] is a flag that indicates if the errors should be displayed.
    this.hideDetails = false,

    /// [padding] is the padding of the input.
    this.padding = const EdgeInsets.all(10),

    /// [dense] is a flag that indicates if the input is dense.
    this.dense = false,

    /// [isRequired] is a flag that indicates if the input is required.
    this.isRequired = false,

    /// [focusNode] is the focus node of the input.
    this.focusNode,

    /// [onSubmitted] is the callback that is called when the user submits the input.
    this.onSubmitted,

    /// [readonly] is a flag that indicates if the input is readonly.
    this.readonly = false,

    /// [borderRadius] is the border radius of the input.
    this.borderRadius,

    /// [maxLines] is the maximum number of lines of the input.
    this.maxLines = 1,

    /// [buttomSize] is the size of the buttom.
    this.buttomSize,

    /// [enabledGroups] is a list of groups that will be enabled.
    this.enabledGroups = const [],

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

    /// [customChild] is a custom child that will be displayed instead of the default input.
    /// If this property is submitted, the input will be render as a [ThemedTextInput].
    this.customChild,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedEmojiPicker> createState() => _ThemedEmojiPickerState();
}

class _ThemedEmojiPickerState extends State<ThemedEmojiPicker> {
  late ScrollController _filtersController;
  late ScrollController _emojisController;

  EmojiGroup? selectedGroup;
  Emoji? _value;

  List<EmojiGroup?> get groups {
    if (widget.enabledGroups.isNotEmpty) {
      return widget.enabledGroups;
    }

    return EmojiGroup.values;
  }

  double get iconSize => 16;
  EdgeInsets get widgetPadding => widget.padding;
  bool get isDense => widget.dense;
  Color get color => Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor;
  final GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _filtersController = ScrollController();
    _emojisController = ScrollController();

    if (widget.value != null) {
      Emoji? emoji = Emoji.byChar(widget.value!);

      if (emoji != null) {
        _value = emoji;
        selectedGroup = emoji.emojiGroup;
      }
    }

    if (groups.isNotEmpty && selectedGroup == null) {
      selectedGroup = groups.first;
    }
  }

  @override
  void dispose() {
    _filtersController.dispose();
    _emojisController.dispose();
    super.dispose();
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
      labelText: widget.labelText,
      label: widget.label,
      suffixIcon: widget.disabled ? null : MdiIcons.emoticonOutline,
      focusNode: widget.focusNode,
      padding: widget.padding,
      dense: widget.dense,
      isRequired: widget.isRequired,
      disabled: widget.disabled,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
      value: _value?.char,
      readonly: true,
      onTap: widget.disabled ? null : _showPicker,
    );
  }

  void _showPicker() async {
    if (widget.disabled) return;

    String? result = await showDialog(
      context: context,
      builder: (context) {
        String? result = _value?.char;
        Emoji? emojiResult = _value;
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SingleChildScrollView(
                        controller: _filtersController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: groups.map((group) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: _EmojiGroupButton(
                                group: group,
                                onTap: () {
                                  setState(() => selectedGroup = group);
                                },
                                isSelected: selectedGroup == group,
                                iconSize: iconSize,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return _EmojiGrid(
                            iconSize: iconSize,
                            selected: emojiResult,
                            constraints: constraints,
                            onTap: (emoji) {
                              setState(() => result = emoji.char);
                              Navigator.of(context).pop(result);
                            },
                            group: selectedGroup,
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
                          onTap: () => Navigator.of(context).pop(result),
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
      _value = Emoji.byChar(result);
      setState(() {});
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

class _EmojiGroupButton extends StatefulWidget {
  final VoidCallback onTap;
  final EmojiGroup? group;
  final bool isSelected;
  final double iconSize;

  const _EmojiGroupButton({
    required this.onTap,
    this.group,
    this.isSelected = false,
    this.iconSize = 16,
  });

  @override
  State<_EmojiGroupButton> createState() => __EmojiGroupButtonState();
}

class __EmojiGroupButtonState extends State<_EmojiGroupButton> {
  bool isHover = false;
  double get iconSize => widget.iconSize;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color hoverColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    Widget child;

    if (widget.group == null) {
      child = Center(child: Icon(MdiIcons.infinity, size: iconSize));
    } else {
      final emojis = Emoji.byGroup(widget.group!);
      if (emojis.isEmpty) {
        child = Icon(MdiIcons.infinity, size: iconSize);
      } else {
        child = Text(emojis.first.char, style: TextStyle(fontSize: iconSize));
      }
    }
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
        child: Center(child: child),
      ),
    );
  }
}

typedef EmojiTapCallback = void Function(Emoji emoji);

class _EmojiGrid extends StatefulWidget {
  final EmojiTapCallback? onTap;
  final EmojiGroup? group;
  final String search;
  final double iconSize;
  final Emoji? selected;
  final BoxConstraints constraints;

  const _EmojiGrid({
    this.onTap,
    this.group,
    this.search = '',
    required this.iconSize,
    this.selected,
    required this.constraints,
  });

  @override
  State<_EmojiGrid> createState() => __EmojiGridState();
}

class __EmojiGridState extends State<_EmojiGrid> {
  BoxConstraints get constraints => widget.constraints;
  int get numOfColumns => (constraints.maxWidth / (widget.iconSize * 3)).floor();
  late ScrollController _scrollController;
  List<Emoji> get emojis {
    List<Emoji> emojis;
    if (widget.group == null) {
      emojis = Emoji.all();
    } else {
      emojis = Emoji.byGroup(widget.group!).toList();
    }

    if (widget.search.isNotEmpty) {
      emojis = emojis.where((emoji) => emoji.shortName.contains(widget.search)).toList();
    }

    return emojis;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _postFrameCallback();
  }

  @override
  void didUpdateWidget(_EmojiGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    _postFrameCallback();
  }

  void _postFrameCallback() {
    if (widget.selected != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final index = emojis.indexOf(widget.selected!);
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
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        return _EmojiButton(
          emoji: emojis[index],
          iconSize: widget.iconSize,
          onTap: () => widget.onTap?.call(emojis[index]),
          isSelected: widget.selected == emojis[index],
        );
      },
    );
  }
}

class _EmojiButton extends StatefulWidget {
  final Emoji emoji;
  final VoidCallback? onTap;
  final double iconSize;
  final bool isSelected;

  const _EmojiButton({
    required this.emoji,
    this.onTap,
    this.iconSize = 16,
    this.isSelected = false,
  });

  @override
  State<_EmojiButton> createState() => __EmojiButtonState();
}

class __EmojiButtonState extends State<_EmojiButton> {
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
        child: Center(child: Text(widget.emoji.char, style: TextStyle(fontSize: iconSize))),
      ),
    );
  }
}
