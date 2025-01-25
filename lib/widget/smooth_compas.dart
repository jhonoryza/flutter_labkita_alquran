import 'package:flutter/material.dart';
//import 'package:smooth_compass_plus/utils/src/compass_ui.dart';

Widget smoothCompas() {
  return const Scaffold(
      // body: SmoothCompassWidget(
      //   rotationSpeed: 200,
      //   height: 300,
      //   isQiblahCompass: true,
      //   width: 300,
      //   compassBuilder: (context, AsyncSnapshot<CompassModel>? compassData,
      //       Widget compassAsset) {
      //     return AnimatedRotation(
      //       turns: compassData?.data?.turns ?? 0 / 360,
      //       duration: const Duration(milliseconds: 400),
      //       child: SizedBox(
      //         height: 200,
      //         width: 200,
      //         child: Stack(
      //           children: [
      //             //put your compass here
      //             Positioned(
      //               top: 0,
      //               left: 0,
      //               right: 0,
      //               bottom: 0,
      //               child: Image.asset(
      //                 "assets/images/compass.png",
      //                 fit: BoxFit.fill,
      //               ),
      //             ),
      //
      //             //put your qiblah needle here
      //             Positioned(
      //               top: 20,
      //               left: 0,
      //               right: 0,
      //               bottom: 20,
      //               child: AnimatedRotation(
      //                 turns: (compassData?.data?.qiblahOffset ?? 0) / 360,
      //                 duration: const Duration(milliseconds: 400),
      //                 child: Image.asset(
      //                   "assets/images/needle.png",
      //                   fit: BoxFit.fitHeight,
      //                 ),
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
      );
}
