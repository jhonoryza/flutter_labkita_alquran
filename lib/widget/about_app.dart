import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BuildAboutApp extends StatefulWidget {
  const BuildAboutApp({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _BuildAboutAppState();
  }
}

class _BuildAboutAppState extends State<BuildAboutApp> {
  // package info related
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SizedBox.expand(
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
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Versi: ${packageInfo.version}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'build number: ${packageInfo.buildNumber}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(height: 20),
                  const Text(
                    'Ini adalah aplikasi alquran dan terjemahan indonesia, jika didapat kekurangan mohon dimaklumi. \n\nUntuk saran dan masukan boleh disampaikan melalui email jardik.oryza@gmail.com, \n\nSupport developer dengan share, terima kasih',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const Text(
                'copyright @labkita februari 2024',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
