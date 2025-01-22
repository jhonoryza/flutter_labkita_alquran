import 'package:flutter/material.dart';
import 'package:flutter_labkita_alquran/main.dart';
import 'package:flutter_labkita_alquran/widget/about_app.dart';
import 'package:flutter_labkita_alquran/widget/surah_list.dart';

class UseTopNavigation extends MyAppState {
  Widget create(String appTitle, ThemeData theme) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appTitle,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuildAboutApp(
                      packageInfo: packageInfo,
                      theme: theme,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: BuildSurahList(
          showSnack: showSnack,
        ),
      ),
    );
  }
}
