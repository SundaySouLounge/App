import 'package:ultimate_band_owner_flutter/app/backend/api/api.dart';
import 'package:ultimate_band_owner_flutter/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/util/constance.dart';

class ContactUsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ContactUsParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> saveContact(dynamic param) async {
    return await apiService.postPublic(AppConstants.saveaContacts, param);
  }

  Future<Response> sendToMail(dynamic param) async {
    return await apiService.postPublic(AppConstants.sendMailToAdmin, param);
  }

  String getSupportEmail() {
    return sharedPreferencesManager.getString('supportEmail') ?? '';
  }
}
