import 'package:cncours_quiz/app/core/controllers/auth_controller.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _authController.clearInputs();
    _authController.errorMessage.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
          child: Form(
            key: _authController.loginformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.vertFaso.withOpacity(0.1),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: IconButton(
                    onPressed: () => Get.offNamed(Routes.ONBOARDING),
                    icon: const Icon(Icons.chevron_left),
                    iconSize: 25,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _isLogin ? 'Bon retour, futur lauréat 🌟' : 'Créer un compte',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  _isLogin
                      ? 'Connectez-vous pour continuer votre apprentissage.'
                      : 'Rejoignez-nous pour sauvegarder votre progression.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                ),
                const SizedBox(height: 24),
                Obx(() {
                  if (_authController.errorMessage.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        _authController.errorMessage.value,
                        style:
                            TextStyle(color: Colors.red.shade700, fontSize: 13),
                      ),
                    ),
                  );
                }),
               
                _buildLabel('Email'),
                Obx(() => TextFormField(
                      controller: _authController.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: 'votre@email.com',
                          prefixIcon: const Icon(Icons.mail_outline),
                          errorText: _authController.errors['email']?.first),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Champ requis'
                              : null,
                    )),
                const SizedBox(height: 20),
                _buildLabel('Mot de passe'),
                Obx(() => TextFormField(
                      controller: _authController.passwordController,
                      obscureText: _authController.obscurePassword.value,
                      decoration: InputDecoration(
                        errorText: _isLogin
                            ? null
                            : _authController.errors['password']?.first,
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              _authController.obscurePassword.toggle(),
                          icon: Icon(
                            _authController.obscurePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      ),
                      validator: (value) => value == null || value.length < 6
                          ? 'Min 6 caractères'
                          : null,
                    )),
                if (!_isLogin) ...[
                  const SizedBox(height: 20),
                  _buildLabel('Confimation du Mot de passe'),
                  Obx(() => TextFormField(
                        controller:
                            _authController.passwordConfirmationController,
                        obscureText: _authController.obscurePassword.value,
                        decoration: const InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (value) => value == null || value.length < 6
                            ? 'Min 6 caractères'
                            : null,
                      ))
                ],
                if (_isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Mot de passe oublié ?',
                          style: TextStyle(color: AppTheme.vertFaso)),
                    ),
                  ),
                const SizedBox(height: 40),
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _authController.isLoading.value
                            ? null
                            : () {
                                if (_isLogin) {
                                  _authController.login();
                                } else {
                                  _authController.register();
                                }
                              },
                        child: _authController.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isLogin ? 'Se connecter' : 'S\'inscrire',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    )),
              
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? 'Vous n\'avez pas de compte ?' : 'Vous avez déjà un compte ?',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                        _authController.clearInputs();
                      },
                      child: Text(
                        _isLogin ? 'Créer-en un ici' : 'Se connecter',
                        style: const TextStyle(
                            color: AppTheme.vertFaso,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
    );
  }
}
