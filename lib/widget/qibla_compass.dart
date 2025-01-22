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

      double degree = atan2(y, x).toDegrees();

      if (degree < 0) degree += 360;

      setState(() {
        qiblaDegrees = degree;
      });
    } catch (e) {
      debugPrint("Error calculating Qibla direction: $e");
    }
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

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    _getQiblaDirection();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: StreamBuilder<CompassEvent>(
          stream: FlutterCompass.events,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            // Ambil heading dari CompassEvent
            double? heading = snapshot.data!.heading;

            if (!snapshot.hasData || heading == null || heading.isNaN) {
              return const Text(
                'data kompas tidak valid',
                style: TextStyle(color: Colors.white),
              );
            }

            if (qiblaDegrees == null) {
              return const Text(
                "data gps tidak valid.",
                style: TextStyle(color: Colors.white),
              );
            }

            double compassAngle = heading * (pi / 180) * -1;
            double qiblaAngle = heading - qiblaDegrees!;
            double qiblaAngleNorm = qiblaAngle % 360;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "KA'BAH ${qiblaAngleNorm.ceil().abs()}°",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: compassAngle,
                        child: Image.asset(
                          "assets/images/compass2.png",
                          scale: 1,
                        ),
                      ),
                      CustomPaint(
                        size: MediaQuery.of(context).size,
                        painter: CompassCustomPainter(
                          angle: qiblaAngle,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "KA'BAH ${qiblaDegrees!.ceil().abs()}° dari Utara",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

// Extension untuk konversi derajat <-> radian
extension AngleConverter on double {
  double toRadians() => this * pi / 180;

  double toDegrees() => this * 180 / pi;
}
