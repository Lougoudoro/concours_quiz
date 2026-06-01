import 'package:cncours_quiz/app/modules/dashboard/bookmark_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/dashboard_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/gamification_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/series_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/session_controller.dart';
import 'package:cncours_quiz/app/modules/history/history_controller.dart';
import 'package:cncours_quiz/app/modules/main_navigation/main_controller.dart';
import 'package:cncours_quiz/app/modules/notification/notification_controller.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainController>(MainController());
    Get.put<DashboardController>(DashboardController());
    Get.put<GamificationController>(GamificationController());
    Get.put<BookmarkController>(BookmarkController());
    Get.put<HistoryController>(HistoryController());
    Get.put<SerieController>(SerieController());
    Get.put<SessionController>(SessionController());
    Get.put<NotificationController>(NotificationController());
  }
}
