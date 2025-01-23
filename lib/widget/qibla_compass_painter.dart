import 'dart:math';

import 'package:flutter/material.dart';

class CompassCustomPainter extends CustomPainter {
  final double angle;

  const CompassCustomPainter({
    required this.angle,
  });

  // Keeps rotating the North Red Triangle
  double get rotation => -angle * pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    // Center The Compass In The Middle Of The Screen
    canvas.translate(size.width / 2, size.height / 2);

    // debugPrint((size.height / 4).toString());

    Paint kaabaPaint = Paint()
      ..color = Colors.lime
      ..style = PaintingStyle.fill;

    canvas.rotate(-angle * pi / 180);

    // Draw Kaaba hexagon
    Path hexagonPath = Path();
    double radius = 15; // Radius for hexagon
    for (int i = 0; i < 6; i++) {
      double theta = (pi / 3) * i;
      double x = radius * cos(theta);
      double y = radius * sin(theta);
      if (i == 0) {
        hexagonPath.moveTo(0 + x, -175 + y); // Start from center offset
      } else {
        hexagonPath.lineTo(0 + x, -175 + y);
      }
    }
    hexagonPath.close();
    canvas.drawPath(hexagonPath, kaabaPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
