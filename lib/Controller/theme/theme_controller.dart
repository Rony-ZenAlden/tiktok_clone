import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController {
  final lightTheme = ThemeData.light();
  final darkTheme = ThemeData.dark();

  final box = GetStorage();
  final darkModeKey = 'isDarkMode';

  RxBool isDarkMode = false.obs;

  void saveThemeData(bool isDarkMode) {
    box.write(darkModeKey, isDarkMode);
  }

  bool isSavedDarkMode() {
    return box.read(darkModeKey) ?? false;
  }

  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  void changeTheme() {
    Get.changeThemeMode(isSavedDarkMode() ? ThemeMode.light : ThemeMode.dark);
    saveThemeData(!isSavedDarkMode());
  }
}