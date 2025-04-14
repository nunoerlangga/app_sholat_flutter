

part of '../shared/pages_shared.dart';

class KotaViewModel extends ChangeNotifier {
  List<KotaModel> _kotaModel = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<KotaModel> get kotaModel => _kotaModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchKota() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      const url = 'https://api.myquran.com/v2/sholat/kota/semua';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Pastikan JSON memiliki key "data" yang berisi List
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          final List<dynamic> kotaList = jsonData['data'];
          _kotaModel = kotaList.map((data) => KotaModel.fromJson(data)).toList();
        } else {
          _errorMessage = 'Data tidak valid';
        }
      } else {
        _errorMessage = 'Gagal memuat data kota. Status code: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
