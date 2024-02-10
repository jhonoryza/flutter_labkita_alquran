import 'package:meta/meta.dart';

@immutable
class Surah {
  final int nomor;
  final String namaLatin;
  final String nama;

  const Surah({required this.nomor, required this.namaLatin, required this.nama});

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'],
      namaLatin: json['nama_latin'],
      nama: json['nama'],
    );
  }
}