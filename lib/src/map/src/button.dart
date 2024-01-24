part of '../map.dart';

class ThemedMapButton extends StatefulWidget {
  /// [labelText] defines the text to show on the button.
  final String labelText;

  /// [icon] defines the icon to show on the button.
  final IconData icon;

  /// [isDisabled] defines if the button is disabled.
  final bool isDisabled;

  /// [onTap] defines the callback to execute when the user press the button.
  /// If is null, the button will appear disabled.
  final VoidCallback? onTap;

  /// [color] defines the color of the button.
  final Color? color;

  /// [ThemedMapButton] is a widget that builds a button for the map.
  /// The button is composed by a label and an icon.
  const ThemedMapButton({
    super.key,
    required this.labelText,
    required this.icon,
    this.isDisabled = false,
    this.onTap,
    this.color,
  });

  @override
  State<ThemedMapButton> createState() => _ThemedMapButtonState();

  static double get size => 40;
}

class _ThemedMapButtonState extends State<ThemedMapButton> {
  bool get _isDisabled => widget.isDisabled || widget.onTap == null;
  Color get color => _isDisabled ? Colors.grey : (widget.color ?? Theme.of(context).primaryColor);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ThemedMapButton.size,
      height: ThemedMapButton.size,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isDisabled ? null : widget.onTap,
          child: ThemedTooltip(
            position: ThemedTooltipPosition.right,
            message: widget.labelText,
            color: color,
            child: Icon(
              widget.icon,
              size: 17,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
