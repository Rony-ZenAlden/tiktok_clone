import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/Controller/home/profile_controller.dart';
import 'package:tiktok_clone/View/screens/home/following/followers_screen.dart';
import 'package:tiktok_clone/View/screens/home/following/following_screen.dart';
import 'package:tiktok_clone/View/screens/home/profile/settings/settings_screen.dart';
import 'package:tiktok_clone/View/screens/home/profile/video_player_profile.dart';
import 'package:tiktok_clone/global.dart';
import '../../../../Controller/theme/theme_controller.dart';
import '../../../../locale/locale_controller.dart';
import '../../../widgets/loading_widget.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    super.key,
    this.visitUserID,
  });

  String? visitUserID;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController controller = Get.put(ProfileController());
  MyLocaleController controllerLang = Get.find();
  bool isFollowingUser = false;
  final _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.updateCurrentUserID(widget.visitUserID.toString());
    getIsFollowingValue();
  }

  getIsFollowingValue() {
    _fireStore
        .collection('Users')
        .doc(widget.visitUserID.toString())
        .collection('followers')
        .doc(currentUserID)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          isFollowingUser = true;
        });
      } else {
        setState(() {
          isFollowingUser = false;
        });
      }
    });
  }

  handleClickEvent(String choiceClicked) async {
    switch (choiceClicked) {
      case 'Settings':
        Get.to(
          () => const SettingsScreen(),
        );
        break;
      case 'Translation':
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
        break;
      case 'Theme':
        ThemeController().changeTheme();
        break;
    }
  }

  readClickedThumbnailInfo(String clickedThumbnailUrl) async {
    var allVideosDocs =
        await FirebaseFirestore.instance.collection('videos').get();

    for (int i = 0; i < allVideosDocs.docs.length; i++) {
      if (((allVideosDocs.docs[i].data() as dynamic)['thumbnailUrl']) ==
          clickedThumbnailUrl) {
        Get.to(
          () => VideoPlayerProfile(
            clickedVideoID:
                (allVideosDocs.docs[i].data() as dynamic)['videoID'],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controllerProfile) {
        if (controllerProfile.userMap.isEmpty) {
          return const LoadingWidget();
        }
        return Scaffold(
          appBar: AppBar(
            leading: widget.visitUserID.toString() == currentUserID
                ? Container()
                : IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
            title: Text(
              controllerProfile.userMap['userName'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              widget.visitUserID.toString() == currentUserID
                  ? PopupMenuButton<String>(
                      onSelected: handleClickEvent,
                      itemBuilder: (BuildContext context) {
                        return {
                          'Settings',
                          'Translation',
                          'Theme',
                        }.map((String choiceClicked) {
                          return PopupMenuItem(
                            value: choiceClicked,
                            child: Text(choiceClicked),
                          );
                        }).toList();
                      },
                    )
                  : Container(),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // User Profile Image
                  CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(
                      controllerProfile.userMap['userImage'],
                    ),
                  ),

                  // Spaces
                  const SizedBox(
                    height: 16,
                  ),

                  // Followers - Followings - Likes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Following
                      GestureDetector(
                        onTap: widget.visitUserID.toString() == currentUserID
                            ? () {
                                Get.to(
                                  () => FollowingScreen(
                                    visitedProfileUserID:
                                        widget.visitUserID.toString(),
                                  ),
                                );
                              }
                            : () {},
                        child: Column(
                          children: [
                            Text(
                              controllerProfile.userMap['totalFollowings'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              'following'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Spaces
                      Container(
                        color: Colors.black54,
                        width: 1,
                        height: 35,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                      ),

                      // Likes
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(
                              controllerProfile.userMap['totalLikes'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              'likes'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Spaces
                      Container(
                        color: Colors.black54,
                        width: 1,
                        height: 35,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                      ),

                      // Followers
                      GestureDetector(
                        onTap: widget.visitUserID.toString() == currentUserID
                            ? () {
                                Get.to(
                                  () => FollowersScreen(
                                    visitedProfileUserID:
                                        widget.visitUserID.toString(),
                                  ),
                                );
                              }
                            : () {},
                        child: Column(
                          children: [
                            Text(
                              controllerProfile.userMap['totalFollowers'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              'followers'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Spaces
                  const SizedBox(
                    height: 16,
                  ),

                  // User Social Links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Facebook
                      GestureDetector(
                        onTap: () {
                          if (controllerProfile.userMap['userFacebook'] == "") {
                            Get.snackbar('Facebook Profile',
                                'This User Has Not Connected His/Her Profile Facebook');
                          } else {
                            controller.launchUserSocialProfile(
                                controllerProfile.userMap['userFacebook']);
                          }
                        },
                        child: Image.asset(
                          'assets/images/facebook.png',
                          width: 50,
                        ),
                      ),

                      // Spaces
                      const SizedBox(
                        width: 10,
                      ), //

                      // Instagram
                      GestureDetector(
                        onTap: () {
                          if (controllerProfile.userMap['userInstagram'] ==
                              "") {
                            Get.snackbar('Instagram Profile',
                                'This User Has Not Connected His/Her Profile Instagram');
                          } else {
                            controller.launchUserSocialProfile(
                                controllerProfile.userMap['userInstagram']);
                          }
                        },
                        child: Image.asset(
                          'assets/images/instagram.png',
                          width: 50,
                        ),
                      ),

                      // Spaces
                      const SizedBox(
                        width: 10,
                      ),

                      // X
                      GestureDetector(
                        onTap: () {
                          if (controllerProfile.userMap['userTwitter'] == "") {
                            Get.snackbar('X Profile',
                                'This User Has Not Connected His/Her Profile X');
                          } else {
                            controller.launchUserSocialProfile(
                                controllerProfile.userMap['userTwitter']);
                          }
                        },
                        child: Image.asset(
                          'assets/images/twitter.png',
                          width: 50,
                        ),
                      ),

                      // Spaces
                      const SizedBox(
                        width: 10,
                      ),

                      // Youtube
                      GestureDetector(
                        onTap: () {
                          if (controllerProfile.userMap['userYoutube'] == "") {
                            Get.snackbar('Youtube Profile',
                                'This User Has Not Connected His/Her Profile Youtube');
                          } else {
                            controller.launchUserSocialProfile(
                                controllerProfile.userMap['userYoutube']);
                          }
                        },
                        child: Image.asset(
                          'assets/images/youtube.png',
                          width: 50,
                        ),
                      ),
                    ],
                  ),

                  // Spaces
                  const SizedBox(
                    height: 16,
                  ),

                  // Follow-Button
                  ElevatedButton(
                    onPressed: () {
                      // IF it is the user own profile - user view his/her own profile.
                      // SignOut-button.
                      if (widget.visitUserID.toString() == currentUserID) {
                        FirebaseAuth.instance.signOut();
                        Get.snackbar(
                          'Logged Out',
                          'You Are Logged Out From The App.',
                          backgroundColor: Colors.black87,
                        );
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          SystemChannels.platform
                              .invokeMethod("SystemNavigator.pop");
                        });
                      }
                      // User view someone's else profile.
                      // Follow btn - UnFollow btn.
                      // follow btn - unfollow btn
                      else {
                        // if currentUser is Already following other user
                        // unfollow btn
                        if (isFollowingUser == true) {
                          setState(() {
                            isFollowingUser = false;
                          });
                        }
                        // if currentUser is NOT Already following other user
                        // follow btn
                        else {
                          setState(() {
                            isFollowingUser = true;
                          });
                        }

                        controllerProfile.followUnFollowUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 90),
                      shape: widget.visitUserID.toString() == currentUserID
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: const BorderSide(color: Colors.red),
                            )
                          : isFollowingUser == true
                              ? RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  side: const BorderSide(color: Colors.red),
                                )
                              : RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  side: const BorderSide(color: Colors.green),
                                ),
                    ),
                    child: Text(
                      widget.visitUserID.toString() == currentUserID
                          ? 'signOut'.tr
                          : isFollowingUser == true
                              ? 'unFollow'.tr
                              : 'follow'.tr,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Spaces
                  const SizedBox(
                    height: 8,
                  ),

                  // User's Videos - Thumbnails
                  widget.visitUserID.toString() == currentUserID
                      ? GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controllerProfile
                              .userMap['thumbnailsList'].length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 2,
                          ),
                          itemBuilder: (context, index) {
                            String eachThumbnailUrl = controllerProfile
                                .userMap['thumbnailsList'][index];
                            return GestureDetector(
                              onTap: () {
                                readClickedThumbnailInfo(eachThumbnailUrl);
                              },
                              child: Image.network(
                                eachThumbnailUrl,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        )
                      : isFollowingUser == true
                          ? GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controllerProfile
                                  .userMap['thumbnailsList'].length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 2,
                              ),
                              itemBuilder: (context, index) {
                                String eachThumbnailUrl = controllerProfile
                                    .userMap['thumbnailsList'][index];
                                return GestureDetector(
                                  onTap: () {
                                    readClickedThumbnailInfo(eachThumbnailUrl);
                                  },
                                  child: Image.network(
                                    eachThumbnailUrl,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            )
                          : Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
