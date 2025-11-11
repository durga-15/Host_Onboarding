import 'package:flutter/material.dart';

class WaveBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05) // Light color for the stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    double amplitude = 15.0; // Wave height
    double waveLength = 35.0; // Distance between wave peaks

    Path path = Path();

    // Save the current state of the canvas before rotating
    canvas.save();

    // Translate the canvas to the center to rotate around the center
    canvas.translate(size.width / 2, size.height / 2);

    // Rotate the canvas by 135 degrees (45 degrees flipped)
    canvas.rotate(135 * 3.14159265359 / 180);

    // Translate the canvas back to its original position
    canvas.translate(-size.width / 1, -size.height / 1);

    for (double y = -size.height * 2; y < size.height * 2; y += 40) {
      // Repeat the wave vertically
      path.moveTo(0, y);
      for (double x = -size.width * 2; x < size.width * 2; x += waveLength) {
        path.quadraticBezierTo(
          x + waveLength / 4,
          y - amplitude,
          x + waveLength / 2,
          y,
        );
        path.quadraticBezierTo(
          x + 3 * waveLength / 4,
          y + amplitude,
          x + waveLength,
          y,
        );
      }
    }

    canvas.drawPath(path, paint);

    // Restore the canvas state to prevent further rotation
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
