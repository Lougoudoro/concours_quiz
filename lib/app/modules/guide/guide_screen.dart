import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide des concours'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SectionCard(
            icon: Icons.info_outline,
            title: 'Qu\'est-ce qu\'un concours ?',
            children: [
              'Un concours est un examen sélectif permettant d\'accéder à une formation ou à un poste dans la fonction publique. Il est organisé par l\'État ou des institutions privées.',
              'Les concours se déroulent généralement en deux phases : les épreuves écrites (admissibilité) puis les épreuves orales (admission).',
            ],
          ),
          SizedBox(height: 12),
          _SectionCard(
            icon: Icons.category_outlined,
            title: 'Types de concours',
            children: [
              'Concours direct : ouvert aux candidats externes remplissant les conditions de diplôme.',
              'Concours professionnel : réservé aux agents déjà en fonction dans l\'administration.',
              'Concours sur titre : sélection sur dossier académique sans épreuve écrite.',
            ],
          ),
          SizedBox(height: 12),
          _SectionCard(
            icon: Icons.lightbulb_outline,
            title: 'Conseils de préparation',
            children: [
              'Anticipe les inscriptions et prépare ton dossier administratif bien à l\'avance.',
              'Entraîne-toi avec des quiz sur les sujets des années précédentes.',
              'Gère ton temps : répartis les révisions sur plusieurs semaines.',
              'Sois régulier : 30 minutes de révision par jour valent mieux que 5 heures d\'affilée.',
            ],
          ),
          SizedBox(height: 12),
          _SectionCard(
            icon: Icons.assignment_outlined,
            title: 'Déroulement des épreuves',
            children: [
              'Les épreuves écrites comprennent généralement une composition sur un sujet d\'actualité ou technique, des questions à choix multiples (QCM), et des exercices pratiques.',
              'Les épreuves orales consistent en un entretien avec le jury, une présentation sur un sujet tiré au sort, et parfois une discussion de dossier.',
            ],
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> children;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.vertFaso.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.vertFaso.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppTheme.vertFaso, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final child in children) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, right: 10),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppTheme.orReussite,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    child,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ],
            ),
            if (child != children.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
