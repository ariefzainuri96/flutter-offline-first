import 'package:flutter/material.dart';
import '../../../cores/base/base_provider_view.dart';
import '../../../hive/entity/add_data.dart';
import '../../../cores/widgets/buttons/button.dart';
import '../../../cores/widgets/text_app_bar.dart';
import '../providers/push_data_provider.dart';
import 'push_data_widget.dart';

class PushDataView extends StatelessWidget {
  const PushDataView({super.key});

  @override
  Widget build(BuildContext context) => BaseProviderView(
        provider: pushDataProvider,
        appBar: (_, __) => const TextAppBar(
          title: 'Push Data',
          isCenterTitle: false,
          shouldShowLeading: true,
        ),
        builder: _buildScreen,
      );

  Widget _buildScreen(
    BuildContext context,
    PushNotifierData data,
    PushDataNotifier vm,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: data.listSavedData.isEmpty
                  ? const Center(child: Text('Data Kosong'))
                  : ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        final item = data.listSavedData[index];

                        return PushDataWidget(
                          data: item,
                          onReloadTap: () async {
                            bool success = await vm.pushData(index);

                            if (success) await vm.removeSavedData(index);
                          },
                        );
                      },
                      itemCount: data.listSavedData.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(height: 1),
                    ),
            ),
            if (data.listSavedData.isNotEmpty)
              Button(
                width: double.infinity,
                text: 'Push All',
                isLoading: data.listSavedData
                    .any((x) => x.status == PushStatus.uploading),
                onPressed: () {
                  vm.pushAllData();
                },
              ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      );
}
