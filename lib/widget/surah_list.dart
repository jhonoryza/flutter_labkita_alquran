import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_labkita_alquran/model/surah.dart';
import 'package:flutter_labkita_alquran/widget/surah_detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class BuildSurahList extends StatefulWidget {
  const BuildSurahList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BuildSuratListState();
  }
}

class _BuildSuratListState extends State<BuildSurahList> {
  String searchValue = '';

  final searchInput = TextEditingController();

  void onSearchChanged(input) {
    setState(() {
      searchValue = input;
    });
  }

  void clearSearchInput() {
    setState(() {
      searchValue = '';
    });
    searchInput.clear();
  }

  // unused since we used offline data
  Future<List<dynamic>> fetchSurah() async {
    final url = Uri.parse("https://quran-api.santrikoding.com/api/surah");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body.map((data) => Surah.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load surah');
    }
  }

  Future<List<dynamic>> fetchOfflineSurah() async {
    final file = await rootBundle.loadString('assets/json/quran-complete.json');
    final body = json.decode(file);
    final listSurah = body.map((data) => Surah.fromOfflineJson(data)).toList();
    if (searchValue.isNotEmpty) {
      var nomor = int.tryParse(searchValue);
      if (nomor == null) {
        listSurah.removeWhere((element) => !element.namaLatin
            .toLowerCase()
            .contains(searchValue.toLowerCase()));
      } else {
        listSurah.removeWhere((element) => !element.nomor
            .toString()
            .toLowerCase()
            .contains(searchValue.toLowerCase()));
      }
    }
    return listSurah;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: searchInput,
              onChanged: onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                // filled: true,
                // fillColor: Colors.black87,
                focusColor: Colors.white70,
                border: InputBorder.none,
                hintText: 'cari nama / no surah',
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontFamily: GoogleFonts.quicksand().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
                suffixIcon: IconButton(
                  onPressed: () => clearSearchInput(),
                  icon: Icon(
                    searchValue.isNotEmpty ? Icons.clear : null,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: fetchOfflineSurah(),
                builder: (context, snapshot) {
                  List<dynamic> datas = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: datas.length,
                    itemBuilder: (context, index) {
                      if (snapshot.hasError) {
                        return spinnerLoading(snapshot.error.toString());
                      }
                      var tileColor =
                          index % 2 == 0 ? Colors.black87 : Colors.black87;
                      var surah = snapshot.data![index];

                      return buildListTile(
                        context,
                        surah,
                        tileColor,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(BuildContext context, Surah surah, Color tileColor) {
    return ListTile(
      // tileColor: tileColor,
      contentPadding:
          const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14.0),
            margin: const EdgeInsets.all(1.0),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    Colors.black87,
                    BlendMode.color,
                  ),
                  image: ExactAssetImage('assets/icons/ayat.png'),
                )),
            child: Text(
              surah.nomor.toString(),
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '  ${surah.namaLatin}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white70,
                        fontFamily: GoogleFonts.quicksand().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('${surah.nama}   ',
                        style: TextStyle(
                          fontFamily: GoogleFonts.scheherazadeNew().fontFamily,
                          color: Colors.white70,
                          fontSize: 18.0,
                        ))
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '  ${surah.jumlahAyat} Ayat | Arti: ${surah.arti}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white70,
                      fontFamily: GoogleFonts.quicksand().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              BuildSurahDetail(
            nomor: surah.nomor,
            namaLatin: surah.namaLatin,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration:
              const Duration(milliseconds: 300), // Durasi animasi
        ),
      ),
    );
  }

  Widget spinnerLoading(String message) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 30,
            ),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
