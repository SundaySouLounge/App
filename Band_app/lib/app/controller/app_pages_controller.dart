import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/backend/api/handler.dart';
import 'package:ultimate_band_owner_flutter/app/backend/parse/app_pages_parse.dart';

class AppPagesController extends GetxController implements GetxService {
  final AppPagesParser parser;
  String title = '';
  String pageId = '';
  String content = '';
  bool apiCalled = false;

  AppPagesController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    var name = Get.arguments[0];
    var dbPageId = Get.arguments[1];
    title = name;
    pageId = dbPageId;
    update();
    getContent();
  }

  Future<void> getContent() async {
    Response response = await parser.getContentById(pageId);
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      if (body['content'] != '' && body['content'] != null) {
        content = body['content'];
      }
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
  }
}
