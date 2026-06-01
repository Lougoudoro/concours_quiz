part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const AUTH = _Paths.AUTH;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const MAIN = _Paths.MAIN;
  static const SETTINGS = _Paths.SETTINGS;
  static const QUIZ = _Paths.QUIZ;
  static const RESULTS = _Paths.RESULTS;
  static const HISTORY = _Paths.HISTORY;
  static const SELECTION = _Paths.SELECTION;
  static const GUIDE = _Paths.GUIDE;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const SERIE = _Paths.SERIE;
  static const LESSON = _Paths.LESSON;
  static const EXAM = _Paths.EXAM;
  static const BRANDS = _Paths.BRANDS;
  static const HELP = _Paths.HELP;
  static const PRIVACY_POLICY = _Paths.PRIVACY_POLICY;
}

abstract class _Paths {
  static const SPLASH = '/';
  static const ONBOARDING = '/onboarding';
  static const AUTH = '/auth';
  static const DASHBOARD = '/dashboard';
  static const MAIN = '/main';
  static const SETTINGS = '/settings';
  static const QUIZ = '/quiz';
  static const RESULTS = '/results';
  static const HISTORY = '/history';
  static const SELECTION = '/selection';
  static const GUIDE = '/guide';
  static const NOTIFICATION = '/notification';
  static const SERIE = '/serie';
  static const LESSON = '/lesson';
  static const EXAM = '/exam';
  static const BRANDS = '/brands';
  static const HELP = '/help';
  static const PRIVACY_POLICY = '/privacy-policy';
}
