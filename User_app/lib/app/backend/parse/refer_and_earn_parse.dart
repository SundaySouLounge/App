import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class ReferAndEarnParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ReferAndEarnParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getMyCode() async {
    return await apiService.postPrivate(
        AppConstants.getMyReferralCode,
        {'id': sharedPreferencesManager.getString('uid')},
        sharedPreferencesManager.getString('token') ?? '');
  }

  String getName() {
    String firstName = sharedPreferencesManager.getString('first_name') ?? '';
    String lastName = sharedPreferencesManager.getString('last_name') ?? '';
    return '$firstName $lastName';
  }
}
