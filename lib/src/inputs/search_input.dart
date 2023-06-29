part of layrz_theme;

typedef OnSearch = void Function(String value);

class ThemedSearchInput extends StatefulWidget {
  final String value;
  final OnSearch onSearch;
  final double maxWidth;
  final String labelText;
  const ThemedSearchInput({
    super.key,
    required this.value,
    required this.onSearch,
    this.maxWidth = 300,
    this.labelText = 'Search',
  });

  @override
  State<ThemedSearchInput> createState() => _ThemedSearchInputState();
}

class _ThemedSearchInputState extends State<ThemedSearchInput> with TickerProviderStateMixin {
  late AnimationController animation;
  OverlayEntry? overlay;
  final GlobalKey _key = GlobalKey();
  bool isHovering = false;

  double get height => 40;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: kHoverDuration);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      key: _key,
      onTap: handleTap,
      onHover: (value) {
        setState(() => isHovering = value);
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: kHoverDuration,
        width: height,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Icon(
            MdiIcons.magnify,
            size: 15,
            color: isDark ? Colors.grey.shade300 : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  void handleTap() {
    if (overlay == null) {
      _buildOverlay();
    } else {
      _destroyOverlay();
    }
  }

  void _buildOverlay() {
    TextEditingController controller = TextEditingController(text: widget.value);
    RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero);
    double screenWidth = MediaQuery.of(context).size.width;
    double widgetWidth = widget.maxWidth;
    double rightOffset = 0;

    if (screenWidth <= widget.maxWidth) {
      rightOffset = screenWidth - offset.dy;
      widgetWidth = screenWidth - offset.dy;
    }

    double? left;
    double? right;

    if ((offset.dx + widgetWidth + rightOffset) <= screenWidth) {
      left = offset.dx;
    } else {
      right = screenWidth - offset.dx - box.size.width;
    }

    overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(child: GestureDetector(onTap: _destroyOverlay)),
              Positioned(
                top: offset.dy,
                left: left,
                right: right,
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: Tween<double>(begin: 0, end: 1).animate(animation),
                      alignment: left == null ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        height: height,
                        width: widgetWidth,
                        decoration: generateContainerElevation(context: context),
                        child: TextField(
                          controller: controller,
                          onChanged: widget.onSearch,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            hintText: widget.labelText,
                            labelStyle: Theme.of(context).textTheme.labelSmall,
                            prefixIcon: Icon(MdiIcons.magnify),
                            filled: true,
                            isDense: true,
                          ),
                          onSubmitted: (value) {
                            widget.onSearch.call(value);
                            _destroyOverlay();
                          },
                        ),
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

    Overlay.of(context, rootOverlay: true).insert(overlay!);
    animation.forward();
  }

  void _destroyOverlay() async {
    await animation.reverse();
    overlay?.remove();
    overlay = null;
  }
}
