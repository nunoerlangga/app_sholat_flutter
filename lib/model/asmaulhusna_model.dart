import 'dart:convert';

class AsmaulHusna {
  final int urutan;
  final String latin;
  final String arab;
  final String arti;

  AsmaulHusna({
    required this.urutan,
    required this.latin,
    required this.arab,
    required this.arti,
  });

 factory AsmaulHusna.fromJson(Map<String, dynamic> json) {
    return AsmaulHusna(
      urutan: json['urutan'],
      latin: json['latin'],
      arab: json['arab'],
      arti: json['arti'],
    );
  } static List<AsmaulHusna> fromJsonList(String jsonString) {
    final List parsed = json.decode(jsonString);
    return parsed.map((json) => AsmaulHusna.fromJson(json)).toList();
  }
  }
 

