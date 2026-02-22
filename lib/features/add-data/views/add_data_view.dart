import 'package:flutter/material.dart';
import '../../../cores/base/base_provider_view.dart';
import '../../../cores/constants/colors.dart';
import '../../../cores/constants/enums/page_state.dart';
import '../../../hive/entity/kode_daerah_data.dart';
import '../../../cores/utils/widget_extension.dart';
import '../../../cores/widgets/buttons/custom_elevated_button.dart';
import '../../../cores/widgets/custom_dropdown.dart';
import '../../../cores/widgets/custom_text_field.dart';
import '../../../cores/widgets/text_app_bar.dart';
import '../providers/add_data_provider.dart';

class AddDataView extends StatelessWidget {
  const AddDataView({super.key});

  @override
  Widget build(BuildContext context) => BaseProviderView(
        provider: addDataProvider,
        appBar: (_, __) => const TextAppBar(
          title: 'Add Data',
          isCenterTitle: true,
          shouldShowLeading: true,
        ),
        builder: _buildScreen,
      );

  Widget _buildScreen(
    BuildContext context,
    AddNotifierData data,
    AddDataNotifier vm,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              hint: 'Enter the name...',
              labelText: 'Name',
              showAsterisk: true,
              filledColor: colors.grey2,
              onChanged: (value) {
                final updated = data.addData.copyWith(nama: value);
                vm.updateAddData(updated);
              },
            ).padOnly(bottom: 12),
            if (data.listKodeDaerahData.isEmpty) ...[
              const Text(
                  'Data kosong, Silahkan download terlebih dahulu pada halaman Download Master!'),
            ] else ...[
              CustomDropdown<KodeDaerahData>(
                hintText: 'Pilih Daerah...',
                selectedValue: data.addData.daerah,
                items: data.listKodeDaerahData,
                contentBuilder: (item) => Text(item.nama ?? ''),
                onChanged: (value) {
                  final updated = data.addData.copyWith(daerah: value!);
                  vm.updateAddData(updated);
                },
              ),
            ],
            const Spacer(),
            CustomElevatedButton(
              width: double.infinity,
              isLoading: data.addDataState == PageState.loading,
              text: 'Tambah Data',
              onPressed: data.addData.isFilled()
                  ? () {
                      vm.saveData();
                    }
                  : null,
            ).padSymmetric(vertical: 12),
            SizedBox(height: 16),
          ],
        ),
      );
}
