import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:app_user/app/backend/api/handler.dart';
import 'package:app_user/app/backend/models/video_model.dart';
import 'package:app_user/app/backend/parse/video_parse.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:app_user/app/util/themeprovider.dart';
import 'package:app_user/app/util/toast.dart';

class VideoController extends GetxController implements GetxService {
  final VideoParser parser;
  final int id;

  String title = 'Add Video'.tr;

  List<VideoModel> _videoList = <VideoModel>[];
  List<VideoModel> get videoList => _videoList;

  final titleTextEditor = TextEditingController();
  final videoLinkTextEditor = TextEditingController();

  bool apiCalled = false;

  int videoId = 0;
  String action = 'Add';

  VideoController({required this.parser, this.id = 14});

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments?[0] == 'Edit') {
      action = 'Edit';
      videoId = Get.arguments[1] as int;
      debugPrint('video id --> $videoId');
      getVideoById();
    } else if (Get.arguments?[0] == 'Add') {
      action = 'Add';
      apiCalled = true;
    } else {
      getMyVideos();
      apiCalled = true;
    }
  }

  Future<void> getMyVideos() async {
    print(id);
    var response = await parser.getMyVideos({"id": id});
    print("object: $id");
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      print("getMyVideos() Response: $body");
      _videoList = [];
      body.forEach((element) {
        VideoModel video = VideoModel.fromJson(element);
        _videoList.add(video);
      });
    } else {
      // Reset the list to make sure there are no cached videos from previous instance.
      _videoList = [];
      ApiChecker.checkApi(response);
    }
    apiCalled = true; // Set apiCalled to true after fetching videos
    update();
  }

  Future<void> getVideoById() async {
    var response = await parser.getVideoById({"id": videoId});
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'][0];
      debugPrint(body.toString());
      titleTextEditor.text = body['title'];
      videoLinkTextEditor.text = body['video_link'];
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> onSubmit() async {
    if (titleTextEditor.text == '' ||
        titleTextEditor.text.isEmpty ||
        videoLinkTextEditor.text == '' ||
        videoLinkTextEditor.text.isEmpty) {
      showToast('All fields are required!');
      return;
    }

    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 30,
              ),
              const CircularProgressIndicator(
                color: Colors.black,
              ),
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                  child: Text(
                "Please wait".tr,
                style: const TextStyle(fontFamily: 'bold'),
              )),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );

    var body = {
      "uid": parser.getUID(),
      "title": titleTextEditor.text,
      "video_link": videoLinkTextEditor.text,
    };

    var response = await parser.onCreateVideo(body);
    Get.back();
    if (response.statusCode == 200) {
      debugPrint(response.bodyString);
      // onBack();
      // await getMyVideos();
      Get.delete<VideoController>(force: true);
      Get.offAndToNamed(AppRouter.getVideoRoute());
      successToast('Video Added !');
      // update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> onUpdateVideo() async {
    var body = {
      "id": videoId,
      "title": titleTextEditor.text,
      "video_link": videoLinkTextEditor.text,
    };
    var response = await parser.onUpdateVideo(body);
    // Get.back();
    if (response.statusCode == 200) {
      debugPrint(response.bodyString);
      Get.delete<VideoController>(force: true);
      Get.offAndToNamed(AppRouter.getVideoRoute());
      successToast('video update !');
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void onRemoveVideo(int id) async {
    var param = {"id": id};
    var response = await parser.removeVideo(param);
    if (response.statusCode == 200) {
      await getMyVideos();
      showToast('Video Remove Successfully');
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void onAddNew() {
    Get.delete<VideoController>(force: true);
    Get.toNamed(AppRouter.getAddVideoRoute(), arguments: ['Add']);
  }

  void onEdit(int id) {
    Get.delete<VideoController>(force: true);
    Get.toNamed(AppRouter.getAddVideoRoute(), arguments: ['Edit', id]);
  }
}
