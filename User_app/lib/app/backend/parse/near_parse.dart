import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class NearParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  NearParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getHomeData(var body) async {
    var response = await apiService.postPublic(AppConstants.getHomeData, body);
    return response;
  }

  double getLat() {
    return sharedPreferencesManager.getDouble('lat') ?? 0.0;
  }

  double getLng() {
    return sharedPreferencesManager.getDouble('lng') ?? 0.0;
  }
}
