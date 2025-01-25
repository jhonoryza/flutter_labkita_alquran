import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_labkita_alquran/bloc/permission.dart';
import 'package:flutter_labkita_alquran/widget/qibla_compass_painter.dart';

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
  @override
  Widget build(BuildContext context) {
    return BlocListener<PermissionBloc, PermissionState>(
      listener: (context, state) async {
        if (state is PermissionGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('izin akses lokasi berhasil'),
            ),
          );
        } else if (state is PermissionDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('memerlukan izin akses lokasi'),
            ),
          );
        } else if (state is PermissionPermanentlyDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('memerlukan izin akses lokasi'),
            ),
          );
        }
      },
      child: BlocBuilder<PermissionBloc, PermissionState>(
          builder: (context, state) {
        if (state is PermissionInitialize) {
          context.read<PermissionBloc>().add(RequestPermissionEvent());
          return spinnerLoading('tunggu sebentar, sedang meminta izin lokasi');
        } else if (state is PermissionGranted) {
          return spinnerLoading('tunggu sebentar, sedang membaca gps');
        } else if (state is QiblaAcquired) {
          double qiblaDegrees = state.qiblaDegree;
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
                    return colSpinnerLoading();
                  }

                  double compassAngle = heading * (pi / 180) * -1;
                  double qiblaAngle = heading - qiblaDegrees;
                  double qiblaAngleNorm = qiblaAngle % 360;

                  return compassRender(
                    qiblaDegrees,
                    qiblaAngle,
                    qiblaAngleNorm,
                    compassAngle,
                  );
                },
              ),
            ),
          );
        } else if (state is PermissionDenied ||
            state is PermissionPermanentlyDenied) {
          context.read<PermissionBloc>().add(OpenAppSettingsEvent());
          return spinnerLoading("menunggu izin akses lokasi");
        }
        return spinnerLoading("menunggu izin akses lokasi");
      }),
    );
  }

  Widget compassRender(
    double qiblaDegrees,
    double qiblaAngle,
    double qiblaAngleNorm,
    double compassAngle,
  ) {
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
          "KA'BAH ${qiblaDegrees.ceil().abs()}° dari Utara",
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
  }

  Widget spinnerLoading(String message) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 30,
            ),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget colSpinnerLoading() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(
          height: 30,
        ),
        Text(
          'tunggu sebentar, sedang membaca kompas',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
