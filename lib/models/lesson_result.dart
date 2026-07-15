/// Het resultaat van een type-les.
class LessonResult {
  final int totalKeystrokes;
  final int correctKeystrokes;
  final int maxCombo;
  final int pointsEarned;
  final int starsEarned; // 1-3 sterren
  final double accuracy; // 0.0 - 1.0
  final int wordsCompleted;
  final Duration timePlayed;
  final bool? isTimeUp;
  final int roundReached;

  const LessonResult({
    required this.totalKeystrokes,
    required this.correctKeystrokes,
    required this.maxCombo,
    required this.pointsEarned,
    required this.starsEarned,
    required this.accuracy,
    required this.wordsCompleted,
    required this.timePlayed,
    this.isTimeUp,
    this.roundReached = 1,
  });
}
