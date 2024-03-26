import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:app_user/app/controller/notification_screen_controller.dart';
import 'package:app_user/app/util/theme.dart';
import './new_event_request_dialog.dart';

class NotificationListWidget extends StatelessWidget {
  const NotificationListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) => controller.apiCalled == false
          ? SkeletonListView(
              itemCount: 5,
            )
          : controller.notificationList.isEmpty
              ? Center(
                  child: SizedBox(height: 10),
                )
              : Container(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.notificationList.length,
                    itemBuilder: (context, index) {
                      final item = controller.notificationList[index];
    List<String> names = [ "Artist", "Venue", "Artist", "Venue", "Artist", "Venue", "Artist", "Venue", "Artist", "Venue", "Artist", "Venue",];

                     if (item.title.toString().toLowerCase() ==
                          "new event request") {
                        return Container();
                      }
                     print('object ${item.data}');

                      return SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                               Text(
                names[index % names.length], // Use index to select the name
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
                              ],
                            ),
                            SizedBox(width: 30),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      item.message.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
