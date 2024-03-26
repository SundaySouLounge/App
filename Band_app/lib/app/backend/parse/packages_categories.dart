import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class PackagesCategoriesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  PackagesCategoriesParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getServices(var body) async {
    var response = await apiService.postPrivate(AppConstants.getMyServices,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
