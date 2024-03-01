import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/View/screens/home/upload_vedio/upload_form.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  getVideoFile(ImageSource sourceVed) async {
    final videoFile = await ImagePicker().pickVideo(source: sourceVed);
    if (videoFile != null) {
      Get.to(
        UploadForm(
            videoFile: File(videoFile.path),
            videoPath: videoFile.path,
        ),
      );
    }
  }

  displayDialogBox() {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {
              getVideoFile(ImageSource.gallery);
              Get.back();
            },
            child: Row(
              children: [
                Icon(
                  Icons.image,
                  color: Colors.red.shade300,
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Get Video from Gallery',
                      maxLines: 3,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              getVideoFile(ImageSource.camera);
              Get.back();
            },
            child: const Row(
              children: [
                Icon(
                  Icons.camera_alt,
                  color: Colors.purple,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Make Video with Camera',
                      maxLines: 3,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Get.back();
            },
            child: const Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Video Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/upload.png',
              width: 260,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // style: ElevatedButton.styleFrom(
              //   // backgroundColor: Colors.green,
              // ),
              onPressed: () {
                displayDialogBox();
              },
              child: const Text(
                'Upload New Video',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
