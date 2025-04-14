import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shalat_schedule_app/model/listdoa_model.dart';

class ListDoaViewModel extends ChangeNotifier {
  List<ListDoaModel> _listModel = []; // Tidak final agar bisa diperbarui
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ListDoaModel> get listModel => _listModel; // Getter untuk UI

  Future<void> fetchListDoa() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      const url = 'https://doa-doa-api-ahmadramadhan.fly.dev/api/';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Gagal memuat list doa, status code: ${response.statusCode}');
      }

      final List<dynamic> jsonList = json.decode(response.body) ?? [];

      _listModel = jsonList.map((json) => ListDoaModel.fromJson(json)).toList();
      
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.runtimeType} - ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
