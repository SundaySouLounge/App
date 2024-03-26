import 'package:get/get.dart';
import 'package:app_user/app/controller/top_offers_controller.dart';

class TopOffersBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => TopOffersController(parser: Get.find()),
    );
  }
}
