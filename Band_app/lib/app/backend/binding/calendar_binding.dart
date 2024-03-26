import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/calendar_controller.dart';

class CalendarsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => CalendarsController(parser: Get.find()),
    );
  }
}
