import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controller/home/profile_controller.dart';
import '../profile/profile_screen.dart';

class FollowersScreen extends StatefulWidget {
  FollowersScreen({
    super.key,
    required this.visitedProfileUserID,
  });

  String visitedProfileUserID;

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  List<String> followersKeysList = [];
  List followersUsersDataList = [];
  ProfileController controller = Get.put(ProfileController());

  getFollowersListKeys() async {
    var followingDocument = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.visitedProfileUserID)
        .collection('followers')
        .get();

    for (int i = 0; i < followingDocument.docs.length; i++) {
      followersKeysList.add(followingDocument.docs[i].id);
    }
    getFollowersKeysDataFromUser(followersKeysList);
  }

  getFollowersKeysDataFromUser(List<String> listOfFollowingKeys) async {
    var allUsersDocument =
        await FirebaseFirestore.instance.collection('Users').get();

    for (int i = 0; i < allUsersDocument.docs.length; i++) {
      for (int j = 0; j < listOfFollowingKeys.length; j++) {
        if (((allUsersDocument.docs[i].data() as dynamic)['uid']) ==
            listOfFollowingKeys[j]) {
          followersUsersDataList.add((allUsersDocument.docs[i].data()));
        }
      }
    }

    setState(() {
      followersUsersDataList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFollowersListKeys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Column(
          children: [
            Text(
              controller.userMap['userName'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              'Followers ' + controller.userMap['totalFollowers'],
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: followersUsersDataList.isEmpty
          ? Center(
              child: Icon(
                Icons.person_off_sharp,
                color: Colors.white,
                size: 60,
              ),
            )
          : ListView.builder(
              itemCount: followersUsersDataList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 4,
                  ),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Get.to(
                          ProfileScreen(
                            visitUserID: followersUsersDataList[index]['uid'],
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            followersUsersDataList[index]['image'].toString(),
                          ),
                        ),
                        title: Text(
                          followersUsersDataList[index]['name'].toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          followersUsersDataList[index]['email'].toString(),
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Get.to(
                              ProfileScreen(
                                visitUserID: followersUsersDataList[index]
                                    ['uid'],
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.navigate_next_outlined,
                            size: 24,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
