import 'package:cncours_quiz/app/core/widgets/shimmer_loading.dart';
import 'package:cncours_quiz/app/modules/auth/auth_binding.dart';
import 'package:cncours_quiz/app/modules/auth/auth_screen.dart';
import 'package:cncours_quiz/app/modules/dashboard/dashboard_binding.dart';
import 'package:cncours_quiz/app/modules/dashboard/dashboard_screen.dart';
import 'package:cncours_quiz/app/modules/history/history_binding.dart';
import 'package:cncours_quiz/app/modules/history/history_screen.dart';
import 'package:cncours_quiz/app/modules/onboarding/onboarding_binding.dart';
import 'package:cncours_quiz/app/modules/onboarding/onboarding_screen.dart';
import 'package:cncours_quiz/app/modules/quiz/quiz_binding.dart';
import 'package:cncours_quiz/app/modules/quiz/quiz_screen.dart';
import 'package:cncours_quiz/app/modules/result/result_binding.dart';
import 'package:cncours_quiz/app/modules/result/result_screen.dart';
import 'package:cncours_quiz/app/modules/selection/selection_binding.dart';
import 'package:cncours_quiz/app/modules/selection/selection_screen.dart';
import 'package:cncours_quiz/app/modules/settings/settings_binding.dart';
import 'package:cncours_quiz/app/modules/settings/settings_screen.dart';
import 'package:cncours_quiz/app/modules/splash/splash_binding.dart';
import 'package:cncours_quiz/app/modules/splash/splash_screen.dart';
import 'package:cncours_quiz/app/data/models/question.dart';
import 'package:cncours_quiz/app/data/models/quiz_result.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = _Paths.DASHBOARD;
  static const LOGIN = _Paths.AUTH;

  static final routes = [
    GetPage(
        name: _Paths.SPLASH,
        page: () => const SplashScreen(),
        binding: SplashBinding()),
    GetPage(
        name: _Paths.ONBOARDING,
        page: () => const OnboardingScreen(),
        binding: OnboardingBinding()),
    GetPage(
        name: _Paths.AUTH,
        page: () => const AuthScreen(),
        binding: AuthBinding()),
    GetPage(
        name: _Paths.DASHBOARD,
        page: () => const DashboardScreen(),
        binding: DashboardBinding()),
    GetPage(
        name: _Paths.SETTINGS,
        page: () => const SettingsScreen(),
        binding: SettingsBinding()),
    GetPage(
      name: _Paths.QUIZ,
      page: () {
        if (Get.arguments == null) {
          Future.microtask(() => Get.offAllNamed(_Paths.DASHBOARD));
          return const Scaffold(body: Center(child: QuizShimmer()));
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
      binding: QuizBinding(),
    ),
    GetPage(
      name: _Paths.RESULTS,
      page: () {
        if (Get.arguments == null) {
          Future.microtask(() => Get.offAllNamed(_Paths.DASHBOARD));
          return const Scaffold(body: Center(child: QuizShimmer()));
        }
        return ResultScreen(quizResult: Get.arguments as QuizResult);
      },
      binding: ResultBinding(),
    ),
    GetPage(
        name: _Paths.HISTORY,
        page: () => const HistoryScreen(),
        binding: HistoryBinding()),
    GetPage(
        name: _Paths.SELECTION,
        page: () {
          final args = Get.arguments as Map<String, dynamic>;
          return SelectionScreen(
            title: args['title'],
            subtitle: args['subtitle'],
            items: args['items'],
            onSelect: args['onSelect'],
          );
        },
        binding: SelectionBinding()),
  ];
}
