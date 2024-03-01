import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/Model/video_model.dart';
import 'package:tiktok_clone/View/screens/home/home_screen.dart';
import 'package:video_compress/video_compress.dart';

class UploadController extends GetxController {
  /// Variables
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _fireStore = FirebaseFirestore.instance;
  final artistSong = TextEditingController();
  final descriptionTags = TextEditingController();
  GlobalKey<FormState> uploadFormKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  compressVideoFile(String videoFilePath) async {
    final compressedVideoFilePath = await VideoCompress.compressVideo(
      videoFilePath,
      quality: VideoQuality.DefaultQuality,
    );

    return compressedVideoFilePath!.file;
  }

  uploadCompressedVideoFileToStorage(String videoID,
      String videoFilePath) async {
    UploadTask videoUploadTask =
    _storage.ref().child('All Videos').child(videoID).putFile(
      await compressVideoFile(videoFilePath),
    );
    TaskSnapshot snapshot = await videoUploadTask;
    String downloadUrlOfUploadedVideo = await snapshot.ref.getDownloadURL();
    return downloadUrlOfUploadedVideo;
  }

  getThumbnailImage(String videoFilePath) async {
    final thumbnailImage = await VideoCompress.getFileThumbnail(videoFilePath);
    return thumbnailImage;
  }

  uploadThumbnailImageFileToStorage(String videoID,
      String videoFilePath) async {
    UploadTask thumbnailUploadTask =
    _storage.ref().child('All Thumbnails').child(videoID).putFile(
      await getThumbnailImage(videoFilePath),
    );
    TaskSnapshot snapshot = await thumbnailUploadTask;
    String downloadUrlOfUploadedThumbnail = await snapshot.ref.getDownloadURL();
    return downloadUrlOfUploadedThumbnail;
  }

  saveVideoInformationToFireStoreDatabase(String artistSongName,
      String descriptionTags,
      String videoFilePath,
      BuildContext context) async {
    try {
      // Loading.
      isLoading.value = true;

      // Form Validation
      if (!uploadFormKey.currentState!.validate()) {
        Get.snackbar(
          'Form',
          'Form field is not valid',
          snackPosition: SnackPosition.BOTTOM,
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

      // Get User Info Form Database.
      DocumentSnapshot userDocumentSnapshot = await _fireStore.collection(
          'Users').doc(_auth.currentUser!.uid).get();
      String videoID = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();

      // 1. Upload Video To Storage.
      String videoDownloadUrl = await uploadCompressedVideoFileToStorage(
          videoID, videoFilePath);

      //2. Upload Thumbnail To Storage.
      String thumbnailDownloadUrl = await uploadThumbnailImageFileToStorage(
          videoID, videoFilePath);

      //3. Save Overall Video Info To FireStore Database.
      Video videoObject = Video(
          userID: _auth.currentUser!.uid,
          userName: (userDocumentSnapshot.data() as Map<String, dynamic>)['name'],
        userProfileImage: (userDocumentSnapshot.data() as Map<String, dynamic>)['image'],
        videoID: videoID,
        totalComments: 0,
        totalShares: 0,
        likesList: [],
        artistSongName: artistSongName,
        descriptionTags: descriptionTags,
        videoUrl: videoDownloadUrl,
        thumbnailUrl: thumbnailDownloadUrl,
        publishedDateTime: DateTime.now().millisecondsSinceEpoch,
      );

      await _fireStore.collection('videos').doc(videoID).set(videoObject.toJson());
      isLoading.value = false;
      Get.offAll(const HomeScreen());
      Get.snackbar(
        'Success',
        'New Video has shared',
      );


    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Warning',
        e.toString(),
        backgroundColor: Colors.red,
      );
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Warning',
          'Error Occurred, Your Video os not uploaded.\n Try Again.');
      isLoading.value = false;
    }
  }
}
