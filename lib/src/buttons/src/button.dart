part of '../buttons.dart';

class ThemedButton extends StatefulWidget {
  /// [defaultHeight] is used to know the default height of the button.
  static const double defaultHeight = 35.0;

  /// [label] and [labelText] is the label of the button. Cannot provide both.
  ///
  /// [label] is for send a custom widget and control the colors and related things.
  ///
  /// Avoid using [label] and [labelText] at the same time. We will prefer [label] over [labelText].
  final Widget? label;

  /// [labelText] is for send only the String and assume the component will adapt the colors and related
  /// things automatically.
  ///
  /// Of the style of the label, we use the [ThemeData.textTheme.bodySmall] as base and changes
  /// the [fontSize] to `13`.
  ///
  /// Avoid using [label] and [labelText] at the same time. We will prefer [label] over [labelText].
  final String? labelText;

  /// [icon] is the icon of the button, when [style] is any FAB style, will only shows the icon and use
  /// the [labelText] as tooltip. In case that you use [label] instead of [labelText], the tooltip will
  /// be the content of the [label].
  ///
  /// FAB styles are:
  /// - [ThemedButtonStyle.fab]
  /// - [ThemedButtonStyle.outlinedFab]
  /// - [ThemedButtonStyle.filledFab]
  /// - [ThemedButtonStyle.filledTonalFab]
  /// - [ThemedButtonStyle.elevatedFab]
  final IconData? icon;

  /// [onTap] is called when the button is tapped.
  final VoidCallback? onTap;

  /// [isLoading] is used to show a loading indicator.
  final bool isLoading;

  /// [color] is used to override the color of the button.
  /// By default, the color will be `Theme.of(context).primaryColor`.
  final Color? color;

  /// [style] is the design of the button, based on Material 3 rules. For more info go to
  /// https://m3.material.io/components/all-buttons.
  final ThemedButtonStyle style;

  /// Information about of the cooldown indicator.
  /// [isCooldown] indicates to the widget when the cooldown was started.
  /// [cooldown] indicates the duration of the cooldown, by default, will use 5 seconds duration.
  /// [onCooldownFinish] will be called when the cooldown is finished.
  final bool isCooldown;

  /// [hintText] is the hint text of the button, will display as tooltip.
  /// This property only will appear when the button is style as any non-FAB style
  /// ([ThemedButtonStyle.text], [ThemedButtonStyle.outlined], [ThemedButtonStyle.filled],
  /// [ThemedButtonStyle.filledTonal] or [ThemedButtonStyle.elevated]).
  final String? hintText;

  /// [width] is the width of the button. If this property is null, the width will be calculated
  /// based on the content of the button.
  final double? width;

  /// [isDisabled] is used to disable the button.
  final bool isDisabled;

  /// [cooldownDuration] is used to set the duration of the cooldown.
  final Duration cooldownDuration;

  /// [onCooldownFinish] will be called when the cooldown is finished.
  /// Take care about this callback, because it will be called every time when the cooldown is finished.
  /// To prevent excesive `setState` or something like that in your app, we recommend to use this callback
  /// in one of the buttons presents in the screen.
  final VoidCallback? onCooldownFinish;

  /// [tooltipPosition] is used to set the position of the tooltip.
  /// By default, will use `ThemedTooltipPosition.bottom`.
  final ThemedTooltipPosition tooltipPosition;

  /// [fontSize] is used to set the font size of the label.
  /// By default, will use `13`.
  final double fontSize;

  /// [tooltipEnabled] is used to enable/disable the tooltip.
  /// By default, will use `true`.
  final bool tooltipEnabled;

  /// [showCooldownRemainingDuration] if false the text counting down the cooldown will not be shown.
  final bool showCooldownRemainingDuration;

  /// [height] is used to override the height of the button.
  /// and replace the ThemedButton.height value used by default.
  /// height 35. Using [defaultHeight]
  final double height;

