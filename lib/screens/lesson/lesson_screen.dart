import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';
import '../../../models/lesson_result.dart';
import '../../../models/typing_words.dart';
import '../../../services/progress_service.dart';
import 'widgets/visual_keyboard.dart';
import 'widgets/timer_bomb.dart';
import 'widgets/combo_counter.dart';
import 'widgets/word_display.dart';

/// Het type-les scherm — 10 minuten typen met gamification.
///
/// Elke ronde binnen een les wordt iets moeilijker:
/// * Ronde 1-3: niveau 1 (korte woorden)
/// * Ronde 4-6: niveau 2 (middellang)
/// * Ronde 7-9: niveau 3 (langer)
/// * Ronde 10+: niveau 4 (complex)
class LessonScreen extends StatefulWidget {
  final int level;
  final int currentStreak;

  const LessonScreen({
    super.key,
    required this.level,
    this.currentStreak = 0,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  // Woorden
  late List<String> _words;
  int _wordIndex = 0;
  int _letterIndex = 0;

  // Ronde tracking voor toenemende moeilijkheid
  int _round = 1;

  // Statistieken
  int _totalKeystrokes = 0;
  int _correctKeystrokes = 0;
  int _combo = 0;
  int _maxCombo = 0;
  int _points = 0;
  int _wordsCompleted = 0;

  // Feedback state
  String? _wrongKey;
  Timer? _wrongKeyTimer;
  bool _isFinished = false;
  bool _isTimeUp = false;
  final DateTime _startTime = DateTime.now();

  // Focus node voor keyboard input
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _setupRoundWords();
    // Vraag focus na build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  /// Bepaalt welke woorden gebruikt worden op basis van de ronde.
  /// Ronde 1-3: niveau 1, 4-6: niveau 2, 7-9: niveau 3, 10+: niveau 4.
  void _setupRoundWords() {
    final difficulty = switch (_round) {
      <= 3 => 1,
      <= 6 => 2,
      <= 9 => 3,
      _ => 4,
    };
    _words = getWordsForLevel(difficulty);
    _words.shuffle();
    _wordIndex = 0;
    _letterIndex = 0;
  }

  /// Gaat naar de volgende ronde met een hoger moeilijkheidsniveau.
  void _nextRound() {
    _round++;
    _setupRoundWords();
  }

  @override
  void dispose() {
    _wrongKeyTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  String get _currentWord {
    // Beschermd tegen out-of-bounds tijdens een race tussen
    // setState en build (vooral na het laatste woord).
    if (_wordIndex >= _words.length) return '';
    return _words[_wordIndex];
  }

  String get _currentLetter {
    final word = _currentWord;
    if (word.isEmpty || _letterIndex >= word.length) return '';
    return word[_letterIndex];
  }

  void _onKeyPressed(String key) {
    if (_isFinished) return;

    _totalKeystrokes++;

    final letter = _currentLetter;
    if (letter.isEmpty) return; // geen woord meer beschikbaar

    if (key == letter) {
      // ✅ Correct!
      _correctKeystrokes++;
      _combo++;
      if (_combo > _maxCombo) _maxCombo = _combo;

      // Punten: basis 10 + combo bonus
      final comboBonus = (_combo ~/ 5) * 5; // +5 per 5 combo
      _points += 10 + comboBonus;

      setState(() {
        _letterIndex++;
        _wrongKey = null;
      });

      // Woord af?
      if (_letterIndex >= _currentWord.length) {
        _wordsCompleted++;
        _letterIndex = 0;
        _wordIndex++;

        // Alle woorden op? Nieuwe ronde met moeilijkere woorden
        if (_wordIndex >= _words.length) {
          _nextRound();
        }
      }
    } else {
      // ❌ Fout
      _combo = 0;
      setState(() {
        _wrongKey = key;
      });

      // Reset wrong key na 400ms
      _wrongKeyTimer?.cancel();
      _wrongKeyTimer = Timer(400.ms, () {
        if (mounted) {
          setState(() => _wrongKey = null);
        }
      });
    }
  }

  void _onTimeUp() {
    if (_isFinished) return;
    _isTimeUp = true;
    _isFinished = true;
    _focusNode.unfocus();
  }

  LessonResult _buildResult() {
    final timePlayed = DateTime.now().difference(_startTime);
    final accuracy = _totalKeystrokes > 0
        ? _correctKeystrokes / _totalKeystrokes
        : 0.0;

    // Sterren: 1 ster voor deelname, 2 voor >80% accuraat, 3 voor >95%
    int stars = 1;
    if (accuracy >= 0.95) {
      stars = 3;
    } else if (accuracy >= 0.80) {
      stars = 2;
    }

    return LessonResult(
      totalKeystrokes: _totalKeystrokes,
      correctKeystrokes: _correctKeystrokes,
      maxCombo: _maxCombo,
      pointsEarned: _points,
      starsEarned: stars,
      accuracy: accuracy,
      wordsCompleted: _wordsCompleted,
      timePlayed: timePlayed,
      isTimeUp: _isTimeUp,
      roundReached: _round,
    );
  }

  /// Slaat de voortgang op en keert terug naar het dashboard.
  void _finishAndPop() async {
    final result = _buildResult();
    try {
      await ProgressService().updateAfterLesson(result);
    } catch (_) {
      // Als opslag mislukt, ga dan toch terug; de speler ziet de resultaten.
    }
    if (mounted) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) {
      return _CelebrationScreen(
        result: _buildResult(),
        onContinue: _finishAndPop,
      );
    }

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          final key = event.logicalKey.keyLabel.toLowerCase();
          if (key.length == 1 && key.codeUnitAt(0) >= 97 && key.codeUnitAt(0) <= 122) {
            _onKeyPressed(key);
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TimerBomb(onTimeUp: _onTimeUp),
                    ComboCounter(combo: _combo, maxCombo: _maxCombo),
                  ],
                ),
                const SizedBox(height: 8),

                // Ronde indicator
                Text(
                  'Ronde $_round',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),

                // Punten teller
                Text(
                  '🪙 $_points punten',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.accent,
                      ),
                ),
                const Spacer(),

                // Woord display
                WordDisplay(
                  word: _currentWord,
                  currentIndex: _letterIndex,
                  wrongLetter: _wrongKey,
                ),
                const SizedBox(height: 8),

                // Voortgang woorden
                Text(
                  'Woord ${_wordIndex + 1} van ${_words.length}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),

                // Visueel toetsenbord
                VisualKeyboard(
                  highlightedKey: _currentLetter,
                  wrongKey: _wrongKey,
                  completedKeys: _letterIndex > 0
                      ? _currentWord.substring(0, _letterIndex).split('').toSet()
                      : {},
                ),
                const SizedBox(height: 8),

                // Hint
                Text(
                  'Tik de oplichtende toets op je toetsenbord! 🎯',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Het feestelijke eindscherm na de les.
class _CelebrationScreen extends StatelessWidget {
  final LessonResult result;
  final VoidCallback onContinue;

  const _CelebrationScreen({
    required this.result,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final accuracyPercent = (result.accuracy * 100).round();
    final isTimeUp = result.isTimeUp ?? false;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sterren
                Text(
                  '🌟' * result.starsEarned,
                  style: const TextStyle(fontSize: 60),
                ).animate().scale(
                      duration: 600.ms,
                      begin: const Offset(0, 0),
                      end: const Offset(1.0, 1.0),
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(height: 16),

                // Titel
                Text(
                  isTimeUp ? 'TIJD OM! ⏰' : _celebrationTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms).slideY(begin: -0.2),
                const SizedBox(height: 12),

                // Ronde bereikt
                if (result.roundReached != null && result.roundReached! > 1)
                  Text(
                    'Je bereikte ronde ${result.roundReached}!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w600,
                        ),
                  ).animate().fadeIn(delay: 350.ms),
                const SizedBox(height: 24),

                // Stats kaart
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.secondary.withAlpha(50),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      _StatRow(
                        icon: '🎯',
                        label: 'Nauwkeurigheid',
                        value: '$accuracyPercent%',
                        color: accuracyPercent >= 80
                            ? AppTheme.success
                            : AppTheme.primary,
                      ),
                      const Divider(color: AppTheme.textSecondary, height: 24),
                      _StatRow(
                        icon: '🪙',
                        label: 'Punten verdiend',
                        value: '${result.pointsEarned}',
                        color: AppTheme.accent,
                      ),
                      const Divider(color: AppTheme.textSecondary, height: 24),
                      _StatRow(
                        icon: '🔥',
                        label: 'Hoogste combo',
                        value: '${result.maxCombo}x',
                        color: AppTheme.primary,
                      ),
                      const Divider(color: AppTheme.textSecondary, height: 24),
                      _StatRow(
                        icon: '📝',
                        label: 'Woorden getypt',
                        value: '${result.wordsCompleted}',
                        color: AppTheme.secondary,
                      ),
                      const Divider(color: AppTheme.textSecondary, height: 24),
                      _StatRow(
                        icon: '⌨️',
                        label: 'Aanslagen',
                        value: '${result.correctKeystrokes}/${result.totalKeystrokes}',
                        color: AppTheme.textSecondary,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),
                const SizedBox(height: 32),

                // Terug naar dashboard knop
                ElevatedButton(
                  onPressed: onContinue,
                  child: const Text('🏠 TERUG NAAR SCHATKAART'),
                ).animate().fadeIn(delay: 800.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get _celebrationTitle => switch (result.starsEarned) {
        3 => 'PERFECT! 🎉',
        2 => 'GOED GEDAAN! 👏',
        _ => 'GOED BEZIG! 💪',
      };
}

/// Een rij in de stats-kaart.
class _StatRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
        ),
      ],
    );
  }
}
