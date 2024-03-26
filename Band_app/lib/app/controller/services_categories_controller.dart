import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/backend/api/handler.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/add_profile_model.dart';
import 'package:ultimate_band_owner_flutter/app/backend/parse/service_categories_parse.dart';
import 'package:ultimate_band_owner_flutter/app/controller/add_services_controller.dart';

class ServicesCategoriesController extends GetxController
    implements GetxService {
  final ServicesCategorisParser parser;

  String title = 'Select Service'.tr;

  bool userType = true;

  List<AddProfileModel> _serviceList = <AddProfileModel>[];
  List<AddProfileModel> get serviceList => _serviceList;

  String selectedService = '';
  String selectedServiceName = '';

  bool apiCalled = false;

  ServicesCategoriesController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    userType = parser.getType();
    getSelectedCategories();
    // selectedService = Get.arguments[0].toString();
  }

  Future<void> getSelectedCategories() async {
    if (userType == true) {
      debugPrint('for salon');
      var response = await parser.selectCategories(
          {"id": parser.sharedPreferencesManager.getString('uid')});
      apiCalled = true;
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        var body = myMap['data'];
        _serviceList = [];
        body.forEach((data) {
          AddProfileModel services = AddProfileModel.fromJson(data);
          _serviceList.add(services);
        });
        debugPrint(serviceList.length.toString());
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    } else {
      debugPrint('for individual');
      var response = await parser.individualCategories(
          {"id": parser.sharedPreferencesManager.getString('uid')});
      apiCalled = true;
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        var body = myMap['data'];
        _serviceList = [];
        body.forEach((data) {
          AddProfileModel services = AddProfileModel.fromJson(data);
          _serviceList.add(services);
        });
        debugPrint(serviceList.length.toString());
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void saveServices(String id) {
    selectedService = id;
    var name =
        _serviceList.firstWhere((element) => element.id.toString() == id).name;
    selectedServiceName = name as String;
    debugPrint('services selected');
    update();
  }

  Future<void> onSave() async {
    Get.find<AddServicesController>()
        .onSaveCategory(selectedService, selectedServiceName);
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
