library map;

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Main
part 'src/tile.dart';
part 'src/toolbar.dart';
part 'src/button.dart';

// Dialogs
part 'src/dialogs/change_layer.dart';

const kGoldenMHeadquarters = LatLng(8.982740428124941, -79.5097236128305);

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
            attributionUrl: 'https://cdn.layrz.com/resources/map_attributions/google_maps/normal.png',
            attributionUrlDark: 'https://cdn.layrz.com/resources/map_attributions/google_maps/white.png',
            attributionWidth: 119,
            attributionHeight: 36,
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
            attributionUrl: 'https://cdn.layrz.com/resources/map_attributions/mapbox_maps/normal.png',
            attributionUrlDark: 'https://cdn.layrz.com/resources/map_attributions/mapbox_maps/white.png',
            attributionWidth: 134,
            attributionHeight: 30,
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
            attributionUrl: 'https://cdn.layrz.com/resources/map_attributions/here_maps/normal.png',
            attributionUrlDark: 'https://cdn.layrz.com/resources/map_attributions/here_maps/white.png',
            attributionWidth: 80,
            attributionHeight: 80,
          ),
        );
      }

      continue;
    }
  }

  return layers;
}
