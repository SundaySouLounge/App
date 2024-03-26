import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_user/app/backend/api/handler.dart';
import 'package:app_user/app/backend/models/salon_model.dart';
import 'package:app_user/app/backend/models/search_individual_model.dart';
import 'package:app_user/app/backend/parse/search_parse.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/controller/services_controller.dart';
import 'package:app_user/app/controller/specialist_controller.dart';
import 'package:app_user/app/controller/video_controller.dart';
import 'package:app_user/app/helper/router.dart';

class AppSearchController extends GetxController implements GetxService {
  final SearchParser parser;
  TextEditingController searchController = TextEditingController(text: '');
  RxBool isEmpty = true.obs;
  // RxBool solo = false.obs;
  // RxBool duo = false.obs;
  // RxBool trio = false.obs;
  bool switchValue1 = true;
  bool switchValue2 = true;
  bool switchValue3 = true;
  bool switchValue4 = true;
  DateTime selectedDate = DateTime.now();

  List<SalonModel> _salonList = <SalonModel>[];
  List<SalonModel> get salonList => _salonList;

  List<SearchIndividualModel> _individualList = <SearchIndividualModel>[];
  List<SearchIndividualModel> get individualList => _individualList;

  String title = '';
  AppSearchController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    title = parser.getAddressName();
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
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
    print("$switchValue1, $switchValue2, $switchValue3, $switchValue4");
    update();
    print("$switchValue1, $switchValue2, $switchValue3, $switchValue4");
    searchProducts(searchController.value.text);
  }

  searchProducts(String name) {
    if (name.isNotEmpty && name != '') {
      getSearchResult(name);
    } else {
      _salonList = [];
      _individualList = [];
      isEmpty = true.obs;
      update();
    }
  }

  void getSearchResult(String name, {bool fallback = false}) async {
    var param = getParameter(name);
    var fallbackParam = getFallbackParameter(name);
    Response response =
        await parser.getSearchResult(fallback ? fallbackParam : param);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var salonData = myMap['salon'];
      var individualData = myMap['individual'];

      _salonList = [];
      _individualList = [];

      salonData.forEach((data) {
        SalonModel salon = SalonModel.fromJson(data);
        _salonList.add(salon);
      });

      individualData.forEach((data) {
        SearchIndividualModel individual = SearchIndividualModel.fromJson(data);
        _individualList.add(individual);
      });
      if (_individualList.isEmpty && _salonList.isEmpty && !fallback) {
        getSearchResult(name, fallback: true);
      }
      isEmpty = false.obs;
      debugPrint(salonList.length.toString());
      debugPrint(individualList.length.toString());
    } else {
      isEmpty = false.obs;
      ApiChecker.checkApi(response);
    }
    update();
  }

  void clearData() {
    searchController.clear();
    _salonList = [];
    _individualList = [];
    isEmpty = true.obs;
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

  Map<String, dynamic> getParameter(name) {
    return {
      "param": name,
      "solo": switchValue1,
      "duo": switchValue2,
      "trio": switchValue3,
      "quarter": switchValue4,
      "lat": parser.getLat(),
      "lng": parser.getLng()
    };
  }

  Map<String, dynamic> getFallbackParameter(name) {
    return {
      "param": name,
      "solo": !switchValue1,
      "duo": !switchValue2,
      "trio": !switchValue3,
      "quarter": !switchValue4,
      "lat": parser.getLat(),
      "lng": parser.getLng(),
    };
  }

//to preven infinite loop
  bool hasOptionSet() {
    bool value = switchValue1 || switchValue2 || switchValue3 || switchValue4;
    return value;
  }
}
