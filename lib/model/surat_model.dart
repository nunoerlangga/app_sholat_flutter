class SuratModel {
  int? nomor;
  String? nama;
  String? namaLatin;
  int? jumlahAyat;
  // String? tempatTurun;
  String? arti;
  // String? deskripsi;
  Map<String, String>? audioFull;
  List<Ayat>? ayat;

  SuratModel({
    this.nomor,
    this.nama,
    this.namaLatin,
    this.jumlahAyat,
    // this.tempatTurun,
    this.arti,
    // this.deskripsi,
    this.audioFull,
    this.ayat,
  });

  factory SuratModel.fromJson(Map<String, dynamic> json) {
    return SuratModel(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      // tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      // deskripsi: json['deskripsi'],
      audioFull: json['audioFull'] != null
          ? Map<String, String>.from(json['audioFull'])
          : null,
      ayat: json['ayat'] != null
          ? (json['ayat'] as List).map((e) => Ayat.fromJson(e)).toList()
          : null,
     
    );
  }
}

class Ayat {
  int? nomorAyat;
  String? teksArab;
  String? teksLatin;
  String? teksIndonesia;
  Map<String, String>? audio;

  Ayat({this.nomorAyat, this.teksArab, this.teksLatin, this.teksIndonesia, 
  this.audio
  });

  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
      nomorAyat: json['nomorAyat'],
      teksArab: json['teksArab'],
      teksLatin: json['teksLatin'],
      teksIndonesia: json['teksIndonesia'],
      audio: json['audio'] != null ? Map<String, String>.from(json['audio']) : null,
    );
  }
}


