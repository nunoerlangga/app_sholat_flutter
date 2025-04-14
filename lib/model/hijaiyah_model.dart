import 'dart:convert';

class HijaiyahModel {
  final int urutan;
  final String huruf;
  final String nama;
  final List<String> harakat;
  final List<String> baca;

  HijaiyahModel(
      {required this.urutan,
      required this.huruf,
      required this.nama,
      required this.harakat,
      required this.baca});
  factory HijaiyahModel.fromJson(Map<String, dynamic> json) {
    return HijaiyahModel(
      urutan: json['urutan'],
      huruf: json['huruf'],
      nama: json['nama'],
      harakat: List<String>.from(json['harakat']),
      baca: List<String>.from(json['baca']),
    );
  }
  static List<HijaiyahModel> fromJsonList(String jsonString) {
    final List parsed = json.decode(jsonString);
    return parsed.map((json) => HijaiyahModel.fromJson(json)).toList();
  }
}
