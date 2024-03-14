import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constant/alert_dialog.dart';
import '../../../../../Controller/home/comment_controller.dart';
import 'package:timeago/timeago.dart' as time;

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({
    super.key,
    required this.videoID,
  });

  final String videoID;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentController());
    controller.updateCurrentVideoID(videoID);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: controller.commentFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Display Comments
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: controller.listOfComments.length,
                      itemBuilder: (context, index) {
                        final eachCommentInfo =
                            controller.listOfComments[index]; // [0] [1] [2]
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: GestureDetector(
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              controller.deleteComment(
                                                eachCommentInfo.commentID
                                                    .toString(),
                                              );
                                              Get.back();
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text('Delete Comment'),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  Icons.cancel,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text('Cancel'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Card(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 2, bottom: 2),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    backgroundImage: NetworkImage(
                                      eachCommentInfo.userProfileImage
                                          .toString(),
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        eachCommentInfo.userName.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        eachCommentInfo.commentText.toString(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        time.format(
                                          eachCommentInfo.publishedDateTime
                                              .toDate(),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${eachCommentInfo.commentLikeList!.length}Likes',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      controller.likeUnLikeComment(
                                        eachCommentInfo.commentID.toString(),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.favorite,
                                      size: 30,
                                      color: eachCommentInfo.commentLikeList!
                                              .contains(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),

                // Add New Comment Box
                Container(
                  color: Colors.white24,
                  child: ListTile(
                    title: TextFormField(
                      controller: controller.comment,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'new Comment...'.tr,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.grey,
                        )),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.grey,
                        )),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        controller
                            .saveCommentToDatabase(controller.comment.text);
                        controller.comment.clear();
                      },
                      icon: const Icon(
                        Icons.send,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
