import 'package:get/get.dart';
import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:app_user/app/util/constant.dart';

class FindLocationParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  FindLocationParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getPlacesList(url) async {
    var response = await apiService.getOther(url);
    return response;
  }

  Future<Response> getHomeData(dynamic body) async {
    var response = await apiService.postPublic(AppConstants.getHomeData, body);
    return response;
  }

  void saveLatLng(var lat, var lng, var address) {
    sharedPreferencesManager.putDouble('lat', lat);
    sharedPreferencesManager.putDouble('lng', lng);
    sharedPreferencesManager.putString('address', address);
  }
}
