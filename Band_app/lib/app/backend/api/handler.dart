import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/backend/parse/profile_parse.dart';
import 'package:ultimate_band_owner_flutter/app/util/toast.dart';

import '../../helper/router.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      showToast('Session expired!'.tr);
      // Take user to the login screen.
      ProfileParser parser = Get.find();
      parser.clearAccount();
      if(Get.context != null) {
        // Ref: https://stackoverflow.com/questions/51071933/navigator-routes-clear-the-stack-of-flutter
        Navigator.pushNamedAndRemoveUntil(Get.context!, AppRouter.getInitialRoute(), (r) => false);
      } else {
        Get.toNamed(AppRouter.getInitialRoute());
      }
    } else {
    //  showToast(response.statusText.toString().tr);
    }
  }
}
