import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tiktok_clone/Controller/Authentication/auth_controller.dart';
import '../../View/screens/home/home_screen.dart';
import '../../constant/network_manger.dart';

class LoginController extends GetxController {
  /// Variables
  final _auth = FirebaseAuth.instance;
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final localStorage = GetStorage();
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  var isLoading = false.obs;
  final AuthController _authController = AuthController();

  /// Initializing
  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  /// LOGIN
  Future<void> login() async {
    try {
      // Loading
      isLoading.value = true;

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Get.snackbar(
          'warning'.tr,
          'no Internet Connection'.tr,
          backgroundColor: Colors.red,
        );
        isLoading.value = false;
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        Get.snackbar(
          'form'.tr,
          'form field is not valid'.tr,
          snackPosition: SnackPosition.TOP,
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

      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login To User
      _authController.loginForUser(email.text, password.text);
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar(
        'success'.tr,
        'loginSuccess'.tr,
        backgroundColor: Colors.black87,
      );
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

  /// SignIn With Google
  Future<void> sigInGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      // Obtain the Auth detail from the request
      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;

      // Create a new credential
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await _auth.signInWithCredential(credentials);
      Get.to(() => const HomeScreen());
      Get.snackbar(
        'Success',
        'Login Successfully',
        backgroundColor: Colors.black87,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Warning',
        e.toString(),
        backgroundColor: Colors.red,
      );
    } catch (e) {
      Get.snackbar(
        'Warning',
        e.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  /// SignIn With Facebook
// Future<void> sigInFacebook() async {
//   try {
//     // Trigger the sign-in flow
//     final LoginResult loginResult = await FacebookAuth.instance.login();
//
//     // Create a credential from the access token
//     final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
//
//     // Once signed in, return the UserCredential
//     _auth.signInWithCredential(facebookAuthCredential);
//     Get.to(() => const HomeScreen());
//   } on FirebaseAuthException catch (e) {
//     Get.snackbar(
//       'Warning',
//       e.toString(),
//       backgroundColor: Colors.red,
//     );
//   } catch (e) {
//     Get.snackbar(
//       'Warning',
//       e.toString(),
//       backgroundColor: Colors.red,
//     );
//   }
// }

  /// SignIn With GitHub
// Future<void> signInGitHub() async{
//   // Create a GitHubSignIn instance
//   final GitHubSignIn gitHubSignIn = GitHubSignIn(
//       clientId: 'c938d83b08bf9c63f25e',
//       clientSecret: '2596f7b8f222877e038dca87135c5f7da266fb7f',
//       redirectUrl:
//       'https://fir-auth-test-bf4ec.firebaseapp.com/__/auth/handler');
//
//   // Trigger the sign-in flow
//   final result = await gitHubSignIn.signIn(context);
//
//   // Create a credential from the access token
//   final AuthCredential githubAuthCredential =
//   GithubAuthProvider.credential(result.token);
//   _isLoading = true;
//   notifyListeners();
//   // Once signed in, return the UserCredential
//   userCredential = await auth.signInWithCredential(githubAuthCredential);
// }

  /// SignIn With Linkedin
// Future<void> signInLinkedin() async{
//
// }
}
