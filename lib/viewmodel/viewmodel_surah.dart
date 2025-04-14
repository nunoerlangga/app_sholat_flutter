import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shalat_schedule_app/model/surah_model.dart';

class SurahViewModel extends ChangeNotifier {
  List<SurahModel> _surah = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SurahModel> get surah => _surah;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSurah() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      const url = 'https://equran.id/api/v2/surat/';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Mengambil data list dari API
        final List<dynamic> surahList = jsonData['data'];

        // Mapping ke List<SurahModel>
        _surah = surahList.map((json) => SurahModel.fromJson(json)).toList();
      } else {
        _errorMessage =
            'Failed to load surah. Status code: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
