import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_labkita_alquran/model/surah.dart';
import 'package:flutter_labkita_alquran/widget/surah_detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class BuildSurahList extends StatefulWidget {
  final Function(String) showSnack;

  const BuildSurahList({super.key, required this.showSnack});

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
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: searchInput,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'cari nama / no surah',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () => clearSearchInput(),
                  icon: Icon(searchValue.isNotEmpty ? Icons.clear : null),
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
                      // if (datas.isEmpty) {
                      //   return Container(
                      //     height: 20,
                      //     child: const CircularProgressIndicator(),
                      //   );
                      // }
                      if (snapshot.hasError) {
                        widget.showSnack(snapshot.error.toString());
                      }
                      var tileColor =
                          index % 2 == 0 ? Colors.white : Colors.grey[300];
                      var surah = snapshot.data![index];

                      return buildListTile(
                        context,
                        surah,
                        tileColor!,
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
      tileColor: tileColor,
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
                    Colors.brown,
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
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text('${surah.nama}   ',
                        style: TextStyle(
                          fontFamily: GoogleFonts.scheherazadeNew().fontFamily,
                          color: Colors.brown,
                          fontSize: 18.0,
                        ))
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '  ${surah.jumlahAyat} Ayat | Arti: ${surah.arti}',
                    style: const TextStyle(
                      fontSize: 12.0,
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
        MaterialPageRoute(
          builder: (context) => BuildSurahDetail(
            nomor: surah.nomor,
            namaLatin: surah.namaLatin,
          ),
        ),
      ),
    );
  }
}
