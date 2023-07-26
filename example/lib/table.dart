import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';

class TableView extends StatefulWidget {
  final String name;

  const TableView({
    super.key,
    this.name = 'Generic View',
  });

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  late DateTime now;
  List<int> selected = [];
  List<ThemedSelectItem<int>> get choices => [];

  @override
  void initState() {
    super.initState();
    now = DateTime.now();

    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) setState(() => now = DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      showDrawer: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ThemedTable<Asset>(
              module: 'assets',
              rowAvatarBuilder: (context, columns, item) => ThemedTableAvatar(
                label: item.name,
              ),
              rowTitleBuilder: (context, columns, item) => Text(item.name),
              rowSubtitleBuilder: (context, columns, item) => Text(item.id),
              idBuilder: (context, item) => item.id,
              items: List.generate(1000, (i) {
                return Asset(
                    id: (i + 1).toString(),
                    name: "Asset ${i + 1}",
                    telemetry: AssetTelemetry(
                      id: (i + 1).toString(),
                      receivedAt: Random().nextDouble() > 0.5
                          ? now
                          : DateTime(
                              2022,
                            ),
                    ));
              }),
              onShow: (ctx, asset) async {
                return;
              },
              columns: [
                ThemedColumn(
                  labelText: 'ID',
                  valueBuilder: (context, item) => item.id,
                  customSortingFunction: (a, b) {
                    int aId = int.tryParse(a.id) ?? 0;
                    int bId = int.tryParse(b.id) ?? 0;
                    return aId.compareTo(bId);
                  },
                ),
                ThemedColumn(
                  labelText: 'Name',
                  valueBuilder: (context, item) => item.name,
                ),
                ThemedColumn(
                  labelText: 'Connection',
                  valueBuilder: (context, item) => 'N/A',
                  widgetBuilder: (context, item) {
                    return TelemetryIndicator(
                      receivedAt: item.telemetry?.receivedAt,
                    );
                  },
                  customSortingFunction: (a, b) {
                    double aReceivedAt = a.telemetry?.receivedAt.secondsSinceEpoch.toDouble() ?? 0;
                    double bReceivedAt = b.telemetry?.receivedAt.secondsSinceEpoch.toDouble() ?? 0;
                    return aReceivedAt.compareTo(bReceivedAt);
                  },
                ),
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
