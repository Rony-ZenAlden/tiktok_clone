import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingManager {
  static void openLoading(String text) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false, // the dialog can not be dismissed ny tapping outside it.
      builder: (_) => PopScope(
        canPop: false, //Disable popping with back button.
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
