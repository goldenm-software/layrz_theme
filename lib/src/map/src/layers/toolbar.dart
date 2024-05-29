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

  /// [enableGoogleStreetView] defines if the google street view button is enabled.
  /// Only will be shown if the selected layer is a google layer.
  final bool enableGoogleStreetView;

  /// [controller] defines the `ThemedMapController` to listen some events from other widgets.
  final ThemedMapController? controller;

  /// [mapController] defines the `MapController` class from `flutter_map` package.
  final MapController? mapController;

  /// [mapKey] defines the key of the map.
  /// Is used to convert screen coordinates to map coordinates.
  final GlobalKey? mapKey;

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
    this.enableGoogleStreetView = false,
    this.controller,
    this.mapController,
    this.mapKey,
  });

  @override
  State<ThemedMapToolbar> createState() => _ThemedMapToolbarState();
}

class _ThemedMapToolbarState extends State<ThemedMapToolbar> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  double get buttonSize => ThemedMapButton.size;
  Color get buttonColor => isDark ? Colors.white : Colors.black;

  MapLayer? _selected;
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);

  List<MapLayer> get layers => widget.layers;

  List<ThemedMapButton> get actions => [
        ...widget.additionalButtons,
        ...fixedButtons,
      ];

  // bool get _canStreetView =>
  //     widget.enableGoogleStreetView &&
  //     _selected?.source == MapSource.google &&
  //     widget.controller != null &&
  //     widget.mapController != null &&
  //     widget.mapKey != null;

  List<ThemedMapButton> get fixedButtons => [
        // if (_canStreetView) ...[
        //   ThemedMapDragButton(
        //     labelText: i18n?.t('layrz.map.google.street.view') ?? 'Street View',
        //     icon: MdiIcons.googleStreetView,
        //     color: buttonColor,
        //     onDragStart: (offset) {
        //       widget.controller?.notify(StartGoogleStreetView());
        //     },
        //     onDragFinish: (offset) async {
        //       widget.controller?.notify(StopGoogleStreetView());

        //       if (offset == null) return;
        //       if (widget.mapKey == null) return;
        //       if (widget.mapController == null) return;

        //       RenderBox box = widget.mapKey!.currentContext!.findRenderObject() as RenderBox;
        //       final projectedOffset = box.globalToLocal(offset);
        //       math.Point p = math.Point(projectedOffset.dx, projectedOffset.dy);
        //       LatLng coordinates = widget.mapController!.camera.pointToLatLng(p);
        //       final result = await _searchStreetView(coordinates);
        //       if (result == null) return;
        //       _openStreetView(result.$1, result.$2, result.$3);
        //     },
        //     onDragCancel: () {
        //       widget.controller?.notify(StopGoogleStreetView());
        //     },
        //   ),
        // ],
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

    widget.controller?.addListener(_eventListener);
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

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_eventListener);
      widget.controller?.addListener(_eventListener);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_eventListener);
    super.dispose();
  }

  void _notify() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLayerChanged?.call(_selected);
    });
  }

  void _eventListener(ThemedMapEvent event) {
    debugPrint("Event received in toolbar: $event");
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

  /// [_openStreetView] opens a street view with the given [panoId], [xTiles], [yTiles] and [tileSize].
  /// Each parameter comes from the metadata query,
  /// [xTiles] is calculated using `imageWidth` and `tileWidth` from the metadata query.
  /// [yTiles] is calculated using `imageHeight` and `tileWidth` from the metadata query.
  /// Why `tileWidth`? Because `tileWidth` and `tileHeight` are the same (At least in the tests I did).

  void _openStreetView(String panoId, int xTiles, int yTiles) async {
    final prefs = await SharedPreferences.getInstance();

    String? googleSession = prefs.getString('google.maps.${_selected!.id}.streetView.token');
    int? googleExpiration = prefs.getInt('google.maps.${_selected!.id}.streetView.expiration');

    if (googleSession == null || googleExpiration == null) {
      debugPrint('layrz_theme/ThemedMapToolbar/_openStreetView(): No session found');
      return;
    }

    if (googleExpiration < DateTime.now().secondsSinceEpoch) {
      debugPrint('layrz_theme/ThemedMapToolbar/_openStreetView(): Session expired');
      return;
    }

    debugPrint('layrz_theme/ThemedMapToolbar/_openStreetView(): Opening street view');

    showDialog(
      context: context,
      builder: (context) {
        return ThemedStreetViewDialog(
          panoId: panoId,
          session: googleSession,
          googleToken: _selected!.googleToken!,
          xTiles: xTiles,
          yTiles: yTiles,
        );
      },
    );
  }

  /// [_searchStreetView] searches for a street view in Map Tiles API with the given [point].
  /// Returns the `panoId` of the street view if found, otherwise returns `null`.
  /// Also, can return `null` if the requirements are not met.
  ///
  /// Returns:
  /// - String: `panoId` of the street view.
  /// - double: `xTiles` of the street view.
  /// - double: `yTiles` of the street view.
  /// - double: `tileSize` of the street view.
  Future<(String, int, int)?> _searchStreetView(LatLng point) async {
    if (_selected == null) return null;
    if (_selected!.source != MapSource.google) return null;
    String? googleMapsKey = _selected!.googleToken;

    if (googleMapsKey == null) return null;

    final prefs = await SharedPreferences.getInstance();

    String? googleSession = prefs.getString('google.maps.${_selected!.id}.streetView.token');
    int? googleExpiration = prefs.getInt('google.maps.${_selected!.id}.streetView.expiration');

    if (googleSession == null || googleExpiration == null) {
      final resp = await _startSession(prefs, googleMapsKey);
      if (resp == null) return null;

      googleSession = resp.$1;
      googleExpiration = resp.$2;
    }

    if (googleExpiration < DateTime.now().secondsSinceEpoch) {
      final resp = await _startSession(prefs, googleMapsKey);
      if (resp == null) return null;

      googleSession = resp.$1;
      googleExpiration = resp.$2;
    }

    debugPrint('layrz_theme/ThemedMapToolbar/_searchStreetView(): Searching street view');

    try {
      final search = await http.get(Uri.parse(
        'https://tile.googleapis.com/v1/streetview/metadata?'
        'session=$googleSession&'
        'key=$googleMapsKey&'
        'lat=${point.latitude}&'
        'lng=${point.longitude}&'
        'radius=100',
      ));

      final pano = jsonDecode(search.body);
      if (pano['error'] != null) {
        debugPrint('layrz_theme/ThemedMapToolbar/_searchStreetView(): metadata error ${pano['error']}');
        prefs.remove('google.maps.${_selected!.id}.streetView.token');
        prefs.remove('google.maps.${_selected!.id}.streetView.expiration');
        return null;
      }

      num imageWidth = pano['imageWidth'] as num;
      num imageHeight = pano['imageHeight'] as num;
      num tileSize = pano['tileWidth'] as num;

      int xTiles = (imageWidth / tileSize).ceil();
      int yTiles = (imageHeight / tileSize).ceil();

      return (pano['panoId'] as String, xTiles, yTiles);
    } catch (e) {
      debugPrint('layrz_theme/ThemedMapToolbar/_searchStreetView(): metadata exception $e');
      return null;
    }
  }

  Future<(String, int)?> _startSession(SharedPreferences prefs, String googleMapsKey) async {
    try {
      final params = {
        'mapType': 'streetview',
        'language': 'en-US',
      };

      debugPrint('layrz_theme/ThemedMApToolbar/_searchStreetView(): Request $params');
      final response = await http.post(
        Uri.parse('https://tile.googleapis.com/v1/createSession?key=$googleMapsKey'),
        body: jsonEncode(params),
      );
      if (response.statusCode != 200) {
        debugPrint(
          'layrz_theme/ThemedMapToolbar/_searchStreetView(): createSession error code ${response.statusCode}',
        );
        return null;
      }

      debugPrint('layrz_theme/ThemedMapToolbar/_searchStreetView(): Response ${response.body}');
      final data = jsonDecode(response.body);

      prefs.setString('google.maps.${_selected!.id}.streetView.token', data['session']);
      prefs.setInt('google.maps.${_selected!.id}.streetView.expiration', int.parse(data['expiry']));
      String googleSession = data['session'];
      int googleExpiration = int.parse(data['expiry']);

      return (googleSession, googleExpiration);
    } catch (e) {
      debugPrint('layrz_theme/ThemedMapToolbar/_searchStreetView(): createSession exception $e');
      return null;
    }
  }
}
