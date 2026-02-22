import 'package:flutter/material.dart';
import '../../../cores/base/base_provider_view.dart';
import '../../../cores/routers/router_constant.dart';
import '../../../cores/utils/navigation_service.dart';
import '../../../cores/widgets/buttons/custom_elevated_button.dart';
import '../../../cores/widgets/tap_detector.dart';
import '../../../cores/widgets/text_app_bar.dart';
import '../../../hive/hive_helper.dart';
import '../model/download_data.dart';
import '../providers/download_master_provider.dart';
import 'download_data_widget.dart';

class DownloadMasterView extends StatelessWidget {
  const DownloadMasterView({super.key});

  @override
  Widget build(BuildContext context) => BaseProviderView(
        provider: downloadMasterProvider,
        appBar: (_, __) => TextAppBar(
          title: 'Download Master Data',
          isCenterTitle: false,
          shouldShowLeading: false,
          actions: [
            TapDetector(
              onTap: () => NavigationService.pushNamed(Routes.pushData),
              child: const Icon(
                Icons.upload_outlined,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            TapDetector(
              onTap: () => NavigationService.pushNamed(Routes.addData),
              child: const Icon(
                Icons.add,
              ),
            ),
          ],
        ),
        builder: _buildScreen,
      );

  Widget _buildScreen(
    BuildContext context,
    DownloadMasterData data,
    DownloadMasterNotifier vm,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  final item = data.downloadList[index];

                  return DownloadDataWidget(
                    data: item,
                    onReloadTap: () => vm.startDownload(index),
                  );
                },
                itemCount: data.downloadList.length,
                separatorBuilder: (BuildContext context, int index) => const Divider(
                  height: 1,
                ),
              ),
            ),
            CustomElevatedButton(
              width: double.infinity,
              text: 'Download All',
              isLoading: data.downloadList
                  .any((x) => x.downloadStatus == DownloadStatus.downloading),
              onPressed: () => vm.downloadAll(),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomElevatedButton(
              width: double.infinity,
              text: 'Clear Data',
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // set your yellow color here
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              isLoading: data.downloadList
                  .any((x) => x.downloadStatus == DownloadStatus.downloading),
              onPressed: () async {
                await HiveHelper.clearOfflineData();

                final newList = data.downloadList
                    .map(
                      (x) => x.copyWith(
                        downloadStatus: DownloadStatus.empty,
                        progress: 0.0,
                      ),
                    )
                    .toList();

                vm.updateDownloadList(newList);
              },
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      );
}
