import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';

/// Een stoere level-up balk die laat zien hoe ver de speler is.
class LevelBar extends StatelessWidget {
  final int level;
  final int currentPoints;
  final int pointsNeeded;
  final double progress; // 0.0 - 1.0

  const LevelBar({
    super.key,
    required this.level,
    required this.currentPoints,
    required this.pointsNeeded,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.surface, AppTheme.dark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.secondary.withAlpha(60), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondary.withAlpha(30),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '⚡ LEVEL $level',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.secondary,
                  shadows: [
                    Shadow(
                      color: AppTheme.secondary.withAlpha(100),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              Text(
                '$currentPoints / $pointsNeeded XP',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Voortgangsbalk
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: AppTheme.dark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.secondary.withAlpha(40)),
              ),
              child: Stack(
                children: [
                  // Gevulde balk
                  AnimatedContainer(
                    duration: 800.ms,
                    curve: Curves.easeOutCubic,
                    width: progress *
                        (MediaQuery.of(context).size.width - 64),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.accent],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withAlpha(80),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  // Glow effect op de balk
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withAlpha(30),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2);
  }
}
