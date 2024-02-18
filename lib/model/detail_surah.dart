import 'package:flutter/cupertino.dart';
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

  factory DetailSurah.fromOfflineJson(
    Map<String, dynamic> json,
    int nomor,
  ) {
    return DetailSurah(
      nomor: json['number_of_surah'],
      namaLatin: json['name'],
      nama: json['name_translations']['ar'],
      jumlahAyat: json['number_of_ayah'],
      ayat: List<dynamic>.from(
        json['verses'].map(
          (x) => DetailAyat.fromOfflineJson(x),
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

  factory DetailAyat.fromOfflineJson(Map<String, dynamic> json) {
    return DetailAyat(
        nomor: json['number'], ar: json['text'], idn: json['translation_id']);
  }
}
