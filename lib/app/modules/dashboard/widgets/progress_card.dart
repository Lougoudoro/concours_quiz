import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final double progress;
  final int totalQuizzesDone;
  final double averageScore;

  const ProgressCard({
    super.key,
    required this.progress,
    required this.totalQuizzesDone,
    required this.averageScore,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceCardSombre : AppTheme.surfaceCardClair,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerTheme.color!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressHeader(progress: progress),
          const SizedBox(height: 12),
          _ProgressBar(progress: progress),
          const SizedBox(height: 16),
          _StatsRow(
            totalQuizzesDone: totalQuizzesDone,
            averageScore: averageScore,
          ),
          const SizedBox(height: 12),
          _QuickActions(),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final double progress;
  const _ProgressHeader({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Progression Générale',
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14)),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            key: ValueKey(progress),
            style: const TextStyle(
                color: AppTheme.orReussite, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) => LinearProgressIndicator(
          value: value,
          minHeight: 8,
          backgroundColor:
              isDark ? AppTheme.borderSubtleSombre : AppTheme.neutralGreyClair,
          valueColor: const AlwaysStoppedAnimation(AppTheme.orReussite),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int totalQuizzesDone;
  final double averageScore;
  const _StatsRow({required this.totalQuizzesDone, required this.averageScore});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(
          icon: Icons.checklist,
          label: '$totalQuizzesDone quiz',
          color: AppTheme.vertFaso,
        ),
        const SizedBox(width: 12),
        _StatChip(
          icon: Icons.trending_up,
          label: '${averageScore.toStringAsFixed(0)}% moy.',
          color:
              averageScore >= 70 ? AppTheme.correctGreen : AppTheme.orReussite,
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _StatChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.bolt, size: 14),
            label: const Text('Test Rapide', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.vertFaso.withOpacity(0.2),
              foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.bolt, size: 14),
            label: const Text('Examen blanc', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.vertFaso.withOpacity(0.2),
              foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
