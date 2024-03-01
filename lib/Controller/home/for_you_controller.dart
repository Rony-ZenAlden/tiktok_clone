import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../Model/video_model.dart';

class ForYouController extends GetxController {
  /// Variables
  final Rx<List<Video>> forYouVideoList = Rx<List<Video>>([]);

  List<Video> get forYouAllVideoList => forYouVideoList.value;
  final _fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  var isLikeAnimating = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    forYouVideoList.bindStream(
      _fireStore
          .collection('videos')
          .orderBy('totalComments', descending: true)
          .snapshots()
          .map((QuerySnapshot snapshotQuery) {
        List<Video> videoList = [];

        for (var eachVideo in snapshotQuery.docs) {
          videoList.add(
            Video.fromDocumentSnapshot(eachVideo),
          );
        }
        return videoList;
      }),
    );
  }

  likeOrUnLikeVideo(String videoID) async {
    var currentUserID = auth.currentUser!.uid.toString();

    DocumentSnapshot snapshotDoc =
        await _fireStore.collection('videos').doc(videoID).get();
    // if already liked
    if((snapshotDoc.data() as dynamic)['likesList'].contains(currentUserID)) {
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
