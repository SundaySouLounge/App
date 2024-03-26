import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/constant.dart';

class ContactUsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ContactUsParser(
      {required this.apiService, required this.sharedPreferencesManager});

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
