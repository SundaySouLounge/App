import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/inbox_controller.dart';

class InboxBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => InboxController(parser: Get.find()),
    );
  }
}