  /// [ThemedButton] is a widget that displays a button with a custom label.
  const ThemedButton({
    super.key,
    this.label,
    this.labelText,
    this.icon,
    this.onTap,
    this.isLoading = false,
    this.color,
    this.style = ThemedButtonStyle.filledTonal,
    this.isCooldown = false,
    this.cooldownDuration = const Duration(seconds: 5),
    this.onCooldownFinish,
    this.hintText,
    this.width,
    this.isDisabled = false,
    this.tooltipPosition = ThemedTooltipPosition.bottom,
    this.fontSize = 13,
    this.tooltipEnabled = true,
    this.showCooldownRemainingDuration = true,
    this.height = defaultHeight,
  })  : assert(label != null || labelText != null),
        assert(height >= 25);

  factory ThemedButton.save({
    bool isMobile = false,
    required VoidCallback onTap,
    required String labelText,
    bool isLoading = false,
    bool isDisabled = false,
    bool isCooldown = false,
    VoidCallback? onCooldownFinish,
  }) {
    return ThemedButton(
      labelText: labelText,
      onTap: onTap,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isCooldown: isCooldown,
      onCooldownFinish: onCooldownFinish,
      icon: LayrzIcons.solarOutlineInboxIn,
      style: isMobile ? ThemedButtonStyle.filledTonalFab : ThemedButtonStyle.filledTonal,
      color: Colors.green,
    );
  }

  factory ThemedButton.cancel({
    bool isMobile = false,
    required VoidCallback onTap,
    required String labelText,
    bool isLoading = false,
    bool isDisabled = false,
    bool isCooldown = false,
    VoidCallback? onCooldownFinish,
  }) {
    return ThemedButton(
      labelText: labelText,
      onTap: onTap,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isCooldown: isCooldown,
      onCooldownFinish: onCooldownFinish,
      icon: LayrzIcons.solarOutlineCloseSquare,
      style: isMobile ? ThemedButtonStyle.fab : ThemedButtonStyle.text,
      color: Colors.red,
    );
  }

  factory ThemedButton.info({
    bool isMobile = false,
    required VoidCallback onTap,
    required String labelText,
    bool isLoading = false,
    bool isDisabled = false,
    bool isCooldown = false,
    VoidCallback? onCooldownFinish,
  }) {
    return ThemedButton(
      labelText: labelText,
      onTap: onTap,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isCooldown: isCooldown,
      onCooldownFinish: onCooldownFinish,
      icon: LayrzIcons.solarOutlineInfoSquare,
      style: isMobile ? ThemedButtonStyle.filledTonalFab : ThemedButtonStyle.filledTonal,
      color: Colors.blue,
    );
  }

  factory ThemedButton.show({
    bool isMobile = false,
    required VoidCallback onTap,
    required String labelText,
    bool isLoading = false,
    bool isDisabled = false,
    bool isCooldown = false,
    VoidCallback? onCooldownFinish,
  }) {
    return ThemedButton(
      labelText: labelText,
      onTap: onTap,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isCooldown: isCooldown,
      onCooldownFinish: onCooldownFinish,
      icon: LayrzIcons.solarOutlineEyeScan,
      style: isMobile ? ThemedButtonStyle.filledTonalFab : ThemedButtonStyle.filledTonal,
      color: Colors.blue,
    );
  }

  factory ThemedButton.edit({
    bool isMobile = false,
    required VoidCallback onTap,
    required String labelText,
    bool isLoading = false,
    bool isDisabled = false,
    bool isCooldown = false,
    VoidCallback? onCooldownFinish,
  }) {
    return ThemedButton(
      labelText: labelText,
      onTap: onTap,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isCooldown: isCooldown,
      onCooldownFinish: onCooldownFinish,
      icon: LayrzIcons.solarOutlinePenNewSquare,
      style: isMobile ? ThemedButtonStyle.filledTonalFab : ThemedButtonStyle.filledTonal,
      color: Colors.orange,
    );
  }

