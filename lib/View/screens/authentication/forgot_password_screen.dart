import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/Controller/Authentication/forgot_password_controller.dart';
import '../../widgets/subtitle_text.dart';
import '../../widgets/title_text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final controller = Get.put(ForgetPasswordController());

  @override
  void dispose() {
    if (mounted) {
      controller.email.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'forgotPassword'.tr,
          style: const TextStyle(
            fontSize: 28,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: ListView(
            // shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              // Section 1 - Header
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                'assets/images/forgot_password.jpg',
                // width: size.width * 0.6,
                // height: size.width * 0.6,
              ),
              const SizedBox(
                height: 10,
              ),
              TitlesTextWidget(
                label: 'forgotPassword'.tr,
                fontSize: 22,
              ),
              SubtitleTextWidget(
                label:
                'pleaseEnter'.tr,
                fontSize: 14,
              ),
              const SizedBox(
                height: 40,
              ),

              Form(
                key: controller.forgetFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.email,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'enterEmail'.tr,
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(12),
                          child: const Icon(Icons.email),
                        ),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Email Address Must Not Be Empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    // backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.send),
                  label: Text(
                    'resetPassword'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () async {
                    await controller.passwordReset();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
