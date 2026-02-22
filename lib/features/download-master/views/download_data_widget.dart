import 'package:flutter/material.dart';
import '../../../cores/widgets/tap_detector.dart';
import '../model/download_data.dart';

class DownloadDataWidget extends StatelessWidget {
  final DownloadData data;
  final Function onReloadTap;

  const DownloadDataWidget({
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
                  child: Text(data.title ?? ''),
                ),
                if (data.downloadStatus == DownloadStatus.downloading) ...[
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(),
                  ),
                ],
                if (data.downloadStatus == DownloadStatus.success) ...[
                  const Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
                ],
                if (data.downloadStatus == DownloadStatus.empty) ...[
                  TapDetector(
                    onTap: () => onReloadTap.call(),
                    child: const Icon(
                      Icons.download_outlined,
                      color: Colors.blue,
                    ),
                  ),
                ] else if (data.downloadStatus == DownloadStatus.failed) ...[
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
            if (data.downloadStatus != DownloadStatus.empty)
              Text("${data.progress.toStringAsFixed(1)}/100 %"),
          ],
        ),
      );
}
