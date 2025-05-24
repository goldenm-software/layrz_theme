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

  /// [actionsOffset] is the offset to be used to display the actions.
  final Offset actionsOffset;

  /// [actionPadding] defines the padding to be used on the buttons.
  final EdgeInsetsGeometry actionPadding;

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
    this.actionPadding = const EdgeInsets.only(left: 5),
  });

  @override
  State<ThemedActionsButtons> createState() => _ThemedActionsButtonsState();
}

class _ThemedActionsButtonsState extends State<ThemedActionsButtons> with SingleTickerProviderStateMixin {
  late OverlayState _overlayState;
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  final GlobalKey _key = GlobalKey();
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  double get width => MediaQuery.sizeOf(context).width;
  bool get isMobile => width <= widget.mobileBreakpoint;

  Offset get actionsOffset => widget.actionsOffset;

  double get _itemHeight => 40;
  double get _overlayHeight => widget.actions.length * _itemHeight;

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
        icon: LayrzIcons.solarOutlineMenuDots,
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
          return Padding(
            padding: widget.actionPadding,
            child: ThemedButton(
              style: action.onlyIcon ? ThemedButtonStyle.filledTonalFab : ThemedButtonStyle.filledTonal,
              icon: action.icon,
              label: action.label,
              labelText: action.labelText,
              color: action.color,
              onTap: action.onTap,
              tooltipPosition: action.tooltipPosition,
              isLoading: action.isLoading,
              cooldownDuration: action.cooldown ?? const Duration(seconds: 5),
              isCooldown: action.isCooldown,
              onCooldownFinish: action.onCooldownFinish,
              isDisabled: action.isDisabled,
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

    double width = this.width * 0.5;
    if (width > 400) width = 400;

    if (this.width < kExtraSmallGrid) {
      width = this.width - 20;
    }

    double? right = screenSize.width - offset.dx - boxSize.width + actionsOffset.dx;
    double? left;

    double? top = offset.dy + actionsOffset.dy;
    double? bottom;

    if (right >= screenSize.width) {
      right = null;
      left = offset.dx + actionsOffset.dx;
    }

    if ((top + _overlayHeight + 20) >= screenSize.height) {
      top = null;
      bottom = screenSize.height - offset.dy - boxSize.height + actionsOffset.dy;
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
                top: top,
                bottom: bottom,
                right: right,
                left: left,
                child: SizedBox(
                  width: width,
                  height: _overlayHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1).animate(_animationController),
                        child: Container(
                          decoration: generateContainerElevation(context: context, elevation: 2),
                          clipBehavior: Clip.antiAlias,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: kListViewPadding,
                            itemCount: widget.actions.length,
                            itemExtent: _itemHeight,
                            itemBuilder: (context, index) {
                              ThemedActionButton action = widget.actions[index];
                              Color color = action.color ?? (isDark ? Colors.white : Colors.black);
                              if (action.isDisabled) {
                                color = ThemedButton.getDisabledColor(isDark, ThemedButtonStyle.filledTonal);
                              }

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: action.isDisabled ? null : () => _removeOverlay(callback: action.onTap),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          action.icon,
                                          color: color,
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
                                              color: color,
                                              overflow: TextOverflow.fade,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
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
  /// [label] is the label to be displayed on the button.
  final Widget? label;

  /// [labelText] is the label to be displayed on the button.
  final String? labelText;

  /// [icon] is the icon to be displayed on the button.
  final IconData icon;

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

  /// [isDisabled] forces the button to be displayed as disabled.
  final bool isDisabled;

  const ThemedActionButton({
    this.label,
    this.labelText,
    required this.icon,
    this.onTap,
    this.color,
    this.onlyIcon = false,
    this.isLoading = false,
    this.cooldown,
    this.isCooldown = false,
    this.onCooldownFinish,
    this.tooltipPosition = ThemedTooltipPosition.bottom,
    this.isDisabled = false,
  }) : assert(label != null || labelText != null);

  factory ThemedActionButton.save({
    bool isMobile = false,
    required VoidCallback onTap,
    required String labelText,
    bool isLoading = false,
    bool isDisabled = false,
    bool isCooldown = false,
    VoidCallback? onCooldownFinish,
    ThemedTooltipPosition tooltipPosition = ThemedTooltipPosition.bottom,
  }) {
    return ThemedActionButton(
      tooltipPosition: tooltipPosition,
      onlyIcon: isMobile,
      labelText: labelText,
      onTap: onTap,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isCooldown: isCooldown,
      onCooldownFinish: onCooldownFinish,
      icon: LayrzIcons.solarOutlineInboxIn,
      color: Colors.green,
    );
  }

  factory ThemedActionButton.cancel({
    bool isMobile = false,
    required VoidCallback onTap,
    required String labelText,
    bool isLoading = false,
    bool isDisabled = false,
    bool isCooldown = false,
    VoidCallback? onCooldownFinish,
    ThemedTooltipPosition tooltipPosition = ThemedTooltipPosition.bottom,
  }) {
    return ThemedActionButton(
      tooltipPosition: tooltipPosition,
      labelText: labelText,
      onTap: onTap,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isCooldown: isCooldown,
      onCooldownFinish: onCooldownFinish,
      icon: LayrzIcons.solarOutlineCloseSquare,
      onlyIcon: isMobile,
      color: Colors.red,
    );
  }

  factory ThemedActionButton.info({
    bool isMobile = false,
    required VoidCallback onTap,
    required String labelText,
    bool isLoading = false,
    bool isDisabled = false,
    bool isCooldown = false,
    VoidCallback? onCooldownFinish,
    ThemedTooltipPosition tooltipPosition = ThemedTooltipPosition.bottom,
  }) {
    return ThemedActionButton(
      tooltipPosition: tooltipPosition,
      labelText: labelText,
      onTap: onTap,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isCooldown: isCooldown,
      onCooldownFinish: onCooldownFinish,
      icon: LayrzIcons.solarOutlineInfoSquare,
      onlyIcon: isMobile,
      color: Colors.blue,
    );
  }

  factory ThemedActionButton.show({
    bool isMobile = false,
    required VoidCallback onTap,
    required String labelText,
    bool isLoading = false,
    bool isDisabled = false,
    bool isCooldown = false,
    VoidCallback? onCooldownFinish,
    ThemedTooltipPosition tooltipPosition = ThemedTooltipPosition.bottom,
  }) {
    return ThemedActionButton(
      tooltipPosition: tooltipPosition,
      labelText: labelText,
      onTap: onTap,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isCooldown: isCooldown,
      onCooldownFinish: onCooldownFinish,
      icon: LayrzIcons.solarOutlineEyeScan,
      onlyIcon: isMobile,
      color: Colors.blue,
    );
  }

  factory ThemedActionButton.edit({
    bool isMobile = false,
    required VoidCallback onTap,
    required String labelText,
    bool isLoading = false,
    bool isDisabled = false,
    bool isCooldown = false,
    VoidCallback? onCooldownFinish,
    ThemedTooltipPosition tooltipPosition = ThemedTooltipPosition.bottom,
  }) {
    return ThemedActionButton(
      tooltipPosition: tooltipPosition,
      labelText: labelText,
      onTap: onTap,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isCooldown: isCooldown,
      onCooldownFinish: onCooldownFinish,
      icon: LayrzIcons.solarOutlinePenNewSquare,
      onlyIcon: isMobile,
      color: Colors.orange,
    );
  }

  factory ThemedActionButton.delete({
    bool isMobile = false,
    required VoidCallback onTap,
    required String labelText,
    bool isLoading = false,
    bool isDisabled = false,
    bool isCooldown = false,
    VoidCallback? onCooldownFinish,
    ThemedTooltipPosition tooltipPosition = ThemedTooltipPosition.bottom,
  }) {
    return ThemedActionButton(
      tooltipPosition: tooltipPosition,
      labelText: labelText,
      onTap: onTap,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isCooldown: isCooldown,
      onCooldownFinish: onCooldownFinish,
      icon: LayrzIcons.solarOutlineTrashBinMinimalistic2,
      onlyIcon: isMobile,
      color: Colors.red,
    );
  }
}
