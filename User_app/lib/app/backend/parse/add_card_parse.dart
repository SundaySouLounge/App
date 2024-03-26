import 'package:get/get.dart';
import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:app_user/app/util/constant.dart';

class AddCardParse {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AddCardParse(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> updateProfile(dynamic param) async {
    return await apiService.postPrivate(AppConstants.updateProfile, param,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> createCardToken(dynamic param) async {
    return await apiService.postPrivate(AppConstants.createStripeToken, param,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> createCustomer(dynamic param) async {
    return await apiService.postPrivate(AppConstants.createStripeCustomer,
        param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> addStripeCard(dynamic param) async {
    return await apiService.postPrivate(AppConstants.addStripeCard, param,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getProfile() async {
    return await apiService.postPrivate(
        AppConstants.getUserProfile,
        {'id': sharedPreferencesManager.getString('uid')},
        sharedPreferencesManager.getString('token') ?? '');
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }
}
