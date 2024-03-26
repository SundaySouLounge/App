import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/analytics_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/appointment_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/calendar_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/history_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/profile_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/tabs_controller.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => TabsController(parser: Get.find()));
    Get.lazyPut(() => AppointmentController(parser: Get.find()));
    Get.lazyPut(() => HistoryController(parser: Get.find()));
    Get.lazyPut(() => AnalyticsController(parser: Get.find()));
    Get.lazyPut(() => CalendarsController(parser: Get.find()));
    Get.lazyPut(() => ProfileController(parser: Get.find()));
  }
}
