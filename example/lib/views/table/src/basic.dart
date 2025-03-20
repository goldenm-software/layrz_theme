part of '../table.dart';

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

  int get _it => 1;

  @override
  void initState() {
    super.initState();
    _items = List.generate(_it, (i) => _generateAsset(i));
  }

  Asset _generateAsset(int index) {
    return Asset(
      id: (index + 1).toString(),
      name: "Asset ${index + 1} asdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
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
                  valueBuilder: (context, item) => item.name,
                  richTextBuilder: (context, item) {
                    return [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: item.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ];
                  },
                  width: 200,
                  // cellColor: (item) => Colors.yellow,
                  cellTextColor: (item) => Colors.red,
                  onTap: (item) {
                    debugPrint("Tapped on ${item.name}");
                  },
                ),
                ...List.generate(20, (i) {
                  return ThemedColumn(
                    labelText: 'VIN $i',
                    valueBuilder: (context, item) => item.vin ?? 'N/A',
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
