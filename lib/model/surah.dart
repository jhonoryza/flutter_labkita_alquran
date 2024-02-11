import 'package:meta/meta.dart';

@immutable
class Surah {
  final int nomor;
  final String namaLatin;
  final String nama;
  final int jumlahAyat;
  final String arti;

  const Surah({
    required this.nomor,
    required this.namaLatin,
    required this.nama,
    required this.jumlahAyat,
    required this.arti,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'],
      namaLatin: json['nama_latin'],
      nama: json['nama'],
      jumlahAyat: json['jumlah_ayat'],
      arti: json['arti'],
    );
  }
}
