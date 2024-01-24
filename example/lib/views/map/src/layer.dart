part of '../map.dart';

class MapLayerView extends StatefulWidget {
  const MapLayerView({super.key});

  @override
  State<MapLayerView> createState() => _MapLayerViewState();

  static double get reservedAttributionHeight => 100;
}

class _MapLayerViewState extends State<MapLayerView> {
  AppStore get store => VxState.store as AppStore;
  List<MapLayer> get layers => store.availableLayers;
  MapLayer? selectedLayer;

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Map Layers",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              "We uses flutter_map package to perform map operations. You can find more information about it "
              "here: https://pub.dev/packages/flutter_map",
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 8,
              textAlign: TextAlign.justify,
            ),
            Text(
              "But, we also have different layers support for different map providers. So, how can we support all "
              "of them? Easy! We create a wrapper! Only we provide a list of wrappers to a `ThemedMapLayer` widget "
              "and automatically it will detect which one to use, of course the widget take the first one if the "
              "default value is not provided, and automatically add the layer selector on the right-bottom corner "
              "of the map. If you don't provide a list of layers, the widget will use the default one, which is "
              "OpenStreetMap.",
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 8,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),
            Container(
              decoration: generateContainerElevation(context: context),
              height: 600,
              clipBehavior: Clip.antiAlias,
              child: FlutterMap(
                options: const MapOptions(
                  initialCenter: kGoldenMHeadquarters,
                  initialZoom: 13,
                ),
                children: [
                  ThemedTileLayer(layer: selectedLayer),
                  ThemedMapToolbar(
                    layers: layers,
                    selectedLayer: selectedLayer,
                    onLayerChanged: (layer) => setState(() => selectedLayer = layer),
                    position: Alignment.bottomLeft,
                    // flow: ThemedMapToolbarFlow.horizontal,
                    onZoomIn: () {
                      debugPrint('Zoom in');
                    },
                    onZoomOut: () {
                      debugPrint('Zoom out');
                    },
                    additionalButtons: [
                      ThemedMapButton(
                        labelText: "My custom button",
                        icon: Icons.house,
                        onTap: () {
                          debugPrint('My custom button');
                        },
                      ),
                      ThemedMapButton(
                        labelText: "Beurre Gatún",
                        icon: Icons.abc,
                        onTap: () {
                          debugPrint('My custom button');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
