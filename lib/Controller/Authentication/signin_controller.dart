import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/Controller/Authentication/auth_controller.dart';
import 'package:tiktok_clone/View/screens/authentication/login_screen.dart';
import 'package:tiktok_clone/constant/network_manger.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  final password = TextEditingController();
  final userName = TextEditingController();
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final hidePassword = true.obs;
  Rx<Uint8List> imageBytes = Uint8List(0).obs;
  final AuthController _authController = AuthController();
  var isLoading = false.obs;

  /// SIGN-IN
  Future<void> signIn() async {
    try {
      // Loading
      isLoading.value = true;

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Get.snackbar(
          'Warning',
          'No Internet Connection',
          backgroundColor: Colors.red,
        );
        isLoading.value = false;
        return;
      }

      // Form Validation
      if (!signInFormKey.currentState!.validate()) {
        Get.snackbar(
          'Form',
          'Form field is not valid',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Get.isDarkMode ? Colors.white : Colors.black,
          margin: const EdgeInsets.all(15),
          icon: const Icon(
            Icons.message,
            color: Colors.white,
          ),
        );
        isLoading.value = false;
        return;
      }

      // Create Account to User
      await Future.delayed(const Duration(seconds: 3));
      _authController.createAccountForUser(
          userName.text, email.text, password.text, imageBytes.value);
      Get.snackbar(
        'Success',
        'Account has been created',
        backgroundColor: Colors.black87,
      );
      Get.offAll(() => const LoginScreen());
      isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Warning',
        e.toString(),
        backgroundColor: Colors.red,
      );
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Warning', e.toString());
      isLoading.value = false;
    }
  }

  void setImageBytes(Uint8List bytes) {
    imageBytes.value = bytes;
  }
}
