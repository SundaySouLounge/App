import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/video_controller.dart';

class VideoBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => VideoController(parser: Get.find()),
    );
  }
}
