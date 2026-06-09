import 'package:cncours_quiz/app/data/models/quiz_custom_ids.dart';
import 'package:cncours_quiz/app/modules/dashboard/bookmark_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/dashboard_screen.dart';
import 'package:cncours_quiz/app/modules/history/history_screen.dart';
import 'package:cncours_quiz/app/modules/main_navigation/main_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/series_controller.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void _quickQuiz() {
    final series = Get.find<SerieController>().listing;
    if (series.isEmpty) return;
    final random = (series..shuffle()).first;
    Get.toNamed(Routes.SERIE, arguments: random);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _quickQuiz,
        backgroundColor: AppTheme.vertFaso.withOpacity(0.6),
        shape: const CircleBorder(),
        child: const Icon(Icons.bolt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: const [
              DashboardScreen(),
              _TrainingTab(),
              HistoryScreen(showBackButton: false),
              _BookmarksTab(),
            ],
          )),
      bottomNavigationBar: Obx(() => BottomAppBar(
            color: Theme.of(context).cardTheme.color,
            notchMargin: 4,
            shape: const CircularNotchedRectangle(),
            child: SizedBox(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    label: 'Accueil',
                    index: 0,
                    selectedIndex: controller.tabIndex.value,
                  ),
                  _NavItem(
                    icon: Icons.school_outlined,
                    selectedIcon: Icons.school,
                    label: 'Quiz',
                    index: 1,
                    selectedIndex: controller.tabIndex.value,
                  ),
                  const SizedBox(width: 10),
                  _NavItem(
                    icon: Icons.history_outlined,
                    selectedIcon: Icons.history,
                    label: 'Historique',
                    index: 2,
                    selectedIndex: controller.tabIndex.value,
                  ),
                  _NavItem(
                    icon: Icons.bookmark_border,
                    selectedIcon: Icons.bookmark,
                    label: 'Favoris',
                    index: 3,
                    selectedIndex: controller.tabIndex.value,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final int selectedIndex;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => Get.find<MainController>().changeTab(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? AppTheme.vertFaso : null,
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? AppTheme.vertFaso : null,
              fontWeight: isSelected ? FontWeight.w600 : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookmarksTab extends StatelessWidget {
  const _BookmarksTab();

  void _startBookmarkQuiz() {
    final bookmarks = Get.find<BookmarkController>().bookmarks;
    if (bookmarks.isEmpty) return;
    Get.toNamed(Routes.QUIZ, arguments: {
      'quizId': CustomQuiz.bookmarks.id,
      'quizName': CustomQuiz.bookmarks.name,
      'questions': bookmarks.toList(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<BookmarkController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes favoris'),
        centerTitle: true,
      ),
      body: Obx(() {
        final bookmarks = ctrl.bookmarks;
        if (bookmarks.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.orReussite.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bookmark_border,
                        color: AppTheme.orReussite, size: 48),
                  ),
                  const SizedBox(height: 20),
                  const Text('Aucun favori',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoute des questions en favoris pendant tes quiz pour les retrouver ici.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.vertFaso.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '${bookmarks.length} question${bookmarks.length > 1 ? 's' : ''} sauvegardée${bookmarks.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _startBookmarkQuiz,
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('Réviser mes favoris'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.vertFaso,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Aperçu des questions',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 12)),
            const SizedBox(height: 8),
            ...bookmarks.map((q) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.vertFaso.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.help_outline,
                          color: AppTheme.vertFaso, size: 18),
                    ),
                    title: Text(q.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14)),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark,
                          color: AppTheme.orReussite, size: 20),
                      onPressed: () => ctrl.toggle(q),
                    ),
                  ),
                )),
          ],
        );
      }),
    );
  }
}

class _TrainingTab extends StatelessWidget {
  const _TrainingTab();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SerieController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entraînement'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.listing.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.vertFaso.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school,
                      color: AppTheme.vertFaso, size: 48),
                ),
                const SizedBox(height: 20),
                Text('Aucun quiz disponible',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(
                  'Reviens bientôt, de nouveaux quiz seront ajoutés.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.list(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: controller.listing.length,
              itemBuilder: (context, index) {
                final serie = controller.listing[index];
                return _TrainingCard(serie: serie);
              },
            ),
          ),
        );
      }),
    );
  }
}

class _TrainingCard extends StatelessWidget {
  final dynamic serie;
  const _TrainingCard({required this.serie});

  void _openSerie() {
    Get.toNamed(Routes.SERIE, arguments: serie);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openSerie,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Theme.of(context).dividerTheme.color!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.vertFaso.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.quiz_outlined,
                  color: AppTheme.vertFaso, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              serie.name ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              serie.description ?? '',
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodyMedium?.color),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
