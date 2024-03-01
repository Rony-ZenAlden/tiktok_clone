import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tiktok_clone/Controller/Authentication/auth_controller.dart';
import 'package:tiktok_clone/Controller/theme/theme_controller.dart';
import 'package:tiktok_clone/View/screens/splash/onBoarding_screen.dart';
import 'package:tiktok_clone/general_bindings.dart';
import 'firebase_options.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  // );
  ).then(
    (FirebaseApp value) => Get.put(AuthController()),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialBinding: GeneralBindings(),
      theme: ThemeController().lightTheme,
      darkTheme: ThemeController().darkTheme,
      themeMode: ThemeController().getThemeMode(),
      home: const OnBoardingScreen(),
    );
  }
}
