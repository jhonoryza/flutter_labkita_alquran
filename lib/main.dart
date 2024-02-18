import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_labkita_alquran/detail_surah_widget.dart';
import 'dart:convert';
import 'package:flutter_labkita_alquran/model/surah.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:social_share/social_share.dart';

void main() {
  runApp(const NavigationBarApp());
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPageIndex = 0;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  final _searchInput = TextEditingController();
  String searchValue = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    // _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  void _onSearchChanged(input) {
    setState(() {
      searchValue = input;
    });
  }

  void _clearSearchInput() {
    setState(() {
      searchValue = '';
    });
    _searchInput.clear();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const String appTitle = 'Alquran Indonesia';
    return MaterialApp(
      title: appTitle,
      home: buildWithTabNavigation(appTitle, theme),
    );
  }

  Widget buildWithTabNavigation(String appTitle, ThemeData theme) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appTitle, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => buildAboutCard(theme),
                  ),
                );
              },
              icon: const Icon(Icons.info, color: Colors.white),
            ),
          ],
        ),
        body: buildListSurah(),
      ),
    );
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

  Widget buildListSurah() {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _searchInput,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'cari nama / no surah',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () => _clearSearchInput(),
                  icon: Icon(searchValue.isNotEmpty ? Icons.clear : null),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FutureBuilder<List<dynamic>>(
                future: fetchOfflineSurah(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var tileColor =
                            index % 2 == 0 ? Colors.white : Colors.grey[300];
                        var surah = snapshot.data![index];

                        return buildListTile(surah, tileColor!);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('error : ${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAboutCard(ThemeData theme) {
    return Scaffold(
      body: Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(height: 80),
                    const Text(
                      'Alquran Indonesia',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Versi: ${_packageInfo.version}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'build number: ${_packageInfo.buildNumber}',
                      style: theme.textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                    Container(height: 20),
                    const Text(
                      'Ini adalah aplikasi alquran dan terjemahan indonesia, jika didapat kekurangan mohon dimaklumi. \n\nUntuk saran dan masukan boleh disampaikan melalui email jardik.oryza@gmail.com, \n\nSupport developer dengan share, terima kasih',
                      textAlign: TextAlign.left,
                    ),
                    Container(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      onPressed: () async {
                        SocialShare.shareTwitter(
                          "Download Alquran terjemahan indonesia, gratis tanpa iklan.",
                          hashtags: ["Alquran", "Islam"],
                          url:
                              "https://play.google.com/store/apps/details?id=com.labkita.baca_alquran",
                        );
                      },
                      child: const Text(
                        "Share Twitter",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey),
                      ),
                      onPressed: () async {
                        SocialShare.copyToClipboard(
                          text:
                              "https://play.google.com/store/apps/details?id=com.labkita.baca_alquran",
                        ).then((data) {
                          const snackBar = SnackBar(content: Text('Copied !!'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      },
                      child: const Text(
                        "Copy Link Aplikasi",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.teal),
                      ),
                      onPressed: () {
                        //go to home
                        Navigator.pop(context);
                      },
                      child: const Text(
                        ' Kembali',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(height: 20),
                  ],
                ),
                const Text(
                  'copyright @labkita februari 2024',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListTile(Surah surah, Color tileColor) {
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
                  colorFilter: ColorFilter.mode(Colors.brown, BlendMode.color),
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
          builder: (context) => DetailSurahWidget(
            nomor: surah.nomor,
            namaLatin: surah.namaLatin,
          ),
        ),
      ),
    );
  }

  // this one currenly unused
  Widget buildWithBottomNavigation(String appTitle, ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: <Widget>[
        buildListSurah(),
        buildAboutCard(theme),
      ][currentPageIndex],
    );
  }

  Widget buildBottomNavigationBar() {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      indicatorColor: Colors.teal,
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        Icon(Icons.home_outlined),
        Icon(Icons.info),
      ],
    );
  }
}
