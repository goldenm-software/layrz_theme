part of layrz_theme;

class ThemedButton extends StatefulWidget {
  final Widget? label;
  final String? labelText;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? color;
  final ThemedButtonStyle style;
  final bool isCooldown;
  final Duration cooldownDuration;
  final VoidCallback? onCooldownFinish;
  final String? hintText;
  final double? width;
  final bool isDisabled;
  final ThemedTooltipPosition tooltipPosition;

  /// [ThemedButton] is a widget that displays a button with a custom label.
  const ThemedButton({
    super.key,

    /// [label] and [labelText] is the label of the button. Cannot provide both.
    /// [label] is for send a custom widget and control the colors and related things.
    this.label,

    /// [labelText] is for send only the String and assume the component will adapt the colors and related
    /// things automatically.
    this.labelText,

    /// [icon] is the icon of the button, when [style] is ThemedButtonStyle.fab, will only shows the icon and use
    /// the [labelText] as tooltip.
    this.icon,

    /// [onTap] is called when the button is tapped.
    this.onTap,

    /// [isLoading] is used to show a loading indicator.
    this.isLoading = false,

    /// [color] is used to override the color of the button.
    /// By default, the color will be [defaultColor].
    this.color,

    /// [style] is the design of the button, based on Material 3 rules. For more info go to
    /// https://m3.material.io/components/all-buttons.
    this.style = ThemedButtonStyle.filledTonal,

    /// Information about of the cooldown indicator.
    /// [isCooldown] indicates to the widget when the cooldown was started.
    /// [cooldown] indicates the duration of the cooldown, by default, will use 5 seconds duration.
    /// [onCooldownFinish] will be called when the cooldown is finished.
    this.isCooldown = false,
    this.cooldownDuration = const Duration(seconds: 5),
    this.onCooldownFinish,

    /// [hintText] is the hint text of the button, will display as tooltip.
    this.hintText,

    /// [width] is the width of the button.
    this.width,

    /// [isDisabled] is used to disable the button.
    this.isDisabled = false,

    /// [tooltipPosition] is used to set the position of the tooltip.
    /// By default, will use `ThemedTooltipPosition.bottom`.
    this.tooltipPosition = ThemedTooltipPosition.bottom,
  }) : assert(label != null || labelText != null);

  @override
  State<ThemedButton> createState() => _ThemedButtonState();
}

class _ThemedButtonState extends State<ThemedButton> {
  final GlobalKey _key = GlobalKey();

  IconData? get icon => widget.icon;
  Widget? get label => widget.label;
  String? get labelText => widget.labelText;
  bool get isLoading => widget.isLoading;
  Color? get color => widget.color;
  ThemedButtonStyle get style => widget.style;
  String? get hintText => widget.hintText;
  VoidCallback? get onPressed => widget.onTap;
  bool get isDisabled => widget.isDisabled || isLoading || isCooldown;
  double? get width => widget.width;

  // Cooldown control
  bool get isCooldown => widget.isCooldown;
  Duration get cooldownDuration => widget.cooldownDuration;
  VoidCallback? get onCooldownFinish => widget.onCooldownFinish;

  bool get isFabButton => [
        ThemedButtonStyle.outlinedFab,
        ThemedButtonStyle.fab,
        ThemedButtonStyle.filledFab,
      ].contains(style);
  double get buttonSize => isFabButton ? 40 : 30;
  EdgeInsets get padding => const EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  bool isHovered = false;

