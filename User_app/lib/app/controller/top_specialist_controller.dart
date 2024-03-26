import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:app_user/app/backend/api/handler.dart';
import 'package:app_user/app/backend/models/top_freelancer_model.dart';
import 'package:app_user/app/backend/parse/top_specialist_parse.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/controller/specialist_controller.dart';
import 'package:app_user/app/controller/video_controller.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:app_user/app/util/constant.dart';

class TopSpecialistController extends GetxController implements GetxService {
  final TopSpecialistParser parser;

  List<TopFreelancerModel> _topFreelancerList = <TopFreelancerModel>[];
  List<TopFreelancerModel> get topFreelancerList => _topFreelancerList;

  String topFreelancerId = '';
  String topFreelancerName = '';

  bool apiCalled = false;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  TopSpecialistController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    getDataFromCategories();
    print("cart $_topFreelancerList");
  }

  Future<void> getDataFromCategories() async {
    var param = {"lat": parser.getLat(), "lng": parser.getLng()};
    Response response = await parser.getTopFreelancer(param);
    apiCalled = true;

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var topFreelancerData = myMap['data'];

      _topFreelancerList = [];

      topFreelancerData.forEach((data) {
        TopFreelancerModel datas = TopFreelancerModel.fromJson(data);
        _topFreelancerList.add(datas);
      });
      debugPrint(topFreelancerList.length.toString());
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onSpecialist(int id) {
    Get.delete<SpecialistController>(force: true);
    Get.delete<EventsCreationController>(force: true);
    Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [id, 0]);
  }
}
