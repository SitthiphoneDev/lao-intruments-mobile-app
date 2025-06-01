import 'package:flutter/material.dart';

class WaveformWidget extends StatelessWidget {
  final List<double> waveformData;
  final Color color;
  final double height;
  final double strokeWidth;

  const WaveformWidget({
    super.key,
    required this.waveformData,
    this.color = Colors.blue,
    this.height = 60.0,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: WaveformPainter(
          waveformData: waveformData,
          color: color,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final Color color;
  final double strokeWidth;

  WaveformPainter({
    required this.waveformData,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData.isEmpty) return;

    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final path = Path();
    final stepWidth = size.width / waveformData.length;
    final centerY = size.height / 2;

    for (int i = 0; i < waveformData.length; i++) {
      final x = i * stepWidth;
      final amplitude = waveformData[i] * centerY;

      if (i == 0) {
        path.moveTo(x, centerY - amplitude);
      } else {
        path.lineTo(x, centerY - amplitude);
      }
    }

    canvas.drawPath(path, paint);

    // Draw mirror image below center line
    final mirrorPath = Path();
    for (int i = 0; i < waveformData.length; i++) {
      final x = i * stepWidth;
      final amplitude = waveformData[i] * centerY;

      if (i == 0) {
        mirrorPath.moveTo(x, centerY + amplitude);
      } else {
        mirrorPath.lineTo(x, centerY + amplitude);
      }
    }

    canvas.drawPath(mirrorPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
