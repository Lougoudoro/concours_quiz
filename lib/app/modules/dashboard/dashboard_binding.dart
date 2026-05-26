import 'package:cncours_quiz/app/modules/dashboard/bookmark_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/dashboard_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/formation_controller.dart';
import 'package:cncours_quiz/app/modules/history/history_controller.dart';
import 'package:cncours_quiz/data/mock_formation_data.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController());
    Get.put<BookmarkController>(BookmarkController());
    Get.put<HistoryController>(HistoryController());
    final formationController = Get.put(FormationController());

    // Initialisation avec la session active par défaut
    formationController
        .setSession(MockFormationData.getSession2026()); // sera retirer
  }
}
