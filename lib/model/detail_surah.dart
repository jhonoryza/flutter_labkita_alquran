import 'package:meta/meta.dart';

@immutable
class DetailSurah {
  final int nomor;
  final String namaLatin;
  final String nama;
  final int jumlahAyat;

  final List<dynamic> ayat;

  const DetailSurah({
    required this.nomor,
    required this.namaLatin,
    required this.nama,
    required this.jumlahAyat,
    required this.ayat,
  });

  factory DetailSurah.fromJson(Map<String, dynamic> json) {
    return DetailSurah(
      nomor: json['nomor'],
      namaLatin: json['nama_latin'],
      nama: json['nama'],
      jumlahAyat: json['jumlah_ayat'],
      ayat: List<dynamic>.from(
        json['ayat'].map(
          (x) => DetailAyat.fromJson(x),
        ),
      ),
    );
  }
}

@immutable
class DetailAyat {
  final int nomor;
  final String ar;
  final String idn;

  const DetailAyat({
    required this.nomor,
    required this.ar,
    required this.idn,
  });

  factory DetailAyat.fromJson(Map<String, dynamic> json) {
    return DetailAyat(nomor: json['nomor'], ar: json['ar'], idn: json['idn']);
  }
}
