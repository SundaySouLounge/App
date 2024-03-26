import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:app_user/app/backend/api/handler.dart';
import 'package:app_user/app/backend/models/individual_categories_model.dart';
import 'package:app_user/app/backend/models/salon_categories_model.dart';
import 'package:app_user/app/backend/models/salon_model.dart';
import 'package:app_user/app/backend/models/search_individual_model.dart';
import 'package:app_user/app/backend/parse/categories_list_parse.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/controller/services_controller.dart';
import 'package:app_user/app/controller/specialist_controller.dart';
import 'package:app_user/app/controller/video_controller.dart';
import 'package:app_user/app/helper/router.dart';

class CategoriesListController extends GetxController implements GetxService {
  final CategoriesListParser parser;

  List<IndividualCategoriesModel> _individualCateList =
      <IndividualCategoriesModel>[];
  List<IndividualCategoriesModel> get individualCateList => _individualCateList;

  List<SalonCategoriesModel> _salonCateList = <SalonCategoriesModel>[];
  List<SalonCategoriesModel> get salonCateList => _salonCateList;

  List<int> _individualList = <int>[];
  List<int> get individualList => _individualList;

  RxBool isEmpty = true.obs;

  List<int> selectedCateIds = [];
  String selectedCateName = '';
  bool switchValue1 = true;
  bool switchValue2 = true;
  bool switchValue3 = true;
  bool switchValue4 = true;

  bool apiCalled = false;

  bool haveData = false;
  CategoriesListController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    selectedCateIds = Get.arguments;
    // selectedCateName = Get.arguments[1].toString();
    update();
    // debugPrint(selectedCateIds);
    getBatchDataFromCategories();
    getSearchResult();
  }

  void setFilterValues(
    bool newSwitchValue1,
    bool newSwitchValue2,
    bool newSwitchValue3,
    bool newSwitchValue4,
    DateTime newSelectedDate,
  ) {
    switchValue1 = newSwitchValue1;
    switchValue2 = newSwitchValue2;
    switchValue3 = newSwitchValue3;
    switchValue4 = newSwitchValue4;
    getSearchResult();
  }

  Future<void> getBatchDataFromCategories() async {
    var param = {
      "lat": parser.getLat(),
      "lng": parser.getLng(),
      "ids": selectedCateIds
    };
    Response response = await parser.getBatchDataFromCategories(param);
    apiCalled = true;

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var individualData = myMap['individual'];
      var salonData = myMap['salon'];

      _individualCateList = [];
      print('object ${_individualCateList}');
      _salonCateList = [];
      individualData.forEach((data) {
        IndividualCategoriesModel individual =
            IndividualCategoriesModel.fromJson(data);
        _individualCateList.add(individual);
      });
      debugPrint('hello ${(individualCateList.length.toString())}');

      salonData.forEach((data) {
        SalonCategoriesModel salon = SalonCategoriesModel.fromJson(data);
        _salonCateList.add(salon);
      });
      debugPrint(salonCateList.length.toString());
      if (_salonCateList.isEmpty && _individualCateList.isEmpty) {
        haveData = false;
      } else {
        haveData = true;
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void getSearchResult() async {
    var param = {
      "param": "",
      "solo": switchValue1,
      "duo": switchValue2,
      "trio": switchValue3,
      "quarter": switchValue4,
      "lat": parser.getLat(),
      "lng": parser.getLng()
    };
    Response response = await parser.getSearchResult(param);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var individualData = myMap['individual'];
      _individualList = [];

      individualData.forEach((data) {
        SearchIndividualModel individual = SearchIndividualModel.fromJson(data);
        if (individual.id != null) {
          _individualList.add(individual.id!);
        }
      });
      isEmpty = false.obs;
      debugPrint(individualList.length.toString());
    } else {
      isEmpty = false.obs;
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onServices(int id) {
    Get.delete<ServicesController>(force: true);
    Get.toNamed(AppRouter.getServicesRoutes(), arguments: [id]);
  }

  void onSpecialist(int id) {
    Get.delete<SpecialistController>(force: true);
    Get.delete<EventsCreationController>(force: true);
    Get.delete<VideoController>(force: true);
    Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [id, 0]);
  }
}
