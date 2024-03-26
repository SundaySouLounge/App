import 'package:get/get.dart';
import 'package:app_user/app/backend/parse/intro_parse.dart';
import 'package:app_user/app/helper/router.dart';

class IntroController extends GetxController implements GetxService {
  final IntroParser parser;
  IntroController({required this.parser});

  void onSkip() {
    Get.toNamed(AppRouter.getWelcomeRoute(), arguments: ['']);
  }

  void saveLanguage(String code) {
    parser.saveLanguage(code);
    update();
  }
}
