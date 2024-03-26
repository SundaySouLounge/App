import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:app_user/app/backend/parse/choose_location_parse.dart';
import 'package:app_user/app/controller/account_controller.dart';
import 'package:app_user/app/controller/booking_controller.dart';
import 'package:app_user/app/controller/categories_controller.dart';
import 'package:app_user/app/controller/favorite_controller.dart';
import 'package:app_user/app/controller/home_controller.dart';
import 'package:app_user/app/controller/near_controller.dart';
import 'package:app_user/app/controller/tabs_controller.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:app_user/app/util/theme.dart';
import 'package:app_user/app/util/toast.dart';
import 'package:geolocator/geolocator.dart';

class ChooseLocationController extends GetxController implements GetxService {
  final ChooseLocationParser parser;

  ChooseLocationController({required this.parser});

  void onChooseLocation() {
    Get.toNamed(AppRouter.getFindLocationRoutes());
  }

  void getLocation() async {
    ////// TEST DATA ////
    ///
  
   if (parser.isLogin() == true) {
    parser.saveLatLng(51.5072, 0.1276, 'London');

    Get.delete<TabsController>(force: true);
    Get.delete<HomeController>(force: true);
    Get.delete<FavoriteController>(force: true);
    Get.delete<NearController>(force: true);
    Get.delete<CategoriesController>(force: true);
    Get.delete<BookingController>(force: true);
    Get.delete<AccountController>(force: true);
    Get.offAndToNamed(AppRouter.getTabsBarRoute());
   }else{
    parser.onLogin();
   }
    /// TEST DATA //

    /////// REAL DATA /////
    // Get.dialog(
    //     SimpleDialog(
    //       children: [
    //         Row(
    //           children: [
    //             const SizedBox(
    //               width: 30,
    //             ),
    //             const CircularProgressIndicator(
    //               color: ThemeProvider.appColor,
    //             ),
    //             const SizedBox(
    //               width: 30,
    //             ),
    //             SizedBox(
    //                 child: Text(
    //               "Featching Location".tr,
    //               style: const TextStyle(fontFamily: 'bold'),
    //             )),
    //           ],
    //         )
    //       ],
    //     ),
    //     barrierDismissible: false);
    // _determinePosition().then((value) async {
    //   Get.back();
    //   debugPrint(value.toString());
    //   List<Placemark> newPlace =
    //       await placemarkFromCoordinates(value.latitude, value.longitude);
    //   Placemark placeMark = newPlace[0];
    //   String name = placeMark.name.toString();
    //   String subLocality = placeMark.subLocality.toString();
    //   String locality = placeMark.locality.toString();
    //   String administrativeArea = placeMark.administrativeArea.toString();
    //   String postalCode = placeMark.postalCode.toString();
    //   String country = placeMark.country.toString();
    //   String address =
    //       "$name,$subLocality,$locality,$administrativeArea,$postalCode,$country";
    //   debugPrint(address);
    //   parser.saveLatLng(value.latitude, value.longitude, address);

    //   Get.delete<TabsController>(force: true);
    //   Get.delete<HomeController>(force: true);
    //   Get.delete<NearController>(force: true);
    //   Get.delete<CategoriesController>(force: true);
    //   Get.delete<BookingController>(force: true);
    //   Get.delete<AccountController>(force: true);
    //   Get.offAndToNamed(AppRouter.getTabsBarRoute());
    // }).catchError((error) async {
    //   Get.back();
    //   showToast(error.toString());
    //   await Geolocator.openLocationSettings();
    // });

    /////// REAL DATA /////
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void saveLanguage(String code) {
    parser.saveLanguage(code);
    update();
  }
}
