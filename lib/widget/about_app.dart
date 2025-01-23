import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
    Future<void> githubURL() async {
      await launchUrl(Uri.parse(
          'https://github.com/jhonoryza/flutter_labkita_alquran/issues'));
    }

    const appLink =
        'https://play.google.com/store/apps/details?id=com.labkita.baca_alquran';

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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Ini adalah aplikasi alquran dan terjemahan indonesia, jika ada kekurangan mohon dimaklumi. ',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(height: 20),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'Untuk saran, masukan dan pelaporan bug, silakan kunjungi ',
                        ),
                        TextSpan(
                          text: 'link berikut.',
                          style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = githubURL,
                        ),
                      ],
                    ),
                  ),
                  Container(height: 20),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Support developer dengan share ',
                        ),
                        TextSpan(
                            text: 'aplikasi',
                            style: const TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await Clipboard.setData(
                                  const ClipboardData(text: appLink),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Link disalin ke clipboard!'),
                                  ),
                                );
                              }),
                        const TextSpan(text: ' ini.'),
                      ],
                    ),
                  ),
                  Container(height: 20),
                  const Text(
                    'Hatur Nuhun, 🙏',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: 100,
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
            ],
          ),
        ),
      ),
    );
  }
}
