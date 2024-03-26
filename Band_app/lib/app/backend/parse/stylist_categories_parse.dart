import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class StylistCategoriesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  StylistCategoriesParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> selectCategories() async {
    var response = await apiService.getPrivate(AppConstants.categories,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
