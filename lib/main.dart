import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_labkita_alquran/detail_surah_widget.dart';
import 'dart:convert';
import 'package:flutter_labkita_alquran/model/surah.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_update/in_app_update.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String? _result;

  void setResult(String? result) {
    setState(() => _result = result);
  }

  final MobileScannerController controller = MobileScannerController();

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      InAppUpdate.performImmediateUpdate().catchError((e) {
        showSnack(e.toString());
        return AppUpdateResult.inAppUpdateFailed;
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

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
    //checkForUpdate();
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
      home: buildWithBottomNavigation(appTitle, theme),
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
                        showSnack(snapshot.error.toString());
                      }
                      var tileColor =
                          index % 2 == 0 ? Colors.white : Colors.grey[300];
                      var surah = snapshot.data![index];

                      return buildListTile(surah, tileColor!);
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
                  ],
                ),
                const Text(
                  'copyright @labkita februari 2024',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
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
        buildScanner(),
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
      backgroundColor: Colors.white,
      height: 60,
      indicatorColor: Colors.white,
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.teal), label: 'Home'),
        NavigationDestination(
            icon: Icon(Icons.scanner, color: Colors.teal), label: 'QR Scan'),
        NavigationDestination(
            icon: Icon(Icons.info, color: Colors.teal), label: 'About'),
      ],
    );
  }

  Future<void> _launchURL() async {
    try {
      await launchUrl(Uri.parse(_result ?? ''));
    } on PlatformException catch (e) {
      debugPrint("Failed to open URL: '${e.message}'.");
    }
  }

  Widget buildScanner() {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: controller,
              onDetect: (BarcodeCapture capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                final barcode = barcodes.first;
                if (barcode.rawValue != null) {
                  setResult(barcode.rawValue);
                }
              },
            ),
          ),
          Center(
              heightFactor: 3,
              child: GestureDetector(
                onTap: _launchURL,
                child: Text(
                  _result ?? 'No result',
                  style: const TextStyle(
                      color: Colors.indigoAccent,
                      decoration: TextDecoration.underline),
                ),
              )),
        ],
      ),
    );
  }
}
