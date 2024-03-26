import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class AppPagesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AppPagesParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getContentById(var id) async {
    return await apiService.postPublic(AppConstants.pageContent, {'id': id});
  }
}
