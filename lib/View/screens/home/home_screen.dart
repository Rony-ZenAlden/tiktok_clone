import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/View/screens/home/following/following_vedio_screen.dart';
import 'package:tiktok_clone/View/screens/home/for_you/for_you_screen.dart';
import 'package:tiktok_clone/View/screens/home/profile/profile_screen.dart';
import 'package:tiktok_clone/View/screens/home/search/search_screen.dart';
import 'package:tiktok_clone/View/widgets/upload_custom_icon.dart';
import 'package:tiktok_clone/View/screens/home/upload_vedio/upload_video_screen.dart';
import '../../../global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenIndex = 0;
  List screensList = [
    const ForYouScreen(),
    const SearchScreen(),
    const UploadVideoScreen(),
    const FollowingVideoScreen(),
    ProfileScreen(
      visitUserID: currentUserID,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         ThemeController().changeTheme();
      //         setState(() {
      //           Get.isDarkMode;
      //         });
      //       },
      //       icon: Get.isDarkMode
      //           ? const Icon(
      //         CupertinoIcons.sun_max_fill,
      //       )
      //           : const Icon(
      //         CupertinoIcons.moon_stars_fill,
      //       ),
      //     ),
      //   ],
      // ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            screenIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white12,
        currentIndex: screenIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              size: 30,
            ),
            label: 'home'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
            label: 'search'.tr,
          ),
          BottomNavigationBarItem(
            icon: const UploadIcon(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.inbox_sharp,
              size: 30,
            ),
            label: 'following'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person,
              size: 30,
            ),
            label: 'me'.tr,
          ),
        ],
      ),
      body: screensList[screenIndex],
    );
  }
}
