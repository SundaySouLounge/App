import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_user/app/controller/favorite_controller.dart';
import 'package:app_user/app/controller/tabs_controller.dart';
import 'package:app_user/app/util/theme.dart';
import 'package:app_user/app/view/account.dart';
import 'package:app_user/app/view/eventcontract_screen/booking.dart';
import 'package:app_user/app/view/favorites_screen.dart';
import 'package:app_user/app/view/home.dart';
import 'package:app_user/app/view/near.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:app_user/app/view/notification_screen/notification_screen.dart';
import 'package:app_user/app/view/pending.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
      final FavoriteController _favoriteController = Get.find<FavoriteController>();

    List<Widget> pages = const [
      HomeScreen(),
      FavoritesScreen(),
      PendingScreen(),
      BookingScreen(),
      AccountScreen()
    ];
    return GetBuilder<TabsController>(builder: (value) {
      return DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: InkWell(
                child: (GNav(
                  rippleColor: ThemeProvider.appColor,
                  hoverColor: ThemeProvider.appColor,
                  haptic: false,
                  curve: Curves.easeOutExpo,
                  tabBorderRadius: 15,
                  textStyle:
                      const TextStyle(fontFamily: 'bold', color: Colors.white),
                  duration: const Duration(milliseconds: 300),
                  gap: 5,
                  color: Colors.grey.shade400,
                  activeColor: Colors.white,
                  iconSize: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  tabs: [
                    GButton(
                      icon: Icons.home_outlined,
                      text: 'Home'.tr,
                      backgroundColor: ThemeProvider.appColor,
                    ),
                    GButton(
                      icon: Icons.favorite,
                      text: 'Favorites'.tr,
                      backgroundColor: ThemeProvider.appColor,
                    ),
                    GButton(
                      icon: Icons.message_outlined,
                      text: 'NearBy'.tr,
                      backgroundColor: ThemeProvider.appColor,
                      leading: badges.Badge(
                        showBadge: value.cartTotal > 0,
                        badgeStyle: badges.BadgeStyle(
                            badgeColor: value.tabId == 2
                                ? ThemeProvider.whiteColor
                                : ThemeProvider.appColor),
                        badgeContent: Text(
                          value.cartTotal.toString(),
                          style: TextStyle(
                              color: value.tabId == 2
                                  ? ThemeProvider.appColor
                                  : ThemeProvider.whiteColor),
                        ),
                        child: Icon(
                          Icons.circle_notifications_outlined,
                          color: value.tabId == 2 ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                    GButton(
                      icon: Icons.calendar_today_outlined,
                      text: 'Contracts'.tr,
                      backgroundColor: ThemeProvider.appColor,
                    ),
                    GButton(
                      icon: Icons.menu,
                      text: 'Account'.tr,
                      backgroundColor: ThemeProvider.appColor,
                    ),
                  ],
                  selectedIndex: value.tabId,
                  onTabChange: (index) {
                    value.updateTabId(index);
                    if (index == 1) {
                       _favoriteController.getFavoriteData();
                    }
                  },
                )),
              ),
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: value.tabController,
            children: pages,
          ),
        ),
      );
    });
  }
}
