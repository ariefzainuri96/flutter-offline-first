import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../cores/constants/enums/page_state.dart';
import '../../../hive/entity/add_data.dart';
import '../../../hive/hive_helper.dart';

final pushDataProvider =
    NotifierProvider.autoDispose<PushDataNotifier, PushNotifierData>(
  PushDataNotifier.new,
);

class PushDataNotifier extends Notifier<PushNotifierData> {
  @override
  PushNotifierData build() => PushNotifierData(
        listSavedData: HiveHelper.getData(),
        pushState: PageState.initial,
        succesfullDeletedData: [],
      );

  Future<void> removeSavedData(int index) async {
    await HiveHelper.removeData(index);
    state = state.copyWith(listSavedData: HiveHelper.getData());
  }

  Future<bool> pushData(int index) async {
    try {
      _updateItemStatus(index,
          status: PushStatus.uploading, progress: 0.5 * 100);
      await Future.delayed(const Duration(seconds: 1));
      _updateItemStatus(index, status: PushStatus.success, progress: 1.0 * 100);

      state = state.copyWith(
        succesfullDeletedData: [
          ...state.succesfullDeletedData,
          state.listSavedData[index].nama ?? '',
        ],
      );
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> pushAllData() async {
    // 1. Create a list of Futures (tasks)
    final tasks = <Future<void>>[];

    // 2. Loop through all items
    for (int i = 0; i < state.listSavedData.length; i++) {
      tasks.add(pushData(i));
    }

    // 4. Wait for ALL tasks to complete in parallel
    await Future.wait(tasks);

    debugPrint('All uploads completed!');

    List<AddData> remainingSavedData = List.from(state.listSavedData);

    for (int i = 0; i < state.succesfullDeletedData.length; i++) {
      final itemTitle = state.succesfullDeletedData[i];

      remainingSavedData.removeWhere((e) => e.nama == itemTitle);
    }

    await HiveHelper.saveAllData(remainingSavedData);
    state = state.copyWith(listSavedData: HiveHelper.getData());
  }

  void _updateItemStatus(
    int index, {
    required PushStatus status,
    required double progress,
  }) {
    // specific item update strategy
    final currentList = state.listSavedData;

    // Create a NEW item with updated values
    final updatedItem = currentList[index].copyWith(
      status: status,
      progress: progress,
    );

    // Create a NEW list to trigger Riverpod notification
    final newList = List<AddData>.from(currentList);
    newList[index] = updatedItem;

    state = state.copyWith(listSavedData: newList);
  }
}

class PushNotifierData {
  List<AddData> listSavedData = [];
  PageState pushState;
  List<String> succesfullDeletedData = [];

  PushNotifierData({
    required this.listSavedData,
    required this.pushState,
    required this.succesfullDeletedData,
  });

  PushNotifierData copyWith({
    PageState? pushState,
    List<AddData>? listSavedData,
    List<String>? succesfullDeletedData,
  }) =>
      PushNotifierData(
        pushState: pushState ?? this.pushState,
        listSavedData: listSavedData ?? this.listSavedData,
        succesfullDeletedData:
            succesfullDeletedData ?? this.succesfullDeletedData,
      );
}
