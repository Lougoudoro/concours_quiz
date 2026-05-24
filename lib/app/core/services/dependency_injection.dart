import 'package:cncours_quiz/app/core/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DependencyInjection {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Future<void> init() async {
    Get.put<ThemeController>(ThemeController());
    await GetStorage.init();
  }
}
