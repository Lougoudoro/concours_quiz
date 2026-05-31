import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Politique de confidentialité'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            title: '1. Collecte des informations',
            content:
                'Nous collectons certaines informations personnelles lorsque vous utilisez '
                'ConcoursOp BF, notamment votre nom, adresse email, et les données de '
                'navigation au sein de l\'application. Ces informations sont utilisées '
                'pour personnaliser votre expérience et améliorer nos services.',
          ),
          _section(
            title: '2. Utilisation des informations',
            content: 'Les informations collectées nous permettent de :\n\n'
                '• Fournir et maintenir le service\n'
                '• Vous notifier des changements importants\n'
                '• Permettre votre participation aux fonctionnalités interactives\n'
                '• Assurer le support technique\n'
                '• Analyser l\'utilisation pour améliorer l\'application',
          ),
          _section(
            title: '3. Protection des données',
            content:
                'Nous mettons en œuvre des mesures de sécurité techniques et '
                'organisationnelles appropriées pour protéger vos données personnelles '
                'contre tout accès non autorisé, modification, divulgation ou destruction.',
          ),
          _section(
            title: '4. Partage des données',
            content:
                'Nous ne vendons ni ne louons vos données personnelles à des tiers. '
                'Nous pouvons partager vos informations uniquement avec votre consentement '
                'ou lorsque la loi l\'exige.',
          ),
          _section(
            title: '5. Vos droits',
            content:
                'Vous avez le droit d\'accéder, de modifier ou de supprimer vos données '
                'personnelles à tout moment. Pour exercer ces droits, contactez-nous à '
                'support@concoursop.bf.',
          ),
          _section(
            title: '6. Contact',
            content:
                'Pour toute question concernant cette politique de confidentialité, '
                'veuillez nous contacter à support@concoursop.bf.',
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Dernière mise à jour : Mai 2026',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close),
              label: const Text('Fermer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.vertFaso,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _section({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.vertFaso.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle_outline,
                    size: 18, color: AppTheme.vertFaso),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.orReussite,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Get.theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
