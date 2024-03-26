import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/individual_cities_controller.dart';

class IndividualCitiesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => IndividualCitiesController(parser: Get.find()),
    );
  }
}
