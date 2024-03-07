import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/Model/comment_model.dart';

class CommentController extends GetxController {
  final comment = TextEditingController();
  GlobalKey<FormState> commentFormKey = GlobalKey<FormState>();
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String currentVideoID = '';
  final Rx<List<Comment>> commentsList = Rx<List<Comment>>([]);

  List<Comment> get listOfComments => commentsList.value;

  updateCurrentVideoID(String videoID) {
    currentVideoID = videoID;
    retrieveComments();
  }

  saveCommentToDatabase(String commentTextData) async {
    try {
      // Form Validation
      if (!commentFormKey.currentState!.validate()) {
        Get.snackbar(
          'Error',
          'Write Any Thing',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Get.isDarkMode ? Colors.white : Colors.black,
          margin: const EdgeInsets.all(15),
          icon: const Icon(
            Icons.message,
            color: Colors.white,
          ),
        );
        return;
      }

      // For Date Time OF Comments
      String commentID = DateTime.now().millisecondsSinceEpoch.toString();

      // For User Information
      DocumentSnapshot snapshotUserDocument = await _fireStore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .get();

      Comment commentModel = Comment(
        userName: (snapshotUserDocument.data() as dynamic)['name'],
        userID: _auth.currentUser!.uid,
        userProfileImage: (snapshotUserDocument.data() as dynamic)['image'],
        commentText: commentTextData,
        commentID: commentID,
        commentLikeList: [],
        publishedDateTime: DateTime.now(),
      );

      // Save New Comment
      await _fireStore
          .collection('videos')
          .doc(currentVideoID)
          .collection('comments')
          .doc(commentID)
          .set(commentModel.toJson());

      // Update Comment
      DocumentSnapshot currentVideoSnapshotDocument =
          await _fireStore.collection('videos').doc(currentVideoID).get();

      await _fireStore.collection('videos').doc(currentVideoID).update({
        'totalComments':
            (currentVideoSnapshotDocument.data() as dynamic)['totalComments'] +
                1,
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  retrieveComments() async {
    commentsList.bindStream(
      _fireStore
          .collection('videos')
          .doc(currentVideoID)
          .collection('comments')
          .orderBy('publishedDateTime', descending: true)
          .snapshots()
          .map((QuerySnapshot commentsSnapshot) {
        List<Comment> commentsListOfVideo = [];
        for (var eachComment in commentsSnapshot.docs) {
          commentsListOfVideo.add(
            Comment.fromDocumentSnapshot(eachComment),
          );
        }
        return commentsListOfVideo;
      }),
    );
  }

  likeUnLikeComment(String commentID) async {
    DocumentSnapshot commentDocumentSnapshot = await _fireStore
        .collection('videos')
        .doc(currentVideoID)
        .collection('comments')
        .doc(commentID)
        .get();
    // UnLike Comment
    if ((commentDocumentSnapshot.data() as dynamic)['commentLikeList']
        .contains(_auth.currentUser!.uid)) {
      await _fireStore
          .collection('videos')
          .doc(currentVideoID)
          .collection('comments')
          .doc(commentID)
          .update({
        'commentLikeList': FieldValue.arrayRemove([_auth.currentUser!.uid]),
      });
    }
    // Like Comment
    else {
      await _fireStore
          .collection('videos')
          .doc(currentVideoID)
          .collection('comments')
          .doc(commentID)
          .update({
        'commentLikeList': FieldValue.arrayUnion([_auth.currentUser!.uid]),
      });
    }
  }

  deleteComment(String commentID) async {
    // Update Comment
    DocumentSnapshot currentVideoSnapshotDocument =
        await _fireStore.collection('videos').doc(currentVideoID).get();
    await _fireStore
        .collection('videos')
        .doc(currentVideoID)
        .collection('comments')
        .doc(commentID)
        .delete();
    await _fireStore.collection('videos').doc(currentVideoID).update({
      'totalComments':
          (currentVideoSnapshotDocument.data() as dynamic)['totalComments'] - 1,
    });
  }
}
