import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/individual_categories_controller.dart';

class IndividualProfileCategoriesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => IndividualprofileCategoriesController(parser: Get.find()),
    );
  }
}
