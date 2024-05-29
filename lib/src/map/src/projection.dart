part of '../map.dart';

class ContainCamera extends CameraConstraint {
  /// [bounds] is the bounds to keep the camera within.
  final LatLngBounds bounds;

  /// [ContainCamera] is a camera constraint that keeps the camera within the
  /// given [bounds].
  ///
  /// This class is a copy of [ConstrainCameraToBounds] from the `flutter_map`
  /// package, but it does not constrain the camera to the bounds when the zoom
  /// level is 0.
  const ContainCamera({
    required this.bounds,
  });

  @override
  MapCamera? constrain(MapCamera camera) {
    final testZoom = camera.zoom;
    final testCenter = camera.center;

    final nePixel = camera.project(bounds.northEast, testZoom);
    final swPixel = camera.project(bounds.southWest, testZoom);

    final halfSize = camera.size / 2;

    // Find the limits for the map center which would keep the camera within the
    // [latLngBounds].
    final leftOkCenter = math.min(swPixel.x, nePixel.x) + halfSize.x;
    final rightOkCenter = math.max(swPixel.x, nePixel.x) - halfSize.x;
    final topOkCenter = math.min(swPixel.y, nePixel.y) + halfSize.y;
    final botOkCenter = math.max(swPixel.y, nePixel.y) - halfSize.y;

    // Stop if we are zoomed out so far that the camera cannot be translated to
    // stay within [latLngBounds].
    if (leftOkCenter > rightOkCenter || topOkCenter > botOkCenter) return null;

    final centerPix = camera.project(testCenter, testZoom);
    final newCenterPix = math.Point(
      centerPix.x.clamp(leftOkCenter, rightOkCenter),
      centerPix.y.clamp(topOkCenter, botOkCenter),
    );

    if (newCenterPix == centerPix) return camera;

    return camera.withPosition(
      center: camera.unproject(newCenterPix, testZoom),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ContainCamera && other.bounds == bounds;
  }

  @override
  int get hashCode => bounds.hashCode;
}

// class ThemedPlainCrs extends Crs {
//   /// [code] is the code of the CRS.
//   @override
//   final String code;

//   /// [projection] is the projection to use.
//   @override
//   final Projection projection;

//   /// [transformation] is the transformation to use.
//   @override
//   final Transformation transformation;

//   /// [ThemedPlainCrs] is a CRS that uses a plain projection.
//   ///
//   /// An example of the implementation:
//   /// ```dart
//   /// ThemedPlainCrs(
//   ///   projection: ThemedPlainProjection(
//   ///     rawBounds: Bounds(
//   ///       const math.Point(0, 0), // The top left corner of the map
//   ///       const math.Point(1, 1), // The bottom right corner of the map
//   ///     ),
//   ///   ),
//   ///   transformation: const Transformation(1, 1, 1, 1), // No transformation
//   /// )
//   /// ```
//   const ThemedPlainCrs({
//     this.code = 'layrz.plain',
//     required this.projection,
//     required this.transformation,
//   });

//   @override
//   bool get infinite => false;

//   @override
//   (double, double)? get wrapLat => null;

//   @override
//   (double, double)? get wrapLng => null;
// }

// class ThemedPlainProjection extends Projection {
//   /// [rawBounds] is the bounds of the projection.
//   final Bounds<double> rawBounds;

//   /// [ThemedPlainProjection] is a projection that uses a plain projection.
//   /// The [rawBounds] are the bounds of the map.
//   const ThemedPlainProjection({
//     required this.rawBounds,
//   });

//   @override
//   Bounds<double> get bounds => rawBounds;

//   @override
//   math.Point<double> project(LatLng latlng) {
//     return math.Point(latlng.longitude, latlng.latitude);
//   }

//   @override
//   LatLng unproject(math.Point point) {
//     return LatLng(point.y.toDouble(), point.x.toDouble());
//   }
// }
