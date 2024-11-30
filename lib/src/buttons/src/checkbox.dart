part of '../buttons.dart';

class ThemedAnimatedCheckbox extends StatefulWidget {
  final Color? activeColor;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Duration animationDuration;

  /// Creates a [ThemedAnimatedCheckbox] widget.
  /// The concept is simple, use an animation to translate between unselected icon and selected icon.
  const ThemedAnimatedCheckbox({
    super.key,

    /// Represents the active color of the checkbox.
    /// By default will take [Theme.of(context).primaryColor]
    this.activeColor,

    /// Is the value/state of the button.
    required this.value,

    /// The callback that is called when the value of the checkbox changes.
    this.onChanged,

    /// Represents the duration of the animation/transition, by default will take [kHoverDuration]
    this.animationDuration = const Duration(milliseconds: 100),
  });

  @override
  State<ThemedAnimatedCheckbox> createState() => _ThemedAnimatedCheckboxState();
}

class _ThemedAnimatedCheckboxState extends State<ThemedAnimatedCheckbox> with TickerProviderStateMixin {
  late AnimationController _unselectedController;
  late AnimationController _selectedController;
  late bool value;

  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get activeColor => widget.activeColor ?? (isDark ? Colors.white : Theme.of(context).primaryColor);
  Widget get _unselectedIcon => Icon(LayrzIcons.mdiCheckboxBlankCircleOutline, color: Colors.grey, size: 20);
  Widget get _selectedIcon => Icon(LayrzIcons.mdiCheckboxMarkedCircleOutline, color: activeColor, size: 20);

  @override
  void initState() {
    super.initState();
    value = widget.value;
    _unselectedController = AnimationController(vsync: this, duration: widget.animationDuration, value: value ? 0 : 1);
    _selectedController = AnimationController(vsync: this, duration: widget.animationDuration, value: value ? 1 : 0);
  }

  @override
  void didUpdateWidget(ThemedAnimatedCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      value = widget.value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!widget.value) {
          _unselectedController.forward();
          _selectedController.reverse();
        } else {
          _unselectedController.reverse();
          _selectedController.forward();
        }
      });
    }
  }

  @override
  dispose() {
    _unselectedController.dispose();
    _selectedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onChanged == null ? null : _handleTap,
      borderRadius: BorderRadius.circular(100),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            FadeTransition(opacity: _unselectedController, child: _unselectedIcon),
            FadeTransition(opacity: _selectedController, child: _selectedIcon),
          ],
        ),
      ),
    );
  }

  void _handleTap() async {
    if (_selectedController.isAnimating || _unselectedController.isAnimating) return;
    widget.onChanged?.call(!value);
  }
}
