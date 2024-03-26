import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/backend/parse/languages_parse.dart';

class LanguagesController extends GetxController implements GetxService {
  final LanguagesParser parser;
  late String languageCode;
  LanguagesController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    languageCode = parser.getDefault();
  }

  void saveLanguages(String code) {
    var locale = Locale(code.toString());
    Get.updateLocale(locale);
    parser.saveLanguage(code);
    languageCode = code;
    update();
  }
}
