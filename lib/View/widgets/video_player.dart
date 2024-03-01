import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.videoFileUrl, this.playerController,
  });

  final String videoFileUrl;
  final VideoPlayerController? playerController;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? playerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playerController = VideoPlayerController.network(widget.videoFileUrl)
      ..initialize().then((value) {
        playerController!.play();
        playerController!.setVolume(2);
        playerController!.setLooping(true);
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          playerController!.value.isPlaying
              ? playerController!.pause()
              : playerController!.play();
        });
      },
      onDoubleTap: () async {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: VideoPlayer(
          playerController!,
        ),
      ),
    );
  }
}
