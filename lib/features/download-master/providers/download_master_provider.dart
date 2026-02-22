import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import '../../../cores/constants/enums/page_state.dart';
import '../../../hive/entity/kode_daerah_data.dart';
import '../../../hive/hive_helper.dart';
import '../model/download_data.dart';
import '../services/download_master_service.dart';

final downloadMasterProvider =
    NotifierProvider.autoDispose<DownloadMasterNotifier, DownloadMasterData>(
  DownloadMasterNotifier.new,
);

class DownloadMasterNotifier extends Notifier<DownloadMasterData> {
  @override
  DownloadMasterData build() {
    final initialDownloadList = <DownloadData>[
      DownloadData(
        url: 'wilayah/provinsi',
        key: 'data1',
        title: 'Download Data 1',
      ),
      DownloadData(
        url: 'wilayah/provinsi',
        key: 'data2',
        title: 'Download Data 2',
      ),
      DownloadData(
        url: 'wilayah/provinsi',
        key: 'data3',
        title: 'Download Data 3',
      ),
    ];

    // Trigger an async check to update status based on Hive
    Future.microtask(() => _syncWithLocalStorage(initialDownloadList));

    return DownloadMasterData(
      downloadList: initialDownloadList,
      pageState: PageState.loading,
    );
  }

  Future<void> _syncWithLocalStorage(List<DownloadData> currentItems) async {
    state = state.copyWith(pageState: PageState.loading);

    final tasks = <Future<void>>[];

    for (var i = 0; i < currentItems.length; i++) {
      tasks.add(Hive.openBox<KodeDaerahData>(currentItems[i].key ?? ''));
    }

    await Future.wait(tasks);

    final updatedList = currentItems.map((item) {
      final cachedData = HiveHelper.getKodeDaerah(item.key ?? '');

      if (cachedData.isNotEmpty) {
        return item.copyWith(
          downloadStatus: DownloadStatus.success,
          progress: 100,
        );
      }
      return item;
    }).toList();

    state =
        state.copyWith(downloadList: updatedList, pageState: PageState.success);
  }

  void updateDownloadList(List<DownloadData> value) {
    state = state.copyWith(downloadList: value);
  }

  Future<void> startDownload(int index) async {
    // 1. Get the target item
    final item = state.downloadList[index];

    // 2. Set initial status to 'downloading'
    _updateItemStatus(index, status: DownloadStatus.downloading, progress: 0.0);

    try {
      if (!Hive.isBoxOpen(item.key ?? '')) {
        await Hive.openBox<KodeDaerahData>(item.key ?? '');
      }

      // 3. Perform the Request
      final response = await ref
          .read(downloadMasterService)
          .getKodeDaerah(state.downloadList[index], (received, total) {
        if (total != -1) {
          // Calculate percentage (0.0 to 1.0)
          final progress = (received / total) * 100;

          // 4. Update State in Real-time
          // Optimization: Only update if progress changed significantly (optional but good for performance)
          _updateItemStatus(
            index,
            status: DownloadStatus.downloading,
            progress: progress,
          );
        }
      });

      final kodeDaerahList = (response ?? []).toSet().toList();

      // 5. Save to Hive (Success)
      await HiveHelper.saveOfflineDataKey(item.key ?? '');
      await HiveHelper.saveKodeDaerah(item.key ?? '', kodeDaerahList);

      // 6. Finalize State
      _updateItemStatus(index,
          status: DownloadStatus.success, progress: 1.0 * 100);
    } catch (e) {
      // 7. Handle Error
      debugPrint('Download error: $e');
      _updateItemStatus(index, status: DownloadStatus.failed, progress: 0.0);
    }
  }

  Future<void> downloadAll() async {
    // 1. Create a list of Futures (tasks)
    final tasks = <Future<void>>[];

    // 2. Loop through all items
    for (int i = 0; i < state.downloadList.length; i++) {
      tasks.add(startDownload(i));
    }

    // 4. Wait for ALL tasks to complete in parallel
    await Future.wait(tasks);

    debugPrint('All downloads completed!');
  }

  void _updateItemStatus(
    int index, {
    required DownloadStatus status,
    required double progress,
  }) {
    // specific item update strategy
    final currentList = state.downloadList;

    // Create a NEW item with updated values
    final updatedItem = currentList[index].copyWith(
      downloadStatus: status,
      progress: progress,
    );

    // Create a NEW list to trigger Riverpod notification
    final newList = List<DownloadData>.from(currentList);
    newList[index] = updatedItem;

    state = state.copyWith(downloadList: newList);
  }
}

class DownloadMasterData {
  List<DownloadData> downloadList = [];
  PageState pageState;

  DownloadMasterData({
    required this.downloadList,
    required this.pageState,
  });

  DownloadMasterData copyWith({
    PageState? pageState,
    List<DownloadData>? downloadList,
  }) =>
      DownloadMasterData(
        pageState: pageState ?? this.pageState,
        downloadList: downloadList ?? this.downloadList,
      );
}
