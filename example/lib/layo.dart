import 'dart:async';

import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';

class LayoView extends StatefulWidget {
  final String name;

  const LayoView({
    super.key,
    this.name = 'Generic View',
  });

  @override
  State<LayoView> createState() => _LayoViewState();
}

class _LayoViewState extends State<LayoView> {
  List<int> selected = [];
  List<ThemedSelectItem<int>> get choices => [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      debugPrint("Tick on LayoView");
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      showDrawer: true,
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const ThemedGridDelegateWithFixedHeight(crossAxisCount: 2, height: 140),
        itemCount: LayoEmotions.values.length,
        itemBuilder: (context, index) {
          final emotion = LayoEmotions.values[index];

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: generateContainerElevation(context: context, elevation: 3),
              child: InkWell(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Layo(
                            size: 500,
                            emotion: emotion,
                            elevation: 5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Layo(
                        size: 100,
                        emotion: emotion,
                        elevation: 5,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text("$emotion"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
