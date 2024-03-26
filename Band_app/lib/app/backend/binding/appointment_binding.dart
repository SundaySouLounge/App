import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/appointment_controller.dart';

class AppointmentBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AppointmentController(parser: Get.find()),
    );
  }
}
