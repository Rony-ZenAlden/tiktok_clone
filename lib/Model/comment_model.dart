import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? userName;
  String? commentText;
  String? userProfileImage;
  String? userID;
  String? commentID;
  final publishedDateTime;
  List? commentLikeList;

  Comment({
    this.userName,
    this.commentText,
    this.userProfileImage,
    this.userID,
    this.commentID,
    this.publishedDateTime,
    this.commentLikeList,
});

  Map<String, dynamic> toJson()=> {
    'userName': userName,
    'commentText': commentText,
    'userProfileImage': userProfileImage,
    'userID': userID,
    'commentID': commentID,
    'publishedDateTime': publishedDateTime,
    'commentLikeList': commentLikeList,
  };

  static Comment fromDocumentSnapshot(DocumentSnapshot snapshot) {
    var documentSnapshot = snapshot.data() as Map<String, dynamic>;
    return Comment(
      userName: documentSnapshot['userName'],
      commentText: documentSnapshot['commentText'],
      userProfileImage: documentSnapshot['userProfileImage'],
      userID: documentSnapshot['userID'],
      commentID: documentSnapshot['commentID'],
      publishedDateTime: documentSnapshot['publishedDateTime'],
      commentLikeList: documentSnapshot['commentLikeList'],
    );
  }
}