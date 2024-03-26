import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class AccountParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AccountParser(
      {required this.apiService, required this.sharedPreferencesManager});

  String getCover() {
    return sharedPreferencesManager.getString('cover') ?? '';
  }

  bool haveLoggedIn() {
    return sharedPreferencesManager.getString('uid') != '' &&
            sharedPreferencesManager.getString('uid') != null
        ? true
        : false;
  }

  String getFirstName() {
    return sharedPreferencesManager.getString('first_name') ?? '';
  }

  String getVenueName() {
    return sharedPreferencesManager.getString('venue_name') ?? '';
  }

  String getVenueAddress() {
    return sharedPreferencesManager.getString('venue_address') ?? '';
  }

  String getVenueNumber() {
    return sharedPreferencesManager.getString('mobile') ?? '';
  }

  String getLastName() {
    return sharedPreferencesManager.getString('last_name') ?? '';
  }

  String getEmail() {
    return sharedPreferencesManager.getString('email') ?? '';
  }

  Future<Response> logout() async {
    return await apiService.logout(
        AppConstants.logout, sharedPreferencesManager.getString('token') ?? '');
  }

  void clearAccount() {
    sharedPreferencesManager.clearKey('first_name');
    sharedPreferencesManager.clearKey('last_name');
    sharedPreferencesManager.clearKey('token');
    sharedPreferencesManager.clearKey('uid');
    sharedPreferencesManager.clearKey('email');
    sharedPreferencesManager.clearKey('cover');
  }
}
