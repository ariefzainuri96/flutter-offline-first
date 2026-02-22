import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../cores/base/base_service.dart';
import '../model/download_data.dart';
import '../model/kode_daerah_response.dart';

final downloadMasterService = Provider((ref) => DownloadMasterService());

class DownloadMasterService extends BaseService {
  Future<List<KodeDaerahResponse>?> getKodeDaerah(
    DownloadData downloadData,
    Function(int count, int total) onReceiveProgress,
  ) async {
    try {
      Response? response = await getWithProgress(
        url: downloadData.url ?? '',
        onReceiveProgress: onReceiveProgress,
      );

      if (response?.statusCode != 200) return null;

      return KodeDaerahResponse.fromJsonList(response?.data);
    } catch (e) {
      return null;
    }
  }

  Future<List<KodeDaerahResponse>?> getKabupaten(String kode) async {
    try {
      Response? response = await get(
        url: 'wilayah/kabupaten?kode=$kode',
      );

      if (response?.statusCode != 200) return null;

      return KodeDaerahResponse.fromJsonList(response?.data);
    } catch (e) {
      return null;
    }
  }

  Future<List<KodeDaerahResponse>?> getKecamatan(String kode) async {
    try {
      Response? response = await get(
        url: 'wilayah/kecamatan?kode=$kode',
      );

      if (response?.statusCode != 200) return null;

      return KodeDaerahResponse.fromJsonList(response?.data);
    } catch (e) {
      return null;
    }
  }

  Future<List<KodeDaerahResponse>?> getKelurahan(String kode) async {
    try {
      Response? response = await get(
        url: 'wilayah/kelurahan?kode=$kode',
      );

      if (response?.statusCode != 200) return null;

      return KodeDaerahResponse.fromJsonList(response?.data);
    } catch (e) {
      return null;
    }
  }
}
