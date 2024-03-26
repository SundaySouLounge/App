import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class AddressListParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AddressListParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getSavedAddress(var body) async {
    var response = await apiService.postPrivate(AppConstants.getSavedAddress,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }
}