  double get hoverOpacity => isHovered ? 0.3 : 0.2;
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get defaultColor => isDark ? Colors.white : Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      borderRadius: BorderRadius.circular(buttonSize),
      onTap: isDisabled ? null : onPressed,
      onHover: (value) {
        setState(() => isHovered = value);
      },
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (style) {
      case ThemedButtonStyle.filledTonal:
        return _buildFilledTonalButton();
      case ThemedButtonStyle.filled:
        return _buildFilledButton();
      case ThemedButtonStyle.elevated:
        return _buildElevatedButton();
      case ThemedButtonStyle.outlined:
        return _buildOutlinedButton();
      case ThemedButtonStyle.outlinedFab:
        return _builOutlinedFabButton();
      case ThemedButtonStyle.filledFab:
        return _builFilledFabButton();
      case ThemedButtonStyle.fab:
        return _buildFabButton();
      case ThemedButtonStyle.text:
        return _buildTextButton();
      default:
        return Text("Unsupported $style");
    }
  }

  Widget _buildFabButton() {
    Color color = this.color ?? defaultColor;

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color disabledColor = isDark ? Colors.grey.shade800 : Colors.grey.shade400;

    String message = "";

    if (labelText != null) {
      message = labelText ?? "";
    } else if (label != null) {
      if (label is Text) {
        message = (label! as Text).data ?? "";
      } else {
        message = label.toString();
      }
    }

    Color contentColor = isDisabled ? disabledColor : color;
    return ThemedTooltip(
      position: widget.tooltipPosition,
      message: message,
      child: AnimatedContainer(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        key: _key,
        duration: kHoverDuration,
        height: buttonSize,
        width: buttonSize,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isHovered ? contentColor.withOpacity(hoverOpacity) : Colors.transparent,
          borderRadius: BorderRadius.circular(buttonSize),
        ),
        child: buildLoadingOrChild(
          child: Center(
            child: Icon(
              icon ?? MdiIcons.help,
              color: contentColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _builOutlinedFabButton() {
    Color color = this.color ?? defaultColor;

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color disabledColor = isDark ? Colors.grey.shade800 : Colors.grey.shade400;

    String message = "";

    if (labelText != null) {
      message = labelText ?? "";
    } else if (label != null) {
      if (label is Text) {
        message = (label! as Text).data ?? "";
      } else {
        message = label.toString();
      }
    }

    Color contentColor = isDisabled ? disabledColor : color;
    return ThemedTooltip(
      position: widget.tooltipPosition,
      message: message,
      child: AnimatedContainer(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
        key: _key,
        duration: kHoverDuration,
        height: buttonSize,
        width: buttonSize,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isHovered ? contentColor.withOpacity(hoverOpacity) : Colors.transparent,
          border: Border.all(
            color: isDisabled ? disabledColor : contentColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(buttonSize),
        ),
        child: buildLoadingOrChild(
          child: Center(
            child: Icon(
              icon ?? MdiIcons.help,
              color: contentColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _builFilledFabButton() {
    Color color = this.color ?? defaultColor;

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color disabledColor = isDark ? Colors.grey.shade800 : Colors.grey.shade400;

    String message = "";

    if (labelText != null) {
      message = labelText ?? "";
    } else if (label != null) {
      if (label is Text) {
        message = (label! as Text).data ?? "";
      } else {
        message = label.toString();
      }
    }

    Color contentColor = isDisabled ? disabledColor : color;
    return ThemedTooltip(
      position: widget.tooltipPosition,
      message: message,
      child: AnimatedContainer(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
        key: _key,
        duration: kHoverDuration,
        height: buttonSize,
        width: buttonSize,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: contentColor.withOpacity(hoverOpacity),
          borderRadius: BorderRadius.circular(buttonSize),
        ),
        child: buildLoadingOrChild(
          child: Center(
            child: Icon(
              icon ?? MdiIcons.help,
              color: contentColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton() {
    Color color = this.color ?? defaultColor;

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color disabledColor = isDark ? Colors.grey.shade800 : Colors.grey.shade400;
    TextStyle? textButtonStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontSize: 14,
        );

    Color contentColor = isDisabled ? disabledColor : color;
    return AnimatedContainer(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      key: _key,
      duration: kHoverDuration,
      height: buttonSize,
      width: width,
      padding: padding.subtract(const EdgeInsets.symmetric(vertical: 2)),
      decoration: BoxDecoration(
        color: isHovered ? contentColor.withOpacity(hoverOpacity) : Colors.transparent,
        borderRadius: BorderRadius.circular(buttonSize),
      ),
      child: buildLoadingOrChild(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: contentColor,
                size: 14,
              ),
              const SizedBox(width: 5),
            ],
            label ??
                Text(
                  labelText ?? "",
                  style: textButtonStyle?.copyWith(
                    color: contentColor,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    Color color = this.color ?? defaultColor;

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color disabledColor = isDark ? Colors.grey.shade800 : Colors.grey.shade400;
    TextStyle? textButtonStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontSize: 14,
        );

    Color contentColor = isDisabled ? disabledColor : color;
    return AnimatedContainer(
      key: _key,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      duration: kHoverDuration,
      height: buttonSize,
      width: width,
      padding: padding.subtract(const EdgeInsets.symmetric(vertical: 2)),
      decoration: BoxDecoration(
        color: isHovered ? contentColor.withOpacity(0.3) : Colors.transparent,
        border: Border.all(
          color: isDisabled ? disabledColor : contentColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(buttonSize),
      ),
      child: buildLoadingOrChild(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: contentColor,
                size: 14,
              ),
              const SizedBox(width: 5),
            ],
            label ??
                Text(
                  labelText ?? "",
                  style: textButtonStyle?.copyWith(
                    color: contentColor,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildElevatedButton() {
    Color color = this.color ?? defaultColor;

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color disabledColor = isDark ? Colors.grey.shade800 : Colors.grey.shade400;
    TextStyle? textButtonStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontSize: 14,
        );

    Color contentColor = isDisabled ? disabledColor : color;
    return AnimatedContainer(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      key: _key,
      duration: kHoverDuration,
      height: buttonSize,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: isDisabled ? disabledColor : contentColor,
        borderRadius: BorderRadius.circular(buttonSize),
        boxShadow: [
          BoxShadow(
            color: (isDisabled ? disabledColor : contentColor).withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: buildLoadingOrChild(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: validateColor(color: contentColor),
                size: 14,
              ),
              const SizedBox(width: 5),
            ],
            label ??
                Text(
                  labelText ?? "",
                  style: textButtonStyle?.copyWith(
                    color: validateColor(color: contentColor),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilledButton() {
    Color color = this.color ?? defaultColor;

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color disabledColor = isDark ? Colors.grey.shade800 : Colors.grey.shade400;
    TextStyle? textButtonStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontSize: 14,
        );

    Color contentColor = isDisabled ? disabledColor : color;
    return AnimatedContainer(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      key: _key,
      duration: kHoverDuration,
      height: buttonSize,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: isDisabled ? disabledColor : contentColor,
        borderRadius: BorderRadius.circular(buttonSize),
      ),
      child: buildLoadingOrChild(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: validateColor(color: contentColor),
                size: 14,
              ),
              const SizedBox(width: 5),
            ],
            label ??
                Text(
                  labelText ?? "",
                  style: textButtonStyle?.copyWith(
                    color: validateColor(color: contentColor),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilledTonalButton() {
    Color color = this.color ?? defaultColor;

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color disabledColor = isDark ? Colors.grey.shade800 : Colors.grey.shade400;
    TextStyle? textButtonStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontSize: 14,
        );

    Color contentColor = isDisabled ? disabledColor : color;
    return AnimatedContainer(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      key: _key,
      duration: kHoverDuration,
      height: buttonSize,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: isDisabled ? disabledColor.withOpacity(hoverOpacity) : contentColor.withOpacity(hoverOpacity),
        borderRadius: BorderRadius.circular(buttonSize),
      ),
      child: buildLoadingOrChild(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: contentColor,
                size: 14,
              ),
              const SizedBox(width: 5),
            ],
            label ??
                Text(
                  labelText ?? "",
                  style: textButtonStyle?.copyWith(
                    color: contentColor,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget buildLoadingOrChild({required Widget child}) {
    if (isLoading || isCooldown) {
      return _buildLoadingIndicator();
    }
    return child;
  }

  Widget _buildLoadingIndicator() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color buttonColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;

    RenderBox? renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    Size? size = renderBox?.size;

    double width = (size?.width == null || size?.width == double.infinity ? buttonSize : size!.width) - 20;
    double height = (size?.height ?? buttonSize) - 10;

    if (style == ThemedButtonStyle.outlined) {
      width -= 3;
      height -= 3;
    } else if ([ThemedButtonStyle.fab, ThemedButtonStyle.outlinedFab, ThemedButtonStyle.filledFab].contains(style)) {
      width -= 8;
      height -= 8;
    }

    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: isCooldown
            ? TweenAnimationBuilder(
                duration: cooldownDuration,
                onEnd: onCooldownFinish,
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, _) {
                  int remaining = (cooldownDuration.inSeconds * (1 - value)).round() + 1;
                  return Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: height,
                          height: height,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: value,
                            color: validateColor(color: buttonColor),
                            // backgroundColor: validateColor(color: buttonColor).withOpacity(0.2),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          remaining.toString(),
                          style: TextStyle(
                            color: validateColor(color: buttonColor),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : SizedBox(
                width: height,
                height: height,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: validateColor(color: buttonColor),
                  // backgroundColor: validateColor(color: buttonColor).withOpacity(0.2),
                ),
              ),
      ),
    );
  }
}

enum ThemedButtonStyle {
  elevated,
  filled,
  filledTonal,
  outlined,
  text,
  fab,
  outlinedFab,
  filledFab,
}
