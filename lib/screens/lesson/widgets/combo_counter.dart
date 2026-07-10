import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';

/// Toont de huidige combo-multiplier met explosieve animaties.
class ComboCounter extends StatelessWidget {
  final int combo;
  final int maxCombo;

  const ComboCounter({
    super.key,
    required this.combo,
    required this.maxCombo,
  });

  @override
  Widget build(BuildContext context) {
    if (combo == 0) {
      return const SizedBox.shrink();
    }

    final isHighCombo = combo >= 10;
    final comboColor = isHighCombo ? AppTheme.accent : AppTheme.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            comboColor.withAlpha(40),
            comboColor.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: comboColor.withAlpha(100), width: 1.5),
        boxShadow: isHighCombo
            ? [
                BoxShadow(
                  color: AppTheme.accent.withAlpha(80),
                  blurRadius: 15,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isHighCombo ? '🔥' : '✨',
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(width: 6),
          Text(
            '${combo}x',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: comboColor,
                  fontWeight: FontWeight.w900,
                  fontSize: isHighCombo ? 28 : 22,
                ),
          ),
          if (isHighCombo) ...[
            const SizedBox(width: 6),
            Text(
              'COMBO!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.accent,
                    letterSpacing: 2,
                  ),
            ),
          ],
        ],
      ),
    )
        .animate(key: ValueKey(combo))
        .scale(
          duration: 200.ms,
          begin: const Offset(1.3, 1.3),
          end: const Offset(1.0, 1.0),
          curve: Curves.elasticOut,
        );
  }
}
