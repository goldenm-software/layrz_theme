part of '../table.dart';

class InfinityTableView extends StatefulWidget {
  final String name;

  const InfinityTableView({
    super.key,
    this.name = 'Generic View',
  });

  @override
  State<InfinityTableView> createState() => _InfinityTableViewState();
}

class _InfinityTableViewState extends State<InfinityTableView> {
  List<Asset> _items = [];

  int get _it => 15_000;

  @override
  void initState() {
    super.initState();
    _items = List.generate(_it, (i) => _generateAsset(i));
  }

  Asset _generateAsset(int index) {
    return Asset(
      id: (index + 1).toString(),
      name: (index == 2) ? "Asset asdasfasfasf ${index + 1}" : "Other Asset ${index + 1}",
      plate: 'PLATE${index + 1} testestes',
      vin: 'VIN${index + 1}',
      mode: AssetMode.single,
      kind: Category(id: (index + 1).toString(), name: 'Category ${index + 1}', kind: CategoryKind.asset),
      activeTime: DateTime.now().toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: ThemedTable2<Asset>(
        items: _items,
        actionsBuilder: (Asset item) => [
          ThemedActionButton(
            icon: LayrzIcons.faSolidLayerGroup,
            color: Colors.teal,
            labelText: "Test",

            onTap: () {},
          ),
          ThemedActionButton(
            icon: LayrzIcons.faSolidLayerGroup,
            labelText: "Test",
            color: Colors.blueGrey,

            onTap: () {},
          ),
          ThemedActionButton(
            icon: LayrzIcons.faSolidLayerGroup,
            labelText: "Test",
            onTap: () {},
          ),
        ],

        columns: [
          ThemedColumn2(
            headerText: 'ID',
            valueBuilder: (item) => item.id,
          ),
          ThemedColumn2(
            headerText: 'Name',
            valueBuilder: (item) => item.name,
            onTap: (item) {
              debugPrint("Tapped on ${item.name}");
            },
          ),
          ThemedColumn2(
            headerText: 'Plate',

            valueBuilder: (item) => item.plate ?? 'N/A',
          ),
          ThemedColumn2(
            headerText: 'VIN',
            valueBuilder: (item) => item.vin ?? 'N/A',
          ),
          ThemedColumn2(
            headerText: 'Mode',
            valueBuilder: (item) => item.mode?.name ?? 'N/A',
          ),
          ThemedColumn2(
            headerText: 'Kind',
            valueBuilder: (item) => item.kind?.name ?? 'N/A',
          ),
          ThemedColumn2(
            headerText: 'Kind',
            valueBuilder: (item) => item.kind?.name ?? 'N/A',
          ),
          ThemedColumn2(
            headerText: 'Kind',
            valueBuilder: (item) => item.kind?.name ?? 'N/A',
          ),
          ThemedColumn2(
            headerText: 'Kind',
            valueBuilder: (item) => item.kind?.name ?? 'N/A',
          ),
          ThemedColumn2(
            headerText: 'Kind',
            valueBuilder: (item) => item.kind?.name ?? 'N/A',
          ),
          ThemedColumn2(
            headerText: 'Active Time',
            valueBuilder: (item) => item.activeTime != null ? item.activeTime.toString() : 'N/A',
            fixedWidth: 250,
            richTextBuilder: (item) => [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(
                    LayrzIcons.mdiClock,
                    size: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              TextSpan(text: item.activeTime.toString()),
            ],
          ),
          ThemedColumn2(
            headerText: 'Kind',
            valueBuilder: (item) => item.kind?.name ?? 'N/A',
          ),
          ThemedColumn2(
            headerText: 'Kind',
            valueBuilder: (item) => item.kind?.name ?? 'N/A',
          ),
          ThemedColumn2(
            headerText: 'Kind',
            valueBuilder: (item) => item.kind?.name ?? 'N/A',
          ),
          ThemedColumn2(
            headerText: 'Kind',
            valueBuilder: (item) => item.kind?.name ?? 'N/A',
          ),
        ],
      ),
    );
  }
}
