import 'package:flutter/material.dart';
import 'package:flutter_labkita_alquran/helper.dart';
import 'package:flutter_labkita_alquran/widget/navigation/bottom.dart';
import 'package:in_app_update/in_app_update.dart';

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
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // check in app update
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

  // toast message related
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: UseBottomNavigation(),
    );
  }
}
