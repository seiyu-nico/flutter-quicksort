// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:flutter_quicksort/providers/number_list_provider.dart';

class NumberListDisplay extends ConsumerWidget {
  const NumberListDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numbers = ref.watch(numberListProvider);
    final maxNumber = numbers.maxOrNull;
    final swappedIndices =
        ref.watch(numberListProvider.notifier).swappedIndices;
    final currentPivotIndex =
        ref.watch(numberListProvider.notifier).currentPivotIndex;
    final currentLeftIndex =
        ref.watch(numberListProvider.notifier).currentLeftIndex;
    final currentRightIndex =
        ref.watch(numberListProvider.notifier).currentRightIndex;

    return LayoutBuilder(
      builder: (context, constraints) {
        const double marginRight = 1;
        final blockSize =
            (constraints.maxWidth - (numbers.length * marginRight)) /
                numbers.length;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: numbers.asMap().entries.map<Widget>((entry) {
            int index = entry.key;
            int number = entry.value;
            Color color;
            Color? backgroundColor;
            BorderSide? borderTop;

            if (currentPivotIndex == index) {
              color = Colors.red;
              borderTop = const BorderSide(width: 2, color: Colors.orange);
            } else if (swappedIndices.any((swapped) =>
                swapped.contains(index) && swapped.index1 != swapped.index2)) {
              color = Colors.green;
            } else {
              color = Colors.blue;
            }

            if (currentLeftIndex != null &&
                currentRightIndex != null &&
                index >= currentLeftIndex &&
                index <= currentRightIndex) {
              backgroundColor = Colors.yellow.withOpacity(0.2);
            }

            return Container(
              color: backgroundColor,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: (constraints.maxHeight / maxNumber!) * number,
                  width: blockSize,
                  margin: const EdgeInsets.only(right: marginRight),
                  decoration: BoxDecoration(
                    color: color,
                    border: Border(top: borderTop ?? BorderSide.none),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
