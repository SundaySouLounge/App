import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_band_owner_flutter/app/controller/notification_screen_controller.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';
import 'package:ultimate_band_owner_flutter/app/view/inbox_screen/widgets/inbox_content.dart';
import './widgets/notifications_section.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenScreenState();
}

class _NotificationsScreenScreenState extends State<NotificationsScreen> {
  bool notificationsSelected = true;

  void toggleSelection(bool isNotifications) {
    setState(() {
      notificationsSelected = isNotifications;
    });
  }

  @override
  void initState() {
    super.initState();
    final controller = Get.find<NotificationController>();
    Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null && arguments.containsKey('user_id')) {
      String userId = arguments['user_id'];
      // Now you can use userId to update eventContractData
      controller.updateEventContractData(userId);
    }

    if (controller.parser.isLogin() == true) {
      controller.getNotificationData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.blackColor,
      appBar: AppBar(
        backgroundColor: ThemeProvider.appColor,
        title: Text("Notification",style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                        ),),
        centerTitle: true,
      //   leading: IconButton(
      //   icon: Icon(Icons.arrow_back, color: Colors.white),
      //   onPressed: () => Navigator.of(context).pop(),
      // ),
      ),
      body: GetBuilder<NotificationController>(
        builder: (value) {
          return SafeArea(
            child: Column(
              children: [
                // Add your top bar elements here
                Container(
                  color: Color.fromARGB(0, 128, 128, 128),
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align left
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: notificationsSelected
                              ? ThemeProvider.orangeColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () => toggleSelection(true),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.notification_add_rounded,
                                color: notificationsSelected
                                    ? ThemeProvider.whiteColor
                                    : ThemeProvider.whiteColor,
                              ),
                              SizedBox(width: 8), // Add spacing
                              Text(
                                "Notifications",
                                style: TextStyle(
                                  color: notificationsSelected
                                      ? ThemeProvider.whiteColor
                                      : ThemeProvider.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: !notificationsSelected
                              ? ThemeProvider.orangeColor
                              : ThemeProvider.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                         GestureDetector(
                          onTap: () => toggleSelection(false),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.message,
                                color: !notificationsSelected
                                    ? ThemeProvider.whiteColor
                                    : ThemeProvider.whiteColor,
                              ),
                              SizedBox(width: 8), // Add spacing
                              Text(
                                "Messages",
                                style: TextStyle(
                                  color: !notificationsSelected
                                      ? ThemeProvider.whiteColor
                                      : ThemeProvider.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                         if (notificationsSelected)
                        Container(
                              margin: EdgeInsets.only(top: 0, right: 1),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                            ),
                        ]
                        )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Add space between top bar and content
                Expanded(
                  child: notificationsSelected
                      ? NotificationsSection()
                      : InboxContent(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
