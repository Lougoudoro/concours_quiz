import 'package:cncours_quiz/app/core/controllers/auth_controller.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/theme_controller.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final authController = Get.find<AuthController>();
    final isDark = themeController.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body:SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child:Obx(() =>  Column(
          children: [
            // ─── Header Profil ──────────────────────────────────────
            const SizedBox(height: 10),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.getSurfaceCardActive(isDark),
                    child: const Icon(Icons.person, size: 50, color: AppTheme.vertFaso),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.orReussite,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 18, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "${authController.authResource.value?.name}",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              "${authController.authResource.value?.email}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // ─── Section Préférences ────────────────────────────────
            _buildSectionTitle(context, 'Préférences Culturelles'),
            const SizedBox(height: 12),
            _buildSettingCard(
              context,
              icon: Icons.dark_mode_outlined,
              title: 'Mode Sombre',
              subtitle: 'Basculer entre thème clair et sombre',
              trailing:Switch(
                    value: themeController.isDarkMode,
                    onChanged: (val) => themeController.toggleTheme(),
                    activeColor: AppTheme.vertFaso,
                  ),
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              context,
              icon: Icons.notifications_none_outlined,
              title: 'Notifications',
              subtitle: 'Rappel d\'entraînement quotidien',
              trailing: Switch(
                value: true,
                onChanged: (val) {},
                activeColor: AppTheme.vertFaso,
              ),
            ),
            const SizedBox(height: 24),

            // ─── Section Compte & Sécurité ──────────────────────────
            _buildSectionTitle(context, 'Compte & Sécurité'),
            const SizedBox(height: 12),
            _buildSettingCard(
              context,
              icon: Icons.person_outline,
              title: 'Modifier le profil',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              context,
              icon: Icons.lock_outline,
              title: 'Changer le mot de passe',
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // ─── Section À propos ───────────────────────────────────
            _buildSectionTitle(context, 'À propos de l\'application'),
            const SizedBox(height: 12),
            _buildSettingCard(
              context,
              icon: Icons.info_outline,
              title: 'Version de l\'application',
              trailing: const Text('v1.0.2', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              context,
              icon: Icons.help_outline,
              title: 'Aide & Support',
              onTap: () {},
            ),
            const SizedBox(height: 32),

            // ─── Bouton Déconnexion ─────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => authController.logout(),
                icon: const Icon(Icons.logout),
                label: const Text('Se déconnecter'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.rougeTerre,
                  side: const BorderSide(color: AppTheme.rougeTerre),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      
      )
      )
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.vertFaso,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildSettingCard(BuildContext context,
      {required IconData icon,
      required String title,
      String? subtitle,
      Widget? trailing,
      VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerTheme.color!),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.getSurfaceCardActive(isDark),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.vertFaso, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(fontSize: 12))
            : null,
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, size: 20) : null),
      ),
    );
  }
}
