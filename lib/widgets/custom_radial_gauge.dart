import 'package:flutter/material.dart';

class CustomRadialGauge extends StatelessWidget {
  final double size;           // Taille du widget
  final double strokeWidth;    // Épaisseur de l’anneau
  final Color backgroundColor; // Couleur de fond du cercle
  final Color progressColor;   // Couleur de la partie remplie
  final double? temperature;   // Température récupérée (en °C)
  final String? city;          // Nom de la ville
  final double maxTemperature; // Température maximale pour normaliser la progression

  const CustomRadialGauge({
    Key? key,
    this.size = 200,
    this.strokeWidth = 22,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.temperature,
    this.city,
    this.maxTemperature = 50.0, required double progress, // Température maximale par défaut
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Normaliser la température pour obtenir une progression entre 0.0 et 1.0
    final progress = temperature != null ? (temperature! / maxTemperature).clamp(0.0, 1.0) : 0.0;

    // Affiche la température et le nom de la ville ou des placeholders
    final tempText = temperature != null ? '${temperature!.toStringAsFixed(1)}°C' : '--';
    final cityText = city ?? '...';

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _GaugePainter(
              progress: progress,
              strokeWidth: strokeWidth,
              backgroundColor: backgroundColor,
              progressColor: progressColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tempText,
                style: TextStyle(
                  fontSize: size * 0.20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                cityText,
                style: TextStyle(
                  fontSize: size * 0.08,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _GaugePainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final sweepAngle = 2 * 3.141592653589793 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}