import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';

/// Toont de dagelijkse streak met een vuur-icoon.
class DailyStreak extends StatelessWidget {
  final int streak;

  const DailyStreak({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withAlpha(40),
            AppTheme.danger.withAlpha(30),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primary.withAlpha(80),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🔥',
            style: TextStyle(
              fontSize: 28,
              shadows: [
                Shadow(
                  color: AppTheme.primary.withAlpha(150),
                  blurRadius: 12,
                ),
              ],
            ),
          ).animate(onPlay: (controller) => controller.repeat())
            ..shimmer(
              duration: 1500.ms,
              color: AppTheme.accent.withAlpha(60),
            ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$streak',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              Text(
                'DAGEN STREAK',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
