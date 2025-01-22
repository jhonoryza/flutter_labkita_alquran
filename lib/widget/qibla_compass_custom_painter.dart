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
    // Minimal Compass

    // Center The Compass In The Middle Of The Screen
    canvas.translate(size.width / 2, size.height / 2);

    Paint circle = Paint()
      ..strokeWidth = 2
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Paint shadowCircle = Paint()
      ..strokeWidth = 2
      ..color = Colors.grey.withOpacity(.2)
      ..style = PaintingStyle.fill;

    // Draw Outer Circle
    canvas.drawCircle(Offset.zero, 100, circle);

    Paint darkIndexLine = Paint()
      ..color = Colors.grey[700]!
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    Paint lightIndexLine = Paint()
      ..color = Colors.grey
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    Paint northTriangle = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    canvas.rotate(-pi / 2);

    // Draw The Light Grey Lines 16 Times While Rotating 22.5° Degrees
    for (int i = 1; i <= 16; i++) {
      canvas.drawLine(
          Offset.fromDirection(-(angle + 22.5 * i) * pi / 180, 60),
          Offset.fromDirection(-(angle + 22.5 * i) * pi / 180, 80),
          lightIndexLine);
    }

    // Draw The Dark Grey Lines 3 Times While Rotating 90° Degrees
    for (int i = 1; i <= 3; i++) {
      canvas.drawLine(
          Offset.fromDirection(-(angle + 90 * i) * pi / 180, 60),
          Offset.fromDirection(-(angle + 90 * i) * pi / 180, 80),
          darkIndexLine);
    }

    // Draw North Triangle
    Path path = Path();
    path.moveTo(
      Offset.fromDirection(rotation, 85).dx,
      Offset.fromDirection(rotation, 85).dy,
    );
    path.lineTo(
      Offset.fromDirection(-(angle + 15) * pi / 180, 60).dx,
      Offset.fromDirection(-(angle + 15) * pi / 180, 60).dy,
    );
    path.lineTo(
      Offset.fromDirection(-(angle - 15) * pi / 180, 60).dx,
      Offset.fromDirection(-(angle - 15) * pi / 180, 60).dy,
    );

    path.close();
    canvas.drawPath(path, northTriangle);

    // Drawing "North" text above the North Triangle
    const textStyle = TextStyle(
      color: Colors.red,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    const textSpan = TextSpan(
      text: 'North',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Layout the text
    textPainter.layout();

    // Calculate the position for the text (just above the North Triangle)
    final textPosition = Offset(
      Offset.fromDirection(rotation, 120).dx - textPainter.width / 2,
      Offset.fromDirection(rotation, 120).dy - 30, // Adjust vertical position
    );

    // Draw the text on canvas
    textPainter.paint(canvas, textPosition);

    // Draw Shadow For Inner Circle
    canvas.drawCircle(Offset.zero, 68, shadowCircle);

    // Draw Inner Circle
    canvas.drawCircle(Offset.zero, 65, circle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
