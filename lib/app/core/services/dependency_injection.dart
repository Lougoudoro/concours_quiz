import 'package:cncours_quiz/app/core/client/my_client.dart';
import 'package:cncours_quiz/app/core/controllers/auth_controller.dart';
import 'package:cncours_quiz/app/core/controllers/connectivity_controller.dart';
import 'package:cncours_quiz/app/core/controllers/theme_controller.dart';
import 'package:cncours_quiz/app/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DependencyInjection {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Future<void> init() async {
    await GetStorage.init();
    Get.put<MyClient>(MyClient());

    // 2. Inject the Provider which relies on MyClient
    Get.put<AuthProvider>(AuthProvider());
    Get.put<ThemeController>(ThemeController());
    Get.put<ConnectivityController>(ConnectivityController());
    Get.put<AuthController>(AuthController());
  }
}
