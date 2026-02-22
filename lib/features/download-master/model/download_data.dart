class DownloadData {
  String? url;
  String? title;
  String? key;
  double progress;
  DownloadStatus downloadStatus;

  DownloadData({
    required this.url,
    required this.title,
    required this.key,
    this.progress = 0,
    this.downloadStatus = DownloadStatus.empty,
  });

  DownloadData copyWith({
    String? url,
    String? title,
    String? key,
    double? progress,
    DownloadStatus? downloadStatus,
  }) =>
      DownloadData(
        url: url ?? this.url,
        title: title ?? this.title,
        key: key ?? this.key,
        progress: progress ?? this.progress,
        downloadStatus: downloadStatus ?? this.downloadStatus,
      );
}

enum DownloadStatus { downloading, failed, success, empty, idle }
