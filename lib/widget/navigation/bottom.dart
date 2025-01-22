import 'package:flutter/material.dart';
import 'package:flutter_labkita_alquran/main.dart';
import 'package:flutter_labkita_alquran/widget/about_app.dart';
import 'package:flutter_labkita_alquran/widget/qibla_compass.dart';
import 'package:flutter_labkita_alquran/widget/qrcode_scanner.dart';
import 'package:flutter_labkita_alquran/widget/surah_list.dart';

class UseBottomNavigation extends MyAppState {
  Widget create(String appTitle, ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: createBar(),
      body: <Widget>[
        BuildSurahList(
          showSnack: showSnack,
        ),
        const BuildQiblaCompass(),
        const BuildScanner(),
        const BuildAboutApp(),
      ][currentPageIndex],
    );
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
      selectedIndex: currentPageIndex,
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
