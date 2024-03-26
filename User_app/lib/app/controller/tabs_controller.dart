import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:app_user/app/backend/parse/tabs_parse.dart';
import 'package:app_user/app/controller/product_cart_controller.dart';

class TabsController extends GetxController
    with GetTickerProviderStateMixin
    implements GetxService {
  final TabsParser parser;
  int cartTotal = 0;
  int tabId = 0;
  late TabController tabController;
  TabsController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 5, vsync: this, initialIndex: tabId);
  }

  void updateCartValue() {
    cartTotal = Get.find<ProductCartController>().savedInCart.length;
    update();
  }

  void cleanLoginCreds() {
    // parser.cleanData();
  }

  void updateTabId(int id) {
    tabId = id;
    tabController.animateTo(tabId);
    update();
  }
}
