/// Écran A : Tableau de bord / Accueil
///
/// Affiche :
/// - Un en-tête de bienvenue avec la progression globale
/// - Les catégories de concours sous forme de cartes
/// - Un bouton "Lancer un test rapide"
library;

import 'package:flutter/material.dart';

import '../models/category.dart';
import '../theme/app_theme.dart';
import 'quiz_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ─── Données des catégories ─────────────────────────────────────────
  static const List<ConcourCategory> _categories = [
    ConcourCategory(
      id: 'enaref',
      name: 'ENAREF',
      description: 'École Nationale des Régies Financières',
      icon: Icons.account_balance,
      totalQuestions: 20,
      progress: 0.35,
    ),
    ConcourCategory(
      id: 'enam',
      name: 'ENAM',
      description: 'École Nationale d\'Administration et de Magistrature',
      icon: Icons.gavel,
      totalQuestions: 20,
      progress: 0.15,
    ),
    ConcourCategory(
      id: 'sante',
      name: 'Santé',
      description: 'Concours du secteur de la santé',
      icon: Icons.local_hospital,
      totalQuestions: 20,
      progress: 0.0,
    ),
    ConcourCategory(
      id: 'police',
      name: 'Police',
      description: 'Concours d\'entrée à la Police Nationale',
      icon: Icons.shield,
      totalQuestions: 20,
      progress: 0.60,
    ),
    ConcourCategory(
      id: 'douanes',
      name: 'Douanes',
      description: 'Concours de la Direction Générale des Douanes',
      icon: Icons.local_shipping,
      totalQuestions: 20,
      progress: 0.0,
    ),
    ConcourCategory(
      id: 'education',
      name: 'Éducation',
      description: 'Concours de l\'éducation nationale',
      icon: Icons.school,
      totalQuestions: 20,
      progress: 0.45,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Progression globale moyenne
    final globalProgress = _categories.isEmpty
        ? 0.0
        : _categories.map((c) => c.progress).reduce((a, b) => a + b) /
            _categories.length;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ─── En-tête ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo / Titre de l'app
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.vertFaso, AppTheme.orReussite],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.quiz_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ConcourQuiz BF',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Prépare ton concours 🇧🇫',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Icône de profil
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.surfaceCardActive,
                          child: const Icon(
                            Icons.person_outline,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ─── Carte de progression globale ────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF0D4F28),
                            Color(0xFF1A6B3C),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.vertFaso.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Progression globale',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${(globalProgress * 100).toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    color: AppTheme.orReussite,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Barre de progression
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: globalProgress,
                              minHeight: 8,
                              backgroundColor: Colors.white.withOpacity(0.15),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.orReussite,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Bouton test rapide
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const QuizScreen(
                                      categoryId: 'enaref',
                                      categoryName: 'Test Rapide',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.bolt, size: 20),
                              label: const Text('Lancer un test rapide'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.orReussite,
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ─── Titre de section ────────────────────────────
                    Text(
                      'Catégories de concours',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choisis ta catégorie pour commencer',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            // ─── Grille de catégories ───────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final cat = _categories[index];
                    return _CategoryCard(category: cat);
                  },
                  childCount: _categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte de catégorie interactive
class _CategoryCard extends StatelessWidget {
  final ConcourCategory category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => QuizScreen(
              categoryId: category.id,
              categoryName: category.name,
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.borderSubtle,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icône
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.vertFaso.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category.icon,
                color: AppTheme.vertFaso,
                size: 22,
              ),
            ),
            const SizedBox(height: 12),
            // Nom
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            // Description
            Expanded(
              child: Text(
                category.description,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            // Barre de progression
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: category.progress,
                      minHeight: 5,
                      backgroundColor: AppTheme.borderSubtle,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        category.progress > 0
                            ? AppTheme.vertFaso
                            : AppTheme.borderSubtle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(category.progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
