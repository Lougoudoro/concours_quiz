part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const AUTH = _Paths.AUTH;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const SETTINGS = _Paths.SETTINGS;
  static const QUIZ = _Paths.QUIZ;
  static const RESULTS = _Paths.RESULTS;
  static const HISTORY = _Paths.HISTORY;
  static const SELECTION = _Paths.SELECTION;
  static const GUIDE = _Paths.GUIDE;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const HELP = _Paths.HELP;
}

abstract class _Paths {
  static const SPLASH = '/';
  static const ONBOARDING = '/onboarding';
  static const AUTH = '/auth';
  static const DASHBOARD = '/dashboard';
  static const SETTINGS = '/settings';
  static const QUIZ = '/quiz';
  static const RESULTS = '/results';
  static const HISTORY = '/history';
  static const SELECTION = '/selection';
  static const GUIDE = '/guide';
  static const NOTIFICATION = '/notification';
  static const HELP = '/help';
}
