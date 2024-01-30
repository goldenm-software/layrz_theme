part of '../../map.dart';

class ThemedStreetViewDialog extends StatefulWidget {
  /// [panoId] is the id of the panorama to show.
  final String panoId;

  /// [session] is the session of the panorama to show.
  final String session;

  /// [googleToken] is the token of the panorama to show.
  final String googleToken;

  /// [xTiles] is the number of tiles to show horizontally.
  final int xTiles;

  /// [yTiles] is the number of tiles to show vertically.
  final int yTiles;

  /// [zoomLevel] is the zoom level of the panorama to show.
  /// The default value is 5 and, acording to the documentation, it
  /// should be between 0 and 5.
  final int zoomLevel;

  /// [ThemedStreetViewDialog] is a widget that builds a street view. Uses
  /// `flutter_map` to render tiles as a layer.
  ///
  /// Important notice, we define it as a [Dialog], but it is not a dialog.
  /// Irl it is a full screen widget that is shown as a dialog.
  const ThemedStreetViewDialog({
    super.key,
    required this.panoId,
    required this.session,
    required this.googleToken,
    required this.xTiles,
    required this.yTiles,
    this.zoomLevel = 5,
  })  : assert(xTiles > 0),
        assert(yTiles > 0),
        assert(zoomLevel >= 0 && zoomLevel <= 5);

  @override
  State<ThemedStreetViewDialog> createState() => _ThemedStreetViewDialogState();
}

class _ThemedStreetViewDialogState extends State<ThemedStreetViewDialog> {
  final mapController = MapController();
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);

  String get _streetViewUrl => 'https://tile.googleapis.com/v1/streetview/tiles/5/{x}/{y}'
      '?session=${widget.session}'
      '&key=${widget.googleToken}'
      '&panoId=${widget.panoId}';

  LatLngBounds get _panoBounds => LatLngBounds.fromPoints([
        const LatLng(0, 0),
        LatLng(widget.yTiles.toDouble() - 1, widget.xTiles.toDouble() - 1),
      ]);

  String get _googleAttributionLight => 'https://cdn.layrz.com/resources/map_attributions/google_maps/normal.png';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: _panoBounds.center,
          initialZoom: 0,
          cameraConstraint: ContainCamera(bounds: _panoBounds),
          crs: ThemedPlainCrs(
            projection: ThemedPlainProjection(
              rawBounds: Bounds(
                const math.Point(0, 0),
                math.Point(widget.xTiles.toDouble() - 1, widget.yTiles.toDouble() - 1),
              ),
            ),
            transformation: const Transformation(1, 1, 1, 1),
          ),
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.drag,
            rotationWinGestures: MultiFingerGesture.none,
            pinchZoomWinGestures: MultiFingerGesture.none,
            pinchMoveWinGestures: MultiFingerGesture.none,
          ),
          onPositionChanged: (position, hasGesture) {
            if (position.bounds == null) return;
            if (position.center == null) return;

            final bounds = position.bounds!;
            final center = position.center!;

            if (bounds.northEast.longitude > widget.xTiles.toDouble() - 1) {
              mapController.move(
                LatLng(center.latitude, 0),
                mapController.camera.zoom,
              );
            } else if (bounds.southWest.longitude < 0) {
              mapController.move(
                LatLng(center.latitude, widget.xTiles.toDouble() - 1),
                mapController.camera.zoom,
              );
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: _streetViewUrl,
            tileSize: 256,
            tileBounds: _panoBounds,
            tileProvider: CancellableNetworkTileProvider(
              headers: {'Cache-Control': 'max-age=2592000'},
              silenceExceptions: true,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Image.network(
                _googleAttributionLight,
                alignment: Alignment.centerLeft,
                width: 200,
                height: 50,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: generateContainerElevation(
                context: context,
                color: Colors.white,
                radius: 30,
              ),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: ThemedTooltip(
                  message: i18n?.t('actions.back') ?? 'Back',
                  position: ThemedTooltipPosition.right,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      MdiIcons.chevronLeft,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
