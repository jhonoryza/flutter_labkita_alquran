import 'dart:math';

import 'package:geolocator/geolocator.dart';

const String appTitle = 'Alquran';

// Lokasi Ka'bah (Mekah)
const double kaabaLatitude = 21.4225;
const double kaabaLongitude = 39.8262;

// Menghitung arah kiblat berdasarkan lokasi pengguna
Future<double> getQiblaDirection() async {
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

    return degree;
  } catch (e) {
    return 0;
  }
}

// Extension untuk konversi derajat <-> radian
extension AngleConverter on double {
  double toRadians() => this * pi / 180;

  double toDegrees() => this * 180 / pi;
}
