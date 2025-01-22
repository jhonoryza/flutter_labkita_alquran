import 'package:flutter/material.dart';
import 'package:flutter_labkita_alquran/helper.dart';
import 'package:flutter_labkita_alquran/widget/about_app.dart';
import 'package:flutter_labkita_alquran/widget/qibla_compass.dart';
import 'package:flutter_labkita_alquran/widget/qrcode_scanner.dart';
import 'package:flutter_labkita_alquran/widget/surah_list.dart';

class UseBottomNavigation extends StatefulWidget {
  const UseBottomNavigation({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _UseBottomNavigationState();
  }
}

class _UseBottomNavigationState extends State<UseBottomNavigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appTitle,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: createBar(),
      body: _buildPage(currentPageIndex),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return BuildSurahList(
          showSnack: (String message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
        );
      case 1:
        return const BuildQiblaCompass();
      case 2:
        return const BuildScanner();
      case 3:
        return const BuildAboutApp();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  Widget createBar() {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      backgroundColor: Colors.white,
      height: 60,
      indicatorColor: Colors.white,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
            color: Colors.teal,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.compass_calibration_rounded,
            color: Colors.teal,
          ),
          label: 'Qibla',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.scanner,
            color: Colors.teal,
          ),
          label: 'QR Scan',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.info,
            color: Colors.teal,
          ),
          label: 'About',
        ),
      ],
    );
  }
}
