import 'package:cncours_quiz/app/core/client/api_exception.dart';
import 'package:cncours_quiz/app/core/client/error_handler.dart';
import 'package:cncours_quiz/app/core/helpers/storage_helper.dart';
import 'package:cncours_quiz/app/data/models/token.dart';
import 'package:cncours_quiz/app/data/providers/auth_provider.dart';
import 'package:cncours_quiz/app/data/resources/auth_resource.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
  final RxMap<String, List> errors = <String, List>{}.obs;

  void clearInputs() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    errorMessage.value = '';
  }

  Future<void> login() async {
    if (!loginformKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      errors.assignAll({});

      final response = await ErrorHandler.guard(
        () => _provider.login(data: {
          'email': emailController.text.trim(),
          'password': passwordController.text,
        }),
        context: 'AuthController.login',
        showError: false,
        onError: (e) {
          if (e is ApiException) {
            errors.assignAll({
              'email': [e.message]
            });
          } else {
            errorMessage.value = e.message;
          }
        },
      );

      if (response != null && response['success'] == true) {
        authResource.value = AuthResource.fromJson(response['data']);
        Token.set(response['token'] as String);
        _cacheUser();
        isLoading.value = false;
        Get.offNamed(Routes.DASHBOARD);
        return;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!loginformKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      errors.assignAll({});

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
          if (e is ApiException && e.errors is Map<String, dynamic>) {
            errors.assignAll((e.errors as Map<String, dynamic>)
                .map((key, val) => MapEntry(key, val as List)));
          } else {
            errorMessage.value = e.message;
          }
        },
      );

      if (response != null && response['success'] == true) {
        authResource.value = AuthResource.fromJson(response['data']);
        Token.set(response['token'] as String);
        _cacheUser();
        Get.offNamed(Routes.DASHBOARD);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await ErrorHandler.run(() => _provider.logout(),
        context: 'AuthController.logout', showError: false);
    Token.delete();
    StorageHelper.delete(StorageHelper.cachedUserKey);
    authResource.value = null;
    clearInputs();
    Get.offNamed(Routes.AUTH);
  }

  Future<void> fetchUser() async {
    final response = await ErrorHandler.guard(() => _provider.user(),
        context: 'AuthController.fetchUser', showError: false);
    if (response != null && response['success'] == true) {
      authResource.value = AuthResource.fromJson(response['data']);
      _cacheUser();
    } else if (authResource.value == null) {
      _loadCachedUser();
    }
  }

  void _cacheUser() {
    if (authResource.value != null) {
      StorageHelper.set(
          StorageHelper.cachedUserKey, authResource.value!.toJson());
    }
  }

  void _loadCachedUser() {
    final cached = StorageHelper.get(StorageHelper.cachedUserKey);
    if (cached is Map<String, dynamic>) {
      authResource.value = AuthResource.fromJson(cached);
    }
  }

  bool get isLoggedIn => Token.get().isNotEmpty;

  Future<void> pickAndUploadPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await ErrorHandler.guard(
        () => _provider.uploadPhoto(filePath: picked.path),
        context: 'AuthController.pickAndUploadPhoto',
        showError: false,
        onError: (e) {
          errorMessage.value = e.message;
        },
      );
      if (response != null && response['success'] == true) {
        authResource.value = AuthResource.fromJson(response['data']);
        _cacheUser();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProfilePhoto() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await ErrorHandler.guard(
        () => _provider.deletePhoto(),
        context: 'AuthController.deleteProfilePhoto',
        showError: false,
        onError: (e) {
          errorMessage.value = e.message;
        },
      );
      if (response != null && response['success'] == true) {
        authResource.value = AuthResource.fromJson(response['data']);
        _cacheUser();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    required String name,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      errors.assignAll({});

      final response = await ErrorHandler.guard(
        () => _provider.updateProfile(data: {
          'name': name.trim(),
        }),
        context: 'AuthController.updateProfile',
        showError: false,
        onError: (e) {
          if (e is ApiException && e.errors is Map<String, dynamic>) {
            errors.assignAll((e.errors as Map<String, dynamic>)
                .map((key, val) => MapEntry(key, val as List)));
          } else {
            errorMessage.value = e.message;
          }
        },
      );

      if (response != null && response['success'] == true) {
        authResource.value = AuthResource.fromJson(response['data']);
        _cacheUser();
        isLoading.value = false;
        return true;
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      errors.assignAll({});

      final response = await ErrorHandler.guard(
        () => _provider.changePassword(data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': newPasswordConfirmation,
        }),
        context: 'AuthController.changePassword',
        showError: false,
        onError: (e) {
          if (e is ApiException && e.errors is Map<String, dynamic>) {
            errors.assignAll((e.errors as Map<String, dynamic>)
                .map((key, val) => MapEntry(key, val as List)));
          } else {
            errorMessage.value = e.message;
          }
        },
      );

      if (response != null && response['success'] == true) {
        isLoading.value = false;
        return true;
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.onClose();
  }
}
