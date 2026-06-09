import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aide & Support'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SectionCard(
            icon: Icons.contact_support_outlined,
            title: 'Contact',
            items: [
              _HelpItem(
                icon: Icons.email_outlined,
                text: 'slougoudoro@gmail.com',
                detail:
                    'Envoyez-nous un email pour toute question. Réponse sous 48h.',
              ),
              _HelpItem(
                icon: Icons.phone_outlined,
                text: '+226 56 80 96 35',
                detail: 'Appelez-nous du lundi au vendredi de 8h à 17h.',
              ),
            ],
          ),
          SizedBox(height: 12),
          _SectionCard(
            icon: Icons.help_outline,
            title: 'Questions fréquentes',
            items: [
              _HelpItem(
                icon: Icons.live_help_outlined,
                text: 'Comment passer un quiz ?',
                detail:
                    'Rends-toi dans le tableau de bord, sélectionne une session, '
                    'choisis un type de concours, une catégorie, une série, puis '
                    'un quiz. Tu peux ensuite répondre aux questions et valider.',
              ),
              _HelpItem(
                icon: Icons.live_help_outlined,
                text: 'Comment voir mes résultats ?',
                detail: 'Après avoir terminé un quiz, tu accèdes directement '
                    'à la page des résultats. Tu peux aussi les retrouver '
                    'dans "Mon historique" depuis le menu.',
              ),
              _HelpItem(
                icon: Icons.live_help_outlined,
                text: 'Comment sauvegarder mes favoris ?',
                detail:
                    'Pendant un quiz, appuie sur l\'icône de signet en haut '
                    'à droite d\'une question pour l\'ajouter à tes favoris. '
                    'Retrouve-les dans le menu "Mes favoris".',
              ),
            ],
          ),
          SizedBox(height: 12),
          _SectionCard(
            icon: Icons.report_problem_outlined,
            title: 'Signaler un problème',
            items: [
              _HelpItem(
                icon: Icons.bug_report_outlined,
                text: 'Signaler un bug',
                detail: 'Si tu rencontres un bug technique, décris-le nous par '
                    'email à slougoudoro@gmail.com avec une capture d\'écran.',
              ),
              _HelpItem(
                icon: Icons.feedback_outlined,
                text: 'Envoyer un feedback',
                detail:
                    'Tes suggestions nous aident à améliorer l\'application. '
                    'Écris-nous à slougoudoro@gmail.com.',
              ),
            ],
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<_HelpItem> items;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  final Set<int> _expandedIndexes = {};

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
                child: Icon(widget.icon, color: AppTheme.vertFaso, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < widget.items.length; i++) ...[
            _buildItem(context, i, widget.items[i]),
            if (i != widget.items.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, _HelpItem item) {
    final isExpanded = _expandedIndexes.contains(index);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              if (isExpanded) {
                _expandedIndexes.remove(index);
              } else {
                _expandedIndexes.add(index);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                Icon(item.icon, size: 20, color: AppTheme.orReussite),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.expand_more,
                      size: 20,
                      color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isExpanded
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(36, 0, 4, 8),
                  child: Text(
                    item.detail,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _HelpItem {
  final IconData icon;
  final String text;
  final String detail;

  const _HelpItem({
    required this.icon,
    required this.text,
    required this.detail,
  });
}
