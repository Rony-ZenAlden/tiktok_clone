import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/Controller/home/profile_controller.dart';
import 'package:tiktok_clone/Controller/home/settings_controller.dart';
import 'package:tiktok_clone/global.dart';

import '../../../../widgets/input_text_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsController controller = Get.put(SettingsController());
  ProfileController controllerProfile = Get.put(ProfileController());
  String facebook = '';
  String youtube = '';
  String twitter = '';
  String instagram = '';
  String userImageUrl = '';
  String email = '';

  getCurrentUserData() async {
    DocumentSnapshot snapshotUser = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserID)
        .get();

    facebook = snapshotUser['facebook'];
    youtube = snapshotUser['youtube'];
    twitter = snapshotUser['twitter'];
    instagram = snapshotUser['instagram'];
    email = snapshotUser['email'];
    userImageUrl = snapshotUser['image'];

    setState(() {
      controller.facebook.text = facebook ?? '';
      controller.youtube.text = youtube ?? '';
      controller.instagram.text = instagram ?? '';
      controller.twitter.text = twitter ?? '';
      controller.email.text = email ?? '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controllerProfile) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.black,
            title: Text(
              'account Settings'.tr,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Space
                const SizedBox(
                  height: 20,
                ),

                // Image
                CircleAvatar(
                  radius: 75,
                  backgroundImage: NetworkImage(
                    controllerProfile.userMap['userImage'],
                  ),
                ),

                // Space
                const SizedBox(
                  height: 10,
                ),

                Text(
                  'update your profile:'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),

                // Space
                const SizedBox(
                  height: 10,
                ),

                // Email
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: InputTextWidget(
                    textEditingController: controller.email,
                    textString: 'Email@gmail.com',
                    iconData: Icons.email,
                    isObscure: false,
                  ),
                ),

                // Space
                const SizedBox(
                  height: 10,
                ),

                // Facebook
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: InputTextWidget(
                    textEditingController: controller.facebook,
                    textString: 'Facebook.com/userName',
                    assetsRef: 'assets/images/facebook.png',
                    isObscure: false,
                  ),
                ),

                // Space
                const SizedBox(
                  height: 15,
                ),

                // Instagram
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: InputTextWidget(
                    textEditingController: controller.instagram,
                    textString: 'Instagram.com/userName',
                    assetsRef: 'assets/images/instagram.png',
                    isObscure: false,
                  ),
                ),

                // Space
                const SizedBox(
                  height: 15,
                ),

                // Youtube
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: InputTextWidget(
                    textEditingController: controller.youtube,
                    textString: 'm.youtube.com/c/userName',
                    assetsRef: 'assets/images/youtube.png',
                    isObscure: false,
                  ),
                ),

                // Space
                const SizedBox(
                  height: 15,
                ),

                // Twitter
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: InputTextWidget(
                    textEditingController: controller.twitter,
                    textString: 'Twitter.com/userName',
                    assetsRef: 'assets/images/twitter.png',
                    isObscure: false,
                  ),
                ),

                // Space
                const SizedBox(
                  height: 15,
                ),

                // Update-Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 20,
                    ),
                  ),
                  onPressed: () {
                    controllerProfile.updateUserAccount(
                      controller.email.text,
                      controller.facebook.text,
                      controller.instagram.text,
                      controller.youtube.text,
                      controller.twitter.text,
                    );
                  },
                  child: Text(
                    'update Now'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
