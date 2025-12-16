// ignore_for_file: use_build_context_synchronously

part of '../../map.dart';

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
  ///
  /// It's important to know that you should send the layers decomposed, to do that you can use the
  /// function `subdivideLayersPerSource` from `layrz_theme` package.
  ///
  /// For example:
  /// ```dart
  /// final layers = subdivideLayersPerSource(rawLayers: [
  ///  MapLayer(
  ///   id: 'layer1',
  ///   name: 'Layer 1',
  ///   source: MapSource.google,
  ///   googleToken: 'your_google_maps_token',
  ///   googleLayers: GoogleMapLayer.values,
  ///  ),
  /// ]);
  /// ```
  final List<MapLayer> layers;

  /// [selectedLayer] defines the selected layer to use.
  /// You must provide `layers` to define the list of layers to toggle.
  final MapLayer? selectedLayer;

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

  /// [enableGoogleStreetView] defines if the google street view button is enabled.
  /// Only will be shown if the selected layer is a google layer.
  final bool enableGoogleStreetView;

  /// [mapKey] defines the key of the map.
  /// Is used to convert screen coordinates to map coordinates.
  final GlobalKey? mapKey;

  /// [zoomSlider] defines if the zoom slider is enabled. When is enabled, the zoom in and zoom out buttons will not be shown.
  final bool zoomSlider;

  /// [animatedMapController] defines the `AnimatedMapController` class from `flutter_map_animation` package.
  /// It's used to animate the zoom in and zoom out actions.
  final AnimatedMapController animatedMapController;

  /// [maxZoom] defines the maximum zoom level of the map.
  final double maxZoom;

  /// [minZoom] defines the minimum zoom level of the map.
  final double minZoom;

  /// [zoomListenable] is a ValueNotifier that notifies when the zoom level changes.
  final ValueNotifier<double>? zoomListenable;

  /// [ThemedMapToolbar] is a widget that builds a toolbar for the map.
  /// The position of the toolbar is on the right-bottom corner of the map but you can change it.
  /// The toolbar is composed by a layer toggler and a zoom in/out buttons.
  ///
  /// To use google Street View, you must provide in [selectedLayer] a [MapLayer] with [MapSource.google] as source.
  /// Also, you must provide [controller], [mapController] and [mapKey] to use it. This [controller] you also need to
  /// provide it to [ThemedTileLayer] to listen the start and end of drag events.
  /// If you don't provide these parameters, the street view button will not do anything.
  ///
  /// For example:
  /// ```dart
  /// final GlobalKey mapKey = GlobalKey();
  /// final mapController = MapController();
  /// final controller = ThemedMapController();
  ///
  /// /* ...your code */
  ///
  /// Widget build(BuildContext context) {
  ///  return FlutterMap(
  ///   mapController: mapController,
  ///   key: mapKey,
  ///   /* ...other parameters */
  ///   children: [
  ///    ThemedTileLayer(
  ///      controller: controller,
  ///      /* ...any other parameters */
  ///    ),
  ///    ThemedMapToolbar(
  ///      controller: controller,
  ///      mapController: mapController,
  ///      mapKey: mapKey,
  ///      /* ... any other parameters */
  ///   ),
  ///   /* ...other layers */
  /// );
  /// ```
  const ThemedMapToolbar({
    super.key,
    this.layers = const [],
    this.selectedLayer,
    this.onLayerChanged,
    this.position = Alignment.bottomRight,
    this.flow = ThemedMapToolbarFlow.vertical,
    this.additionalButtons = const [],
    this.zoomInLabelText = 'Zoom In',
    this.zoomOutLabelText = 'Zoom Out',
    this.changeLayerLabelText = 'Change Layer',
    this.saveLabelText = 'Save',
    this.cancelLabelText = 'Cancel',
    this.enableGoogleStreetView = false,
    this.mapKey,
    this.zoomSlider = false,
    required this.animatedMapController,
    this.maxZoom = kMaxZoom,
    this.minZoom = kMinZoom,
    this.zoomListenable,
  });

  @override
  State<ThemedMapToolbar> createState() => _ThemedMapToolbarState();
}

class _ThemedMapToolbarState extends State<ThemedMapToolbar> {
  bool get isDark => Theme.of(context).brightness == .dark;
  double get _buttonSize => ThemedMapButton.size;
  Color get buttonColor => isDark ? Colors.white : Colors.black;

  MapLayer? _selected;
  LayrzAppLocalizations? get i18n => .maybeOf(context);

  double get _sliderSizeFactor => 5;

  List<MapLayer> get layers => widget.layers;

  List<ThemedMapButton> get actions => [
    ...widget.additionalButtons,
    ...fixedButtons,
  ];

  late ValueNotifier<double> _zoomListenable;

