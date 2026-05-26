import 'dart:io';

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

  late AuthProvider provider;
  Rx<AuthResource?> authResource = Rx<AuthResource?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxBool obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    provider = AuthProvider();
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

    try {
      var response = await provider.login(data: {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      });

      if (response['success'] == true) {
        
        authResource.value = AuthResource.fromJson(response['data']);
        Token.set(response['token'] as String);
        Get.offNamed(Routes.DASHBOARD);
      } else {
        errorMessage.value =
            response['message'] ?? 'Email ou mot de passe incorrect';
      }
    } on SocketException {
      errorMessage.value = 'Pas de connexion internet';
    } catch (e) {
      errorMessage.value = 'Erreur de connexion au serveur';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!loginformKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      var response = await provider.register(data: {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'password_confirmation': passwordConfirmationController.text,
        
      });

      if (response['success'] == true) {
        authResource.value = AuthResource.fromJson(response['data']);
        Token.set(response['token'] as String);
        Get.offNamed(Routes.DASHBOARD);
      } else {
        var message = response['message'] ?? 'Erreur lors de l\'inscription';
        if (response['errors'] != null) {
          var errors = response['errors'] as Map;
          message = errors.values
              .expand((e) => (e as List).cast<String>())
              .join('\n');
        }
        errorMessage.value = message;
      }
    } on SocketException {
      errorMessage.value = 'Pas de connexion internet';
    } catch (e) {
      errorMessage.value = 'Erreur de connexion au serveur';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await provider.logout();
    } catch (_) {}
    Token.delete();
    authResource.value = null;
    clearInputs();
    Get.offNamed(Routes.AUTH );
  }

  Future<void> fetchUser() async {
    try {
      var response = await provider.user();
      if (response['success'] == true) {
        authResource.value = AuthResource.fromJson(response['data']);
      }
    } catch (_) {}
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
