import 'package:get/get.dart';
import 'package:app_user/app/controller/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => ChatController(parser: Get.find()),
    );
  }
}
