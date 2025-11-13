part of '../../map.dart';

class ThemedChangeLayerDialog extends StatefulWidget {
  /// [saveLabelText] defines the text to show on the save button.
  /// By default is `Save`.
  final String saveLabelText;

  /// [cancelLabelText] defines the text to show on the cancel button.
  /// By default is `Cancel`.
  final String cancelLabelText;

  /// [layers] defines the list of layers to show.
  final List<MapLayer> layers;

  /// [currentLayer] defines the current layer selected.
  final MapLayer? currentLayer;

  /// [title] defines the title of the dialog.
  /// By default is `Change Layer`.
  final String title;

  /// [ThemedChangeLayerDialog] is a dialog to change the layer of the map.
  /// You must provide the [layers] and the [currentLayer] to show the dialog.
  /// The return value is the new layer selected or null if the user cancel the dialog.
  const ThemedChangeLayerDialog({
    super.key,
    this.saveLabelText = 'Save',
    this.cancelLabelText = 'Cancel',
    required this.layers,
    this.currentLayer,
    this.title = 'Change Layer',
  });

  @override
  State<ThemedChangeLayerDialog> createState() => _ThemedChangeLayerDialogState();
}

class _ThemedChangeLayerDialogState extends State<ThemedChangeLayerDialog> {
  MapLayer? selectedLayer;

  @override
  void initState() {
    super.initState();
    selectedLayer = widget.currentLayer;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const .all(20),
        decoration: generateContainerElevation(context: context, elevation: 4),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: .bold, fontSize: 20),
            ),
            const SizedBox(height: 10),

            /// List of layers
            ThemedSelectInput<MapLayer?>(
              items: widget.layers.map((layer) {
                return ThemedSelectItem(
                  value: layer,
                  label: layer.name,
                );
              }).toList(),
              labelText: widget.title,
              padding: .zero,
              value: selectedLayer,
              onChanged: (value) => setState(() => selectedLayer = value?.value),
              hideDetails: true,
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                ThemedButton(
                  style: .text,
                  labelText: widget.cancelLabelText,
                  color: Colors.red,
                  onTap: () => Navigator.of(context).pop(),
                ),
                ThemedButton(
                  labelText: widget.saveLabelText,
                  color: Colors.green,
                  onTap: () => Navigator.of(context).pop(selectedLayer),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
