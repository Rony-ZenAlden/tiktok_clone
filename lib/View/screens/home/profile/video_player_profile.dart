import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../Controller/home/video_profile_controller.dart';
import '../../../widgets/circular_image_animation.dart';
import '../../../widgets/like_animation.dart';
import '../../../widgets/video_player.dart';
import '../for_you/comments/comments_screen.dart';

class VideoPlayerProfile extends StatefulWidget {
  VideoPlayerProfile({
    super.key,
    required this.clickedVideoID,
  });

  String clickedVideoID;

  @override
  State<VideoPlayerProfile> createState() => _VideoPlayerProfileState();
}

class _VideoPlayerProfileState extends State<VideoPlayerProfile> {
  final controller = Get.put(VideoProfileController());

  @override
  Widget build(BuildContext context) {
    controller.setVideoID(widget.clickedVideoID.toString());
    return Scaffold(body: Obx(() {
      return PageView.builder(
        itemCount: controller.clickedVideoFile.length,
        controller: PageController(initialPage: 0, viewportFraction: 1),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final clickedVideoInfo = controller.clickedVideoFile[index];
          return Stack(
            children: [
              // Display Video
              VideoPlayerWidget(
                videoFileUrl: clickedVideoInfo.videoUrl.toString(),
              ),

              Column(
                children: [
                  // Spaces
                  const SizedBox(
                    height: 130,
                  ),

                  // Left right - panels
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Left Panel
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 18),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // UserName
                                Text(
                                  '@${clickedVideoInfo.userName}',
                                  style: GoogleFonts.abel(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                // Spaces
                                const SizedBox(
                                  height: 6,
                                ),

                                // Descriptions + Tags
                                Text(
                                  '${clickedVideoInfo.descriptionTags}',
                                  style: GoogleFonts.abel(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),

                                // Spaces
                                const SizedBox(
                                  height: 6,
                                ),

                                // Artist-SongName
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/music_note.png',
                                      width: 20,
                                      color: Colors.white,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '   ${clickedVideoInfo.artistSongName}',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.alexBrush(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Right Panel
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 3.8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Profile
                              SizedBox(
                                width: 62,
                                height: 62,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 4,
                                      child: Container(
                                        width: 52,
                                        height: 52,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Image(
                                            image: NetworkImage(
                                              clickedVideoInfo.userProfileImage
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Likes-Button / Total Likes
                              Column(
                                children: [
                                  // Like-Button
                                  IconButton(
                                    onPressed: () {
                                      controller.likeOrUnLikeVideo(
                                        clickedVideoInfo.videoID.toString(),
                                      );
                                      setState(() {
                                        controller.isLikeAnimating.value = true;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.favorite_rounded,
                                      size: 40,
                                      color: clickedVideoInfo.likesList!.contains(
                                              controller.auth.currentUser!.uid)
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                  ),

                                  // Total Likes
                                  Text(
                                    clickedVideoInfo.likesList!.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              // Comment-Button / Total Comments
                              Column(
                                children: [
                                  // Comment-Button
                                  IconButton(
                                    onPressed: () {
                                      Get.to(CommentsScreen(
                                        videoID:
                                            clickedVideoInfo.videoID.toString(),
                                      ));
                                    },
                                    icon: const Icon(
                                      Icons.add_comment,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),

                                  // Total Comments
                                  Text(
                                    clickedVideoInfo.totalComments.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              // Share-Button / Total Shares
                              Column(
                                children: [
                                  // Share-Button
                                  IconButton(
                                    onPressed: () {
                                      Share.share(
                                          clickedVideoInfo.videoUrl!.toString());
                                    },
                                    icon: const Icon(
                                      Icons.share,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),

                                  // Total Shares
                                  Text(
                                    clickedVideoInfo.totalShares!.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              // Profile Circular Animation
                              CircularImageAnimation(
                                widgetAnimation: SizedBox(
                                  width: 62,
                                  height: 62,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        height: 52,
                                        width: 52,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.grey,
                                              Colors.white,
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Image(
                                            image: NetworkImage(
                                              clickedVideoInfo.userProfileImage
                                                  .toString(),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Animation For Like-Button
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: controller.isLikeAnimating.value ? 1 : 0,
                child: LikeAnimationWidget(
                  isAnimating: controller.isLikeAnimating.value,
                  duration: const Duration(milliseconds: 400),
                  onEnd: () {
                    setState(() {
                      controller.isLikeAnimating.value = false;
                    });
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 200,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }));
  }
}
