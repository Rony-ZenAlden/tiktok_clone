import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetFormKey = GlobalKey<FormState>();

  /// Change Password
  Future passwordReset() async {
    if(forgetFormKey.currentState!.validate()){
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: email.text.trim());
        Get.snackbar('Notice', 'Password Reset');
      } on FirebaseAuthException catch (e) {
        Get.snackbar('Warning', e.toString(),backgroundColor: Colors.black87,);
      }
    }
  }

}