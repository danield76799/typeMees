/// Het voortgangsmodel van de speler.
class PlayerProgress {
  final int level;
  final int totalPoints;
  final int currentStreak; // Dagen achter elkaar gespeeld
  final int totalStars;
  final int lessonsCompleted;
  final List<String> unlockedBadgeIds;
  final DateTime? lastPlayedDate;

  const PlayerProgress({
    this.level = 1,
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.totalStars = 0,
    this.lessonsCompleted = 0,
    this.unlockedBadgeIds = const [],
    this.lastPlayedDate,
  });

  /// Max punten nodig voor volgend level (wordt steeds moeilijker).
  int get pointsToNextLevel => level * 500;

  /// Hoeveel procent naar het volgende level (0.0 - 1.0).
  double get levelProgress {
    final needed = pointsToNextLevel;
    if (needed == 0) return 1.0;
    return (totalPoints % needed) / needed;
  }

  /// Punten verdiend in het huidige level.
  int get pointsInCurrentLevel => totalPoints % pointsToNextLevel;

  PlayerProgress copyWith({
    int? level,
    int? totalPoints,
    int? currentStreak,
    int? totalStars,
    int? lessonsCompleted,
    List<String>? unlockedBadgeIds,
    DateTime? lastPlayedDate,
  }) {
    return PlayerProgress(
      level: level ?? this.level,
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      totalStars: totalStars ?? this.totalStars,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
    );
  }

  Map<String, dynamic> toJson() => {
        'level': level,
        'totalPoints': totalPoints,
        'currentStreak': currentStreak,
        'totalStars': totalStars,
        'lessonsCompleted': lessonsCompleted,
        'unlockedBadgeIds': unlockedBadgeIds,
        'lastPlayedDate': lastPlayedDate?.toIso8601String(),
      };

  factory PlayerProgress.fromJson(Map<String, dynamic> json) {
    return PlayerProgress(
      level: json['level'] as int? ?? 1,
      totalPoints: json['totalPoints'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      totalStars: json['totalStars'] as int? ?? 0,
      lessonsCompleted: json['lessonsCompleted'] as int? ?? 0,
      unlockedBadgeIds: (json['unlockedBadgeIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      lastPlayedDate: json['lastPlayedDate'] != null
          ? DateTime.tryParse(json['lastPlayedDate'] as String)
          : null,
    );
  }
}