  factory ThemedButton.delete({
    bool isMobile = false,
    required VoidCallback onTap,
    required String labelText,
    bool isLoading = false,
    bool isDisabled = false,
    bool isCooldown = false,
    VoidCallback? onCooldownFinish,
  }) {
    return ThemedButton(
      labelText: labelText,
      onTap: onTap,
      isLoading: isLoading,
      isDisabled: isDisabled,
      isCooldown: isCooldown,
      onCooldownFinish: onCooldownFinish,
      icon: LayrzIcons.solarOutlineTrashBinMinimalistic2,
      style: isMobile ? ThemedButtonStyle.filledTonalFab : ThemedButtonStyle.filledTonal,
      color: Colors.red,
    );
  }

  @override
  State<ThemedButton> createState() => _ThemedButtonState();

  /// [height] is used to know the height of the button.
  // static double get height => 35;

  /// [disabledColor] is used to know the color of the disabled button.
  static Color getDisabledColor(bool isDark, ThemedButtonStyle style) {
    if ([
      ThemedButtonStyle.filledTonal,
      ThemedButtonStyle.filledTonalFab,
      ThemedButtonStyle.text,
      ThemedButtonStyle.fab,
      ThemedButtonStyle.outlined,
      ThemedButtonStyle.outlinedFab,
      ThemedButtonStyle.outlinedTonal,
      ThemedButtonStyle.outlinedTonalFab,
    ].contains(style)) {
      return isDark ? Colors.grey.shade600 : Colors.grey.shade500;
    }
    return isDark ? Colors.grey.shade800 : Colors.grey.shade200;
  }
}

class _ThemedButtonState extends State<ThemedButton> {
  /// [icon] is the icon of the button, when [style] is ThemedButtonStyle.fab, will only shows the icon and use
  /// the [labelText] as tooltip.
  /// Otherwise, the icon will be displayed at the left of the label.
  /// It's a shortcut to [widget.icon].
  IconData? get icon => widget.icon;

  /// [label] of the button.
  /// It's a shortcut to [widget.label].
  Widget? get label => widget.label;

  /// [labelText] of the button.
  /// It's a shortcut to [widget.labelText].
  String? get labelText => widget.labelText;

  /// [isLoading] is used to show a loading indicator.
  /// It's a shortcut to [widget.isLoading].
  bool get isLoading => widget.isLoading;

  /// [hintText] is the hint text of the button, will display as tooltip.
  String? get hintText => widget.hintText;

  /// [isDisabled] is used to disable the button.
  /// It's an or condition between [widget.isDisabled], [isLoading] and [isCooldown].
  bool get isDisabled => widget.isDisabled || isLoading || isCooldown;

  /// [isCooldown] is used to know if the button is on cooldown.
  /// It's a shortcut to [widget.isCooldown].
  bool get isCooldown => widget.isCooldown;

  /// [cooldownDuration] is used to set the duration of the cooldown.
  /// It's a shortcut to [widget.cooldownDuration].
  Duration get cooldownDuration => widget.cooldownDuration;

  /// [onCooldownFinish] will be called when the cooldown is finished.
  /// It's a shortcut to [widget.onCooldownFinish].
  VoidCallback? get onCooldownFinish => widget.onCooldownFinish;

  /// [isDark] is used to know if the theme is dark.
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  /// [isFabButton] is used to know if the button is a FAB/icon button.
  bool get isFabButton => [
        ThemedButtonStyle.outlinedFab,
        ThemedButtonStyle.fab,
        ThemedButtonStyle.filledFab,
        ThemedButtonStyle.filledTonalFab,
        ThemedButtonStyle.elevatedFab,
        ThemedButtonStyle.outlinedTonalFab,
      ].contains(style);

  /// [onTap] is called when the button is tapped.
  /// It's a shortcut to [widget.onTap].
  VoidCallback? get onTap => widget.onTap;

  /// [style] defines the style of the button.
  /// It's a shortcut to [widget.style].
  ThemedButtonStyle get style => widget.style;

