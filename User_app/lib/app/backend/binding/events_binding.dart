import 'package:get/get.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';

class EventsCreationBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => EventsCreationController(parser: Get.find()),
    );
  }
}
