import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/global.dart';

import '../../Model/video_model.dart';

class FollowingVideosController extends GetxController {
  /// Variables
  final Rx<List<Video>> followingVideoList = Rx<List<Video>>([]);
  List<Video> get followingAllVideoList => followingVideoList.value;
  final _fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  var isLikeAnimating = false.obs;
  List<String> followingKeysList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFollowingUsersVideos();
  }

  getFollowingUsersVideos() async {
    // 1. Get that followers
    var followingDocument = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserID)
        .collection('following')
        .get();

    for (int i = 0; i < followingDocument.docs.length; i++) {
      followingKeysList.add(followingDocument.docs[i].id);
    }

    // 2. Get videos of that following people
    followingVideoList.bindStream(
      _fireStore
          .collection('videos')
          .orderBy('publishedDateTime', descending: true)
          .snapshots()
          .map((QuerySnapshot snapshotVideo) {
        List<Video> followingPersonsVideos = [];

        for (var eachVideo in snapshotVideo.docs) {
          for (int i = 0; i < followingKeysList.length; i++) {
            String followingPersonID = followingKeysList[i];
            if (eachVideo['userID'] == followingPersonID) {
              followingPersonsVideos.add(Video.fromDocumentSnapshot(eachVideo));
            }
          }
        }

        return followingPersonsVideos;
      }),
    );
  }

  likeOrUnLikeVideo(String videoID) async {
    var currentUserID = auth.currentUser!.uid.toString();

    DocumentSnapshot snapshotDoc =
        await _fireStore.collection('videos').doc(videoID).get();
    // if already liked
    if ((snapshotDoc.data() as dynamic)['likesList'].contains(currentUserID)) {
      await _fireStore.collection('videos').doc(videoID).update({
        'likesList': FieldValue.arrayRemove([currentUserID]),
      });
    }
    // if Not liked
    else {
      await _fireStore.collection('videos').doc(videoID).update({
        'likesList': FieldValue.arrayUnion([currentUserID]),
      });
    }
  }
}
