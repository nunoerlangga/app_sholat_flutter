import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shalat_schedule_app/model/doa_model.dart';

class DoaViewModel extends ChangeNotifier {
  DoaModel? _doaSebelum;
  DoaModel? _doaSekarang;
  DoaModel? _doaSesudah;
  bool _isLoading = false;
  String? _errorMessage;

  DoaModel? get doaSebelum => _doaSebelum;
  DoaModel? get doaSekarang => _doaSekarang;
  DoaModel? get doaSesudah => _doaSesudah;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDoa(int idSekarang, int idSebelum, int idSetelah,) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final urlSebelum =
          'https://doa-doa-api-ahmadramadhan.fly.dev/api/$idSebelum';
      final urlSekarang =
          'https://doa-doa-api-ahmadramadhan.fly.dev/api/$idSekarang';
      final urlSesudah =
          'https://doa-doa-api-ahmadramadhan.fly.dev/api/$idSetelah';

      final responses = await Future.wait([
        http.get(Uri.parse(urlSebelum)),
        http.get(Uri.parse(urlSekarang)),
        http.get(Uri.parse(urlSesudah)),
      ]);

      // Periksa apakah ada error dalam response
      if (responses.any((response) => response.statusCode != 200)) {
        throw 'Gagal memuat salah satu doa';
      }

      // Parse JSON
      final jsonSebelum = json.decode(responses[0].body);
      final jsonSekarang = json.decode(responses[1].body);
      final jsonSesudah = json.decode(responses[2].body);

      // Simpan data ke model
      _doaSebelum = DoaModel.fromJson(
          jsonSebelum is List ? jsonSebelum.first : jsonSebelum);
      _doaSekarang = DoaModel.fromJson(
          jsonSekarang is List ? jsonSekarang.first : jsonSekarang);
      _doaSesudah = DoaModel.fromJson(
          jsonSesudah is List ? jsonSesudah.first : jsonSesudah);
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
