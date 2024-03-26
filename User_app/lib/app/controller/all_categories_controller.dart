import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:app_user/app/backend/api/handler.dart';
import 'package:app_user/app/backend/models/categories_model.dart';
import 'package:app_user/app/backend/parse/all_categories_parse.dart';
import 'package:app_user/app/controller/categories_list_controller.dart';
import 'package:app_user/app/helper/router.dart';

class AllCategoriesController extends GetxController implements GetxService {
  final AllCategoriesParser parser;

  List<CategoriesModel> _categoriesList = <CategoriesModel>[];
  List<CategoriesModel> get categoriesList => _categoriesList;

  final List<int> selectedCategoriesList = [];

  bool apiCalled = false;
  bool switchValue1 = false;
  bool switchValue2 = false;
  bool switchValue3 = false;
  bool switchValue4 = false;
  DateTime selectedDate = DateTime.now();

  AllCategoriesController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
  }

  Future<void> getAllCategories() async {
    var response = await parser.getAllCategories();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      _categoriesList = [];
      body.forEach((data) {
        CategoriesModel cateData = CategoriesModel.fromJson(data);
        _categoriesList.add(cateData);
      });
      debugPrint(categoriesList.length.toString());
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void clickCategoryItem(CategoriesModel item) {
    if (selectedCategoriesList.contains(item.id)) {
      selectedCategoriesList.remove(item.id);
    } else {
      selectedCategoriesList.add(item.id!);
    }
    update();
  }

  void onCategoriesList() {
    Get.delete<CategoriesListController>(force: true);
    Get.toNamed(AppRouter.getCategoriesListRoutes(),
        arguments: selectedCategoriesList);
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
    update();
  }
}
