import 'package:get/get.dart';

class MyValidators {
  static String? displayNameValidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'display name cannot be empty'.tr;
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'display name must be between 3 and 20 characters'.tr;
    }

    return null; // Return null if display name is valid
  }

  static String? displayLinkValidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'Display name cannot be empty';
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Display link must be between 3 and 20 characters';
    }

    return null; // Return null if display name is valid
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'please enter an email'.tr;
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(value)) {
      return 'please enter a valid email'.tr;
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'please enter a password'.tr;
    }
    if (value.length < 6) {
      return 'password must be at least 6 characters long'.tr;
    }
    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? uploadProdTexts({String? value, String? toBeReturnedString}) {
    if (value!.isEmpty) {
      return toBeReturnedString;
    }
    return null;
  }
}
