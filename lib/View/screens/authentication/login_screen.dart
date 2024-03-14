import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:tiktok_clone/Controller/Authentication/login_controller.dart';
import 'package:tiktok_clone/View/screens/authentication/forgot_password_screen.dart';
import 'package:tiktok_clone/View/screens/authentication/sigin_screen.dart';
import '../../../Controller/theme/theme_controller.dart';
import '../../../constant/validator.dart';
import '../../../locale/locale_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    MyLocaleController controllerLang = Get.find();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          controllerLang.changeLang('ar');
                          Navigator.pop(context);
                        },
                        child: Text('1'.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          controllerLang.changeLang('en');
                          Navigator.pop(context);
                        },
                        child: Text('2'.tr),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.message_outlined,
            ),
          ),
          IconButton(
            onPressed: () {
              ThemeController().changeTheme();
              setState(() {
                Get.isDarkMode;
              });
            },
            icon: Get.isDarkMode
                ? const Icon(
                    CupertinoIcons.sun_max_fill,
                  )
                : const Icon(
                    CupertinoIcons.moon_stars_fill,
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: controller.loginFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image
                    Image.asset(
                      'assets/images/tiktok.png',
                      height: 200,
                      width: 200,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                    // Text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'welcome'.tr,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'glad to see you!'.tr,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Email Input
                    TextFormField(
                      validator: (value) => MyValidators.emailValidator(value),
                      controller: controller.email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'enterEmail'.tr,
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        filled: true,
                        contentPadding: const EdgeInsets.all(8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Input
                    Obx(() {
                      return TextFormField(
                        validator: (value) =>
                            MyValidators.passwordValidator(value),
                        controller: controller.password,
                        keyboardType: TextInputType.text,
                        obscureText: controller.hidePassword.value,
                        decoration: InputDecoration(
                          hintText: 'enterPassword'.tr,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  controller.hidePassword.value =
                                      !controller.hidePassword.value;
                                });
                              },
                              icon: controller.hidePassword.value
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility)),
                          border: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: Divider.createBorderSide(context)),
                          filled: true,
                          contentPadding: const EdgeInsets.all(8),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    // Forgot Password screen
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: (value) {
                                  controller.rememberMe.value =
                                      !controller.rememberMe.value;
                                },
                              ),
                            ),
                            Text(
                              'remember me'.tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              Get.to(
                                () => const ForgotPasswordScreen(),
                              );
                            },
                            child: Text(
                              'forgotPassword'.tr,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                                fontSize: 19,
                                color: Colors.blue,
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Login Button
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Obx(() {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.white24,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () async {
                            await controller.login();
                          },
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.black,
                                )
                              : Text(
                                  'login'.tr,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Obx(() {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.white24,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () async {
                            await controller.sigInGoogle();
                          },
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.black,
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'sign in with google'.tr,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/images/google.png',
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                        );
                      }),
                    ),
                    const SizedBox(height: 15),
                    // Sign in screen
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'do not have'.tr,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 19),
                        ),
                        InkWell(
                          onTap: () {
                            Get.offAll(const SignInScreen());
                          },
                          child: Text(
                            'Sign in'.tr,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
