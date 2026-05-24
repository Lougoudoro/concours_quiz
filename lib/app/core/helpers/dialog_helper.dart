import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelper {
  //show error dialog
  static void showErroDialog(
      {String title = 'Error', String? description = 'Something went wrong'}) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Get.textTheme.headlineMedium,
                ),
                Text(
                  description ?? '',
                  style: Get.textTheme.titleLarge,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (Get.isDialogOpen!) Get.back();
                  },
                  child: const Text('Okay'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


// confirmation dialogue

  static void showConfirmationDialog({
    required VoidCallback onYes,
    VoidCallback? onNo,
    String? title,
    String? content,
Color?titeColor=Colors.red,
Color?confirmColor=Colors.red,
  }) {
    Get.defaultDialog(
      title: title!.tr,
      barrierDismissible: true,
      titleStyle:  TextStyle(fontSize: 20, color: titeColor!),
      titlePadding: const EdgeInsets.all(16.0),

      content:  Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(content!.tr),
      ),
      textConfirm: 'OUI',
      contentPadding: const EdgeInsets.symmetric(horizontal:20),
      confirm: TextButton(
        child:  Text(
          "yes".tr,
          style:  TextStyle(color: confirmColor!),
        ),
        onPressed: () {
          Get.back(); 
          onYes();
        },
      ),
      cancel: TextButton(
        child:  Text(
          "no".tr,
          style: const TextStyle(color: Color.fromARGB(255, 24, 24, 24)),
        ),
        onPressed: () {
          onNo?.call();
          Get.back(); 
        },
      ),
    );
  }

  //show toast
  //show snack bar

  //show loading
  static void showLoading({String? message}) {
    print('message1');
    try {
      Get.dialog(
        const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Loading...'),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print("Error showing dialog: $e");
    }


  }

  //hide loading
  static void hideLoading() {

    if (Get.isDialogOpen!) Get.back();

  }
}
