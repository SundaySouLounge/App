import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class CouponParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CouponParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getCouponCodes() async {
    return apiService.getPrivate(AppConstants.getCoupons,
        sharedPreferencesManager.getString('token') ?? '');
  }
}
