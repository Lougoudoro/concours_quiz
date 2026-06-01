import 'package:cncours_quiz/app/data/models/quiz_result.dart';
import 'package:cncours_quiz/app/modules/dashboard/series_controller.dart';
import 'package:cncours_quiz/app/modules/dashboard/session_controller.dart';
import 'package:cncours_quiz/app/modules/history/history_controller.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxDouble globalProgress = 0.0.obs;
  final Rx<QuizResult?> lastActivity = Rx<QuizResult?>(null);
  final RxInt totalQuizzesDone = 0.obs;
  final RxDouble averageScore = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStats();
  }

  void _loadStats() {
    try {
      final history = Get.find<HistoryController>().history;
      _computeStats(history);
    } catch (_) {}
  }

  void _computeStats(List<QuizResult> history) {
    if (history.isEmpty) {
      globalProgress.value = 0.0;
      lastActivity.value = null;
      totalQuizzesDone.value = 0;
      averageScore.value = 0.0;
      return;
    }

    lastActivity.value = history.first;
    totalQuizzesDone.value = history.length;
    averageScore.value =
        history.map((e) => e.percentage).reduce((a, b) => a + b) /
            history.length;
    globalProgress.value =
        history.map((e) => e.percentage).reduce((a, b) => a + b) /
            (history.length * 100);
  }

  @override
  Future<void> refresh() async {
    isLoading.value = true;
    await Future.wait([
      Get.find<SerieController>(tag: '').list(),
      Get.find<SessionController>().fetchSelectedSession(),
    ]);
    _loadStats();
    isLoading.value = false;
  }
}
