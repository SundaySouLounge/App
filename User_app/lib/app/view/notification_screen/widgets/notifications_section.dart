import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:app_user/app/view/pending.dart';
import 'package:skeletons/skeletons.dart';
import 'package:app_user/app/controller/notification_screen_controller.dart';
import 'package:app_user/app/util/theme.dart';
import './new_event_request_dialog.dart';

class NotificationsSection extends StatelessWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) => controller.apiCalled == false
          ? SkeletonListView(
              itemCount: 5,
            )
          : controller.notificationList.isEmpty
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.asset(
                          "assets/images/no-data.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: List.generate(
                      controller.notificationList.length,
                      (index) {
                        //   ListView.builder(
                        // itemCount: controller.notificationList.length,
                        // itemBuilder: (BuildContext context, int index) {
                          final reversedIndex =
          controller.notificationList.length - 1 - index;
                          final item = controller.notificationList[reversedIndex];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: ThemeProvider.whiteColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      ThemeProvider.blackColor.withOpacity(0.2),
                                  offset: const Offset(0, 1),
                                  blurRadius: 3),
                            ], // Set the border radius to make it rounded
                          ),
                          child: InkWell(
                            onTap: () async {
                              print("Tapped on item at index $index");
                              if (item.data != null && item.data != "null") {
                                print("Fetching event data");
                                Get.dialog(
                                    SimpleDialog(
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 30,
                                            ),
                                            const CircularProgressIndicator(
                                              color: ThemeProvider.appColor,
                                            ),
                                            const SizedBox(
                                              width: 30,
                                            ),
                                            SizedBox(
                                                child: Text(
                                              "Fetching event data".tr,
                                              style: const TextStyle(
                                                  fontFamily: 'bold'),
                                            )),
                                          ],
                                        )
                                      ],
                                    ),
                                    barrierDismissible: true);
                                final eventContractData = await controller
                                    .getEventContractById(item.data!);
                                Navigator.of(context).pop(true);
                                if (eventContractData != null) {
                                  print("Showing dialog...");
                                  Get.dialog(NewEventRequestDialog(
                                      notificationData: item));
                                } else {
                                  print("Event contract data is null");
                                }
                              }else{
                                 
                              Get.to(const PendingScreen());
                          
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          120,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(
                                            item.title.toString()),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        getStatusText(item.title.toString()),
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          controller
                                              .deletePushNotification(item.id!);
                                        },
                                        icon: Icon(Icons.cancel))
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        item.message.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}

Color getStatusColor(String title) {
  final trimmedTitle = title.trim().toLowerCase();
  print('Trimmed Title: $trimmedTitle');

  if (trimmedTitle.contains('pending')) {
    return Colors.yellow;
  } else if (trimmedTitle.contains('accepted')) {
    return Colors.black;
  } else if (trimmedTitle.contains('declined')) {
    return Colors.black;
  } else if (trimmedTitle.contains('You declined a contract from')) {
    return Colors.black;
  } else if (trimmedTitle.contains('has declined your contract!')) {
    return Colors.black;
  }else if (trimmedTitle.contains('You have accepted your contract!')) {
    return Colors.black;
  }else if (trimmedTitle.contains('You have accepted your contract!')) {
    return Colors.black;
  }else if (trimmedTitle.contains('is unavailable on')) {
    return Colors.black;
  }else if (trimmedTitle.contains('is negotiating your contact!')) {
    return Colors.green;
  }  else {
    return Colors.red;
  }
}
String getStatusText(String title) {
  String trimmedTitle = title.toLowerCase().trim();

  if (trimmedTitle.contains('accepted a contract')) {
    return 'Accepted';
  } else if (trimmedTitle.contains('has declined your contract!')) {
    return 'Declined';
  } else if (trimmedTitle.contains('is unavailable on')) {
    return 'Declined';
  }else if (trimmedTitle.contains('You declined a contract from')) {
    return 'Declined';
  }else if (trimmedTitle.contains('You have accepted your contract!')) {
    return 'Accepted';
  }else if (trimmedTitle.contains('new event request')) {
    return 'Waiting For Artist';
  } else if (trimmedTitle.contains('is negotiating your contact!')) {
    return 'Need your attention!';
  } else if (trimmedTitle.contains('accepted your date change!')) {
    return 'Need your attention!';
  }else if (trimmedTitle.contains('declined your date Change!')) {
    return 'Need your attention!';
  }else {
    return 'Waiting For Artist';
  }
}


