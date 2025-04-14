

part of '../shared/pages_shared.dart';


class ScheduleViewModel extends ChangeNotifier{
  ScheduleModel? _schedule;
  bool _isLoading = false;
  String? _errorMessage;

  ScheduleModel? get schedule => _schedule;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSholatSchedule(
    String locationId,
    int year,
    int month,
    int day) async{

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final url = 'https://api.myquran.com/v2/sholat/jadwal/$locationId/$year/$month/$day';
        final response = await http.get(Uri.parse(url));

        if(response.statusCode == 200){
          final jsonData = json.decode(response.body);
          _schedule = ScheduleModel.fromJson(jsonData);
        } else {
          _errorMessage = 'Failed to load schedule. Status code : ${response.statusCode}';
        }
      } catch (e) {
        _errorMessage = 'An error occurred : $e';
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
}