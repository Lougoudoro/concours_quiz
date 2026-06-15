import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showBackButton;
  final VoidCallback? onBack;

  const EmptyState({
    super.key,
    this.icon = Icons.quiz_outlined,
    this.title = 'Aucune question disponible',
    this.subtitle = 'Reviens bientôt, de nouvelles questions seront ajoutées.',
    this.showBackButton = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.vertFaso, Color(0xFF00B86B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.vertFaso.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 44),
            ),
            const SizedBox(height: 24),
            Text(title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
            if (showBackButton) ...[
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: onBack ?? () => Get.back(),
                  icon: const Icon(Icons.arrow_back, size: 20),
                  label: const Text('Retour'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? AppTheme.surfaceCardActiveSombre
                        : AppTheme.neutralGreyClair,
                    foregroundColor: isDark
                        ? AppTheme.textPrimarySombre
                        : AppTheme.textPrimaryClair,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    side: BorderSide(
                      color: isDark
                          ? AppTheme.borderSubtleSombre
                          : AppTheme.borderSubtleClair,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
