import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class ShopSubCategoriesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ShopSubCategoriesParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getProductsById(var body) async {
    var response = await apiService.postPrivate(AppConstants.getSubCateById,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  void saveId(var id) {
    sharedPreferencesManager.putString('id', id);
  }
}
