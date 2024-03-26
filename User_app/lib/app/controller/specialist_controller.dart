import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_user/app/backend/api/handler.dart';
import 'package:app_user/app/backend/models/categories_model.dart';
import 'package:app_user/app/backend/models/individual_categories_model.dart';
import 'package:app_user/app/backend/models/individual_info_model.dart';
import 'package:app_user/app/backend/models/packages_model.dart';
import 'package:app_user/app/backend/models/owner_reviews_model.dart';
import 'package:app_user/app/backend/models/userinfo_model.dart';
import 'package:app_user/app/backend/parse/specialist_parse.dart';
import 'package:app_user/app/controller/chat_controller.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/controller/individual_checkout_controller.dart';
import 'package:app_user/app/controller/individual_list_controller.dart';
import 'package:app_user/app/controller/individual_packages_controller.dart';
import 'package:app_user/app/controller/login_controller.dart';
import 'package:app_user/app/env.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:app_user/app/helper/shared_pref.dart';
import 'package:app_user/app/util/constant.dart';
import 'package:app_user/app/util/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecialistController extends GetxController
    with GetTickerProviderStateMixin
    implements GetxService {
  final SpecialistParser parser;

  int tabID = 1;

  String title = 'Select Service'.tr;
  final sharedPref = Get.find<SharedPreferencesManager>();

  List<String> dayList = [
    'Sunday'.tr,
    'Monday'.tr,
    'Tuesday'.tr,
    'Wednesday'.tr,
    'Thursday'.tr,
    'Friday'.tr,
    'Saturday'.tr
  ];

  List<String> gallery = [];

  IndividualInfoModel _individualDetails = IndividualInfoModel();
  IndividualInfoModel get individualDetails => _individualDetails;

  UserInfoModel _userInfo = UserInfoModel();
  UserInfoModel get userInfo => _userInfo;

  List<CategoriesModel> _categoriesList = <CategoriesModel>[];
  List<CategoriesModel> get categoriesList => _categoriesList;

  List<PackagesModel> _packagesList = <PackagesModel>[];
  List<PackagesModel> get packagesList => _packagesList;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  List<OwnerReviewsModel> _ownerReviewsList = <OwnerReviewsModel>[];
  List<OwnerReviewsModel> get ownerReviewsList => _ownerReviewsList;

  String selectedService = '';
  String selectedServiceName = '';

  bool apiCalled = false;
  bool reviewsCalled = false;

  int individualId = 0;
  final Set<Marker> markers = {};
  String getDistance = '';
  SpecialistController({
    required this.parser,
    this.individualId = 0,
  });

  late TabController tabController;

  List<String> brandSizeList = [];

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      debugPrint(tabController.index.toString());
      if (tabController.index == 2) {
        debugPrint('get reviews');
        reviewsCalled = false;
        update();
        getOwnerReviews();
      }
    });
    if (Get.arguments != null) {
      individualId = Get.arguments[0] ??
          sharedPref.getInt(
            "key-individualId",
          );
    } else {
      individualId = sharedPref.getInt("key-individualId") ?? 0;
    }
    getindividualDetails();
    debugPrint('individual id --> $individualId');
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
  }

  Future<void> getindividualDetails() async {
    var response = await parser.individualDetails({"id": individualId});
    if (response.statusCode == 200) {
      print('API Response: ${response.body}');
      apiCalled = true;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      var salonCategories = myMap['categories'];
      var salonPackages = myMap['packages'];
      var user = myMap['userInfo'];

      _individualDetails = IndividualInfoModel();
      _userInfo = UserInfoModel();
      _categoriesList = [];
      _packagesList = [];

      IndividualInfoModel services = IndividualInfoModel.fromJson(body);
      _individualDetails = services;
      double storeDistance = 0.0;
      double totalMeters = 0.0;
      storeDistance = Geolocator.distanceBetween(
        double.tryParse(_individualDetails.lat.toString()) ?? 0.0,
        double.tryParse(_individualDetails.lng.toString()) ?? 0.0,
        double.tryParse(parser.getLat().toString()) ?? 0.0,
        double.tryParse(parser.getLng().toString()) ?? 0.0,
      );
      totalMeters = totalMeters + storeDistance;
      double distance = double.parse((storeDistance / 1000).toStringAsFixed(2));
      debugPrint(distance.toString());
      getDistance = distance.toString();
      if (individualDetails.images != 'NA' &&
          individualDetails.images != null &&
          individualDetails.images != '') {
        var imgs = jsonDecode(individualDetails.images!);
        gallery = [];
        if (imgs.length > 0) {
          imgs.forEach((element) {
            if (element != '') {
              gallery.add(element);
            }
          });
          update();
        }
      }

      if (individualDetails.inHome == 1) {
        brandSizeList.add("solo");
      }
      UserInfoModel userDetails = UserInfoModel.fromJson(user);
      _userInfo = userDetails;

      salonCategories.forEach((data) {
        print('Data Categories: $data');
        CategoriesModel categories = CategoriesModel.fromJson(data);
        _categoriesList.add(categories);
      });
      debugPrint(' LIST: ${categoriesList.length.toString()}');

      salonPackages.forEach((data) {
        PackagesModel packages = PackagesModel.fromJson(data);
        _packagesList.add(packages);
      });
      debugPrint(packagesList.length.toString());
      update();
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getOwnerReviews() async {
    var response = await parser.getOwnerReviewsList({"id": individualId});
    reviewsCalled = true;
    _ownerReviewsList = [];
    update();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];

      body.forEach((data) {
        OwnerReviewsModel reviews = OwnerReviewsModel.fromJson(data);
        _ownerReviewsList.add(reviews);
      });
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onServicesView(int id, String name) {
    Get.delete<IndividualListController>(force: true);
    Get.toNamed(AppRouter.getIndividualList(),
        arguments: [id, name, individualDetails.uid]);
  }

  void onPackagesDetails(int id, String name) {
    Get.delete<IndividualPackagesController>(force: true);
    Get.toNamed(AppRouter.getIndividualPackages(), arguments: [id, name]);
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  onMapCreated() {
    if (individualDetails.lat != null && individualDetails.lng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('Id-1'),
          position: LatLng(
              individualDetails.lat as double, individualDetails.lng as double),
        ),
      );
    }
  }

  Future<void> openMap() async {
    double latitude = individualDetails.lat as double;
    double longitude = individualDetails.lng as double;
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    var url = Uri.parse(googleUrl);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> openWebsite() async {
    if (individualDetails.website.toString() != 'NA' ||
        individualDetails.website!.isEmpty ||
        individualDetails.website != null) {
      var url = Uri.parse(individualDetails.website.toString());
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
    } else {
      showToast('No Website Found'.tr);
    }
  }

  Future<void> callIndividual() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: individualDetails.mobile.toString(),
    );
    await launchUrl(launchUri);
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: Environments.appName,
        linkUrl: individualDetails.website.toString(),
        chooserTitle: 'Share with'.tr);
  }

  void onChat() {
    debugPrint('on chat');
    if (parser.isLogin() == true) {
      Get.delete<ChatController>(force: true);
      Get.toNamed(AppRouter.getChatRoutes(), arguments: [
        individualDetails.uid.toString(),
        '${userInfo.firstName} ${userInfo.lastName}'
      ]);
    } else {
      Get.delete<LoginController>(force: true);
      Get.toNamed(AppRouter.getLoginRoute());
    }
  }

  void onCheckout() {
    Get.delete<IndividualCheckoutController>(force: true);
    Get.toNamed(AppRouter.getIndividualCheckout());
  }

  Future<void> updateFavoriteIndividual(int isFavorite) async {
    apiCalled = false;
    update();
    print('isFavorite: $isFavorite');
    var response = await parser.updateFavoriteIndividual(
        {"id": individualId, "is_favorite": isFavorite});
    print('heeeey $isFavorite');
    if (response.statusCode == 200) {
      var res = await getindividualDetails();
      _individualDetails.isFavorite = 1;
      print('heeeeys $isFavorite');
    } else {
      ApiChecker.checkApi(response);
    }
    successToast("Artist added to favorites");
    apiCalled = true;
    update();
  }

  Future<void> deleteFromFavorites() async {
    apiCalled = false;
    update();

    try {
      var response = await parser.deleteFavoriteIndividual({
        "id": individualId,
        "is_favorite": 0,
      });
      if (response.statusCode == 200) {
// Assuming 0 represents not in favorites
        var res = await getindividualDetails();
        _individualDetails.isFavorite = 0;
        print('Deleted from favorites');
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      // Handle exceptions or errors here
      print('Error: $e');
    }

    successToast("Artist removed from favorites");
    apiCalled = true;
    update();
  }

//OLD
  void onToSendContract(bool isSpecialist) {
    if (parser.isLogin() == true) {
      Get.delete<EventsCreationController>(force: true);
      Get.toNamed(
        AppRouter.eventsCreationRoutes,
        arguments: [
          individualId,
          null,
          brandSizeList,
          isSpecialist,
        ],
      );
    } else {
      showToast('Please login now'.tr);
    }
  }
}
