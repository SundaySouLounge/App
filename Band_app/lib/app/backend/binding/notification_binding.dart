import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/chat_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/notification_screen_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => NotificationController(parser: Get.find()),
    );
    Get.lazyPut(
      () => ChatController(parser: Get.find()),
    );
  }
}
