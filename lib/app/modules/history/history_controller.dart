import 'package:cncours_quiz/app/data/models/quiz_result.dart';
import 'package:cncours_quiz/app/modules/dashboard/gamification_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HistoryController extends GetxController {
  final _box = GetStorage();
  final _key = 'quiz_history';

  final RxList<QuizResult> history = <QuizResult>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  void _loadHistory() {
    final List<dynamic>? stored = _box.read(_key);
    if (stored != null) {
      history.assignAll(stored.map((e) => QuizResult.fromJson(e)).toList());
    }
  }

  void addResult(QuizResult result) {
    history.insert(0, result);
    if (history.length > 20) history.removeLast();
    _saveHistory();
    try {
      Get.find<GamificationController>().recordActivity(
        questionsCount: result.total,
      );
    } catch (_) {}
  }

  void _saveHistory() {
    _box.write(_key, history.map((e) => e.toJson()).toList());
  }

  void clearHistory() {
    history.clear();
    _box.remove(_key);
  }
}
