import 'package:flutter/material.dart';
import 'package:layrz_icons/layrz_icons.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/store/store.dart';

class TestView extends StatefulWidget {
  final String name;

  const TestView({
    super.key,
    this.name = 'Generic View',
  });

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  List<Asset> _items = [];

  int get _it => 14000;

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
    // TextStyle? style = Theme.of(context).textTheme.titleSmall;
    return Layout(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: NewThemedTable<Asset>(
              labelText: "Assets",
              items: _items,
              onShow: (p0, p1) async => debugPrint("Show $p1"),
              onEdit: (p0, p1) async => debugPrint("Edit $p1"),
              onDelete: (p0, p1) async => debugPrint("Delete $p1"),
              addtionalActions: [
                ThemedActionButton(icon: LayrzIcons.faSolidLayerGroup, labelText: "Test", onTap: () {}, onlyIcon: true),
                ThemedActionButton(
                  icon: LayrzIcons.faSolidLayerGroup,
                  color: Colors.teal,
                  labelText: "Test",
                  onlyIcon: true,
                  onTap: () {},
                ),
                ThemedActionButton(
                  icon: LayrzIcons.faSolidLayerGroup,
                  labelText: "Test",
                  color: Colors.blueGrey,
                  onlyIcon: true,

                  onTap: () {},
                ),
              ],

              columns: [
                ThemedColumn2(
                  headerText: 'ID',
                  valueBuilder: (item) => item.id,
                  wantMinWidth: true,
                  // richTextBuilder: (item) => TextSpan(
                  //   text: item.id,
                  //   // style: style,
                  // ),
                ),
                ThemedColumn2(
                  headerText: 'Name',
                  valueBuilder: (item) => item.name,

                  // richTextBuilder: (item) => TextSpan(
                  //   text: item.name,
                  //   // style: style,
                  // ),
                  onTap: (item) {
                    debugPrint("Tapped on ${item.name}");
                  },
                ),
                ThemedColumn2(
                  headerText: 'Plate',

                  // richTextBuilder: (item) => TextSpan(
                  //   text: item.plate ?? 'N/A',
                  //   // style: style,
                  // ),
                  valueBuilder: (item) => item.plate ?? 'N/A',
                ),
                ThemedColumn2(
                  headerText: 'VIN',

                  // richTextBuilder: (item) => TextSpan(
                  //   text: item.vin ?? 'N/A',
                  //   // style: style,
                  // ),
                  valueBuilder: (item) => item.vin ?? 'N/A',
                ),
                ThemedColumn2(
                  headerText: 'Mode',

                  // richTextBuilder: (item) => TextSpan(
                  //   text: item.mode?.name ?? 'N/A',
                  //   // style: style,
                  // ),
                  valueBuilder: (item) => item.mode?.name ?? 'N/A',
                ),
                ThemedColumn2(
                  headerText: 'Kind',
                  valueBuilder: (item) => item.kind?.name ?? 'N/A',
                  // richTextBuilder: (item) => TextSpan(
                  //   text: item.kind?.name ?? 'N/A',
                  //   // style: style,
                  // ),
                ),
                ThemedColumn2(
                  headerText: 'Active Time',
                  valueBuilder: (item) => item.activeTime != null ? item.activeTime.toString() : 'N/A',
                  // richTextBuilder: (item) => TextSpan(
                  //   text: item.activeTime != null ? item.activeTime.toString() : 'N/A',
                  //   // style: style,
                  // ),
                  fixWidth: 250,
                  widgetBuilder: (item) => Row(
                    spacing: 8,
                    children: [
                      Icon(
                        LayrzIcons.mdiClock,
                      ),
                      Text(item.activeTime.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
