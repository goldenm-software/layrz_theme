part of '../chips.dart';

class ThemedChipGroup extends StatelessWidget {
  final List<ThemedChip> chips;
  final ThemedChipGroupBehavior behavior;
  final double spacing;

  const ThemedChipGroup({
    super.key,
    required this.chips,
    this.behavior = .scrollable,
    this.spacing = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(
          constraints.maxWidth != double.infinity,
          'ThemedChipGroup with clampWidth behavior requires a finite maxWidth constraint.',
        );

        if (behavior == .scrollable) {
          return SingleChildScrollView(
            child: Row(spacing: spacing, children: chips),
          );
        }

        double takenWidth = 0;

        List<Widget> visibleChips = [];
        double requiredRemainingWidth = ThemedChip(
          labelText: '+9',
          style: ThemedChipStyle.filledTonal,
          color: Colors.grey,
        ).computeWidth(context);
        for (final entry in chips.asMap().entries) {
          final chip = entry.value;

          double width = chip.computeWidth(context);
          if (entry.key < chips.length - 1) width += spacing;
          takenWidth += width;
          if (entry.key == chips.length - 1) requiredRemainingWidth = 0;
          if (takenWidth + requiredRemainingWidth < constraints.maxWidth) {
            visibleChips.add(chip);
          } else {
            int remaining = chips.length - visibleChips.length;
            if (remaining > 0) {
              final clampedRemaining = remaining.clamp(1, 9);
              // Get the difference between the current chips and visible chips to display the label
              List<ThemedChip> remainingChips = chips.sublist(visibleChips.length);

              visibleChips.add(
                ThemedTooltip(
                  color: Colors.grey,
                  position: .top,
                  message: remainingChips.map((e) => e.labelText ?? e.content).join('\n'),
                  child: ThemedChip(
                    labelText: '+$clampedRemaining',
                    style: ThemedChipStyle.filledTonal,
                    color: Colors.grey,
                  ),
                ),
              );
            }
            break;
          }
        }

        return SingleChildScrollView(
          child: Row(spacing: spacing, children: visibleChips),
        );
      },
    );
  }
}

enum ThemedChipGroupBehavior {
  /// [.scrollable] makes the chip group scrollable horizontally.
  scrollable,

  /// [.clampWidth] makes the chip group clamp its width to the available space.
  /// After reaching the max width, at the end will be a `+N` indicator.
  ///
  /// This behavior is not 100% perfect, as it calculates the width of each chip
  /// individually, so in some cases, the `+N` chip may not appear when expected.
  ///
  /// Also, it's high cost in terms of performance, so use it wisely.
  clampWidth,
}
