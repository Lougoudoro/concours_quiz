import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginformKey = GlobalKey<FormState>();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearInputs() {
    emailController.clear();
    passwordController.clear();
  }

  void login() async {
    if (loginformKey.currentState!.validate()) {
      Get.toNamed(AppPages.INITIAL, preventDuplicates: false);
      clearInputs();
    }
  }

  @override
  void onClose() {}
}
