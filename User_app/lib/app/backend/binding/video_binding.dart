import 'package:get/get.dart';
import 'package:app_user/app/controller/video_controller.dart';

class VideoBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => VideoController(parser: Get.find()),
    );
  }
}
