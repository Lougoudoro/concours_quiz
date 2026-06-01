import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  final int totalQuizzes;
  final double avgScore;
  final int streak;

  const StatsRow({
    super.key,
    required this.totalQuizzes,
    required this.avgScore,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppTheme.surfaceCardSombre : Colors.white;

    return SizedBox(
      height: 92,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        children: [
          _StatCard(
            icon: Icons.quiz_outlined,
            value: '$totalQuizzes',
            label: 'Quiz faits',
            color: AppTheme.vertFaso,
            surface: surface,
          ),
          const SizedBox(width: 10),
          _StatCard(
            icon: Icons.trending_up,
            value: '${avgScore.toStringAsFixed(0)}%',
            label: 'Moyenne',
            color: avgScore >= 70 ? AppTheme.correctGreen : AppTheme.orReussite,
            surface: surface,
          ),
          const SizedBox(width: 10),
          _StatCard(
            icon: Icons.local_fire_department,
            value: '$streak',
            label: 'Série (jours)',
            color: streak >= 7 ? AppTheme.orReussite : AppTheme.vertFaso,
            surface: surface,
          ),
          const SizedBox(width: 10),
          _StatCard(
            icon: Icons.emoji_events_outlined,
            value: (avgScore * totalQuizzes).toStringAsFixed(0),
            label: 'Points',
            color: AppTheme.orReussite,
            surface: surface,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color surface;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
