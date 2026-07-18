import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../models/player_progress.dart';
import '../../models/lesson_result.dart';
import '../../services/progress_service.dart';
import '../lesson/lesson_screen.dart';
import 'widgets/treasure_map.dart';
import 'widgets/level_bar.dart';
import 'widgets/points_badge.dart';
import 'widgets/daily_streak.dart';

/// Het hoofd-dashboard: de Schatkaart met alle gamification-elementen.
class DashboardScreen extends StatefulWidget {
  final PlayerProgress progress;

  const DashboardScreen({super.key, required this.progress});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PlayerProgress _progress;
  final _progressService = ProgressService();

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
    // Herstel streak bij elke opstart (kan ook in main.dart, maar dit
    // werkt ook en houdt het dashboard up-to-date).
    _reconcileStreak();
  }

  Future<void> _reconcileStreak() async {
    final reconciled = await _progressService.reconcileStreak();
    if (mounted) {
      setState(() => _progress = reconciled);
    }
  }

  Future<void> _startLesson() async {
    final result = await Navigator.of(context).push<LessonResult>(
      MaterialPageRoute(
        builder: (_) => LessonScreen(
          level: _progress.level,
          currentStreak: _progress.currentStreak,
        ),
      ),
    );

    if (!mounted) return;
    if (result == null) return;

    // Update voortgang met lesresultaat
    final newTotalPoints = _progress.totalPoints + result.pointsEarned;
    final pointsNeeded = _progress.level * 500;
    final newLevel = (newTotalPoints / pointsNeeded).floor() + 1;

    setState(() {
      _progress = _progress.copyWith(
        totalPoints: newTotalPoints,
        level: newLevel,
        totalStars: _progress.totalStars + result.starsEarned,
        lessonsCompleted: _progress.lessonsCompleted + 1,
        lastPlayedDate: DateTime.now(),
      );
    });

    await _progressService.save(_progress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header: titel + punten + streak
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TYPETOPIA',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [AppTheme.primary, AppTheme.accent],
                                ).createShader(
                                  const Rect.fromLTWH(0, 0, 300, 70),
                                ),
                            ),
                      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.3),
                      const SizedBox(height: 4),
                      Text(
                        'Jouw type-avontuur! 🚀',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  PointsBadge(points: _progress.totalPoints),
                ],
              ),
              const SizedBox(height: 16),

              // Streak
              Align(
                alignment: Alignment.centerRight,
                child: DailyStreak(streak: _progress.currentStreak),
              ),
              const SizedBox(height: 20),

              // Schatkaart
              TreasureMap(
                currentLevel: _progress.level,
                totalLevels: 20,
              ),
              const SizedBox(height: 20),

              // Level balk
              LevelBar(
                level: _progress.level,
                currentPoints: _progress.pointsInCurrentLevel,
                pointsNeeded: _progress.pointsToNextLevel,
                progress: _progress.levelProgress,
              ),
              const SizedBox(height: 24),

              // START-knop
              _StartButton(onTap: _startLesson),
              const SizedBox(height: 16),

              // Prijzenkast knop
              _PrizeCabinetButton(),
              const SizedBox(height: 24),

              // Stats in grid
              _StatsGrid(progress: _progress),
            ],
          ),
        ),
      ),
    );
  }
}

/// De grote START-knop — het belangrijkste element.
class _StartButton extends StatelessWidget {
  final VoidCallback onTap;

  const _StartButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        splashColor: Colors.white.withAlpha(40),
        highlightColor: Colors.white.withAlpha(20),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, Color(0xFFFF8A65)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withAlpha(100),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('⚔️', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Text(
                  'START TYPELES',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(width: 12),
                const Text('⚔️', style: TextStyle(fontSize: 32)),
              ],
            ),
          ),
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
      ..scale(
        duration: 1500.ms,
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.03, 1.03),
        curve: Curves.easeInOut,
      )
      ..shimmer(
        duration: 2000.ms,
        color: Colors.white.withAlpha(30),
      );
  }
}

/// Knop naar de prijzenkast.
class _PrizeCabinetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        splashColor: AppTheme.secondary.withAlpha(40),
        highlightColor: AppTheme.secondary.withAlpha(20),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.secondary.withAlpha(40),
                AppTheme.secondary.withAlpha(20),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.secondary.withAlpha(80),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Text(
                  'PRIJZENKAST',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.secondary,
                        letterSpacing: 2,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Statistieken in een 2x2 grid.
class _StatsGrid extends StatelessWidget {
  final PlayerProgress progress;

  const _StatsGrid({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 360;
        final cards = [
          _StatCard(icon: '⭐', label: 'Sterren', value: '${progress.totalStars}', color: AppTheme.accent),
          _StatCard(icon: '✅', label: 'Lessen', value: '${progress.lessonsCompleted}', color: AppTheme.success),
          _StatCard(icon: '🎖️', label: 'Badges', value: '${progress.unlockedBadgeIds.length}', color: AppTheme.secondary),
          _StatCard(icon: '📊', label: 'Level', value: '${progress.level}', color: AppTheme.primary),
        ];

        if (isWide) {
          return IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 6, top: 4, bottom: 4),
                  child: cards[0],
                )),
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 4, top: 4, bottom: 4),
                  child: cards[1],
                )),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: cards[0]),
                    const SizedBox(width: 12),
                    Expanded(child: cards[1]),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    Expanded(child: cards[2]),
                    const SizedBox(width: 12),
                    Expanded(child: cards[3]),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms);
  }
}

/// Een enkel statistiek-kaartje.
class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(50), width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}
