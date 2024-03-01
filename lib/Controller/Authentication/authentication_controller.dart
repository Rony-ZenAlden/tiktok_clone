import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tiktok_clone/View/screens/authentication/login_screen.dart';
import '../../View/screens/splash/onBoarding_screen.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController get instance => Get.find();

  /// Variables.
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  /// Called form main.dart on app lunch.
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
    super.onReady();
  }

  /// Function to show Relevant Screen.
  screenRedirect() async {
    deviceStorage.writeIfNull('IsFirstTime', true);
    deviceStorage.read('IsFirstTime') != true
        ? Get.offAll(() => const LoginScreen())
        : Get.offAll(() => const OnBoardingScreen());
  }

/* ----------------------- Email & Password sign-in ----------------------- */

  /// [EmailAuthentication] - login.

  /// [EmailAuthentication] - signIn.

  /// [ReAuthentication] - ReAuthenticate User.

  /// [EmailVerification] - Mail Verification.

  /// [EmailAuthentication] - Forget Password.

/* ----------------------- Email & Password sign-in ----------------------- */

  /// [GoogleAuthentication] - GOOGLE.

  /// [FacebookAuthentication] - FACEBOOK.

/* ----------------------- Email & Password sign-in ----------------------- */

  /// [LogoutUser] - Valid for any Authentication.

  /// [DeleteUser] - Remove user Auth and FireStore Account.
}
