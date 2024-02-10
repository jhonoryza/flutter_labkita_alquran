import 'package:flutter/material.dart';
import 'package:flutter_labkita_alquran/detail_surah_widget.dart';
import 'dart:convert';
import 'package:flutter_labkita_alquran/model/surah.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

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

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
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
    const String appTitle = 'Alquran';
    return MaterialApp(
        title: appTitle,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
            backgroundColor: Colors.teal,
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            indicatorColor: Colors.teal,
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.info),
                label: 'About',
              ),
            ],
          ),
          body: <Widget>[
            Center(
              child: FutureBuilder<List<dynamic>>(
                future: fetchSurah(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var tileColor =
                            index % 2 == 0 ? Colors.white : Colors.grey[300];
                        var surah = snapshot.data![index];

                        return ListTile(
                          tileColor: tileColor,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                margin: const EdgeInsets.only(right: 12.0),
                                // color: Colors.grey,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      colorFilter: ColorFilter.mode(
                                        tileColor!,
                                        BlendMode.modulate,
                                      ),
                                      image: const ExactAssetImage(
                                          'assets/icons/ayat.png')),
                                ),
                                child: Text(
                                  '${surah.nomor}',
                                  style: const TextStyle(
                                    // color: ColorBase.primaryText,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                              Text('${surah.nama}'),
                              Text('${surah.namaLatin}'),
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
            Card(
              shadowColor: Colors.transparent,
              margin: const EdgeInsets.all(8.0),
              child: SizedBox.expand(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'version: ${_packageInfo.version}',
                        style: theme.textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'build number: ${_packageInfo.buildNumber}',
                        style: theme.textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '@copyright labkita 2024',
                        style: theme.textTheme.labelSmall,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ][currentPageIndex],
        ));
  }
}
