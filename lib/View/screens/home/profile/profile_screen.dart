import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/Controller/home/profile_controller.dart';
import 'package:tiktok_clone/View/screens/home/profile/settings/settings_screen.dart';
import 'package:tiktok_clone/global.dart';
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
  bool isFollowingUser = false;
  final _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.updateCurrentUserID(widget.visitUserID.toString());
    // controller.updateCurrentUserID(FirebaseAuth.instance.currentUser!.uid);
  }

  getIsFollowingValue() {
    _fireStore
        .collection('Users')
        .doc(widget.visitUserID.toString())
        .collection('followers')
        .doc(currentUserID)
        .get().then((value) {
      if(value.exists) {
        setState(() {
          isFollowingUser = true;
        });
      }
      else {
        setState(() {
          isFollowingUser = false;
        });
      }
    });
  }

  handleClickEvent(String choiceClicked) async {
    switch (choiceClicked) {
      case 'Settings':
        Get.to(const SettingsScreen());
        break;
      case 'Logout':
        controller.signOut();
        break;
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
                    'Logout',
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
                        onTap: () {},
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
                            const Text(
                              'Followings',
                              style: TextStyle(
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
                        height: 25,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                      ),

                      // Followers
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
                            const Text(
                              'Likes',
                              style: TextStyle(
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
                        height: 25,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                      ),

                      // Followers
                      GestureDetector(
                        onTap: () {},
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
                            const Text(
                              'Followers',
                              style: TextStyle(
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
                      }
                      // User view someone's else profile.
                      // Follow btn - UnFollow btn.
                      else {
                        // IF following other user already.
                        // UnFollow btn.
                        if (isFollowingUser == true) {
                          setState(() {
                            isFollowingUser = false;
                          });
                        }
                        // IF Not following other user.
                        // Follow btn.
                        else {
                          setState(() {
                            isFollowingUser = true;
                          });
                        }
                      }
                      controller.followUnFollowUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 90),
                      shape: widget.visitUserID.toString() == currentUserID
                          ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Colors.red),
                      ) : isFollowingUser == true ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Colors.red),
                      ) :  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Colors.green),
                      ),
                    ),
                    child: Text(
                      widget.visitUserID.toString() == currentUserID
                          ? 'Sign Out'
                          : isFollowingUser == true
                          ? 'UnFollow'
                          : 'Follow',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
