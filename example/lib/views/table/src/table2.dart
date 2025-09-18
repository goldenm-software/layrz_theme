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
  // int get _it => 100;

  final ValueNotifier<DateTime> _now = ValueNotifier(DateTime.now());
  late final Timer timer;
  @override
  void initState() {
    super.initState();
    _items = List.generate(_it, (i) => _generateAsset(i));

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _now.value = DateTime.now();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
        actionsCount: 3,
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
            width: 80,
            valueBuilder: (item) => item.id,
          ),
          ThemedColumn2(
            headerText: 'Name',
            valueBuilder: (item) => item.name,
            width: 200,
          ),
          ThemedColumn2(
            headerText: 'Plate',
            valueBuilder: (item) => item.plate ?? 'N/A',
          ),
          // ...List.generate(10, (index) {
          //   return ThemedColumn2(
          //     width: 100,
          //     headerText: 'Column ${index + 1}',
          //     valueBuilder: (item) => 'Data ${index + 1}',
          //   );
          // }),
          ThemedColumn2(
            headerText: 'VIN',
            valueBuilder: (item) => '${item.vin}',
            width: 250,
            richTextBuilder: (item) => [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(color: Colors.green, width: 8, height: 8, margin: const EdgeInsets.only(right: 6)),
              ),
              WidgetSpan(
                child: ValueListenableBuilder(
                  valueListenable: _now,
                  builder: (context, value, child) {
                    return Text('${item.vin} - ${value.hour}:${value.minute}:${value.second}');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
