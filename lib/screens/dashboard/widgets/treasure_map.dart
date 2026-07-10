import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';

/// De schatkaart — het visuele hart van het dashboard.
/// Toont levels als eilanden op een kaart, met de huidige positie gemarkeerd.
class TreasureMap extends StatelessWidget {
  final int currentLevel;
  final int totalLevels;

  const TreasureMap({
    super.key,
    required this.currentLevel,
    this.totalLevels = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D1B2A), Color(0xFF1B2838)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.accent.withAlpha(50),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondary.withAlpha(20),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Achtergrond decoratie: stippellijn-pad
          CustomPaint(
            size: const Size(double.infinity, 220),
            painter: _MapPathPainter(
              color: AppTheme.accent.withAlpha(40),
            ),
          ),
          // Level-eilanden
          ...List.generate(totalLevels, (index) {
            final level = index + 1;
            final isUnlocked = level <= currentLevel;
            final isCurrent = level == currentLevel;
            final xFraction = index / (totalLevels - 1);
            final x = 40 + xFraction * (MediaQuery.of(context).size.width - 120);
            final y = isCurrent
                ? 80.0
                : 120.0 + (index % 3) * 25.0; // Golvend pad

            return Positioned(
              left: x - 25,
              top: y,
              child: _LevelIsland(
                level: level,
                isUnlocked: isUnlocked,
                isCurrent: isCurrent,
              ),
            );
          }),
          // Titel
          Positioned(
            top: 12,
            left: 20,
            child: Text(
              '🗺️ SCHATKAART',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.accent,
                    letterSpacing: 3,
                    fontSize: 14,
                  ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).scale(
          begin: const Offset(0.95, 0.95),
          duration: 600.ms,
          curve: Curves.elasticOut,
        );
  }
}

/// Een enkel level-eiland op de kaart.
class _LevelIsland extends StatelessWidget {
  final int level;
  final bool isUnlocked;
  final bool isCurrent;

  const _LevelIsland({
    required this.level,
    required this.isUnlocked,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final size = isCurrent ? 50.0 : 36.0;
    final color = isCurrent
        ? AppTheme.accent
        : isUnlocked
            ? AppTheme.secondary
            : AppTheme.textSecondary.withAlpha(60);

    return AnimatedContainer(
      duration: 500.ms,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUnlocked ? color.withAlpha(30) : Colors.transparent,
        border: Border.all(
          color: color,
          width: isCurrent ? 3 : 2,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppTheme.accent.withAlpha(100),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          isUnlocked ? '$level' : '🔒',
          style: TextStyle(
            color: isUnlocked ? Colors.white : AppTheme.textSecondary,
            fontSize: isCurrent ? 18 : 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

/// Schildert een golvende stippellijn als pad tussen de eilanden.
class _MapPathPainter extends CustomPainter {
  final Color color;

  _MapPathPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final dashedPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(40, 140);

    for (int i = 1; i <= 20; i++) {
      final x = 40.0 + (i / 19) * (size.width - 80);
      final y = 140.0 + (i % 3 == 0 ? -20.0 : i % 3 == 1 ? 20.0 : 0.0);
      path.lineTo(x, y);
    }

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + 8).clamp(0.0, metric.length);
        canvas.drawPath(
          metric.extractPath(distance, end),
          dashedPaint,
        );
        distance += 16;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
