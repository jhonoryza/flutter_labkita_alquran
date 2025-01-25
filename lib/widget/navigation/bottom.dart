import 'package:flutter/material.dart';
import 'package:flutter_labkita_alquran/helper.dart';
import 'package:flutter_labkita_alquran/widget/about_app.dart';
import 'package:flutter_labkita_alquran/widget/qibla_compass.dart';
import 'package:flutter_labkita_alquran/widget/qrcode_scanner.dart';
import 'package:flutter_labkita_alquran/widget/surah_list.dart';
import 'package:google_fonts/google_fonts.dart';

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
        title: Text(
          appTitle,
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.quicksand().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: createBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _buildPage(currentPageIndex),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const BuildSurahList();
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
