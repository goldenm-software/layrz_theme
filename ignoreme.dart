// This file is for store unused code temporarily.
// Should be empty before a deployment

/*
Positioned.fill(
              child: FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(0, 0),
                  initialZoom: 5,
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.drag,
                    rotationWinGestures: MultiFingerGesture.none,
                    pinchZoomWinGestures: MultiFingerGesture.none,
                    pinchMoveWinGestures: MultiFingerGesture.none,
                  ),
                  crs: Epsg4326(),
                ),
                children: [
                  TileLayer(
                    urlTemplate: _streetViewUrl,
                    minZoom: 0,
                    maxZoom: 5,
                    minNativeZoom: 0,
                    maxNativeZoom: 5,
                    tileProvider: CancellableNetworkTileProvider(headers: {
                      // Set cache to 30 days
                      'Cache-Control': 'max-age=2592000',
                    }),
                    keepBuffer: 0,
                    panBuffer: 0,
                    tileBuilder: (context, child, tile) {
                      return Placeholder(
                        child: Stack(
                          children: [
                            child,
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  "x: ${tile.coordinates.x}\ny: ${tile.coordinates.y}\nz: ${tile.coordinates.z}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
*/