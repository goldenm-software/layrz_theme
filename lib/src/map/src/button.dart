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

typedef ThemedMapButtonDragCallback = void Function(Offset offset);
typedef ThemedMapButtonDragNullCallback = void Function(Offset? offset);

class ThemedMapDragButton extends ThemedMapButton {
  /// [onDragStart] defines the callback to execute when the user start to drag the button.
  final ThemedMapButtonDragCallback? onDragStart;

  /// [onDragFinish] defines the callback to execute when the user end to drag the button.
  final ThemedMapButtonDragNullCallback? onDragFinish;

  /// [onDragUpdate] defines the callback to execute when the user drag the button.
  final ThemedMapButtonDragCallback? onDragUpdate;

  /// [onDragCancel] defines the callback to execute when the user cancel the drag.
  final VoidCallback? onDragCancel;

  /// [dragIcon] defines the icon to show when the user drag the button.
  final IconData? dragIcon;

  /// [ThemedMapButton] is a widget that builds a button for the map.
  /// The button is composed by a label and an icon.
  const ThemedMapDragButton({
    super.key,
    required super.labelText,
    required super.icon,
    super.isDisabled = false,
    super.onTap,
    super.color,
    this.onDragStart,
    this.onDragFinish,
    this.onDragUpdate,
    this.onDragCancel,
    this.dragIcon,
  });

  @override
  State<ThemedMapDragButton> createState() => _ThemedMapDragButtonState();
}

class _ThemedMapDragButtonState extends State<ThemedMapDragButton> {
  late OverlayPortalController _controller;
  bool get _isDisabled => widget.isDisabled;
  Color get color => _isDisabled ? Colors.grey : (widget.color ?? Theme.of(context).primaryColor);
  IconData get icon => _isDragging ? MdiIcons.dragVariant : widget.icon;
  IconData get dragIcon => widget.dragIcon ?? widget.icon;

  bool _isDragging = false;
  Offset? _lastOffset;

  @override
  void initState() {
    super.initState();
    _controller = OverlayPortalController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ThemedMapButton.size,
      height: ThemedMapButton.size,
      child: Material(
        color: Colors.transparent,
        child: OverlayPortal(
          controller: _controller,
          overlayChildBuilder: _buildOverlay,
          child: GestureDetector(
            onPanStart: _isDisabled
                ? null
                : (details) {
                    setState(() {
                      if (!_isDragging) _isDragging = true;
                      _lastOffset = details.globalPosition;
                    });

                    widget.onDragStart?.call(details.globalPosition);
                    _controller.show();
                  },
            onPanEnd: _isDisabled
                ? null
                : (details) {
                    widget.onDragFinish?.call(_lastOffset);
                    setState(() {
                      if (_isDragging) _isDragging = false;
                      _lastOffset = null;
                    });

                    if (_controller.isShowing) _controller.hide();
                  },
            onPanCancel: _isDisabled
                ? null
                : () {
                    setState(() {
                      if (_isDragging) _isDragging = false;
                      _lastOffset = null;
                    });
                    widget.onDragCancel?.call();
                    if (_controller.isShowing) _controller.hide();
                  },
            onPanUpdate: _isDisabled
                ? null
                : (details) {
                    setState(() {
                      if (!_isDragging) _isDragging = true;
                      _lastOffset = details.globalPosition;
                    });
                    widget.onDragUpdate?.call(details.globalPosition);
                    if (!_controller.isShowing) _controller.show();
                  },
            child: ThemedTooltip(
              position: ThemedTooltipPosition.right,
              message: widget.labelText,
              color: color,
              child: Icon(
                icon,
                size: 18,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    if (_lastOffset == null) return const SizedBox.shrink();

    return Positioned(
      left: _lastOffset!.dx - 15,
      top: _lastOffset!.dy - 15,
      child: SizedBox(
        width: 30,
        height: 30,
        child: Center(
          child: Icon(dragIcon, size: 30, color: color),
        ),
      ),
    );
  }
}
