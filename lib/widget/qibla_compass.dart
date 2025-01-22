import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_labkita_alquran/widget/qibla_compass_painter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class BuildQiblaCompass extends StatefulWidget {
  const BuildQiblaCompass({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _BuildQiblaCompassState();
  }
}

class _BuildQiblaCompassState extends State<BuildQiblaCompass> {
  double? qiblaDegrees;

  void setQiblaDegrees(double qiblaDegrees) {
    setState(() => qiblaDegrees = qiblaDegrees);
  }

  // Lokasi Ka'bah (Mekah)
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  // Menghitung arah kiblat berdasarkan lokasi pengguna
  Future<void> _getQiblaDirection() async {
    try {
      // Mendapatkan lokasi pengguna
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double userLatitude = position.latitude;
      double userLongitude = position.longitude;

      // Hitung arah kiblat
      double deltaLongitude = (kaabaLongitude - userLongitude).toRadians();
      double latitude1 = userLatitude.toRadians();
      double latitude2 = kaabaLatitude.toRadians();

      double y = sin(deltaLongitude) * cos(latitude2);
      double x = cos(latitude1) * sin(latitude2) -
          sin(latitude1) * cos(latitude2) * cos(deltaLongitude);

      double qiblaDegrees = atan2(y, x).toDegrees();

      if (qiblaDegrees < 0) qiblaDegrees += 360;

      setQiblaDegrees(qiblaDegrees);
    } catch (e) {
      debugPrint("Error calculating Qibla direction: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    _getQiblaDirection();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: StreamBuilder<CompassEvent>(
          stream: FlutterCompass.events,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError ||
                snapshot.data == null ||
                qiblaDegrees == null) {
              return const Text("Tidak dapat membaca sensor kompas.");
            }

            // Ambil heading dari CompassEvent
            double? heading = snapshot.data!.heading;

            if (heading == null) {
              return const Text("Sensor kompas tidak tersedia.");
            }
            double direction = heading;
            // double direction = qiblaDegrees! - heading;

            // double direction = (qiblaDegrees! - heading) % 360;
            // if (direction < 0) {
            //   direction += 360; // Pastikan arah selalu positif
            // }
            // debugPrint('qibla ' + qiblaDegrees.toString());
            // debugPrint('compass ' + heading.toString());
            // debugPrint('direction ' + direction.toString());

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Qibla",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: size,
                          painter: CompassCustomPainter(
                            angle: direction,
                          ),
                        ),
                        Text(
                          buildHeadingFirstLetter(direction),
                          style: TextStyle(
                            color: Colors.grey[700]!,
                            fontSize: 82,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  String buildHeadingFirstLetter(double direction) {
    if (direction > 315 && direction < 45) {
      return 'N';
    } else if (direction > 45 && direction < 135) {
      return 'E';
    } else if (direction > 135 && direction < 225) {
      return 'S';
    } else if (direction > 225 && direction < 315) {
      return 'W';
    }

    return 'N';
  }
}

// Extension untuk konversi derajat <-> radian
extension AngleConverter on double {
  double toRadians() => this * pi / 180;

  double toDegrees() => this * 180 / pi;
}

Future<void> requestLocationPermission() async {
  PermissionStatus status = await Permission.location.request();

  if (status.isGranted) {
    debugPrint("Location permission granted");
    // Lanjutkan untuk mengakses lokasi
  } else if (status.isDenied) {
    debugPrint("Location permission denied");
  } else if (status.isPermanentlyDenied) {
    openAppSettings(); // Minta pengguna untuk membuka pengaturan dan memberikan izin
  }
}
