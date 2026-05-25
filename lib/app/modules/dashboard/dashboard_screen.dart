import 'package:cncours_quiz/app/core/controllers/auth_controller.dart';
import 'package:cncours_quiz/app/data/models/category.dart';
import 'package:cncours_quiz/app/data/models/formation.dart';
import 'package:cncours_quiz/app/data/models/question.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/controllers/theme_controller.dart';
import 'formation_controller.dart';
import '../history/history_controller.dart';
import 'bookmark_controller.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ─── Données des catégories (Version Originale) ─────────────────────
  static const List<ConcourCategory> _categories = [
    ConcourCategory(
        id: 'enaref',
        name: 'ENAREF',
        description: 'École Nationale des Régies Financières',
        icon: Icons.account_balance,
        totalQuestions: 20,
        progress: 0.35),
    ConcourCategory(
        id: 'enam',
        name: 'ENAM',
        description: 'École Nationale d\'Administration et de Magistrature',
        icon: Icons.gavel,
        totalQuestions: 20,
        progress: 0.15),
    ConcourCategory(
        id: 'sante',
        name: 'Santé',
        description: 'Concours du secteur de la santé',
        icon: Icons.local_hospital,
        totalQuestions: 20,
        progress: 0.0),
    ConcourCategory(
        id: 'police',
        name: 'Police',
        description: 'Concours d\'entrée à la Police Nationale',
        icon: Icons.shield,
        totalQuestions: 20,
        progress: 0.60),
    ConcourCategory(
        id: 'douanes',
        name: 'Douanes',
        description: 'Concours de la Direction Générale des Douanes',
        icon: Icons.local_shipping,
        totalQuestions: 20,
        progress: 0.0),
    ConcourCategory(
        id: 'education',
        name: 'Éducation',
        description: 'Concours de l\'éducation nationale',
        icon: Icons.school,
        totalQuestions: 20,
        progress: 0.45),
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final formationController = Get.find<FormationController>();
    final authController = Get.find<AuthController>();

    final globalProgress =
        _categories.map((c) => c.progress).reduce((a, b) => a + b) /
            _categories.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon:
                const Icon(Icons.menu_open, color: AppTheme.vertFaso, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Obx(() => IconButton(
                icon: Icon(themeController.isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined),
                onPressed: () => themeController.toggleTheme(),
              )),
          GestureDetector(
            onTap: () => Get.toNamed(Routes.SETTINGS),
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.vertFaso,
                child:
                    Icon(Icons.person_outline, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildFilterDrawer(context, formationController),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ─── En-tête de bienvenue ────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Salut, ${authController.authResource.value?.name} 👋🏿',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Text('Prêt pour ton entraînement du jour ?'),
                    const SizedBox(height: 24),
                    _buildGlobalProgressCard(globalProgress),

                    // --- Section Reprendre (Axe 2) ---
                    Obx(() {
                      final history = Get.find<HistoryController>().history;
                      if (history.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.vertFaso.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppTheme.vertFaso.withOpacity(0.15)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppTheme.vertFaso.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.play_arrow_rounded,
                                      color: AppTheme.vertFaso, size: 32),
                                ),
                                const SizedBox(height: 14),
                                const Text('Pas encore d\'historique',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text(
                                  'Termine ton premier quiz pour voir ta progression ici.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      final last = history.first;
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
                          _buildResumeCard(context, last),
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

            // ─── Grille de catégories (Originale) ────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _CategoryCard(category: _categories[index]),
                  childCount: _categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Drawer pour le filtrage hiérarchique ───────────────────────────
  Widget _buildFilterDrawer(BuildContext context, FormationController fc) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [AppTheme.vertFaso, Color(0xFF1A6B3C)]),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.filter_alt_outlined,
                      color: AppTheme.orReussite, size: 40),
                  const SizedBox(height: 12),
                  Obx(() => Text(
                        fc.activeSession.value?.name ??
                            'Sélectionner une session',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final session = fc.activeSession.value;
              if (session == null)
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
                          child: const Icon(Icons.filter_alt_outlined,
                              color: AppTheme.orReussite, size: 48),
                        ),
                        const SizedBox(height: 20),
                        const Text('Aucune session active',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text(
                          'Reviens bientôt, de nouvelles sessions de concours seront ajoutées.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color),
                        ),
                      ],
                    ),
                  ),
                );

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('FILTRAGE AVANCÉ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 12)),
                  ),
                  ...session.concoursTypes.map((type) => ListTile(
                        leading: Icon(
                            type.category == ConcoursCategory.direct
                                ? Icons.group
                                : Icons.work,
                            color: AppTheme.vertFaso),
                        title: Text(type.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(type.category == ConcoursCategory.direct
                            ? 'Candidats externes'
                            : 'Professionnels'),
                        trailing: const Icon(Icons.chevron_right, size: 18),
                        onTap: () {
                          Get.back(); // Ferme le drawer
                          _navigateToSubCategory(type);
                        },
                      )),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Mon historique'),
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.HISTORY);
                    },
                  ),
                  Obx(() {
                    final count =
                        Get.find<BookmarkController>().bookmarks.length;
                    return ListTile(
                      leading: Icon(
                          count > 0 ? Icons.bookmark : Icons.bookmark_border,
                          color: AppTheme.orReussite),
                      title: Text('Mes favoris${count > 0 ? ' ($count)' : ''}'),
                      onTap: () {
                        Get.back();
                        _navigateToBookmarks();
                      },
                    );
                  }),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Guide des concours'),
                    onTap: () {},
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _navigateToSubCategory(ConcoursType type) {
    final fc = Get.find<FormationController>();
    fc.selectConcoursType(type);
    Get.toNamed(Routes.SELECTION, arguments: {
      'title': type.name,
      'subtitle': type.category == ConcoursCategory.direct
          ? 'Niveau d\'étude'
          : 'Secteur / Corps',
      'items': fc.availableSubCategories,
      'onSelect': (item) => _navigateToCollection(item as SubCategory),
    });
  }

  void _navigateToCollection(SubCategory sub) {
    final fc = Get.find<FormationController>();
    fc.selectSubCategory(sub);
    Get.toNamed(Routes.SELECTION, arguments: {
      'title': sub.name,
      'subtitle': 'Période de formation',
      'items': fc.availableCollections,
      'onSelect': (item) => _navigateToSerie(item as Collection),
    });
  }

  void _navigateToSerie(Collection coll) {
    final fc = Get.find<FormationController>();
    fc.selectCollection(coll);
    Get.toNamed(Routes.SELECTION, arguments: {
      'title': coll.name,
      'subtitle': 'Séries de quiz',
      'items': fc.availableSeries,
      'onSelect': (item) {
        final fc = Get.find<FormationController>();
        fc.selectSerie(item as Serie);
        Get.toNamed(Routes.QUIZ, arguments: {
          'categoryId': item.id,
          'categoryName': item.name,
          'questions': item.questions.toList(),
        });
      },
    });
  }

  void _navigateToBookmarks() {
    final bookmarks = Get.find<BookmarkController>().bookmarks;
    if (bookmarks.isEmpty) return;
    Get.toNamed(Routes.QUIZ, arguments: {
      'categoryId': 'bookmarks',
      'categoryName': 'Mes favoris',
      'questions': bookmarks.toList(),
    });
  }

  Widget _buildGlobalProgressCard(double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppTheme.vertFaso, Color(0xFF1A6B3C)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppTheme.vertFaso.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Progression Générale',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text('${(progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                      color: AppTheme.orReussite, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation(AppTheme.orReussite)),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.bolt, size: 18),
            label: const Text('Test Rapide'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.orReussite,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeCard(BuildContext context, dynamic last) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.QUIZ, arguments: {
          'categoryId': 'last',
          'categoryName': last.categoryName,
          'questions': last.questionResults
              .map((e) => (e as dynamic).question)
              .toList()
              .cast<Question>(),
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.orReussite.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.orReussite.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.orReussite.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.orange),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(last.categoryName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(
                    'Dernier score: ${last.score}/${last.total} (${last.percentage.toStringAsFixed(0)}%)',
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.orReussite),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ConcourCategory category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Get.toNamed(Routes.QUIZ, arguments: {
          'categoryId': category.id,
          'categoryName': category.name
        });
      },
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
            Icon(category.icon, color: AppTheme.vertFaso, size: 28),
            const SizedBox(height: 12),
            Text(category.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(category.description,
                style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).textTheme.bodyMedium?.color),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
