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

  int get _it => 100;

  @override
  void initState() {
    super.initState();
    _items = List.generate(_it, (i) => _generateAsset(i));
  }

  Asset _generateAsset(int index) {
    return Asset(
      id: (index + 1).toString(),
      name: "Asset ${index + 1}",
      plate: 'PLATE${index + 1}',
      vin: 'VIN${index + 1}',
    );
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
              idBuilder: (context, item) => item.id,
              enableMultiSelectDialog: true,
              multiSelectionEnabled: true,
              idEnabled: true,
              disablePaginator: false,
              onIdTap: (item) {
                debugPrint("Tapped on ${item.id}");
              },
              items: _items,
              onShow: (context, item) async {
                debugPrint("onShow tapped: $item");
              },
              onAdd: () async {
                _items.add(_generateAsset(_items.length));
                setState(() {});
              },
              onRefresh: () async {
                _items = List.generate(_it, (i) => _generateAsset(i));
                setState(() {});
              },
              onEdit: (context, item) async {
                debugPrint("onEdit tapped: $item");
              },
              onDelete: (context, item) async {
                _items.removeWhere((element) => element.id == item.id);
                setState(() {});
              },
              onMultiDelete: (context, items) async {
                List<String> pks = items.map((e) => e.id).toList();
                _items.removeWhere((element) => pks.contains(element.id));
                setState(() {});
                return true;
              },
              columns: [
                ThemedColumn(
                  labelText: 'Name',
                  // color: Colors.green,
                  textColor: Colors.blue,
                  valueBuilder: (context, item) => item.name,
                  widgetBuilder: (context, item) => Text(item.name),
                  width: 200,
                  // cellColor: (item) => Colors.yellow,
                  cellTextColor: (item) => Colors.red,
                  onTap: (item) {
                    debugPrint("Tapped on ${item.name}");
                  },
                ),
                // ThemedColumn(
                //   labelText: 'Plate',
                //   valueBuilder: (context, item) => item.plate ?? 'N/A',
                // ),
                // ThemedColumn(
                //   labelText: 'VIN',
                //   valueBuilder: (context, item) => item.vin ?? 'N/A',
                // ),
                // ...List.generate(20, (i) {
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
