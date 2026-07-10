import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';

/// Toont het aantal punten met een gouden gloed.
class PointsBadge extends StatelessWidget {
  final int points;

  const PointsBadge({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withAlpha(80),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🪙', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Text(
            '$points',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    ).animate().scale(
          duration: 300.ms,
          curve: Curves.elasticOut,
        );
  }
}
