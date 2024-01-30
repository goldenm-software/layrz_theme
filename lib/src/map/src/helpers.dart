part of '../map.dart';

/// [subdivideLayersPerSource] takes a list of [MapLayer] and returns a list of
/// [MapLayer] where each layer has only one source.
List<MapLayer> subdivideLayersPerSource({required List<MapLayer> rawLayers}) {
  List<MapLayer> layers = [];

  for (MapLayer layer in rawLayers) {
    if (![MapSource.google, MapSource.mapbox, MapSource.here].contains(layer.source)) {
      layers.add(layer);
      continue;
    }

    if (layer.source == MapSource.google) {
      if (layer.googleToken == null) {
        continue;
      }

      if (layer.googleToken!.isEmpty) {
        continue;
      }

      final googleLayers = layer.googleLayers ?? [];
      if (googleLayers.isEmpty) {
        continue;
      }

      for (int i = 0; i < googleLayers.length; i++) {
        GoogleMapLayer googleLayer = googleLayers[i];
        layers.add(
          MapLayer(
            id: '${layer.id}_$googleLayer',
            name: '${googleLayer.description} (${layer.name})',
            source: layer.source,
            googleToken: layer.googleToken,
            googleLayers: [googleLayer],
          ),
        );
      }

      continue;
    }

    if (layer.source == MapSource.mapbox) {
      if (layer.mapboxToken == null) {
        continue;
      }

      if (layer.mapboxToken!.isEmpty) {
        continue;
      }

      final mapboxLayers = layer.mapboxLayers ?? [];
      if (mapboxLayers.isEmpty) {
        continue;
      }

      for (int i = 0; i < mapboxLayers.length; i++) {
        MapboxStyle mapboxLayer = mapboxLayers[i];
        layers.add(
          MapLayer(
            id: '${layer.id}_$mapboxLayer',
            name: '${mapboxLayer.description} (${layer.name})',
            source: layer.source,
            mapboxToken: layer.mapboxToken,
            mapboxLayers: [mapboxLayer],
          ),
        );
      }

      continue;
    }

    if (layer.source == MapSource.here) {
      if (layer.hereToken == null) {
        continue;
      }

      if (layer.hereToken!.isEmpty) {
        continue;
      }

      final hereLayers = layer.hereLayers ?? [];
      if (hereLayers.isEmpty) {
        continue;
      }

      for (int i = 0; i < hereLayers.length; i++) {
        HereStyle hereLayer = hereLayers[i];
        layers.add(
          MapLayer(
            id: '${layer.id}_$hereLayer',
            name: '${hereLayer.description} (${layer.name})',
            source: layer.source,
            hereToken: layer.hereToken,
            hereLayers: [hereLayer],
          ),
        );
      }

      continue;
    }
  }

  return layers;
}
