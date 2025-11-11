// lib/widgets/wavy_progress_bar.dart

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class WavyProgressBar extends StatelessWidget {
  final double progress; // Progress value (0.0 to 1.0)

  const WavyProgressBar({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double totalWidth = constraints.maxWidth;

        return Stack(
          children: [
            CustomPaint(
              size: Size(totalWidth, 20),
              painter: _WavyOutlinePainter(
                width: totalWidth,
                color: AppColors.border3,
              ),
            ),
            CustomPaint(
              size: Size(totalWidth * progress, 20),
              painter: _WavyOutlinePainter(
                width: totalWidth * progress,
                color: AppColors.primaryAccent,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WavyOutlinePainter extends CustomPainter {
  final double width;
  final Color color;

  _WavyOutlinePainter({required this.width, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path();
    _drawWavyPath(path, width, size.height);
    canvas.drawPath(path, paint);
  }

  // Shared function to draw the wavy path
  void _drawWavyPath(Path path, double width, double height) {
    double amplitude = height / 4;
    double waveLength = 20;

    // Start the path from the left
    path.moveTo(0, height / 2);

    // Add waves
    for (double x = 0; x < width; x += waveLength) {
      path.quadraticBezierTo(
        x + waveLength / 4,
        height / 2 - amplitude,
        x + waveLength / 2,
        height / 2,
      );
      path.quadraticBezierTo(
        x + 3 * waveLength / 4,
        height / 2 + amplitude,
        x + waveLength,
        height / 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
