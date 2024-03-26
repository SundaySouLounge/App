import 'package:get/get.dart';
import 'package:app_user/app/controller/refer_and_earn_controller.dart';

class ReferAndEarnBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => ReferAndEarnController(parser: Get.find()),
    );
  }
}
