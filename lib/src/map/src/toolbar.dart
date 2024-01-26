part of '../map.dart';

/// [ThemedMapToolbarFlow] defines the flow of the toolbar.
enum ThemedMapToolbarFlow {
  /// [ThemedToolbarFlow.horizontal] defines the flow of the toolbar as horizontal.
  horizontal,

  /// [ThemedToolbarFlow.vertical] defines the flow of the toolbar as vertical.
  vertical,
}

class ThemedMapToolbar extends StatefulWidget {
  /// [layers] defines the list of layers to toggle.
  /// You must provide `selectedLayer` to define which layer is selected.
  /// If is empty, the toggler will not be shown.
  final List<MapLayer> layers;

  /// [selectedLayer] defines the selected layer to use.
  /// You must provide `layers` to define the list of layers to toggle.
  final MapLayer? selectedLayer;

  /// [onZoomIn] defines the callback to execute when the user press the zoom in button.
  /// If is null, the button will not be shown.
  final VoidCallback? onZoomIn;

  /// [onZoomOut] defines the callback to execute when the user press the zoom out button.
  /// If is null, the button will not be shown.
  final VoidCallback? onZoomOut;

  /// [zoomInDisabled] defines if the zoom in button is disabled.
  final bool zoomInDisabled;

  /// [zoomOutDisabled] defines if the zoom out button is disabled.
  final bool zoomOutDisabled;

  /// [onLayerChanged] defines the callback to execute when the user change the layer.
  final void Function(MapLayer?)? onLayerChanged;

  /// [position] defines the position of the toolbar.
  /// By default is on the right-bottom corner of the map.
  final Alignment position;

  /// [flow] defines the flow of the toolbar. By default is vertical.
  final ThemedMapToolbarFlow flow;

  /// [additionalButtons] defines the list of additional buttons to show.
  final List<ThemedMapButton> additionalButtons;

  /// [zoomInLabelText] defines the text to show on the zoom in button.
  /// By default is `Zoom In`.
  final String zoomInLabelText;

  /// [zoomOutLabelText] defines the text to show on the zoom out button.
  /// By default is `Zoom Out`.
  final String zoomOutLabelText;

  /// [changeLayerLabelText] defines the text to show on the change layer button.
  /// By default is `Change Layer`.
  /// This text is also used in the title of the dialog to change the layer.
  final String changeLayerLabelText;

  /// [saveLabelText] defines the text to show on the save button.
  /// By default is `Save`.
  final String saveLabelText;

  /// [cancelLabelText] defines the text to show on the cancel button.
  /// By default is `Cancel`.
  final String cancelLabelText;

  /// [ThemedMapToolbar] is a widget that builds a toolbar for the map.
  /// The position of the toolbar is on the right-bottom corner of the map but you can change it.
  /// The toolbar is composed by a layer toggler and a zoom in/out buttons.
  const ThemedMapToolbar({
    super.key,
    this.layers = const [],
    this.selectedLayer,
    this.onZoomIn,
    this.onZoomOut,
    this.zoomInDisabled = false,
    this.zoomOutDisabled = false,
    this.onLayerChanged,
    this.position = Alignment.bottomRight,
    this.flow = ThemedMapToolbarFlow.vertical,
    this.additionalButtons = const [],
    this.zoomInLabelText = 'Zoom In',
    this.zoomOutLabelText = 'Zoom Out',
    this.changeLayerLabelText = 'Change Layer',
    this.saveLabelText = 'Save',
    this.cancelLabelText = 'Cancel',
  });

  @override
  State<ThemedMapToolbar> createState() => _ThemedMapToolbarState();
}

