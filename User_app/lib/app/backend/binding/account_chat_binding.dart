import 'package:get/get.dart';
import 'package:app_user/app/controller/account_chat_controller.dart';

class AccountChatBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AccountChatController(parser: Get.find()),
    );
  }
}
