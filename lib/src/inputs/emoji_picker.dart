part of layrz_theme;

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
  final double? containerHeight;
  final List<EmojiGroup> enabledGroups;

  const ThemedEmojiPicker({
    super.key,
    this.labelText,
    this.label,
    this.disabled = false,
    this.onChanged,
    this.value,
    this.errors = const [],
    this.hideDetails = false,
    this.padding = const EdgeInsets.all(10),
    this.dense = false,
    this.isRequired = false,
    this.focusNode,
    this.onSubmitted,
    this.readonly = false,
    this.borderRadius,
    this.maxLines = 1,
    this.buttomSize,
    this.containerHeight,
    this.enabledGroups = const [],
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedEmojiPicker> createState() => _ThemedEmojiPickerState();
}

class _ThemedEmojiPickerState extends State<ThemedEmojiPicker> with TickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController animation;
  late OverlayState overlayState;
  OverlayEntry? overlayEntry;
  String search = '';

  EmojiGroup? selectedGroup;

  Emoji? _value;
  late ThemeData theme;
  List<EmojiGroup?> get groups {
    if (widget.enabledGroups.isNotEmpty) {
      return widget.enabledGroups;
    }

    return [null, ...EmojiGroup.values];
  }

  double get iconSize => 16;
  EdgeInsets get widgetPadding => widget.padding;
  bool get isDense => widget.dense;
  Color get color => Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor;
  final GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: kHoverDuration);
    overlayState = Overlay.of(context, rootOverlay: true);

    if (widget.value != null) {
      Emoji? emoji = Emoji.byChar(widget.value!);

      if (emoji != null) {
        _value = emoji;
        selectedGroup = emoji.emojiGroup;
      }
    }
    _controller = TextEditingController(text: _value?.char);

    if (groups.isNotEmpty && selectedGroup == null) {
      selectedGroup = groups.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedTextInput(
      key: key,
      labelText: widget.labelText,
      label: widget.label,
      suffixIcon: widget.disabled ? null : MdiIcons.selectGroup,
      onSuffixTap: widget.disabled ? null : _handleTap,
      focusNode: widget.focusNode,
      padding: widget.padding,
      dense: widget.dense,
      isRequired: widget.isRequired,
      disabled: widget.disabled,
      errors: widget.errors,
      hideDetails: widget.hideDetails,
      controller: _controller,
      readonly: true,
      onTap: widget.disabled ? null : _handleTap,
    );
  }

  void _handleTap() {
    if (widget.disabled) return;
    if (overlayEntry != null) {
      _destroyOverlay();
    } else {
      _buildOverlay();
    }
  }

  void _destroyOverlay({VoidCallback? callback}) async {
    await animation.reverse();
    overlayEntry?.remove();
    overlayEntry = null;

    callback?.call();
  }

  void _buildOverlay() {
    ScrollController filtersController;

    if (_value == null) {
      filtersController = ScrollController();
    } else {
      int index = groups.indexOf(selectedGroup);
      filtersController = ScrollController(initialScrollOffset: (index * ((iconSize * 2.5) + 10)).toDouble());
    }

    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    Size screenSize = MediaQuery.of(context).size;

    double height = widget.containerHeight ?? 300;
    double? top;
    double? bottom;

    if (screenSize.height - offset.dy > height) {
      top = offset.dy + widget.padding.top;
    } else {
      bottom = screenSize.height - offset.dy - renderBox.size.height - widget.padding.bottom;
    }
    if (height > 300) {
      height = 300;
    }

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(child: GestureDetector(onTap: _destroyOverlay)),
              Positioned(
                top: top,
                bottom: bottom,
                left: offset.dx + widget.padding.left,
                right: screenSize.width - (offset.dx + renderBox.size.width - widget.padding.right),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeTransition(
                      opacity: animation,
                      child: StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return Container(
                            width: double.infinity,
                            constraints: BoxConstraints(maxHeight: height),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ThemedTextInput(
                                  labelText: i18n?.t('helpers.search') ?? 'Search',
                                  value: search,
                                  prefixIcon: MdiIcons.magnify,
                                  dense: true,
                                  onChanged: (value) {
                                    setState(() => search = value);
                                  },
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: SingleChildScrollView(
                                    controller: filtersController,
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(),
                                ),
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      return _EmojiGrid(
                                        iconSize: iconSize,
                                        selected: _value,
                                        constraints: constraints,
                                        onTap: (emoji) {
                                          _destroyOverlay.call(callback: () {
                                            widget.onChanged?.call(emoji.char);
                                            _controller.text = emoji.char;
                                            _value = emoji;
                                            setState(() {});
                                          });
                                        },
                                        group: selectedGroup,
                                        search: search,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(overlayEntry!);
    animation.forward();
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
    return GridView.count(
      controller: _scrollController,
      crossAxisCount: numOfColumns,
      childAspectRatio: 1,
      children: emojis.map((emoji) {
        return _EmojiButton(
          emoji: emoji,
          iconSize: widget.iconSize,
          onTap: () => widget.onTap?.call(emoji),
          isSelected: widget.selected == emoji,
        );
      }).toList(),
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
