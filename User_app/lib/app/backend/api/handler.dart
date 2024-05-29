import 'package:app_user/app/backend/parse/account_parse.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_user/app/util/toast.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      showToast('Session expired!'.tr);
      // Take user to the login screen.
      AccountParser parser = Get.find();
      parser.clearAccount();
      if(Get.context != null) {
        // Ref: https://stackoverflow.com/questions/51071933/navigator-routes-clear-the-stack-of-flutter
        Navigator.pushNamedAndRemoveUntil(Get.context!, AppRouter.getLoginRoute(), (r) => false);
      } else {
        Get.toNamed(AppRouter.getLoginRoute());
      }
    } else {
      showToast(response.statusText.toString().tr);
    }
  }
}
