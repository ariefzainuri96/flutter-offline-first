import 'package:flutter/material.dart';
import '../../../hive/entity/add_data.dart';
import '../../../cores/widgets/tap_detector.dart';

class PushDataWidget extends StatelessWidget {
  final AddData data;
  final Function onReloadTap;

  const PushDataWidget({
    super.key,
    required this.data,
    required this.onReloadTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(data.nama ?? ''),
                ),
                if (data.status == PushStatus.uploading) ...[
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(),
                  ),
                ],
                if (data.status == PushStatus.idle) ...[
                  TapDetector(
                    onTap: () => onReloadTap.call(),
                    child: const Icon(
                      Icons.upload_outlined,
                      color: Colors.blue,
                    ),
                  ),
                ] else if (data.status == PushStatus.failed) ...[
                  TapDetector(
                    onTap: () => onReloadTap.call(),
                    child: const Icon(
                      Icons.replay_outlined,
                      color: Colors.red,
                    ),
                  ),
                ],
              ],
            ),
            if (data.status != PushStatus.idle)
              Text('${(data.progress ?? 0.0).toStringAsFixed(1)}/100 %'),
          ],
        ),
      );
}
