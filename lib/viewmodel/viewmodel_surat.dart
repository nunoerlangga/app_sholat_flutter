import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shalat_schedule_app/model/surat_model.dart';

class SuratViewModel extends ChangeNotifier {
  SuratModel? _surat; // Ubah dari List ke single object
  bool _isLoading = false;
  String? _errorMessage;

  SuratModel? get surat => _surat; // Getter untuk surah
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSurat(int nomor) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = "https://equran.id/api/v2/surat/$nomor";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Pastikan JSON memiliki struktur yang benar
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          _surat = SuratModel.fromJson(jsonData['data']); // Ambil objek "data"
          if (_surat?.audioFull != null) {
            if (kDebugMode) {
              print("Audio URL: ${_surat!.audioFull}");
            }
          } else {
            if (kDebugMode) {
              print("Audio tidak ditemukan");
            }
          }
        } else {
          _errorMessage = 'Data tidak valid';
        }
      } else {
        _errorMessage = 'Gagal memuat data. Status: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
