import 'dart:convert';

import 'package:equatable/equatable.dart';

class KodeDaerahResponse extends Equatable {
  final String? kode;
  final String? nama;

  const KodeDaerahResponse({this.kode, this.nama});

  factory KodeDaerahResponse.fromMap(Map<String, dynamic> data) =>
      KodeDaerahResponse(
        kode: data['kode'] as String?,
        nama: data['nama'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'kode': kode,
        'nama': nama,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [KodeDaerahResponse].
  factory KodeDaerahResponse.fromJson(String data) =>
      KodeDaerahResponse.fromMap(json.decode(data) as Map<String, dynamic>);

  /// `dart:convert`
  ///
  /// Converts [KodeDaerahResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [kode, nama];

  static List<KodeDaerahResponse> fromJsonList(List<dynamic> jsonList) => jsonList
      .map((json) => KodeDaerahResponse.fromJson(jsonEncode(json)))
      .toList();
}