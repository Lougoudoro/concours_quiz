import 'package:cncours_quiz/app/core/controllers/auth_controller.dart';
import 'package:cncours_quiz/app/data/resources/question_resource.dart';
import 'package:cncours_quiz/app/data/resources/category_resource.dart';
import 'package:cncours_quiz/app/data/resources/concours_type_resource.dart';
import 'package:cncours_quiz/app/data/resources/quiz_resource.dart';
import 'package:cncours_quiz/app/data/resources/serie_resource.dart';
import 'package:cncours_quiz/app/modules/dashboard/dashboard_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/series_controller.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'session_controller.dart';
import '../notification/notification_controller.dart';
import '../history/history_controller.dart';
import 'bookmark_controller.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();
    final sessionController = Get.find<SessionController>();
    final authController = Get.find<AuthController>();
    final serieController = Get.find<SerieController>();

    final globalProgress = dashboardController.globalProgress;

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
          Obx(() {
            final count = Get.find<NotificationController>().unreadCount.value;
            return IconButton(
              icon: count > 0
                  ? Badge(
                      label: Text(
                        count.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
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
                child:
                    Icon(Icons.person_outline, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildFilterDrawer(context, sessionController),
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
                    _buildGlobalProgressCard(context, globalProgress),

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
                      "Concours de référence",
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
            Obx(() => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.95,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _CategoryCard(
                        serie: serieController.listing[index],
                      ),
                      childCount: serieController.listing.length,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // ─── Drawer pour le filtrage hiérarchique ───────────────────────────
  Widget _buildFilterDrawer(BuildContext context, SessionController fc) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [AppTheme.fondSombre, AppTheme.surfaceCardSombre]
                    : [AppTheme.vertFaso, const Color(0xFF1A6B3C)],
              ),
            ),
            child: Obx(() {
              final session = fc.activeSession.value;
              final brand = session?.brand;
              final hasLogo =
                  brand?.logoUrl != null && brand!.logoUrl!.isNotEmpty;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    hasLogo
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(brand.logoUrl!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                          brand.name.isNotEmpty
                                              ? Icons.school
                                              : Icons.school,
                                          color: AppTheme.orReussite,
                                          size: 28),
                                    )),
                          )
                        : Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.school,
                                color: AppTheme.orReussite, size: 28),
                          ),
                    const SizedBox(height: 12),
                    Text(
                      brand?.name ??
                          session?.name ??
                          'Sélectionner une session',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    if (brand?.description != null &&
                        brand!.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          brand.description,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              final session = fc.activeSession.value;
              if (session == null) {
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
              } else {
                return ListView(
                  physics: const BouncingScrollPhysics(),
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
                              type.statusValue == 'direct'
                                  ? Icons.group
                                  : Icons.work,
                              color: AppTheme.vertFaso),
                          title: Text(type.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(type.statusValue == 'direct'
                              ? 'Candidats externes'
                              : 'Professionnels'),
                          trailing: const Icon(Icons.chevron_right, size: 18),
                          onTap: () {
                            Get.back(); // Ferme le drawer
                            _navigateToCategories(type);
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
                        title:
                            Text('Mes favoris${count > 0 ? ' ($count)' : ''}'),
                        onTap: () {
                          Get.back();
                          _navigateToBookmarks();
                        },
                      );
                    }),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Guide des concours'),
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.GUIDE);
                      },
                    ),
                  ],
                );
              }
            }),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.rougeTerre),
            title: const Text('Se déconnecter',
                style: TextStyle(color: AppTheme.rougeTerre)),
            onTap: () {
              Get.back();
              Get.find<AuthController>().logout();
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  void _navigateToCategories(ConcoursTypeResource type) {
    final fc = Get.find<SessionController>();
    fc.selectConcoursType(type);
    Get.toNamed(Routes.SELECTION, arguments: {
      'title': type.name,
      'subtitle':
          type.statusValue == 'direct' ? 'Niveau d\'étude' : 'Secteur / Corps',
      'items': fc.availableSubCategories,
      'onSelect': (item) => _navigateToSeries(item as CategoryResource),
    });
  }

  void _navigateToSeries(CategoryResource sub) {
    final fc = Get.find<SessionController>();
    fc.selectSubCategory(sub);
    Get.toNamed(Routes.SELECTION,
        arguments: {
          'title': sub.name,
          'subtitle': sub.description,
          'items': fc.availableCollections,
          'onSelect': (item) => _navigateToQuizzes(item as SerieResource),
        },
        preventDuplicates: false);
  }

  void _navigateToQuizzes(SerieResource coll) {
    final fc = Get.find<SessionController>();
    fc.selectCollection(coll);
    final quizzes = fc.availableSeries;

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(coll.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  if (coll.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 12),
                      child: Text(coll.description,
                          style: TextStyle(
                              fontSize: 14,
                              color:
                                  Theme.of(ctx).textTheme.bodyMedium?.color)),
                    ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: quizzes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final item = quizzes[i];
                        return _QuizSheetCard(
                          item: item,
                          onTap: () {
                            Navigator.pop(ctx);
                            fc.selectSerie(item);
                            Get.toNamed(Routes.QUIZ, arguments: {
                              'quizId': item.id.toString(),
                              'quizName': item.title,
                              'questions': item.questions.toList(),
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToBookmarks() {
    final bookmarks = Get.find<BookmarkController>().bookmarks;
    if (bookmarks.isEmpty) return;
    Get.toNamed(Routes.QUIZ, arguments: {
      'quizId': 'bookmarks',
      'quizName': 'Mes favoris',
      'questions': bookmarks.toList(),
    });
  }

  Widget _buildGlobalProgressCard(BuildContext context, double progress) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progression Générale',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 14)),
              Text('${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                      color: AppTheme.orReussite, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: isDark
                    ? AppTheme.borderSubtleSombre
                    : AppTheme.neutralGreyClair,
                valueColor: const AlwaysStoppedAnimation(AppTheme.orReussite)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.bolt, size: 14),
                  label:
                      const Text('Test Rapide', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.vertFaso.withOpacity(0.2),
                    foregroundColor:
                        Theme.of(context).textTheme.bodyMedium?.color,
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
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
                  label: const Text('Examen blank',
                      style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.vertFaso.withOpacity(0.2),
                    foregroundColor:
                        Theme.of(context).textTheme.bodyMedium?.color,
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumeCard(BuildContext context, dynamic last) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.QUIZ, arguments: {
          'quizId': 'last',
          'quizName': last.quizName,
          'questions': last.questionResults
              .map((e) => (e as dynamic).question)
              .toList()
              .cast<QuestionResource>(),
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
                  Text(last.quizName,
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
  final SerieResource serie;
  const _CategoryCard({required this.serie});

  void _showQuizBottomSheet(BuildContext context) {
    final quizzes = serie.quizzes;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.book, color: AppTheme.vertFaso, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    serie.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${quizzes.length} quiz disponible${quizzes.length > 1 ? 's' : ''}',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              if (quizzes.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.quiz_outlined,
                            size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text('Aucun quiz disponible',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: quizzes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final quiz = quizzes[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                          Get.toNamed(Routes.QUIZ, arguments: {
                            'quizId': quiz.id.toString(),
                            'quizName': quiz.title,
                            'questions': quiz.questions,
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppTheme.vertFaso.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppTheme.vertFaso.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.quiz_outlined,
                                    color: AppTheme.vertFaso, size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      quiz.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      quiz.description,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${quiz.getQuesionsCount()} Q',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.vertFaso,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Icon(Icons.chevron_right,
                                  color: AppTheme.vertFaso, size: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showQuizBottomSheet(context);
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
            const Icon(Icons.book, color: AppTheme.vertFaso, size: 28),
            const SizedBox(height: 12),
            Text(serie.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(serie.description,
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

class _QuizSheetCard extends StatelessWidget {
  final QuizResource item;
  final VoidCallback onTap;

  const _QuizSheetCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerTheme.color!,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.vertFaso.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.assignment_outlined,
                  color: AppTheme.vertFaso),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.questions.length} questions',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppTheme.vertFaso),
          ],
        ),
      ),
    );
  }
}
