// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumberList extends StateNotifier<List<int>> {
  NumberList() : super(List.generate(10, (index) => index + 1)..shuffle());

  final List<SwappedIndex> swappedIndices = [];
  int? currentPivotIndex;
  int? currentLeftIndex;
  int? currentRightIndex;

  void generateNumbers(int size) {
    swappedIndices.clear();
    currentPivotIndex = null;
    currentLeftIndex = null;
    currentRightIndex = null;
    state = List.generate(size, (index) => index + 1)..shuffle();
  }

  void sort() async {
    await _quickSort(0, state.length - 1);
  }

  Future<void> _quickSort(int left, int right) async {
    currentLeftIndex = left;
    currentRightIndex = right;

    if (left < right) {
      int pivotIndex = await _partition(left, right);
      await _quickSort(left, pivotIndex - 1);
      await _quickSort(pivotIndex + 1, right);
    }

    currentLeftIndex = null;
    currentRightIndex = null;
    currentPivotIndex = null;
  }

  Future<int> _partition(int left, int right) async {
    int pivotIndex = right;
    currentPivotIndex = pivotIndex;
    int i = left;

    for (int j = left; j < right; j++) {
      if (state[j] < state[pivotIndex]) {
        await _swap(i, j);
        i++;
      }
    }
    await _swap(i, pivotIndex);
    currentPivotIndex = null;
    return i;
  }

  Future<void> _swap(int i, int j) async {
    List<int> newState = List.from(state);
    int temp = newState[i];
    newState[i] = newState[j];
    newState[j] = temp;
    state = newState;
    swappedIndices.add(SwappedIndex(i, j));
    await Future.delayed(const Duration(milliseconds: 5));
    swappedIndices
        .removeWhere((element) => element.index1 == i && element.index2 == j);
  }
}

final numberListProvider = StateNotifierProvider<NumberList, List<int>>(
  (ref) => NumberList(),
);

class SwappedIndex {
  final int index1;
  final int index2;

  SwappedIndex(this.index1, this.index2);

  bool contains(int index) {
    return index1 == index || index2 == index;
  }
}