  /// [defaultPadding] defines the raw padding of the button.
  EdgeInsets get defaultPadding {
    if (isFabButton) {
      return const EdgeInsets.all(5);
    }

    return const EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  }

  /// [padding] defines the padding of the button.
  ///
  /// This padding is conditional, because when the button is in loading or cooldown state, the padding
  /// will be reduced to avoid the overflow of the loading indicator.
  EdgeInsets get padding => isLoading || isCooldown ? EdgeInsets.zero : defaultPadding;

  /// [kHoverOpacity] defines the opacity of the button when is hovered.
  double get kHoverOpacity => 0.2;

  /// [kOutlinedTonalOpacity] defines the opacity only for [ThemedButtonStyle.outlinedTonal] and
  /// [ThemedButtonStyle.outlinedTonalFab].
  double get kOutlinedTonalOpacity => 0.15;

  /// [kBorderWidth] defines the border width of the button.
  double get kBorderWidth => 1.5;

  /// [defaultColor] defines the default color of the button.
  Color get defaultColor => isDark ? Colors.white : Theme.of(context).primaryColor;

  /// [textStyle] defines the default text style of the button.
  /// This style only applies when the button uses [labelText] instead of [label].
  /// Also, the font color will change depending of the [style] of the button.
  TextStyle? get textStyle => Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: widget.fontSize,
      );

  Color get disabledColor => ThemedButton.getDisabledColor(isDark, style);

  /// [contentColor] is used to know the color of the content of the button.
  Color get contentColor => isDisabled ? disabledColor : (widget.color ?? defaultColor);

  /// [loadingColor] defines the color of the loading indicator.
  Color get loadingColor => isDark ? Colors.grey.shade500 : Colors.grey.shade400;

  /// [colorOverride] allows to set a new color when the button is loading, on cooldown or disabled.
  /// Otherwise, will return `null`.
  Color? get colorOverride => isLoading || isCooldown ? disabledColor : null;

  /// [iconSize] is used to know the size of the icon.
  /// It's always `16`.
  double get iconSize => 16;

  /// [borderRadius] is used to know the border radius of the button.
  /// It's always `10`.
  double get borderRadius => 10;

  /// [message] is used to know the message of the button.
  /// This message is only used when the button uses [label] instead of [labelText] and
  /// the [style] is [ThemedButtonStyle.fab], [ThemedButtonStyle.outlinedFab], [ThemedButtonStyle.filledFab],
  /// [ThemedButtonStyle.filledTonalFab] or [ThemedButtonStyle.elevatedFab].
  String get message {
    String msg = "";
    if (labelText != null) {
      msg = labelText ?? "";
    } else if (label != null) {
      if (label is Text) {
        msg = (label! as Text).data ?? "";
      } else {
        msg = label.toString();
      }
    }

    if (msg.isEmpty) {
      if (hintText != null) {
        msg = hintText ?? "";
      }
    } else {
      if (hintText != null) {
        msg = "$msg - $hintText";
      }
    }

    return msg;
  }

  /// [width] is used to predict the width of the button.
  /// It's important to know, when the button uses [label] instead of [labelText], the width of the button
  /// will be the [widget.width] property or `50` as a fallback.
  double get width {
    if (labelText == null) {
      return widget.width ?? 50;
    }

    if (isFabButton) {
      return height;
    }

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: labelText,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    double predicted = textPainter.width + defaultPadding.horizontal;

    if (icon != null) {
      // 5 is the space between the icon and the text
      predicted += 5;

      // 14 is the size of the icon
      predicted += iconSize;
    }

    return predicted;
  }

  /// [height] is used to set the height of the button.
  /// Defaults to `35`.
  double get height => widget.height;

  bool get showCooldownRemainingDuration => widget.showCooldownRemainingDuration;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case ThemedButtonStyle.filledTonal:
        return _handleHint(child: _buildFilledTonal());
      case ThemedButtonStyle.filledTonalFab:
        return _buildFilledTonalFab();
      case ThemedButtonStyle.text:
        return _handleHint(child: _buildText());
      case ThemedButtonStyle.fab:
        return _buildFab();
      case ThemedButtonStyle.outlined:
        return _handleHint(child: _buildOutlined());
      case ThemedButtonStyle.outlinedFab:
        return _buildOutlinedFab();
      case ThemedButtonStyle.filled:
        return _handleHint(child: _buildFilled());
      case ThemedButtonStyle.filledFab:
        return _builFilledFab();
      case ThemedButtonStyle.elevated:
        return _handleHint(child: _buildElevated());
      case ThemedButtonStyle.elevatedFab:
        return _builElevatedFab();
      case ThemedButtonStyle.outlinedTonal:
        return _handleHint(child: _buildOutlinedTonal());
      case ThemedButtonStyle.outlinedTonalFab:
        return _buildOutlinedTonalFab();
      default:
        return Text("Unsupported $style");
    }
  }

  /// [_handleHint] is used to handle the hint of the button.
  /// This hint is only used when the button is style as any non-FAB style
  Widget _handleHint({required Widget child}) {
    if (hintText == null) {
      return child;
    }

    return ThemedTooltip(
      position: widget.tooltipPosition,
      message: hintText!,
      color: contentColor,
      child: child,
    );
  }

  /// [_handleTooltip] is used to handle the tooltip of the button when the button is a FAB.
  /// This tooltip is only used when the button is style as any FAB style
  Widget _handleTooltip({required Widget child}) {
    if (!widget.tooltipEnabled) {
      return child;
    }

    return ThemedTooltip(
      position: widget.tooltipPosition,
      message: message,
      color: contentColor,
      child: child,
    );
  }

  /// [_buildFilledTonal] is used to build a filled tonal button.
  /// This button is used when the [style] is [ThemedButtonStyle.filledTonal].
  Widget _buildFilledTonal() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorOverride ?? contentColor.withOpacity(kHoverOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          child: SizedBox(
            height: height,
            width: width,
            child: Padding(
              padding: padding,
              child: _buildLoadingOrChild(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: contentColor,
                        size: iconSize,
                      ),
                      const SizedBox(width: 5),
                    ],
                    label ??
                        Text(
                          labelText ?? "",
                          style: textStyle?.copyWith(color: contentColor),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [_buildFilledTonalFab] is used to build a filled tonal FAB button.
  /// This button is used when the [style] is [ThemedButtonStyle.filledTonalFab].
  Widget _buildFilledTonalFab() {
    return _handleTooltip(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorOverride ?? contentColor.withOpacity(kHoverOpacity),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onTap,
            child: SizedBox(
              height: height,
              width: width,
              child: Padding(
                padding: padding,
                child: _buildLoadingOrChild(
                  child: Center(
                    child: Icon(
                      icon ?? LayrzIcons.mdiHelp,
                      color: contentColor,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [_buildOutlinedTonal] is used to build a filled tonal button.
  /// This button is used when the [style] is [ThemedButtonStyle.filledTonal].
  Widget _buildOutlinedTonal() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorOverride ?? contentColor.withOpacity(kOutlinedTonalOpacity),
        border: Border.all(color: contentColor, width: kBorderWidth),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          child: SizedBox(
            height: height,
            width: width,
            child: Padding(
              padding: padding,
              child: _buildLoadingOrChild(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: contentColor,
                        size: iconSize,
                      ),
                      const SizedBox(width: 5),
                    ],
                    label ??
                        Text(
                          labelText ?? "",
                          style: textStyle?.copyWith(color: contentColor),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [_buildOutlinedTonalFab] is used to build a filled tonal FAB button.
  /// This button is used when the [style] is [ThemedButtonStyle.filledTonalFab].
  Widget _buildOutlinedTonalFab() {
    return _handleTooltip(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorOverride ?? contentColor.withOpacity(kOutlinedTonalOpacity),
          border: Border.all(color: contentColor, width: kBorderWidth),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onTap,
            child: SizedBox(
              height: height,
              width: width,
              child: Padding(
                padding: padding,
                child: _buildLoadingOrChild(
                  child: Center(
                    child: Icon(
                      icon ?? LayrzIcons.mdiHelp,
                      color: contentColor,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [_buildText] is used to build a text button.
  /// This button is used when the [style] is [ThemedButtonStyle.text].
  Widget _buildText() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorOverride ?? Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          child: SizedBox(
            height: height,
            width: width,
            child: Padding(
              padding: padding,
              child: _buildLoadingOrChild(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: contentColor,
                        size: iconSize,
                      ),
                      const SizedBox(width: 5),
                    ],
                    label ??
                        Text(
                          labelText ?? "",
                          style: textStyle?.copyWith(color: contentColor),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [_buildFab] is used to build a FAB button.
  /// This button is used when the [style] is [ThemedButtonStyle.fab].
  Widget _buildFab() {
    return _handleTooltip(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorOverride ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onTap,
            child: SizedBox(
              height: height,
              width: width,
              child: Padding(
                padding: padding,
                child: _buildLoadingOrChild(
                  child: Center(
                    child: Icon(
                      icon ?? LayrzIcons.mdiHelp,
                      color: contentColor,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [_buildOutlined] is used to build a outlined button.
  /// This button is used when the [style] is [ThemedButtonStyle.outlined].
  Widget _buildOutlined() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorOverride ?? Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: contentColor, width: kBorderWidth),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          hoverColor: contentColor.withOpacity(kHoverOpacity),
          child: SizedBox(
            height: height,
            width: width,
            child: Padding(
              padding: padding,
              child: _buildLoadingOrChild(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: contentColor,
                        size: iconSize,
                      ),
                      const SizedBox(width: 5),
                    ],
                    label ??
                        Text(
                          labelText ?? "",
                          style: textStyle?.copyWith(color: contentColor),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [_buildOutlinedFab] is used to build a outlined FAB button.
  /// This button is used when the [style] is [ThemedButtonStyle.outlinedFab].
  Widget _buildOutlinedFab() {
    return _handleTooltip(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: contentColor, width: kBorderWidth),
          color: colorOverride ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onTap,
            child: SizedBox(
              height: height,
              width: width,
              child: Padding(
                padding: padding,
                child: _buildLoadingOrChild(
                  child: Center(
                    child: Icon(
                      icon ?? LayrzIcons.mdiHelp,
                      color: contentColor,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [_buildFilled] is used to build a filled button.
  /// This button is used when the [style] is [ThemedButtonStyle.filled].
  Widget _buildFilled() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorOverride ?? contentColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          child: SizedBox(
            height: height,
            width: width,
            child: Padding(
              padding: padding,
              child: _buildLoadingOrChild(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: validateColor(color: contentColor),
                        size: iconSize,
                      ),
                      const SizedBox(width: 5),
                    ],
                    label ??
                        Text(
                          labelText ?? "",
                          style: textStyle?.copyWith(
                            color: validateColor(color: contentColor),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [_buildFilledFab] is used to build a filled FAB button.
  /// This button is used when the [style] is [ThemedButtonStyle.filledFab].
  Widget _builFilledFab() {
    return _handleTooltip(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorOverride ?? contentColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onTap,
            child: SizedBox(
              height: height,
              width: width,
              child: Padding(
                padding: padding,
                child: _buildLoadingOrChild(
                  child: Center(
                    child: Icon(
                      icon ?? LayrzIcons.mdiHelp,
                      color: validateColor(color: contentColor),
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [_buildElevated] is used to build a elevated button.
  /// This button is used when the [style] is [ThemedButtonStyle.elevated].
  Widget _buildElevated() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorOverride ?? contentColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          child: SizedBox(
            height: height,
            width: width,
            child: Padding(
              padding: padding,
              child: _buildLoadingOrChild(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: validateColor(color: contentColor),
                        size: iconSize,
                      ),
                      const SizedBox(width: 5),
                    ],
                    label ??
                        Text(
                          labelText ?? "",
                          style: textStyle?.copyWith(
                            color: validateColor(color: contentColor),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [_buildElevatedFab] is used to build a elevated FAB button.
  /// This button is used when the [style] is [ThemedButtonStyle.elevatedFab].
  Widget _builElevatedFab() {
    return _handleTooltip(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorOverride ?? contentColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 1),
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onTap,
            child: SizedBox(
              height: height,
              width: width,
              child: Padding(
                padding: padding,
                child: _buildLoadingOrChild(
                  child: Center(
                    child: Icon(
                      icon ?? LayrzIcons.mdiHelp,
                      color: validateColor(color: contentColor),
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [_buildLoadingOrChild] is used to build the loading indicator or the child.
  /// This basically is a helper function to avoid the boilerplate of the conditional.
  Widget _buildLoadingOrChild({required Widget child}) {
    if (isLoading || isCooldown) {
      return _buildLoadingIndicator();
    }
    return child;
  }

  /// [_buildLoadingIndicator] is used to build the loading indicator.
  /// This indicator is used when the button is in loading or cooldown state.
  ///
  /// When the button is in cooldown state, the indicator will show the remaining time and the
  /// linear progress indicator will be animated.
  ///
  /// Otherwise, when the button is in loading state, the indicator will show a linear progress indicator
  /// in indeterminate mode.
  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: width,
      height: height,
      child: isCooldown
          ? TweenAnimationBuilder(
              duration: cooldownDuration,
              onEnd: onCooldownFinish,
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, value, _) {
                int remaining = (cooldownDuration.inSeconds * (1 - value)).round() + 1;

                Widget progress = LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
                  value: value,
                );

                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      width: width * value,
                      child: progress,
                    ),
                    if (showCooldownRemainingDuration)
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            remaining.toString(),
                            style: textStyle,
                          ),
                        ),
                      ),
                  ],
                );
              },
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
                  ),
                ),
              ],
            ),
    );
  }
}

/// [ThemedButtonStyle] is used to define the style of the button.
///
/// The styles are based on Material 3 rules. For more info go to
/// https://m3.material.io/components/all-buttons.
enum ThemedButtonStyle {
  /// [ThemedButtonStyle.elevated] refers to a button with a filled background and a shadow.
  /// The shadow is generated using the helper function `generateContainerElevation` with
  /// an elevation of `1`.
  elevated,

  /// [ThemedButtonStyle.elevatedFab] refers to a button with a filled background and a shadow.
  /// The shadow is generated using the helper function `generateContainerElevation` with
  /// an elevation of `1`.
  elevatedFab,

  /// [ThemedButtonStyle.filled] refers to a button with a filled background.
  /// Works similar as a [ThemedButtonStyle.elevated] but without the shadow.
  filled,

  /// [ThemedButtonStyle.filledFab] refers to a button with a filled background.
  /// Works similar as a [ThemedButtonStyle.elevatedFab] but without the shadow.
  filledFab,

  /// [ThemedButtonStyle.filledTonal] refers to a button with a filled background with an constant
  /// opacity of `0.2`.
  filledTonal,

  /// [ThemedButtonStyle.filledTonalFab] refers to a button with a filled background with an constant
  /// opacity of `0.2`.
  filledTonalFab,

  /// [ThemedButtonStyle.outlined] refers to a button with a outlined border.
  /// The border color is the same as the text color.
  outlined,

  /// [ThemedButtonStyle.outlinedFab] refers to a button with a outlined border.
  /// The border color is the same as the text color.
  outlinedFab,

  /// [ThemedButtonStyle.text] refers to a button with a transparent background.
  text,

  /// [ThemedButtonStyle.fab] refers to a button with a transparent background.
  fab,

  /// [ThemedButtonStyle.outlinedTonal] refers to a button with a outlined border with an constant
  /// opacity of `0.2`.
  outlinedTonal,

  /// [ThemedButtonStyle.outlinedTonalFab] refers to a button with a outlined border with an constant
  /// opacity of `0.2`.
  outlinedTonalFab,
}
