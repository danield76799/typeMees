import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_progress.dart';
import '../models/lesson_result.dart';

/// Slaat de voortgang van de speler op en laadt deze.
class ProgressService {
  static const _key = 'player_progress';

  Future<PlayerProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return const PlayerProgress();
    try {
      return PlayerProgress.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return const PlayerProgress();
    }
  }

  Future<void> save(PlayerProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(progress.toJson()));
  }

  /// Controleert of de streak nog geldig is (gisteren gespeeld).
  /// Zo niet, reset de streak naar 0.
  Future<PlayerProgress> checkAndUpdateStreak() async {
    final progress = await load();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (progress.lastPlayedDate == null) {
      return progress;
    }

    final lastPlayed = DateTime(
      progress.lastPlayedDate!.year,
      progress.lastPlayedDate!.month,
      progress.lastPlayedDate!.day,
    );

    final difference = today.difference(lastPlayed).inDays;

    if (difference == 0) {
      // Vandaag al gespeeld — streak blijft
      return progress;
    } else if (difference == 1) {
      // Gisteren gespeeld — streak +1
      final updated = progress.copyWith(
        currentStreak: progress.currentStreak + 1,
        lastPlayedDate: now,
      );
      await save(updated);
      return updated;
    } else {
      // Streak verbroken
      final updated = progress.copyWith(
        currentStreak: 1,
        lastPlayedDate: now,
      );
      await save(updated);
      return updated;
    }
  }

  /// Silent helper: bij elke opstart controleren of de streak
  /// verstreken is en behouden.
  Future<PlayerProgress> reconcileStreak() => checkAndUpdateStreak();

  /// Werkt de voortgang bij met het resultaat van een afgeronde les.
  /// Dit is de enige plek waar lesresultaten naar persistentie gaan.
  Future<void> updateAfterLesson(LessonResult result) async {
    final progress = await load();

    final newTotalPoints = progress.totalPoints + result.pointsEarned;
    final newLevel = PlayerProgress.levelForPoints(newTotalPoints);

    final updated = progress.copyWith(
      totalPoints: newTotalPoints,
      level: newLevel,
      totalStars: progress.totalStars + result.starsEarned,
      lessonsCompleted: progress.lessonsCompleted + 1,
      lastPlayedDate: DateTime.now(),
    );

    await save(updated);
  }
}
