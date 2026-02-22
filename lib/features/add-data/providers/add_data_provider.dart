import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../cores/constants/enums/page_state.dart';
import '../../../hive/entity/add_data.dart';
import '../../../hive/entity/kode_daerah_data.dart';
import '../../../hive/hive_helper.dart';

final addDataProvider =
    NotifierProvider.autoDispose<AddDataNotifier, AddNotifierData>(
  AddDataNotifier.new,
);

class AddDataNotifier extends Notifier<AddNotifierData> {
  @override
  AddNotifierData build() => AddNotifierData(
        addData: AddData(),
        addDataState: PageState.initial,
        listKodeDaerahData: HiveHelper.getKodeDaerah('data1'),
      );

  Future<void> saveData() async {
    try {
      state = state.copyWith(addDataState: PageState.loading);
      await HiveHelper.saveData(state.addData);
      state = state.copyWith(addDataState: PageState.success);

      debugPrint('Data saved successfully!');
    } catch (e) {
      debugPrint('Error saving data: $e');
    }
  }

  void updateAddData(AddData value) => state = state.copyWith(addData: value);
}

class AddNotifierData {
  PageState addDataState;
  AddData addData;
  List<KodeDaerahData> listKodeDaerahData = [];

  AddNotifierData({
    required this.addDataState,
    required this.addData,
    required this.listKodeDaerahData,
  });

  AddNotifierData copyWith({
    PageState? addDataState,
    AddData? addData,
    List<KodeDaerahData>? listKodeDaerahData,
  }) =>
      AddNotifierData(
        addDataState: addDataState ?? this.addDataState,
        addData: addData ?? this.addData,
        listKodeDaerahData: listKodeDaerahData ?? this.listKodeDaerahData,
      );
}
