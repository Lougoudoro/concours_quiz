import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/modules/dashboard/dashboard_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/series_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/widgets/dashboard_header.dart';
import 'package:cncours_quiz/app/modules/dashboard/widgets/filter_drawer.dart';
import 'package:cncours_quiz/app/modules/dashboard/widgets/progress_card.dart';
import 'package:cncours_quiz/app/modules/dashboard/widgets/resume_card.dart';
import 'package:cncours_quiz/app/modules/dashboard/widgets/series_grid.dart';
import 'package:cncours_quiz/app/modules/notification/notification_controller.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Scaffold(
      appBar: _AppBar(),
      drawer: const FilterDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DashboardHeader(),
                      const SizedBox(height: 20),
                      Obx(() => ProgressCard(
                            progress: controller.globalProgress.value,
                            totalQuizzesDone: controller.totalQuizzesDone.value,
                            averageScore: controller.averageScore.value,
                          )),
                      Obx(() {
                        if (controller.lastActivity.value == null &&
                            controller.totalQuizzesDone.value == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: ResumeCard(lastActivity: null),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 28),
                            Text(
                              'Continuer l\'apprentissage',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            ResumeCard(
                                lastActivity: controller.lastActivity.value),
                          ],
                        );
                      }),
                      const SizedBox(height: 28),
                      Text(
                        'Concours de référence',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Obx(() {
                final serieController = Get.find<SerieController>();
                return SeriesGrid(
                  series: serieController.listing,
                  isLoading: serieController.listingLoading.value &&
                      serieController.listing.isEmpty,
                );
              }),
            ],
          ),
        ),
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
                : const Icon(Icons.notifications_outlined,
                    color: AppTheme.vertFaso, size: 26),
            onPressed: () => Get.toNamed(Routes.NOTIFICATION),
          );
        }),
        GestureDetector(
          onTap: () => Get.toNamed(Routes.SETTINGS),
          child: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.vertFaso,
              child: Icon(Icons.person_outline, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
