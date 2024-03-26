import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/backend/parse/tabs_parse.dart';

class TabsController extends GetxController
    with GetTickerProviderStateMixin
    implements GetxService {
  final TabsParser parser;
  int tabId = 0;
  late TabController tabController;
  TabsController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 5, vsync: this, initialIndex: tabId);
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
