import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/calendar_events_controller.dart';

class CalendarEventsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => CalendarEventsController(parser: Get.find()),
    );
  }
}
