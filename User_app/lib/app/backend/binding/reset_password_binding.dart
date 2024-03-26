import 'package:get/get.dart';
import 'package:app_user/app/controller/reset_password_controller.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => ResetPasswordController(parser: Get.find()),
    );
  }
}
