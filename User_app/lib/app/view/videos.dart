import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_user/app/controller/video_controller.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideosScreen extends StatefulWidget {
  final int id;
  const VideosScreen({Key? key, this.id = 14}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => VideoController(parser: Get.find(), id: widget.id));
    return GetBuilder<VideoController>(builder: (value) {
      print("${value.videoList.length}  Videos");
      return value.videoList.isNotEmpty
          ? ListView.builder(
              itemCount: value.videoList.length,
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                var id = YoutubePlayerController.convertUrlToId(
                    value.videoList[i].videoLink!);
                final controller = YoutubePlayerController.fromVideoId(
                  videoId: id!,
                  autoPlay: false,
                  params: const YoutubePlayerParams(showFullscreenButton: true),
                );
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: YoutubePlayerScaffold(
                    controller: controller,
                    aspectRatio: 16 / 9,
                    builder: (context, player) {
                      return player;
                    },
                  ),
                );
              })
          : const Center(
              child: Text(
                'No Videos to show.',
                style: TextStyle(fontSize: 18),
              ),
            );
    });
  }
}
