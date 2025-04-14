
class SurahModel {
    SurahModel({
        required this.nomor,
        required this.nama,
        required this.namaLatin,
        required this.jumlahAyat,
        required this.tempatTurun,
        required this.arti,
        required this.deskripsi,
        required this.audioFull,
    });

    final int? nomor;
    final String? nama;
    final String? namaLatin;
    final int? jumlahAyat;
    final String? tempatTurun;
    final String? arti;
    final String? deskripsi;
    final Map<String, String> audioFull;

    factory SurahModel.fromJson(Map<String, dynamic> json){ 
        return SurahModel(
            nomor: json["nomor"],
            nama: json["nama"],
            namaLatin: json["namaLatin"],
            jumlahAyat: json["jumlahAyat"],
            tempatTurun: json["tempatTurun"],
            arti: json["arti"],
            deskripsi: json["deskripsi"],
            audioFull: Map.from(json["audioFull"]).map((k, v) => MapEntry<String, String>(k, v)),
        );
    }

  

}
