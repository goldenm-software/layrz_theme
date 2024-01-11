part of '../buttons.dart';

class ThemedActionsButtons extends StatefulWidget {
  /// [actions] is the list of actions to be displayed.
  final List<ThemedActionButton> actions;

  /// [actionsLabel] is the label to be displayed on the button.
  final String actionsLabel;

  /// [forceMobileMode] forces the button to be displayed as a FAB.
  final bool forceMobileMode;

  /// [mobileBreakpoint] is the breakpoint to be used to determine if it's mobile or not.
  final double mobileBreakpoint;

  final Offset actionsOffset;

  /// Creates a [ThemedActionsButtons] widget. This utility is to create a list of actions to be displayed.
  /// When it's in desktop mode (Before [mobileBreakpoint] width), it will display a row of buttons.
  /// Otherwise, it will display a button with a dropdown menu.
  const ThemedActionsButtons({
    super.key,
    required this.actions,
    this.actionsLabel = "Actions",
    this.forceMobileMode = false,
    this.mobileBreakpoint = kSmallGrid,
    this.actionsOffset = Offset.zero,
  });

  @override
  State<ThemedActionsButtons> createState() => _ThemedActionsButtonsState();
}

class _ThemedActionsButtonsState extends State<ThemedActionsButtons> with SingleTickerProviderStateMixin {
  late OverlayState _overlayState;
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  final GlobalKey _key = GlobalKey();
  double get width => MediaQuery.of(context).size.width;
  bool get isMobile => width <= widget.mobileBreakpoint;
  Offset get actionsOffset => widget.actionsOffset;

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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.actions.map<Widget>((ThemedActionButton action) {
          if (action.onlyIcon) {
            return ThemedButton(
              style: ThemedButtonStyle.fab,
              icon: action.icon,
              labelText: action.labelText,
              onTap: action.onTap ?? action.onTap ?? action.onPressed,
              tooltipPosition: action.tooltipPosition,
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
              onTap: action.onTap ?? action.onTap ?? action.onPressed,
              tooltipPosition: action.tooltipPosition,
              isLoading: action.isLoading,
              cooldownDuration: action.cooldown ?? const Duration(seconds: 5),
              isCooldown: action.isCooldown,
              onCooldownFinish: action.onCooldownFinish,
            ),
          );
        }).toList(),
      ),
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

    double? right = screenSize.width - offset.dx - boxSize.width + actionsOffset.dx;
    double? left;

    if (right >= screenSize.width) {
      right = null;
      left = offset.dx + actionsOffset.dx;
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
                top: offset.dy + actionsOffset.dy,
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
                          clipBehavior: Clip.antiAlias,
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
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  _removeOverlay(callback: action.onTap ?? action.onPressed);
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
    debugPrint("Callback: $callback");
    callback?.call();
  }
}

class ThemedActionButton {
  /// [label] is the label to be displayed on the button.
  final Widget? label;

  /// [labelText] is the label to be displayed on the button.
  final String? labelText;

  /// [icon] is the icon to be displayed on the button.
  final IconData icon;

  /// [onPressed] is the callback to be called when the button is pressed.
  final VoidCallback? onPressed;

  /// [onTap] is the callback to be called when the button is tapped.
  final VoidCallback? onTap;

  /// [color] is the color to be used on the button.
  final Color? color;

  /// [onlyIcon] forces the button to be displayed as an icon.
  final bool onlyIcon;

  /// [isLoading] forces the button to be displayed as a loading button.
  final bool isLoading;

  /// [cooldown] is the cooldown duration to be used on the button.
  final Duration? cooldown;

  /// [isCooldown] forces the button to be displayed as a cooldown button.
  final bool isCooldown;

  /// [onCooldownFinish] is the callback to be called when the cooldown is finished.
  final VoidCallback? onCooldownFinish;

  /// [tooltip] is the tooltip to be displayed on the button.
  final ThemedTooltipPosition tooltipPosition;

  const ThemedActionButton({
    this.label,
    this.labelText,
    required this.icon,
    @Deprecated('Use `onTap` instead') this.onPressed,
    this.onTap,
    this.color,
    this.onlyIcon = false,
    this.isLoading = false,
    this.cooldown,
    this.isCooldown = false,
    this.onCooldownFinish,
    this.tooltipPosition = ThemedTooltipPosition.bottom,
  }) : assert(label != null || labelText != null);
}
