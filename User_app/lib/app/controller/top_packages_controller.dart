import 'package:get/get.dart';
import 'package:app_user/app/backend/parse/top_packages_parse.dart';

class TopPackagesController extends GetxController implements GetxService {
  final TopPackagesParser parser;

  TopPackagesController({required this.parser});

  // void onBookAppointment() {
  //   Get.toNamed(AppRouter.getBookAppointmentRoutes());
  // }
}
