import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/modules/dashboard/dashboard_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/gamification_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/widgets/continue_learning.dart';
import 'package:cncours_quiz/app/modules/dashboard/widgets/dashboard_header.dart';
import 'package:cncours_quiz/app/modules/dashboard/widgets/filter_drawer.dart';
import 'package:cncours_quiz/app/modules/dashboard/widgets/progress_card.dart';
import 'package:cncours_quiz/app/modules/dashboard/widgets/stats_row.dart';
import 'package:cncours_quiz/app/modules/notification/notification_controller.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<DashboardController>();
    return Scaffold(
      appBar: _AppBar(),
      drawer: const FilterDrawer(),
      body: RefreshIndicator(
        onRefresh: ctrl.refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildBody(context, ctrl),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DashboardController ctrl) {
    final gamification = Get.find<GamificationController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const DashboardHeader(),
          const SizedBox(height: 20),
          Obx(
            () => ProgressCard(
              progress: ctrl.globalProgress.value,
              totalQuizzesDone: ctrl.totalQuizzesDone.value,
              averageScore: ctrl.averageScore.value,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => StatsRow(
              totalQuizzes: ctrl.totalQuizzesDone.value,
              avgScore: ctrl.averageScore.value,
              streak: gamification.streak.value,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            ctrl.lastActivity.value == null && ctrl.totalQuizzesDone.value == 0
                ? 'Premiers pas'
                : 'Continuer l\'apprentissage',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Obx(
            () => ContinueLearning(
              lastActivity: ctrl.lastActivity.value,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_open, color: AppTheme.vertFaso, size: 28),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        Obx(() {
          final count = Get.find<NotificationController>().unreadCount.value;
          return IconButton(
            icon: count > 0
                ? Badge(
                    label: Text(
                      count.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    child: const Icon(Icons.notifications_outlined,
                        color: AppTheme.vertFaso, size: 26),
                  )
                : Icon(
                    Icons.notifications_outlined,
                    color:
                        isDark ? AppTheme.textPrimarySombre : AppTheme.vertFaso,
                    size: 26,
                  ),
            onPressed: () => Get.toNamed(Routes.NOTIFICATION),
          );
        }),
        GestureDetector(
          onTap: () => Get.toNamed(Routes.SETTINGS),
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.vertFaso, Color(0xFF00B86B)],
              ),
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.person_outline, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
