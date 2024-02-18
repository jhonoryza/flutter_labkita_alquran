import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_labkita_alquran/model/detail_surah.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailSurahWidget extends StatelessWidget {
  const DetailSurahWidget(
      {super.key, required this.nomor, required this.namaLatin});

  final int nomor;
  final String namaLatin;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(namaLatin, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
          actions: [
            BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            )
            // Icon(Icons.arrow_back)
          ],
        ),
        body: Center(
          child: FutureBuilder<DetailSurah>(
            future: fetchDetailOfflineSurah(nomor),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ListView.builder(
                  itemCount: snapshot.data!.ayat.length,
                  itemBuilder: (context, index) {
                    var ayat = snapshot.data!.ayat[index];
                    var tileColor =
                        index % 2 == 0 ? Colors.white : Colors.grey[300];
                    return buildDetailListTile(ayat, tileColor!);
                  },
                );
              } else if (snapshot.hasError) {
                return Text('error : ${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Widget buildDetailListTile(DetailAyat ayat, Color tileColor) {
    return ListTile(
      tileColor: tileColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                margin: const EdgeInsets.only(right: 12.0),
                // color: Colors.grey,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                        tileColor,
                        BlendMode.modulate,
                      ),
                      image: const ExactAssetImage('assets/icons/ayat.png')),
                ),
                child: Text(
                  '${ayat.nomor}',
                  style: const TextStyle(
                    // color: ColorBase.primaryText,
                    fontSize: 10.0,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  ayat.ar,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: GoogleFonts.scheherazadeNew().fontFamily,
                    fontSize: 24.0,
                    color: Colors.brown,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              'Artinya: ${ayat.idn}',
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 12.0,
                // color: ColorBase.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// unused since we used offline data
Future<DetailSurah> fetchDetailSurah(int nomor) async {
  final url = Uri.parse("https://quran-api.santrikoding.com/api/surah/$nomor");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    return DetailSurah.fromJson(body);
  }
  throw Exception('Failed to load detail surah');
}

Future<DetailSurah> fetchDetailOfflineSurah(int nomor) async {
  final file = await rootBundle.loadString('assets/json/quran-complete.json');

  final body = json.decode(file);
  (body as List).removeWhere((element) => element['number_of_surah'] != nomor);
  return DetailSurah.fromOfflineJson(body[0], nomor);
}
