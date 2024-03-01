import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../Controller/home/comment_controller.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({
    super.key,
    required this.videoID,
  });

  final String videoID;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentController());
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Display Comments

              // Add New Comment Box
              Container(
                color: Colors.white24,
                child: ListTile(
                  title: TextFormField(
                    controller: controller.comment,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'New Comment...',
                      labelStyle: TextStyle(
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
                    onPressed: () {},
                    icon: const Icon(
                      Icons.send,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
