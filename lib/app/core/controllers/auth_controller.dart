import 'package:cncours_quiz/app/core/client/error_handler.dart';
import 'package:cncours_quiz/app/data/models/token.dart';
import 'package:cncours_quiz/app/data/providers/auth_provider.dart';
import 'package:cncours_quiz/app/data/resources/auth_resource.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final GlobalKey<FormState> loginformKey = GlobalKey<FormState>();

  final AuthProvider _provider = Get.find<AuthProvider>();
  Rx<AuthResource?> authResource = Rx<AuthResource?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxBool obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void clearInputs() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    errorMessage.value = '';
  }

  Future<void> login() async {
    if (!loginformKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    final response = await ErrorHandler.guard(
      () => _provider.login(data: {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      }),
      context: 'AuthController.login',
      showError: false,
      onError: (e) {
        errorMessage.value = e.message;
      },
    );

    if (response != null && response['success'] == true) {
      authResource.value = AuthResource.fromJson(response['data']);
      Token.set(response['token'] as String);
      Get.offNamed(Routes.DASHBOARD);
    } else if (response != null) {
      errorMessage.value =
          response['message'] ?? 'Email ou mot de passe incorrect';
    }

    isLoading.value = false;
  }

  Future<void> register() async {
    if (!loginformKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    final response = await ErrorHandler.guard(
      () => _provider.register(data: {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'password_confirmation': passwordConfirmationController.text,
      }),
      context: 'AuthController.register',
      showError: false,
      onError: (e) {
        errorMessage.value = e.message;
      },
    );

    if (response != null && response['success'] == true) {
      authResource.value = AuthResource.fromJson(response['data']);
      Token.set(response['token'] as String);
      Get.offNamed(Routes.DASHBOARD);
    } else if (response != null) {
      var message = response['message'] ?? 'Erreur lors de l\'inscription';
      if (response['errors'] != null) {
        var errors = response['errors'] as List;
        message = errors.join('\n');
      }
      errorMessage.value = message;
    }

    isLoading.value = false;
  }

  Future<void> logout() async {
    await ErrorHandler.run(() => _provider.logout(),
        context: 'AuthController.logout', showError: false);
    Token.delete();
    authResource.value = null;
    clearInputs();
    Get.offNamed(Routes.AUTH);
  }

  Future<void> fetchUser() async {
    final response = await ErrorHandler.guard(() => _provider.user(),
        context: 'AuthController.fetchUser', showError: false);
    if (response != null && response['success'] == true) {
      authResource.value = AuthResource.fromJson(response['data']);
    }
  }

  bool get isLoggedIn => Token.get().isNotEmpty;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.onClose();
  }
}
