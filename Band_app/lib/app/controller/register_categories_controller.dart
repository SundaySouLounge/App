import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/backend/api/handler.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/add_profile_model.dart';
import 'package:ultimate_band_owner_flutter/app/backend/parse/register_categories_parse.dart';
import 'package:ultimate_band_owner_flutter/app/controller/signup_controller.dart';

class RegisterCategoriesController extends GetxController
    implements GetxService {
  final RegisterCategoriesParser parser;

  String selectedServedCate = '';
  String selectedServedCateName = '';
  List<AddProfileModel> _servedCategoriesList = <AddProfileModel>[];
  List<AddProfileModel> get servedCategoriesList => _servedCategoriesList;

  List<int> servedCategories = [];

  bool apiCalled = false;
  RegisterCategoriesController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    final item = Get.put(SignUpController(parser: Get.find()));
    if (Get.arguments[0] != null) {
      debugPrint(Get.arguments[0].toString());
      List<AddProfileModel> savedData = <AddProfileModel>[];
      savedData = Get.arguments[0];
      for (var element in savedData) {
        if (element.isChecked == true) {
          servedCategories.add(int.parse(element.id.toString()));
        }
      }
      if(item.type == 1 )
      {
        getAllServedCategory();
      }else{
        getAllServedCategoryUpdate();
      }

      
      update();
      debugPrint(servedCategories.toString());
    }
  }

  Future<void> getAllServedCategory() async {
  var response = await parser.getAllServedCategory();
  apiCalled = true;
  if (response.statusCode == 200) {
    Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
    var body = myMap['data'];
    _servedCategoriesList = [];

    body.forEach((element) {
      AddProfileModel datas = AddProfileModel.fromJson(element);
      var index = servedCategories.indexOf(datas.id as int);
      debugPrint(index.toString());
      
        // Filter categories based on extraField condition
        if (datas.extraField != null || datas.extraField == 'dj') {
          datas.isChecked = index >= 0;
          _servedCategoriesList.add(datas);
        }
      //  if (datas.extraField == null || datas.extraField != 'dj'){
      //   // Show all categories without the extraField condition
      //   datas.isChecked = index >= 0;
      //   _servedCategoriesList.add(datas);
      // }
    });
  } else {
    ApiChecker.checkApi(response);
  }
  update();
}

Future<void> getAllServedCategoryUpdate() async {
  var response = await parser.getAllServedCategory();
  apiCalled = true;
  if (response.statusCode == 200) {
    Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
    var body = myMap['data'];
    _servedCategoriesList = [];

    body.forEach((element) {
      AddProfileModel datas = AddProfileModel.fromJson(element);
      var index = servedCategories.indexOf(datas.id as int);
      debugPrint(index.toString());
      
        // Filter categories based on extraField condition
        // if (datas.extraField != null || datas.extraField == 'dj') {
        //   datas.isChecked = index >= 0;
        //   _servedCategoriesList.add(datas);
        // }
       if (datas.extraField == null || datas.extraField != 'dj'){
        // Show all categories without the extraField condition
        datas.isChecked = index >= 0;
        _servedCategoriesList.add(datas);
      }
    });
  } else {
    ApiChecker.checkApi(response);
  }
  update();
}


  void updateStatus(bool status, int id) {
    var itemIndex =
        _servedCategoriesList.indexWhere((element) => element.id == id);
    _servedCategoriesList[itemIndex].isChecked = status;
    if (status == false) {
      servedCategories.remove(id);
    } else {
      servedCategories.add(id);
    }
    update();
  }

  void saveAndClose() {
    Get.find<SignUpController>().saveCategory(_servedCategoriesList);
    onBack();
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
