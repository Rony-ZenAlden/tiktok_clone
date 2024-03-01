import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../../Controller/home/upload_controller.dart';
import '../../../../constant/validator.dart';

class UploadForm extends StatefulWidget {
  const UploadForm({
    super.key,
    required this.videoFile,
    required this.videoPath,
  });

  final File videoFile;
  final String videoPath;

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  VideoPlayerController? playerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      playerController = VideoPlayerController.file(widget.videoFile);
    });
    playerController!.initialize();
    playerController!.play();
    playerController!.setVolume(2);
    playerController!.setLooping(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UploadController controller = Get.put(UploadController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display video player
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.4,
              child: VideoPlayer(playerController!),
            ),
            const SizedBox(height: 30),

            // Upload Now

            //circular progress

            // Input field
            Padding(
              padding: const EdgeInsets.all(4),
              child: Form(
                key: controller.uploadFormKey,
                child: Column(
                  children: [
                    // Artist-Song
                    TextFormField(
                      validator: (value) =>
                          MyValidators.displayNameValidator(value),
                      controller: controller.artistSong,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Artist - Song...',
                        prefixIcon: const Icon(Icons.music_video_sharp),
                        border: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        // filled: true,
                        contentPadding: const EdgeInsets.all(8),
                      ),
                    ),
                    // Spaces
                    const SizedBox(height: 15),
                    // Description Tags
                    TextFormField(
                      validator: (value) =>
                          MyValidators.displayNameValidator(value),
                      controller: controller.descriptionTags,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Description - Tags...',
                        prefixIcon: const Icon(Icons.slideshow_sharp),
                        border: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        // filled: true,
                        contentPadding: const EdgeInsets.all(8),
                      ),
                    ),
                    // Spaces
                    const SizedBox(height: 15),
                    // Upload Now Button
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Obx(() {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Get.isDarkMode ? Colors.white : Colors.white24,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () async {
                            await controller
                                .saveVideoInformationToFireStoreDatabase(
                              controller.artistSong.text,
                              controller.descriptionTags.text,
                              widget.videoPath,
                              context,
                            );
                          },
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.black,
                                )
                              : const Text(
                                  'Upload Now',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
