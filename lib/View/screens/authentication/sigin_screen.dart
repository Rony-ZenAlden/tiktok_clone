import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/View/screens/authentication/login_screen.dart';
import '../../../Controller/Authentication/auth_controller.dart';
import '../../../Controller/Authentication/signin_controller.dart';
import '../../../constant/validator.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    final AuthController imagePickerService = AuthController();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: controller.signInFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 60),
                    // Text
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'create account'.tr,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          'to get started now'.tr,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Obx(() {
                      return Stack(
                        children: [
                          if (controller.imageBytes.value.isNotEmpty)
                            CircleAvatar(
                              radius: 80,
                              backgroundImage: MemoryImage(
                                controller.imageBytes.value,
                              ),
                            )
                          else
                            const CircleAvatar(
                              radius: 80,
                              backgroundImage: AssetImage(
                                'assets/images/profile_avatar.jpg',
                              ),
                            ),
                          Positioned(
                            right: -5,
                            top: -5,
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    backgroundColor: Colors.white,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            imagePickerService
                                                .pickImageFromGallery(
                                                    controller);
                                            Navigator.pop(context);
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.photo,
                                                color: Colors.pink,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Pick Image From Gallery',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            imagePickerService
                                                .takePicture(controller);
                                            Navigator.pop(context);
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.camera_alt,
                                                color: Colors.purple,
                                              ),
                                              SizedBox(
                                                width: 7,
                                              ),
                                              Text(
                                                'Take Photo',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 20),
                    // User Name Input
                    TextFormField(
                      validator: (value) =>
                          MyValidators.displayNameValidator(value),
                      controller: controller.userName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'enterFullName'.tr,
                        prefixIcon: const Icon(Icons.person),
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
                    const SizedBox(height: 30),
                    // Sign in Button
                    SizedBox(
                      height: 60,
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
                            await controller.signIn();
                          },
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.black,
                                )
                              : Text(
                                  'Sign in'.tr,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    // Login screen
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an'.tr,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 19),
                        ),
                        InkWell(
                          onTap: () {
                            Get.offAll(const LoginScreen());
                          },
                          child: Text(
                            'login'.tr,
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
