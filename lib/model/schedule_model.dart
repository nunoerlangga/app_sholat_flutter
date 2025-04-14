class ScheduleModel {
  final String? lokasi;
  final String? daerah;
  final String? tanggal;
  final String? imsak;
  final String? subuh;
  final String? terbit;
  final String? dhuha;
  final String? dzuhur;
  final String? ashar;
  final String? maghrib;
  final String? isya;

  ScheduleModel(
      {this.lokasi,
      this.daerah,
      this.tanggal,
      this.imsak,
      this.subuh,
      this.terbit,
      this.dhuha,
      this.dzuhur,
      this.ashar,
      this.maghrib,
      this.isya});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      lokasi: json['data']['lokasi'],
      daerah: json['data']['daerah'],
      tanggal: json['data']['jadwal']['tanggal'],
      imsak: json['data']['jadwal']['imsak'],
      subuh: json['data']['jadwal']['subuh'],
      terbit: json['data']['jadwal']['terbit'],
      dhuha: json['data']['jadwal']['dhuha'],
      dzuhur: json['data']['jadwal']['dzuhur'],
      ashar: json['data']['jadwal']['ashar'],
      maghrib: json['data']['jadwal']['maghrib'],
      isya: json['data']['jadwal']['isya'],
    );
  }
}
