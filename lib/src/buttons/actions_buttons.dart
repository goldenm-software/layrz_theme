part of layrz_theme;

class ThemedActionsButtons extends StatefulWidget {
  final List<ThemedActionButton> actions;
  final String actionsLabel;
  final bool forceMobileMode;
  const ThemedActionsButtons({
    super.key,
    required this.actions,
    this.actionsLabel = "Actions",
    this.forceMobileMode = false,
  });

  @override
  State<ThemedActionsButtons> createState() => _ThemedActionsButtonsState();
}

class _ThemedActionsButtonsState extends State<ThemedActionsButtons> with SingleTickerProviderStateMixin {
  late OverlayState _overlayState;
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _overlayState = Overlay.of(context);
    _animationController = AnimationController(vsync: this, duration: kHoverDuration);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width <= kSmallGrid;

    if (widget.actions.isEmpty) {
      return const SizedBox();
    }

    if (isMobile || widget.forceMobileMode) {
      return ThemedButton(
        key: _key,
        icon: MdiIcons.dotsVertical,
        labelText: widget.actionsLabel,
        style: ThemedButtonStyle.fab,
        color: Colors.grey.shade500,
        onTap: _handleTap,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widget.actions.map<Widget>((ThemedActionButton action) {
        if (action.onlyIcon) {
          return ThemedButton(
            style: ThemedButtonStyle.fab,
            icon: action.icon,
            labelText: action.labelText,
            onTap: action.onPressed,
            isLoading: action.isLoading,
            color: action.color,
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ThemedButton(
            style: ThemedButtonStyle.filledTonal,
            icon: action.icon,
            label: action.label,
            labelText: action.labelText,
            color: action.color,
            onTap: action.onPressed,
            isLoading: action.isLoading,
            cooldownDuration: action.cooldown ?? const Duration(seconds: 5),
            isCooldown: action.isCooldown,
            onCooldownFinish: action.onCooldownFinish,
          ),
        );
      }).toList(),
    );
  }

  void _handleTap() {
    if (_overlayEntry == null) {
      _buildOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _buildOverlay() {
    RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero);
    Size boxSize = box.size;
    Size screenSize = MediaQuery.of(context).size;

    double width = 150;

    double? right = screenSize.width - offset.dx - boxSize.width;
    double? left;

    if (right >= screenSize.width) {
      right = null;
      left = offset.dx;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(onTap: _removeOverlay),
              ),
              Positioned(
                top: offset.dy,
                right: right,
                left: left,
                child: SizedBox(
                  width: width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1).animate(_animationController),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: boxSize.height,
                            maxHeight: 300,
                          ),
                          decoration: generateContainerElevation(context: context, elevation: 2),
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: widget.actions.length,
                            separatorBuilder: (context, index) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Divider(),
                            ),
                            itemBuilder: (context, index) {
                              ThemedActionButton action = widget.actions[index];
                              return InkWell(
                                onTap: () {
                                  _removeOverlay(callback: action.onPressed);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        action.icon,
                                        color: action.color,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 5),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: width - 44,
                                        ),
                                        child: Text(
                                          action.labelText ?? "",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: action.color,
                                                overflow: TextOverflow.fade,
                                              ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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

    _overlayState.insert(_overlayEntry!);
    _animationController.forward();
  }

  void _removeOverlay({VoidCallback? callback}) async {
    await _animationController.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
    callback?.call();
  }
}

class ThemedActionButton {
  final Widget? label;
  final String? labelText;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final bool onlyIcon;
  final bool isLoading;
  final Duration? cooldown;
  final bool isCooldown;
  final VoidCallback? onCooldownFinish;

  const ThemedActionButton({
    this.label,
    this.labelText,
    required this.icon,
    required this.onPressed,
    this.color = kPrimaryColor,
    this.onlyIcon = false,
    this.isLoading = false,
    this.cooldown,
    this.isCooldown = false,
    this.onCooldownFinish,
  }) : assert(label != null || labelText != null);
}
