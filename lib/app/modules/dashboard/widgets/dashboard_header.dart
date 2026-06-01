import 'package:cncours_quiz/app/core/controllers/auth_controller.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/modules/dashboard/gamification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salut, ${authController.authResource.value?.name ?? ''} 👋🏿',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Text('Prêt pour ton entraînement du jour ?'),
        const SizedBox(height: 16),
        Obx(() {
          final gamification = Get.find<GamificationController>();
          return Row(
            children: [
              _StreakBadge(streak: gamification.streak.value),
              const SizedBox(width: 10),
              Expanded(
                child: _DailyGoalBadge(
                  count: gamification.dailyCount.value,
                  isReached: gamification.isDailyGoalReached,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final int streak;
  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.vertFaso.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: streak),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, _) => Text(
              '$value jours',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyGoalBadge extends StatelessWidget {
  final int count;
  final bool isReached;
  const _DailyGoalBadge({required this.count, required this.isReached});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.vertFaso.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isReached ? Icons.check_circle : Icons.radio_button_unchecked,
              key: ValueKey(isReached),
              size: 14,
              color: isReached ? AppTheme.correctGreen : AppTheme.vertFaso,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '$count/${GamificationController.dailyGoal}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
