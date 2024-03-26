import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class AllCategoriesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AllCategoriesParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getAllCategories() async {
    var response = await apiService.getPublic(AppConstants.getAllCategories);
    return response;
  }
}
