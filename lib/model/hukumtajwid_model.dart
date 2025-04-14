

class Tajwid {
  final String nama;
  final String pengertian;
  final List<String>? huruf;
  final List<Jenis>? jenis;
  final String? keterangan;
  final List<Tingkatan>? tingkatan;
  Tajwid({
    required this.nama,
    required this.pengertian,
    this.huruf,
    this.jenis,
    this.keterangan,
    this.tingkatan,
  });
  factory Tajwid.fromJson(Map<String, dynamic> json) {
    return Tajwid(
      nama: json['nama'],
      pengertian: json['pengertian'],
      huruf: json['huruf'] is List
          ? List<String>.from(json['huruf'])
          : json['huruf']?.toString().split(','),
      jenis: json['jenis'] != null
          ? (json['jenis'] as List).map((e) => Jenis.fromJson(e)).toList()
          : null,
      keterangan: json['keterangan'],
      tingkatan: json['tingkatan'] != null
          ? (json['tingkatan'] as List)
              .map((e) => Tingkatan.fromJson(e))
              .toList()
          : null,
    );
  }
}

class Jenis {
  final String nama;
  final List<String> huruf;
  final String keterangan;

  Jenis({
    required this.nama,
    required this.huruf,
    required this.keterangan,
  });

  factory Jenis.fromJson(Map<String, dynamic> json) {
    return Jenis(
      nama: json['nama'],
      huruf: List<String>.from(json['huruf']),
      keterangan: json['keterangan'],
    );
  }
}

class Tingkatan {
  final String nama;
  final String keterangan;

  Tingkatan({
    required this.nama,
    required this.keterangan,
  });

  factory Tingkatan.fromJson(Map<String, dynamic> json) {
    return Tingkatan(
      nama: json['nama'],
      keterangan: json['keterangan'],
    );
  }
}
