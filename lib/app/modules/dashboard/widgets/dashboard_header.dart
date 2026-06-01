import 'package:cncours_quiz/app/core/controllers/auth_controller.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/modules/dashboard/gamification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final name = auth.authResource.value?.name ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [AppTheme.vertFaso, AppTheme.orReussite],
                    ).createShader(bounds),
                    child: Text(
                      'Salut, $name 👋',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Prêt pour ton entraînement du jour ?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                        ),
                  ),
                ],
              ),
            ),
            _StreakFlame(),
          ],
        ),
        const SizedBox(height: 20),
        Obx(() {
          final g = Get.find<GamificationController>();
          return _DailyGoalBar(
            count: g.dailyCount.value,
            isReached: g.isDailyGoalReached,
          );
        }),
      ],
    );
  }
}

class _StreakFlame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final streak = Get.find<GamificationController>().streak.value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: streak >= 7
              ? [AppTheme.orReussite, const Color(0xFFFF6B00)]
              : [AppTheme.vertFaso, AppTheme.vertFaso.withGreen(180)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (streak >= 7 ? AppTheme.orReussite : AppTheme.vertFaso)
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) => Transform.scale(
              scale: value,
              child: child,
            ),
            child: Text(
              streak >= 7 ? '🔥' : '🔥',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$streak',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.white,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            'jours',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyGoalBar extends StatelessWidget {
  final int count;
  final bool isReached;
  const _DailyGoalBar({required this.count, required this.isReached});

  @override
  Widget build(BuildContext context) {
    final progress = (count / GamificationController.dailyGoal).clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.surfaceCardSombre.withOpacity(0.6)
            : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isReached
              ? AppTheme.correctGreen.withOpacity(0.3)
              : AppTheme.vertFaso.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isReached
                    ? AppTheme.correctGreen
                    : AppTheme.vertFaso.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isReached ? Icons.check_circle : Icons.menu_book_rounded,
                  key: ValueKey(isReached),
                  color: isReached ? AppTheme.correctGreen : AppTheme.vertFaso,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isReached
                          ? 'Objectif quotidien atteint !'
                          : 'Objectif quotidien',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: isReached
                            ? AppTheme.correctGreen
                            : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    Text(
                      '$count/${GamificationController.dailyGoal}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isReached
                            ? AppTheme.correctGreen
                            : AppTheme.orReussite,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 6,
                      backgroundColor: isDark
                          ? AppTheme.borderSubtleSombre
                          : AppTheme.neutralGreyClair,
                      valueColor: AlwaysStoppedAnimation(
                        isReached ? AppTheme.correctGreen : AppTheme.vertFaso,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
