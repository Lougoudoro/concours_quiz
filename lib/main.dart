/// Point d'entrée de l'application ConcourQuiz BF
///
/// Application d'entraînement aux concours de la fonction publique
/// du Burkina Faso (Directs et Professionnels).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Forcer le mode portrait et le style de la barre de statut
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppTheme.fondSombre,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const ConcourQuizApp());
}

class ConcourQuizApp extends StatelessWidget {
  const ConcourQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConcourQuiz BF',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const OnboardingScreen(),
    );
  }
}
