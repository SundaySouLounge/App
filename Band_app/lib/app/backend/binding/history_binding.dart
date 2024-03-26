import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => HistoryController(parser: Get.find()),
    );
  }
}
