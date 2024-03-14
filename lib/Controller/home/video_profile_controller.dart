import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../Model/video_model.dart';

class VideoProfileController extends GetxController {
  /// Variables
  final Rx<List<Video>> videoFileList = Rx<List<Video>>([]);
  List<Video> get clickedVideoFile => videoFileList.value;
  final _fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  var isLikeAnimating = false.obs;
  final Rx<String> _videoID = ''.obs;
  String get clickedVideoID => _videoID.value;

  setVideoID(String vID) {
    _videoID.value = vID;
  }

  getClickedVideoInfo() async{
    videoFileList.bindStream(
      _fireStore
          .collection('videos')
          .snapshots()
          .map((QuerySnapshot snapshotQuery) {
        List<Video> videoList = [];

        for (var eachVideo in snapshotQuery.docs) {
          if(eachVideo['videoID'] == clickedVideoID){
            videoList.add(
              Video.fromDocumentSnapshot(eachVideo),
            );
          }
        }
        return videoList;
      }),
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getClickedVideoInfo();
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