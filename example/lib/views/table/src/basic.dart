part of table;

class BasicTableView extends StatefulWidget {
  final String name;

  const BasicTableView({
    super.key,
    this.name = 'Generic View',
  });

  @override
  State<BasicTableView> createState() => _BasicTableViewState();
}

class _BasicTableViewState extends State<BasicTableView> {
  List<Asset> _items = [];

  @override
  void initState() {
    super.initState();
    _items = List.generate(5000, (i) {
      return Asset(
        id: (i + 1).toString(),
        name: "Asset ${Random().nextInt(20)}",
        plate: 'PLATE${i + 1}',
        vin: 'VIN${i + 1}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ThemedTable<Asset>(
              module: 'assets',
              idLabel: "#ID",
              rowAvatarBuilder: (context, columns, item) => ThemedTableAvatar(label: item.name),
              rowTitleBuilder: (context, columns, item) => Text(item.name),
              rowSubtitleBuilder: (context, columns, item) => Text(item.id),
              idBuilder: (context, item) => item.id,
              enableMultiSelectDialog: true,
              multiSelectionEnabled: true,
              // itemsPerPage: 10,
              idEnabled: false,
              onIdTap: (item) {
                debugPrint("Tapped on ${item.name}");
              },
              items: _items,
              onShow: (context, item) async {
                debugPrint("onShow tapped: $item");
              },
              onAdd: () async {
                debugPrint("onAdd tapped");
              },
              onRefresh: () async {
                for (var i = 0; i < _items.length; i++) {
                  await Future.delayed(const Duration(seconds: 1));
                  debugPrint("Refreshing $i");
                  _items[i] = _items[i].copyWith(
                    telemetry: AssetTelemetry(
                      receivedAt: DateTime.now(),
                      id: '1',
                    ),
                  );
                  setState(() {});
                }
              },
              onEdit: (context, item) async {
                debugPrint("onEdit tapped: $item");
              },
              onDelete: (context, item) async {
                debugPrint("onDelete tapped: $item");
              },
              columns: [
                ThemedColumn(
                  labelText: 'Name',
                  // color: Colors.green,
                  textColor: Colors.blue,
                  valueBuilder: (context, item) => item.name,
                  // cellColor: (item) => Colors.yellow,
                  cellTextColor: (item) => Colors.red,
                  onTap: (item) {
                    debugPrint("Tapped on ${item.name}");
                  },
                ),
                ThemedColumn(
                  labelText: 'Plate',
                  valueBuilder: (context, item) => item.plate ?? 'N/A',
                ),
                ThemedColumn(
                  labelText: 'VIN',
                  valueBuilder: (context, item) => item.vin ?? 'N/A',
                ),
                // ...List.generate(25, (i) {
                //   return ThemedColumn(
                //     labelText: 'VIN $i',
                //     valueBuilder: (context, item) => item.vin ?? 'N/A',
                //   );
                // }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
