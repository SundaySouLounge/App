import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/tabs_controller.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';
import 'package:ultimate_band_owner_flutter/app/view/CalendarEvents.dart';
import 'package:ultimate_band_owner_flutter/app/view/analytics.dart';
import 'package:ultimate_band_owner_flutter/app/view/eventcontract_screen/appointment.dart';
import 'package:ultimate_band_owner_flutter/app/view/calendar.dart';
import 'package:ultimate_band_owner_flutter/app/view/history.dart';
import 'package:ultimate_band_owner_flutter/app/view/notification_screen/notification_screen.dart';
import 'package:ultimate_band_owner_flutter/app/view/profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ultimate_band_owner_flutter/app/view/profile_show.dart';
import 'package:ultimate_band_owner_flutter/app/view/services.dart';
import 'package:ultimate_band_owner_flutter/app/view/slot.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = const [
      ProfileShow(),
      AppointmentScreen(),
      NotificationsScreen(), 
      CalendarScreen(),
      ProfileScreen()
    ];
    return GetBuilder<TabsController>(builder: (value) {
      return DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: Colors.orangeAccent,
          bottomNavigationBar: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: InkWell(
                child: (GNav(
                  rippleColor: ThemeProvider.orangeColor,
                  hoverColor: ThemeProvider.orangeColor,
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
                      icon: Icons.person_2,
                      text: 'Profile'.tr,
                      backgroundColor: ThemeProvider.orangeColor,
                    ),
                    GButton(
                      icon: Icons.content_paste_outlined,
                      text: 'Contracts'.tr,
                      backgroundColor: ThemeProvider.orangeColor,
                    ),
                    GButton(
                      icon: Icons.rate_review_outlined,
                      text: 'Notifications'.tr,
                      backgroundColor: ThemeProvider.orangeColor,
                    ),
                    
                    GButton(
                      icon: Icons.calendar_today_outlined,
                      text: 'Calendar'.tr,
                      backgroundColor: ThemeProvider.orangeColor,
                    ),
                    GButton(
                      icon: Icons.menu,
                      text: 'Profile'.tr,
                      backgroundColor: ThemeProvider.orangeColor,
                    ),
                  ],
                  selectedIndex: value.tabId,
                  onTabChange: (index) {
                    value.updateTabId(index);
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
