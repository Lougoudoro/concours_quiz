import 'package:cncours_quiz/app/core/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/theme_controller.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import '../notification/notification_controller.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final authController = Get.find<AuthController>();
    final notificationController = Get.find<NotificationController>();
    final isDark = themeController.isDarkMode;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Paramètres'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Obx(
              () => Column(
                children: [
                  // ─── Header Profil ──────────────────────────────────────
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _showAvatarOptions(context),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              AppTheme.getSurfaceCardActive(isDark),
                          backgroundImage: authController
                                      .authResource.value?.profilePhotoUrl !=
                                  null
                              ? NetworkImage(authController
                                  .authResource.value!.profilePhotoUrl!)
                              : null,
                          child: authController
                                      .authResource.value?.profilePhotoUrl ==
                                  null
                              ? const Icon(Icons.person,
                                  size: 50, color: AppTheme.vertFaso)
                              : null,
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
                            child: const Icon(Icons.edit,
                                size: 18, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                  authController.authResource.value?.name??'',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
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
                    trailing: Switch(
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
                    trailing: Obx(() => Switch(
                          value: notificationController.enabled.value,
                          onChanged: (val) => notificationController.toggle(),
                          activeColor: AppTheme.vertFaso,
                        )),
                  ),
                  const SizedBox(height: 24),

                  // ─── Section Compte & Sécurité ──────────────────────────
                  _buildSectionTitle(context, 'Compte & Sécurité'),
                  const SizedBox(height: 12),
                  _buildSettingCard(
                    context,
                    icon: Icons.person_outline,
                    title: 'Modifier le profil',
                    onTap: () => _showEditProfileSheet(context),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingCard(
                    context,
                    icon: Icons.lock_outline,
                    title: 'Changer le mot de passe',
                    onTap: () => _showChangePasswordSheet(context),
                  ),
                  const SizedBox(height: 24),

                  // ─── Section À propos ───────────────────────────────────
                  _buildSectionTitle(context, 'À propos de l\'application'),
                  const SizedBox(height: 12),
                  _buildSettingCard(
                    context,
                    icon: Icons.info_outline,
                    title: 'Version de l\'application',
                    trailing: const Text('v1.0.2',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingCard(
                    context,
                    icon: Icons.help_outline,
                    title: 'Aide & Support',
                    onTap: () => Get.toNamed(Routes.HELP),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            )));
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

  void _showAvatarOptions(BuildContext context) {
    final authController = Get.find<AuthController>();
    final hasPhoto = authController.authResource.value?.profilePhotoUrl != null;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                const Text('Photo de profil',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined,
                      color: AppTheme.vertFaso),
                  title: const Text('Choisir depuis la galerie'),
                  onTap: () {
                    Navigator.pop(ctx);
                    authController.pickAndUploadPhoto(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined,
                      color: AppTheme.vertFaso),
                  title: const Text('Prendre une photo'),
                  onTap: () {
                    Navigator.pop(ctx);
                    authController.pickAndUploadPhoto(ImageSource.camera);
                  },
                ),
                if (hasPhoto)
                  ListTile(
                    leading: const Icon(Icons.delete_outline,
                        color: AppTheme.rougeTerre),
                    title: const Text('Supprimer la photo',
                        style: TextStyle(color: AppTheme.rougeTerre)),
                    onTap: () {
                      Navigator.pop(ctx);
                      authController.deleteProfilePhoto();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditProfileSheet(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.authResource.value;
    final nameCtrl = TextEditingController(text: user?.name ?? '');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                const Text(
                  'Modifier le profil',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Nom complet',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Champ requis' : null,
                ),
             const SizedBox(height: 8),
                Obx(() {
                  if (authController.errorMessage.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        authController.errorMessage.value,
                        style: const TextStyle(
                            color: AppTheme.rougeTerre, fontSize: 13),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                const SizedBox(height: 8),
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;
                                final success =
                                    await authController.updateProfile(
                                  name: nameCtrl.text
                                );
                                if (success && ctx.mounted) {
                                  Navigator.pop(ctx);
                                  Get.snackbar(
                                    'Succès',
                                    'Profil modifié avec succès.',
                                    backgroundColor: AppTheme.vertFaso,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.vertFaso,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: authController.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Enregistrer',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    final authController = Get.find<AuthController>();
    final currentPwdCtrl = TextEditingController();
    final newPwdCtrl = TextEditingController();
    final confirmPwdCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final obscureCurrent = true.obs;
    final obscureNew = true.obs;
    final obscureConfirm = true.obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                const Text(
                  'Changer le mot de passe',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Saisis ton mot de passe actuel et le nouveau.',
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(ctx).textTheme.bodyMedium?.color),
                ),
                const SizedBox(height: 20),
                Obx(() => TextFormField(
                      controller: currentPwdCtrl,
                      obscureText: obscureCurrent.value,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe actuel',
                        prefixIcon: const Icon(Icons.lock_outline),
                        errorText: authController.errors['current_password']?.first,
                        suffixIcon: IconButton(
                          icon: Icon(obscureCurrent.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () => obscureCurrent.toggle(),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Champ requis' : null,
                    )),
                const SizedBox(height: 14),
                Obx(() => TextFormField(
                      controller: newPwdCtrl,
                      obscureText: obscureNew.value,
                      decoration: InputDecoration(
                        labelText: 'Nouveau mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                        errorText: authController.errors['password']?.first,
                        suffixIcon: IconButton(
                          icon: Icon(obscureNew.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () => obscureNew.toggle(),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Champ requis';
                        if (v.length < 6) return 'Minimum 6 caractères';
                        return null;
                      },
                    )),
                const SizedBox(height: 14),
                Obx(() => TextFormField(
                      controller: confirmPwdCtrl,
                      obscureText: obscureConfirm.value,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le nouveau mot de passe',
                        errorText: authController.errors['password_confirmation']?.first,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(obscureConfirm.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () => obscureConfirm.toggle(),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Champ requis';
                        if (v != newPwdCtrl.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 8),
                Obx(() {
                  if (authController.errorMessage.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        authController.errorMessage.value,
                        style: const TextStyle(
                            color: AppTheme.rougeTerre, fontSize: 13),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                const SizedBox(height: 8),
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;
                                final success =
                                    await authController.changePassword(
                                  currentPassword: currentPwdCtrl.text,
                                  newPassword: newPwdCtrl.text,
                                  newPasswordConfirmation: confirmPwdCtrl.text,
                                );
                                if (success && ctx.mounted) {
                                  Navigator.pop(ctx);
                                  Get.snackbar(
                                    'Succès',
                                    'Mot de passe modifié avec succès.',
                                    backgroundColor: AppTheme.vertFaso,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.vertFaso,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: authController.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Confirmer',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    )),
              ],
            ),
          ),
        );
      },
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
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(fontSize: 12))
            : null,
        trailing: trailing ??
            (onTap != null ? const Icon(Icons.chevron_right, size: 20) : null),
      ),
    );
  }
}
