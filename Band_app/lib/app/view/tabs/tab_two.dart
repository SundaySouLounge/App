import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/video_model.dart';
import 'package:ultimate_band_owner_flutter/app/controller/video_controller.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoListScreen extends StatelessWidget {
  final VideoController videoController = Get.put(VideoController(parser: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video List"),
      ),
      body: Obx(() {
        if (videoController.apiCalled) {
          return TableVideos(videoList: videoController.videoList);
        } else {
          // Show loading indicator or any other widget while waiting for API response
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}

class TableVideos extends StatelessWidget {
  final List<VideoModel> videoList;

  const TableVideos({Key? key, required this.videoList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: videoList.isEmpty
          ? Text("No video found")
          : ListView.builder(
              itemCount:videoList.length,
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                var id = YoutubePlayerController.convertUrlToId(
                    videoList[i].videoLink!);
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
          // : ListView.builder(
          //     itemCount: videoList.length,
          //     itemBuilder: (context, index) {
          //       VideoModel video = videoList[index];
          //       return ListTile(
          //         title: Text(video.title ?? "Unknown Title"), // Use null-aware operator
          //         subtitle: Text(video.videoLink ?? "Unknown Link"), // Use null-aware operator
          //         // Add onTap to navigate to a detailed video screen if needed
          //         onTap: () {
          //           // Navigate to a detailed video screen with video details
          //           // You can implement this as per your requirement
          //         },
          //       );
          //     },
          //   ),
    );
  }
}