class _ThemedMapToolbarState extends State<ThemedMapToolbar> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  double get buttonSize => ThemedMapButton.size;
  Color get buttonColor => isDark ? Colors.white : Colors.black;

  MapLayer? _selected;
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);

  List<MapLayer> get layers => subdivideLayersPerSource(rawLayers: widget.layers);

  List<ThemedMapButton> get actions => [
        ...widget.additionalButtons,
        ...fixedButtons,
      ];

  List<ThemedMapButton> get fixedButtons => [
        if (widget.onZoomIn != null) ...[
          ThemedMapButton(
            labelText: i18n?.t('layrz.map.zoom.in') ?? widget.zoomInLabelText,
            icon: MdiIcons.plusCircleOutline,
            isDisabled: widget.zoomInDisabled,
            onTap: widget.onZoomIn,
            color: buttonColor,
          ),
        ],
        if (widget.onZoomOut != null) ...[
          ThemedMapButton(
            labelText: i18n?.t('layrz.map.zoom.out') ?? widget.zoomOutLabelText,
            icon: MdiIcons.minusCircleOutline,
            isDisabled: widget.zoomOutDisabled,
            onTap: widget.onZoomOut,
            color: buttonColor,
          ),
        ],
        if (layers.isNotEmpty) ...[
          ThemedMapButton(
            labelText: i18n?.t('layrz.map.change.layer') ?? widget.changeLayerLabelText,
            icon: MdiIcons.layers,
            color: buttonColor,
            onTap: () async {
              final res = await showDialog<MapLayer>(
                context: context,
                builder: (context) {
                  return ThemedChangeLayerDialog(
                    layers: layers,
                    currentLayer: _selected,
                    saveLabelText: i18n?.t('actions.save') ?? widget.saveLabelText,
                    cancelLabelText: i18n?.t('actions.cancel') ?? widget.cancelLabelText,
                    title: i18n?.t('layrz.map.change.layer') ?? widget.changeLayerLabelText,
                  );
                },
              );

              if (res != null) {
                _selected = res;
                _notify();
              }
            },
          ),
        ],
      ];

  double get _dividerSize => 2;
  double get _dividerIndent => 5;

  Widget get _divider {
    if (fixedButtons.isEmpty) {
      return const SizedBox();
    }
    if (widget.additionalButtons.isEmpty) {
      return const SizedBox();
    }

    return widget.flow == ThemedMapToolbarFlow.horizontal
        ? VerticalDivider(
            width: _dividerSize,
            indent: _dividerIndent,
            endIndent: _dividerIndent,
          )
        : Divider(
            height: _dividerSize,
            indent: _dividerIndent,
            endIndent: _dividerIndent,
          );
  }

  List<Widget> get items => [
        ...widget.additionalButtons,
        _divider,
        ...fixedButtons,
      ];

  double get calculatedSize {
    double size = buttonSize * actions.length;

    if (widget.additionalButtons.isEmpty) {
      return size;
    }

    if (fixedButtons.isEmpty) {
      return size;
    }

    return (buttonSize * actions.length) + 2;
  }

  @override
  void initState() {
    super.initState();

    final validated = layers.firstWhereOrNull((layer) => layer.id == widget.selectedLayer?.id);
    _selected = validated;

    if (layers.isNotEmpty) {
      _selected ??= layers.first;
    }
    _notify();
  }

  @override
  void didUpdateWidget(ThemedMapToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedLayer?.id != widget.selectedLayer?.id) {
      final validated = layers.firstWhereOrNull((layer) => layer.id == widget.selectedLayer?.id);
      _selected = validated;
      if (layers.isNotEmpty) {
        _selected ??= layers.first;
      }
      _notify();
    }
  }

  void _notify() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLayerChanged?.call(_selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry margin = const EdgeInsets.all(10);

    if (widget.position == Alignment.bottomLeft) {
      margin = margin.add(EdgeInsets.only(bottom: ThemedTileLayer.reservedAttributionHeight));
    }
    return Align(
      alignment: widget.position,
      child: Container(
        margin: margin,
        decoration: generateContainerElevation(
          context: context,
          radius: 8,
        ),
        clipBehavior: Clip.antiAlias,
        width: widget.flow == ThemedMapToolbarFlow.horizontal ? calculatedSize : buttonSize,
        height: widget.flow == ThemedMapToolbarFlow.horizontal ? buttonSize : calculatedSize,
        child: widget.flow == ThemedMapToolbarFlow.horizontal
            ? Row(
                children: items,
              )
            : Column(
                children: items,
              ),
      ),
    );
  }
}
