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
              customTitleText: "Assets",
              rowAvatarBuilder: (context, columns, item) => ThemedTableAvatar(label: item.name),
              rowTitleBuilder: (context, columns, item) => Text(item.name),
              rowSubtitleBuilder: (context, columns, item) => Text(item.id),
              idBuilder: (context, item) => item.id,
              // enablePaginator: false,
              enableMultiSelectDialog: false,
              multiSelectionEnabled: false,
              // shouldExpand: false,
              itemsPerPage: 5,
              forceResync: true,
              idEnabled: false,
              onIdTap: (item) {
                debugPrint("Tapped on ${item.name}");
              },
              items: List.generate(60, (i) {
                return Asset(
                  id: (i + 1).toString(),
                  name: "Asset ${i + 1}",
                  plate: 'PLATE${i + 1}',
                  vin: 'VIN${i + 1}',
                );
              }),
              onShow: (ctx, asset) async {
                return;
              },
              // onEdit: (cxt, asset) async {
              //   return;
              // },
              // onDelete: (cxt, asset) async {
              //   return;
              // },
              columns: [
                ThemedColumn(
                  labelText: 'Name',
                  // color: Colors.green,
                  textColor: Colors.blue,
                  valueBuilder: (context, item) => item.name,
                  // cellColor: (item) => Colors.red.shade100,
                  cellTextColor: (item) => Colors.red.shade900,
                  onTap: (item) {
                    debugPrint("Tapped on ${item.name}");
                  },
                ),
                ThemedColumn(
                  labelText: 'Connection',
                  valueBuilder: (context, item) => item.plate ?? 'N/A',
                  width: 200,
                  widgetBuilder: (context, item) {
                    // return const TelemetryIndicator();
                    return const Text("Hola mundo!");
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
                // ...List.generate(15, (i) {
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

class TelemetryIndicator extends StatefulWidget {
  final DateTime? receivedAt;
  final Connection? connection;

  const TelemetryIndicator({
    super.key,
    this.receivedAt,
    this.connection,
  });

  @override
  State<TelemetryIndicator> createState() => _TelemetryIndicatorState();
}

class _TelemetryIndicatorState extends State<TelemetryIndicator> {
  late Timer timer;
  DateTime now = DateTime.now();

  Widget humanizedTime(LayrzAppLocalizations? i18n) {
    if (widget.receivedAt == null) {
      return const SizedBox();
    }

    final difference = now.difference(widget.receivedAt!).inSeconds;

    if (difference < 59) {
      return Text(i18n?.t('helpers.telemetry.lessThan.minute') ?? 'Now');
    } else if (difference < 3600) {
      int minutes = difference ~/ 60;
      return Text(i18n?.tc('helpers.telemetry.about.minute', minutes, {'count': minutes}) ?? '$minutes minutes');
    } else if (difference < 86400) {
      int hours = difference ~/ 3600;
      return Text(i18n?.tc('helpers.telemetry.about.hour', hours, {'count': hours}) ?? '$hours hours');
    } else {
      int days = difference ~/ 86400;
      return Text(i18n?.tc('helpers.telemetry.about.day', days, {'count': days}) ?? '$days days');
    }
  }

  String get label {
    if (widget.receivedAt == null) {
      return 'helpers.telemetry.disconnected';
    }

    final difference = now.difference(widget.receivedAt!).inSeconds;

    if (difference < (widget.connection?.online?.inSeconds ?? 300)) {
      return 'helpers.telemetry.connected';
    } else if (difference < (widget.connection?.hibernation?.inSeconds ?? 3600)) {
      return 'helpers.telemetry.hibernate';
    } else {
      return 'helpers.telemetry.disconnected';
    }
  }

  Color get color {
    if (widget.receivedAt == null) {
      return Colors.grey.shade600;
    }

    final difference = now.difference(widget.receivedAt!).inSeconds;

    if (difference < 5 * 60) {
      return Colors.green.shade600;
    } else if (difference < 60 * 60) {
      return Colors.orange.shade600;
    } else {
      return Colors.red.shade600;
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(2).add(const EdgeInsets.symmetric(horizontal: 4)),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            i18n?.t(label) ?? label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: validateColor(color: color)),
          ),
        ),
        if (widget.receivedAt != null) ...[
          const Text(" - "),
          humanizedTime(i18n),
        ],
      ],
    );
  }
}
