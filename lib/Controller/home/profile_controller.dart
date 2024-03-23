import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/View/screens/home/home_screen.dart';
import 'package:tiktok_clone/global.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final Rx<Map<String, dynamic>> _userMap = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get userMap => _userMap.value;
  final Rx<String> _userID = ''.obs;

  updateCurrentUserID(String visitUserID) {
    _userID.value = visitUserID;
    retrieveUserInformation();
  }

  retrieveUserInformation() async {
    // Get user Info
    DocumentSnapshot userDocumentSnapshot =
        await _fireStore.collection('Users').doc(_userID.value).get();
    final userInfo = userDocumentSnapshot.data() as dynamic;
    String userEmail = userInfo['email'];
    String userName = userInfo['name'];
    String userImage = userInfo['image'];
    String userUid = userInfo['uid'];
    String userYoutube = userInfo['youtube'] ?? '';
    String userInstagram = userInfo['instagram'] ?? '';
    String userTwitter = userInfo['twitter'] ?? '';
    String userFacebook = userInfo['facebook'] ?? '';

    int totalLikes = 0;
    int totalFollowers = 0;
    int totalFollowings = 0;
    bool isFollowing = false;
    List<String> thumbnailsList = [];

    // Get user's videos info
    var currentUserVideos = await _fireStore
        .collection('videos')
        .orderBy('publishedDateTime', descending: true)
        .where('userID', isEqualTo: _userID.value)
        .get();

    for (int i = 0; i < currentUserVideos.docs.length; i++) {
      thumbnailsList
          .add((currentUserVideos.docs[i].data() as dynamic)['thumbnailUrl']);
    }

    // Get total number of likes
    for (var eachVideo in currentUserVideos.docs) {
      totalLikes = totalLikes + (eachVideo.data()['likesList'] as List).length;
    }

    // Get the total number of followers
    var followersNumDocument = await _fireStore
        .collection('Users')
        .doc(_userID.value)
        .collection('followers')
        .get();

    totalFollowers = followersNumDocument.docs.length;

    // Get the total number of followings
    var followingsNumDocument = await _fireStore
        .collection('Users')
        .doc(_userID.value)
        .collection('following')
        .get();

    totalFollowings = followingsNumDocument.docs.length;

    // Get the isFollowing true or False value.
    _fireStore
        .collection('Users')
        .doc(_userID.value)
        .collection('followers')
        .doc(currentUserID)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _userMap.value = {
      'userName': userName,
      'userEmail': userEmail,
      'userImage': userImage,
      'userUid': userUid,
      'userYoutube': userYoutube,
      'userInstagram': userInstagram,
      'userTwitter': userTwitter,
      'userFacebook': userFacebook,
      'totalLikes': totalLikes.toString(),
      'totalFollowers': totalFollowers.toString(),
      'totalFollowings': totalFollowings.toString(),
      'isFollowing': isFollowing,
      'thumbnailsList': thumbnailsList,
    };
    update();
  }

  Future<void> launchUserSocialProfile(String socialLink) async {
    if (!await launchUrl(Uri.parse('https://$socialLink'))) {
      throw Exception('Could Not Launch $socialLink');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    Get.snackbar(
      'Logged Out',
      'You Are Logged Out From The App.',
      backgroundColor: Colors.black87,
    );
  }

  followUnFollowUser() async {
    var document = await _fireStore
        .collection('Users')
        .doc(_userID.value)
        .collection('followers')
        .doc(currentUserID)
        .get();
    // CurrentUser is already following other user
    if (document.exists) {
      // Remove Follower
      // Remove Following

      // 1. Remove currentUser as a new follower to visitor's followerList
      await _fireStore
          .collection('Users')
          .doc(_userID.value)
          .collection('followers')
          .doc(currentUserID)
          .delete();

      // 2. Remove that visitorProfile person as a new following to the current user's followingList
      await _fireStore
          .collection('Users')
          .doc(currentUserID)
          .collection('following')
          .doc(_userID.value)
          .delete();

      // Decrement - update totalFollowers number.
      _userMap.value.update(
          'totalFollowers', (value) => (int.parse(value) - 1).toString());
    }
    // If CurrentUser is Not already following other user
    else {
      // Add New Follower
      // Add New Following

      // 1. Add currentUser as a new follower to visitor's followerList
      await _fireStore
          .collection('Users')
          .doc(_userID.value)
          .collection('followers')
          .doc(currentUserID)
          .set({});
      // 2. Add that visitorProfile person as a new following to the current user's followingList
      await _fireStore
          .collection('Users')
          .doc(currentUserID)
          .collection('following')
          .doc(_userID.value)
          .set({});

      // Increment - update totalFollowers number.
      _userMap.value.update(
          'totalFollowers', (value) => (int.parse(value) + 1).toString());
    }

    _userMap.value.update('isFollowing', (value) => !value);
    update();
  }

  updateUserAccount(String email,
      String facebook, String instagram, String youtube, String twitter) async {
    try {
      final Map<String, dynamic> userSocialLinksMap = {
        'email': email,
        'facebook': facebook,
        'instagram': instagram,
        'youtube': youtube,
        'twitter': twitter,
      };

      await _fireStore
          .collection('Users')
          .doc(currentUserID)
          .update(userSocialLinksMap);
      Get.snackbar('Update Account', 'your account are updated successfully.');
      Get.to(HomeScreen());
    } catch (e) {
      Get.snackbar('Error Updating Account', 'Please Try Again.');
    }
  }

}
