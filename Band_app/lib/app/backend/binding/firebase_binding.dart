import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/firebase_controller.dart';

class FirebaseBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => FirebaseController(parser: Get.find()),
    );
  }
}
