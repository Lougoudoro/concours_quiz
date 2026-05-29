import 'package:cncours_quiz/app/core/services/dependency_injection.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/core/controllers/theme_controller.dart';
import 'package:cncours_quiz/app/data/models/token.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await DependencyInjection.init();

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ConcourQuizApp());
}

class ConcourQuizApp extends StatelessWidget {
  const ConcourQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    Token.delete(); // @TODO :: implement this
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      title: 'ConcourQuiz BF',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      getPages: AppPages.routes,
    );
  }
}
