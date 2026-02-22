import '../../cores/utils/string_extension.dart';
import 'kode_daerah_data.dart';

class AddData {
  KodeDaerahData? daerah;
  String? nama;
  PushStatus? status = PushStatus.idle;
  double? progress;

  AddData({
    this.daerah,
    this.nama,
    this.status = PushStatus.idle,
    this.progress,
  });

  AddData.fromJson(Map<String, dynamic> json) {
    daerah =
        json['daerah'] != null ? KodeDaerahData.fromJson(json['daerah']) : null;
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['daerah'] = daerah?.toJson();
    data['nama'] = nama;
    return data;
  }

  AddData copyWith({
    KodeDaerahData? daerah,
    String? nama,
    PushStatus? status,
    double? progress,
  }) =>
      AddData(
        daerah: daerah ?? this.daerah,
        nama: nama ?? this.nama,
        status: status ?? this.status,
        progress: progress ?? this.progress,
      );

  bool isFilled() => daerah != null && nama?.isNotNullOrEmpty == true;
}

enum PushStatus { uploading, success, failed, idle }
