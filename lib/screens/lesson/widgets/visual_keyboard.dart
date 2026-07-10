import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';

/// Het visuele toetsenbord dat oplicht om te tonen welke vinger waar moet.
/// De huidige toets licht fel op, foute aanslagen geven rode feedback.
class VisualKeyboard extends StatelessWidget {
  final String? highlightedKey; // De toets die de speler moet indrukken
  final String? wrongKey; // De toets die foutief werd ingedrukt (kort rood)
  final Set<String> completedKeys; // Reeds correct getypte toetsen

  const VisualKeyboard({
    super.key,
    this.highlightedKey,
    this.wrongKey,
    this.completedKeys = const {},
  });

  // QWERTY layout rijen
  static const _row1 = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'];
  static const _row2 = ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'];
  static const _row3 = ['z', 'x', 'c', 'v', 'b', 'n', 'm'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface.withAlpha(180),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.secondary.withAlpha(40), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(_row1),
          const SizedBox(height: 6),
          _buildRow(_row2, indent: 16),
          const SizedBox(height: 6),
          _buildRow(_row3, indent: 32),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys, {double indent = 0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: indent),
        ...keys.map((key) => _KeyCap(
              letter: key,
              isHighlighted: key == highlightedKey,
              isWrong: key == wrongKey,
              isCompleted: completedKeys.contains(key),
            )),
      ],
    );
  }
}

/// Een enkele toets op het visuele toetsenbord.
class _KeyCap extends StatelessWidget {
  final String letter;
  final bool isHighlighted;
  final bool isWrong;
  final bool isCompleted;

  const _KeyCap({
    required this.letter,
    this.isHighlighted = false,
    this.isWrong = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isWrong
        ? AppTheme.danger
        : isHighlighted
            ? AppTheme.secondary
            : isCompleted
                ? AppTheme.success.withAlpha(60)
                : AppTheme.dark;

    final borderColor = isHighlighted
        ? AppTheme.secondary
        : isWrong
            ? AppTheme.danger
            : AppTheme.textSecondary.withAlpha(40);

    final textColor = isHighlighted || isWrong ? Colors.white : AppTheme.textSecondary;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: AnimatedContainer(
        duration: 150.ms,
        width: 32,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: isHighlighted ? 2 : 1),
          boxShadow: isHighlighted
              ? [
                  BoxShadow(
                    color: AppTheme.secondary.withAlpha(120),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : isWrong
                  ? [
                      BoxShadow(
                        color: AppTheme.danger.withAlpha(100),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
        ),
        child: Center(
          child: Text(
            letter.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: isHighlighted ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
