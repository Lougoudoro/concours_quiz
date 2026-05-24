import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';
import 'models/quiz_result.dart';
import 'models/question.dart';

import 'controllers/theme_controller.dart';
import 'controllers/history_controller.dart';
import 'controllers/formation_controller.dart';
import 'data/mock_formation_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Inject Controllers globally
  Get.put(ThemeController());
  Get.put(HistoryController());
  final formationController = Get.put(FormationController());
  
  // Initialisation avec la session active par défaut
  formationController.setSession(MockFormationData.getSession2026());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  runApp(const ConcourQuizApp());
}

class ConcourQuizApp extends StatelessWidget {
  const ConcourQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      title: 'ConcourQuiz BF',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      getPages: [
        GetPage(name: '/', page: () => const OnboardingScreen()),
        GetPage(name: '/auth', page: () => const AuthScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/settings', page: () => const SettingsScreen()),
        GetPage(
          name: '/quiz',
          page: () {
            if (Get.arguments == null) {
              Future.microtask(() => Get.offAllNamed('/dashboard'));
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            final args = Get.arguments as Map<String, dynamic>;
            return QuizScreen(
              categoryId: args['categoryId'],
              categoryName: args['categoryName'],
              questions: args['questions'] != null 
                  ? List<Question>.from(args['questions']) 
                  : null,
            );
          },
        ),
        GetPage(
          name: '/results',
          page: () {
            if (Get.arguments == null) {
              // Safety fallback: if arguments are lost (e.g. after hot restart),
              // go back to dashboard instead of crashing.
              Future.microtask(() => Get.offAllNamed('/dashboard'));
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return ResultScreen(quizResult: Get.arguments as QuizResult);
          },
        ),
      ],
    );
  }
}