  List<ThemedMapButton> get fixedButtons => [
    if (layers.isNotEmpty) ...[
      ThemedMapButton(
        labelText: i18n?.t('layrz.map.change.layer') ?? widget.changeLayerLabelText,
        icon: LayrzIcons.solarBoldLayersMinimalistic,
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
  double get _dividerIndent => 4;

  Widget get _divider {
    if (fixedButtons.isEmpty) return const SizedBox();
    if (widget.additionalButtons.isEmpty) return const SizedBox();

    return widget.flow == .horizontal
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
    if (widget.zoomSlider) ...[
      ValueListenableBuilder(
        valueListenable: _zoomListenable,
        builder: (context, value, child) {
          return ThemedMapButton(
            labelText: i18n?.t('layrz.map.zoom.in') ?? widget.zoomOutLabelText,
            icon: LayrzIcons.solarBoldAddSquare,
            isDisabled: value >= widget.maxZoom,
            onTap: () async {
              // Increase zoom by 1
              double newZoom = (value + 1).clamp(widget.minZoom, widget.maxZoom);
              debugPrint('layrz_theme/ThemedMapToolbar/ZoomOut: Zoom to $newZoom');
              await widget.animatedMapController.animatedZoomTo(newZoom);
              _zoomListenable.value = newZoom;
            },
            color: buttonColor,
          );
        },
      ),
      SizedBox(
        height: widget.flow == .horizontal ? _buttonSize : _buttonSize * _sliderSizeFactor,
        width: widget.flow == .horizontal ? _buttonSize * _sliderSizeFactor : _buttonSize,
        child: RotatedBox(
          quarterTurns: widget.flow == .horizontal ? 0 : 3,
          child: ValueListenableBuilder(
            valueListenable: _zoomListenable,
            builder: (context, value, _) {
              return Slider(
                value: value,
                min: widget.minZoom,
                max: widget.maxZoom,
                // divisions: 15,
                label: value.toStringAsFixed(2),
                onChanged: (value) async {
                  value = value.clamp(widget.minZoom, widget.maxZoom);
                  value = (value * 100).toInt() / 100.0;
                  debugPrint('layrz_theme/ThemedMapToolbar/Slider: Zoom to $value');
                  widget.animatedMapController.mapController.move(
                    widget.animatedMapController.mapController.camera.center,
                    value,
                  );
                  _zoomListenable.value = value;
                },
              );
            },
          ),
        ),
      ),
      ValueListenableBuilder(
        valueListenable: _zoomListenable,
        builder: (context, value, child) {
          return ThemedMapButton(
            labelText: i18n?.t('layrz.map.zoom.out') ?? widget.zoomOutLabelText,
            icon: LayrzIcons.solarBoldMinusSquare,
            isDisabled: value <= widget.minZoom,
            onTap: () async {
              // reduce zoom by 1
              double newZoom = (value - 1).clamp(widget.minZoom, widget.maxZoom);
              debugPrint('layrz_theme/ThemedMapToolbar/ZoomOut: Zoom to $newZoom');
              await widget.animatedMapController.animatedZoomTo(newZoom);
              _zoomListenable.value = newZoom;
            },
            color: buttonColor,
          );
        },
      ),
    ],
    ...fixedButtons,
  ];

  double get calculatedSize {
    double size = actions.length * _buttonSize;

    if (widget.zoomSlider) {
      size += _buttonSize * _sliderSizeFactor + (_buttonSize * 2);
    }

    if (fixedButtons.isNotEmpty && widget.additionalButtons.isNotEmpty) {
      size += _dividerSize;
    }

    // Check why on dark mode the size is not correct
    size += 2;

    return size;
  }

  @override
  void initState() {
    super.initState();
    _zoomListenable = widget.zoomListenable ?? ValueNotifier<double>(0);

    final validated = layers.firstWhereOrNull((layer) => layer.id == widget.selectedLayer?.id);
    _selected = validated;

    if (layers.isNotEmpty) {
      _selected ??= layers.first;
    }
    _notify();

    _zoomListenable.value = widget.animatedMapController.mapController.camera.zoom;
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

    if (oldWidget.zoomListenable != widget.zoomListenable && widget.zoomListenable != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _zoomListenable = widget.zoomListenable!;
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    if (widget.zoomListenable == null) _zoomListenable.dispose();
    super.dispose();
  }

  void _notify() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLayerChanged?.call(_selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry margin = const .all(10);

    if (widget.position == .bottomLeft) {
      margin = margin.add(.only(bottom: ThemedTileLayer.reservedAttributionHeight));
    }
    return Align(
      alignment: widget.position,
      child: Container(
        margin: margin,
        decoration: generateContainerElevation(
          context: context,
          radius: 8,
        ),
        clipBehavior: .antiAlias,
        width: widget.flow == .horizontal ? calculatedSize : _buttonSize,
        height: widget.flow == .horizontal ? _buttonSize : calculatedSize,
        child: widget.flow == .horizontal ? Row(children: items) : Column(children: items),
      ),
    );
  }
}
