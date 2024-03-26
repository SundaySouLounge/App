import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class CategoriesListParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CategoriesListParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getDataFromCategories(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.getDataFromCategories,
        body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getBatchDataFromCategories(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.getBatchDataFromCategories,
        body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getSearchResult(var body) async {
    return await apiService.postPublic(AppConstants.searchResult, body);
  }

  double getLat() {
    return sharedPreferencesManager.getDouble('lat') ?? 0.0;
  }

  double getLng() {
    return sharedPreferencesManager.getDouble('lng') ?? 0.0;
  }
}
