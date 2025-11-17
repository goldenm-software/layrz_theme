part of '../map.dart';

/// [kGoldenMHeadquarters] is the default location for the map.
const kGoldenMHeadquarters = LatLng(8.982740428124941, -79.5097236128305);

/// [kDefaultLayer] is the default layer for the map.
/// Uses OpenStreetMap.
const kDefaultLayer = MapLayer(
  id: 'osm',
  name: 'OpenStreetMap',
  source: .osm,
);

/// [kMinZoom] is the minimum zoom level for the map.
const double kMinZoom = 3;

/// [kMaxZoom] is the maximum zoom level for the map.
const double kMaxZoom = 18;
