import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';

/// Toont het te typen woord met de huidige letter gemarkeerd.
/// Reeds getypte letters zijn groen, de huidige letter pulseert.
class WordDisplay extends StatelessWidget {
  final String word;
  final int currentIndex; // Welke letter de speler nu moet typen
  final String? wrongLetter; // Foutief getypte letter (kort rood)

  const WordDisplay({
    super.key,
    required this.word,
    required this.currentIndex,
    this.wrongLetter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.secondary.withAlpha(50), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondary.withAlpha(20),
            blurRadius: 15,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Schaal letters op basis van beschikbare breedte
          final wordWidth = constraints.maxWidth - 64; // padding binnen
          final letterSpacing = 4.0;
          final totalSpacing = (word.length - 1) * letterSpacing;
          final availableWidth = wordWidth - totalSpacing;
          final baseFontSize = (availableWidth / word.length).clamp(24.0, 48.0);

          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(word.length, (index) {
              final letter = word[index];
              final isTyped = index < currentIndex;
              final isCurrent = index == currentIndex;
              final isWrong = isCurrent && wrongLetter != null;

              Color letterColor;
              if (isTyped) {
                letterColor = AppTheme.success;
              } else if (isWrong) {
                letterColor = AppTheme.danger;
              } else if (isCurrent) {
                letterColor = AppTheme.secondary;
              } else {
                letterColor = AppTheme.textSecondary.withAlpha(100);
              }

              final fontSize = isCurrent ? baseFontSize * 1.1 : baseFontSize;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: isCurrent
                    ? _CurrentLetter(
                        letter: letter,
                        color: letterColor,
                        isWrong: isWrong,
                        fontSize: fontSize,
                      )
                    : Text(
                        letter.toUpperCase(),
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w900,
                          color: letterColor,
                          letterSpacing: letterSpacing,
                          decoration: isTyped ? TextDecoration.underline : null,
                          decorationColor: AppTheme.success.withAlpha(100),
                          decorationThickness: 3,
                        ),
                      ),
              );
            }),
          );
        },
      ),
    );
  }
}

/// De huidige letter — pulseert en heeft een underline cursor.
class _CurrentLetter extends StatelessWidget {
  final String letter;
  final Color color;
  final bool isWrong;
  final double fontSize;

  const _CurrentLetter({
    required this.letter,
    required this.color,
    required this.isWrong,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          letter.toUpperCase(),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: 4,
            shadows: [
              Shadow(
                color: color.withAlpha(120),
                blurRadius: 12,
              ),
            ],
          ),
        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
          ..scale(
            duration: 600.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.15, 1.15),
          ),
        Container(
          width: 30,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(100),
                blurRadius: 6,
              ),
            ],
          ),
        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
          ..fadeOut(duration: 400.ms),
      ],
    );
  }
}
