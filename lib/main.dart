import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_labkita_alquran/bloc/permission.dart';
import 'package:flutter_labkita_alquran/helper.dart';
import 'package:flutter_labkita_alquran/widget/navigation/bottom.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter/services.dart';

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
  bool isNewVersionAvailable = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // check for new version
  Future<void> checkForNewVersion() async {
    InAppUpdate.checkForUpdate().then((info) async {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        setState(() {
          isNewVersionAvailable = true;
        });
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content:
                Text("tersedia versi terbaru v${info.availableVersionCode}"),
          ),
        );
        await requestForUpdate();
      } else if (info.updateAvailability ==
          UpdateAvailability.updateNotAvailable) {
        setState(() {
          isNewVersionAvailable = false;
        });
      }
    }).catchError((e) {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    });
  }

  // request update using play api
  Future<AppUpdateResult> requestForUpdate() async =>
      InAppUpdate.performImmediateUpdate().then((AppUpdateResult result) {
        return result;
      }).catchError(
        (e) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
          return AppUpdateResult.inAppUpdateFailed;
        },
      );

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkForNewVersion();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PermissionBloc(),
      child: const MaterialApp(
        title: appTitle,
        home: UseBottomNavigation(),
      ),
    );
  }
}
