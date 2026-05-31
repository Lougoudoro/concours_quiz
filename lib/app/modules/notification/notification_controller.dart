import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  final _box = GetStorage();
  final _countKey = 'notification_unread_count';
  final _enabledKey = 'notifications_enabled';

  final RxInt unreadCount = 0.obs;
  final RxBool enabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    unreadCount.value = _box.read<int>(_countKey) ?? 3;
    enabled.value = _box.read<bool>(_enabledKey) ?? true;
  }

  void toggle() {
    enabled.value = !enabled.value;
    _box.write(_enabledKey, enabled.value);
  }

  void markAllRead() {
    unreadCount.value = 0;
    _box.write(_countKey, 0);
  }

  void addNotification() {
    unreadCount.value++;
    _box.write(_countKey, unreadCount.value);
  }
}
