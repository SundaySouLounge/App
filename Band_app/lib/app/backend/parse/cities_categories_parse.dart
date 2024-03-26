import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';
import 'package:get/get.dart';

class CitiesCategoriesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CitiesCategoriesParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getAllCities() async {
    var response = await apiService.getPrivate(AppConstants.getAllCities,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> updateCities(String cityIds) async {
    var response = await apiService.postPrivate(
        AppConstants.salonUpdate,
        {"id": sharedPreferencesManager.getString('id'), "cid": cityIds},
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
