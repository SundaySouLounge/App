import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:app_user/app/controller/notification_screen_controller.dart';
import 'package:app_user/app/util/theme.dart';
import 'package:app_user/app/view/inbox_screen/widgets/inbox_content.dart';
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

    if (controller.parser.isLogin() == true) {
      controller.getNotificationData();
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: ThemeProvider.backgroundColor2,
    appBar: AppBar(
      backgroundColor: ThemeProvider.appColor,
      title: Text("Notifications"),
      centerTitle: true,
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
                            ? ThemeProvider.appColor
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
                                  : ThemeProvider.appColor,
                            ),
                            Text(
                              "Notifications",
                              style: TextStyle(
                                color: notificationsSelected
                                    ? ThemeProvider.whiteColor
                                    : ThemeProvider.appColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: !notificationsSelected
                            ? ThemeProvider.appColor
                            : Colors.transparent,
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
                                      : ThemeProvider.appColor,
                                ),
                                Text(
                                  "Messages",
                                  style: TextStyle(
                                    color: !notificationsSelected
                                        ? ThemeProvider.whiteColor
                                        : ThemeProvider.appColor,
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
                        ],
                      ),
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
