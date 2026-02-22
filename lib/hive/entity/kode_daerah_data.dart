class KodeDaerahData {
  String? kode;
  String? nama;

  KodeDaerahData({
    this.kode,
    this.nama,
  });

  KodeDaerahData.fromJson(Map<String, dynamic> json) {
    kode = json['kode'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kode'] = kode;
    data['nama'] = nama;
    return data;
  }
}
