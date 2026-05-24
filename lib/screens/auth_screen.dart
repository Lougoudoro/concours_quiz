import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  _isLogin ? 'Bon retour !' : 'Créer un compte',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin
                      ? 'Connectez-vous pour continuer votre apprentissage.'
                      : 'Rejoignez-nous pour sauvegarder votre progression.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                ),
                const SizedBox(height: 48),
                if (!_isLogin) ...[
                  _buildLabel('Nom complet'),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Ex: Jean Traoré',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 20),
                ],
                _buildLabel('Email ou Téléphone'),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'votre@email.com ou 70 00 00 00',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 20),
                _buildLabel('Mot de passe'),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: '••••••••',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: Icon(Icons.visibility_off_outlined),
                  ),
                  validator: (value) => value == null || value.length < 6 ? 'Min 6 caractères' : null,
                ),
                if (_isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Mot de passe oublié ?', style: TextStyle(color: AppTheme.vertFaso)),
                    ),
                  ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Get.offNamed('/dashboard');
                      }
                    },
                    child: Text(
                      _isLogin ? 'Se connecter' : 'S\'inscrire',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text(
                        _isLogin ? 'Pas de compte ?' : 'Déjà un compte ?',
                        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
                      ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin ? 'S\'inscrire' : 'Se connecter',
                        style: const TextStyle(color: AppTheme.vertFaso, fontWeight: FontWeight.bold),
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
