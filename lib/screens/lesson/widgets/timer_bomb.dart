import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';

/// Een visuele 10-minuten timer in de vorm van een tikkende tijdbom.
/// De bom "vult" zich met lava naarmate de tijd verstrijkt.
class TimerBomb extends StatefulWidget {
  final Duration totalTime;
  final VoidCallback onTimeUp;

  const TimerBomb({
    super.key,
    this.totalTime = const Duration(minutes: 10),
    required this.onTimeUp,
  });

  @override
  State<TimerBomb> createState() => _TimerBombState();
}

class _TimerBombState extends State<TimerBomb>
    with SingleTickerProviderStateMixin {
  late Duration _remaining;
  Timer? _timer;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _remaining = widget.totalTime;
    _shakeController = AnimationController(
      vsync: this,
      duration: 100.ms,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining -= const Duration(seconds: 1);
          // Laatste 30 seconden: bom schudt
          if (_remaining.inSeconds <= 30 && _remaining.inSeconds > 0) {
            _shakeController.repeat(reverse: true);
          }
        } else {
          _timer?.cancel();
          widget.onTimeUp();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  double get _progress =>
      1.0 - (_remaining.inSeconds / widget.totalTime.inSeconds);

  @override
  Widget build(BuildContext context) {
    final minutes = _remaining.inMinutes;
    final seconds = _remaining.inSeconds % 60;
    final isUrgent = _remaining.inSeconds <= 30;

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeController.value * 4, 0),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isUrgent
                ? [AppTheme.danger, AppTheme.primary]
                : [AppTheme.surface, AppTheme.dark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUrgent
                ? AppTheme.danger.withAlpha(150)
                : AppTheme.secondary.withAlpha(60),
            width: isUrgent ? 2.5 : 1.5,
          ),
          boxShadow: isUrgent
              ? [
                  BoxShadow(
                    color: AppTheme.danger.withAlpha(80),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bom icoon
            Text(
              isUrgent ? '💣' : '⏰',
              style: TextStyle(
                fontSize: 28,
                shadows: isUrgent
                    ? [
                        Shadow(
                          color: AppTheme.danger.withAlpha(150),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Tijd
            Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: isUrgent ? Colors.white : AppTheme.secondary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(width: 12),
            // Vul-balkje
            SizedBox(
              width: 60,
              height: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: AppTheme.dark,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isUrgent ? AppTheme.danger : AppTheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
