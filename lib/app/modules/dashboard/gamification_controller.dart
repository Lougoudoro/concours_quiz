import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GamificationController extends GetxController {
  final _box = GetStorage();

  static const _streakKey = 'gam_streak';
  static const _lastDateKey = 'gam_last_date';
  static const _dailyKey = 'gam_daily_count';
  static const _dailyDateKey = 'gam_daily_date';
  static const _seriesKey = 'gam_series_progress';
  static const int dailyGoal = 10;

  final RxInt streak = 0.obs;
  final RxInt dailyCount = 0.obs;
  final RxMap<String, int> seriesProgress = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAll();
  }

  void _loadAll() {
    _loadStreak();
    _loadDaily();
    _loadSeriesProgress();
  }

  void _loadStreak() {
    final lastDateStr = _box.read<String>(_lastDateKey);
    final savedStreak = _box.read<int>(_streakKey) ?? 0;

    if (lastDateStr == null) {
      streak.value = 1;
      _box.write(_streakKey, 1);
      _box.write(_lastDateKey, _todayKey());
    } else {
      final lastDate = DateTime.tryParse(lastDateStr);
      if (lastDate != null) {
        final diff = DateTime.now().difference(lastDate).inDays;
        if (diff == 0) {
          streak.value = savedStreak;
        } else if (diff == 1) {
          streak.value = savedStreak + 1;
          _box.write(_streakKey, streak.value);
          _box.write(_lastDateKey, _todayKey());
        } else {
          streak.value = 1;
          _box.write(_streakKey, 1);
          _box.write(_lastDateKey, _todayKey());
        }
      }
    }
  }

  void _loadDaily() {
    final savedDate = _box.read<String>(_dailyDateKey);
    if (savedDate == _todayKey()) {
      dailyCount.value = _box.read<int>(_dailyKey) ?? 0;
    } else {
      dailyCount.value = 0;
      _box.write(_dailyDateKey, _todayKey());
      _box.write(_dailyKey, 0);
    }
  }

  void _loadSeriesProgress() {
    final stored = _box.read<Map<String, dynamic>>(_seriesKey);
    if (stored != null) {
      seriesProgress.assignAll(stored.map((k, v) => MapEntry(k, v as int)));
    }
  }

  void recordActivity({String? serieId, int questionsCount = 1}) {
    dailyCount.value += questionsCount;
    _box.write(_dailyKey, dailyCount.value);

    if (serieId != null) {
      final current = seriesProgress[serieId] ?? 0;
      seriesProgress[serieId] = current + questionsCount;
      _box.write(_seriesKey, seriesProgress.map((k, v) => MapEntry(k, v)));
    }
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  bool get isDailyGoalReached => dailyCount.value >= dailyGoal;
  double get dailyProgress => (dailyCount.value / dailyGoal).clamp(0, 1);

  int getSeriesProgress(String serieId) => seriesProgress[serieId] ?? 0;
}
