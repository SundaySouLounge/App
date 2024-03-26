import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class NewAddressParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  NewAddressParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> saveAddress(var body) async {
    var response = await apiService.postPrivate(AppConstants.saveAddress, body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> updateAddress(var body) async {
    var response = await apiService.postPrivate(AppConstants.updateAddress,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getAddressByID(var body) async {
    var response = await apiService.postPrivate(AppConstants.getAddressById,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  String getUId() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> getLatLngFromAddress(String url) async {
    return await apiService.getExternal(url);
  }
}
