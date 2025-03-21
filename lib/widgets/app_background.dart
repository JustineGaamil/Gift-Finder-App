import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/gold.jpg'),
          fit: BoxFit.cover,
          opacity: 0.0,  // Make the background image lighter
        ),
      ),
      child: child,
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  final Color color;

  BackgroundPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw top wave
    final topPath = Path();
    topPath.moveTo(0, 0);
    topPath.lineTo(size.width, 0);
    topPath.lineTo(size.width, size.height * 0.3);
    topPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.4,
      0,
      size.height * 0.3,
    );
    topPath.close();
    canvas.drawPath(topPath, paint);

    // Draw bottom wave
    final bottomPath = Path();
    bottomPath.moveTo(size.width, size.height);
    bottomPath.lineTo(0, size.height);
    bottomPath.lineTo(0, size.height * 0.7);
    bottomPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.6,
      size.width,
      size.height * 0.7,
    );
    bottomPath.close();
    canvas.drawPath(bottomPath, paint);

    // Draw circles
    for (var i = 0; i < 5; i++) {
      final radius = (size.width * 0.1) * (1 - i * 0.15);
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.2),
        radius,
        paint..color = color.withOpacity(0.03 * (5 - i)),
      );
    }

    for (var i = 0; i < 5; i++) {
      final radius = (size.width * 0.1) * (1 - i * 0.15);
      canvas.drawCircle(
        Offset(size.width * 0.2, size.height * 0.8),
        radius,
        paint..color = color.withOpacity(0.03 * (5 - i)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 