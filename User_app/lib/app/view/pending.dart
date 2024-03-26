import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:app_user/app/controller/booking_controller.dart';
import 'package:app_user/app/env.dart';
import 'package:app_user/app/util/theme.dart';
import 'package:app_user/app/view/eventcontract_screen/widgets/new_event_request_dialog.dart';
import 'package:app_user/app/view/eventcontract_screen/widgets/new_event_request_pending.dart';
import 'package:skeletons/skeletons.dart';


class PendingScreen extends StatefulWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  bool status = false;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<BookingController>();

    if (controller.parser.haveLoggedIn() == true) {
      controller.getMyEventContracts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.backgroundColor2,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ThemeProvider.appColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
          title: Text(
            "PENDING",
            style: ThemeProvider.titleStyle,
          ),
          bottom: value.parser.haveLoggedIn() == true
              ? TabBar(
                  controller: value.tabController,
                  unselectedLabelColor: ThemeProvider.blackColor,
                  labelColor: ThemeProvider.whiteColor,
                  indicatorColor: ThemeProvider.whiteColor,
                  labelStyle: const TextStyle(
                      fontFamily: 'medium',
                      fontSize: 16,
                      color: ThemeProvider.whiteColor),
                  unselectedLabelStyle: const TextStyle(
                      fontFamily: 'medium',
                      fontSize: 16,
                      color: ThemeProvider.whiteColor),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: const EdgeInsets.all(8),
                  tabs: [
                    Text(
                      'Needs your Attention'.tr,
                      style: const TextStyle(color: ThemeProvider.whiteColor),
                    ),
                    Text(
                      'Waiting for Artist'.tr,
                      style: const TextStyle(color: ThemeProvider.whiteColor),
                    ),
                  ],
                )
              : null,
        ),
        body: value.parser.haveLoggedIn() == true
            ? value.apiCalled == false
                ? SkeletonListView()
                : TabBarView(
                    controller: value.tabController,
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: value.appointmentList.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(
                                      value.appointmentList.length, (index) {
                                    if (value.appointmentList[index].suggester ==
                                        "owner" && value.appointmentList[index].status == "pending")  {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                          color: ThemeProvider.whiteColor,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: ThemeProvider.blackColor
                                                    .withOpacity(0.2),
                                                offset: const Offset(0, 1),
                                                blurRadius: 3),
                                          ], // Set the border radius to make it rounded
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            Get.dialog(
                                                NewEventRequestDialogPending(
                                              eventContractData:
                                                  value.appointmentList[index],
                                            ));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [

                                               Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      value.appointmentList[index].musician.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                      //  fontFamily: "bold",
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "£ ${value.appointmentList[index].fee.toString()}",
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                     // fontFamily: "bold",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                               const SizedBox(height: 2),

                                              Row(
                                              children: [
                                               
                                                Text(
                                                  value.appointmentList[index].date != null
                                                    ? DateFormat('MMMM dd, yyyy').format(value.appointmentList[index].date!)
                                                    : '',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                
                                              ],
                                            ),

                                             const SizedBox(height: 10),
                                             
                                              // 2.6 Status
                                            Row(
                                             children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "STATUS: ".tr,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      //fontFamily: "bold",
                                                    ),
                                                  ),
                                                  Text(
                                                    value.appointmentList[index].status.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 18,
                                                     // fontFamily: "bold",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                Get.dialog(
                                                    NewEventRequestDialogPending(
                                                  eventContractData:
                                                      value.appointmentList[index],
                                                ));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: ThemeProvider.appColor, // Set the background color
                                              ),
                                              child: Text(
                                                "View",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                 // fontFamily: "bold",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                      
                                            ],
                                          ),
                                        ),
                                      );
                                    } else
                                      return Container();
                                  }),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/no-data.png',
                                          width: 60, height: 60),
                                      const SizedBox(height: 30),
                                      Text(
                                        'No New Notifications Found!'.tr,
                                        style: const TextStyle(
                                            fontFamily: 'bold',
                                            color: ThemeProvider.appColor),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: value.appointmentList.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(
                                      value.appointmentList.length, (index) {
                                    if (value.appointmentList[index].suggester ==
                                        "user" && value.appointmentList[index].status == "pending") {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                          color: ThemeProvider.whiteColor,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: ThemeProvider.blackColor
                                                    .withOpacity(0.2),
                                                offset: const Offset(0, 1),
                                                blurRadius: 3),
                                          ], // Set the border radius to make it rounded
                                        ),
                                         child: InkWell(
                                          onTap: () async {
                                            Get.dialog(
                                                NewEventRequestDialogPending(
                                              eventContractData:
                                                  value.appointmentList[index],
                                            ));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [

                                               Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      value.appointmentList[index].musician.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                     //   fontFamily: "bold",
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "£ ${value.appointmentList[index].fee.toString()}",
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                     // fontFamily: "bold",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                               const SizedBox(height: 2),

                                              Row(
                                              children: [
                                               
                                                Text(
                                                  value.appointmentList[index].date != null
                                                    ? DateFormat('MMMM dd, yyyy').format(value.appointmentList[index].date!)
                                                    : '',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                
                                              ],
                                            ),

                                             const SizedBox(height: 10),
                                             
                                              // 2.6 Status
                                            Row(
                                             children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "STATUS: ".tr,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                     // fontFamily: "bold",
                                                    ),
                                                  ),
                                                  Text(
                                                    value.appointmentList[index].status.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 18,
                                                     // fontFamily: "bold",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                Get.dialog(
                                                    NewEventRequestDialogPending(
                                                  eventContractData:
                                                      value.appointmentList[index],
                                                ));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: ThemeProvider.appColor, // Set the background color
                                              ),
                                              child: Text(
                                                "View",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                 // fontFamily: "bold",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                            ],
                                          ),
                                        ),
                                      );
                                    } else
                                      return Container();
                                  }),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/no-data.png',
                                          width: 60, height: 60),
                                      const SizedBox(height: 30),
                                      Text(
                                        'No New Notification Found!'.tr,
                                        style: const TextStyle(
                                            fontFamily: 'bold',
                                            color: ThemeProvider.appColor),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      // SingleChildScrollView(
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 10, vertical: 10),
                      //     child: value.appointmentListOld.isNotEmpty
                      //         ? Column(
                      //             children: List.generate(
                      //               value.appointmentListOld.length,
                      //               (index) => Container(
                      //                 padding: const EdgeInsets.symmetric(
                      //                     horizontal: 14, vertical: 8),
                      //                 margin: const EdgeInsets.symmetric(
                      //                     vertical: 8),
                      //                 decoration: BoxDecoration(
                      //                   color: ThemeProvider.whiteColor,
                      //                   borderRadius: const BorderRadius.all(
                      //                     Radius.circular(8),
                      //                   ),
                      //                   boxShadow: [
                      //                     BoxShadow(
                      //                         color: ThemeProvider.blackColor
                      //                             .withOpacity(0.2),
                      //                         offset: const Offset(0, 1),
                      //                         blurRadius: 3),
                      //                   ], // Set the border radius to make it rounded
                      //                 ),
                      //                 child: InkWell(
                      //                   onTap: () async {
                      //                     Get.dialog(NewEventRequestDialog(
                      //                         eventContractData: value
                      //                             .appointmentListOld[index]));
                      //                   },
                      //                   child: Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.stretch,
                      //                       children: [

                      //                          Row(
                      //                           children: [
                      //                             Expanded(
                      //                               child: Text(
                      //                                 value.appointmentListOld[index].venueName.toString(),
                      //                                 style: const TextStyle(
                      //                                   color: Colors.black,
                      //                                   fontSize: 18,
                      //                                   fontFamily: "bold",
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                             Text(
                      //                               "£ ${value.appointmentListOld[index].fee.toString()}",
                      //                               style: const TextStyle(
                      //                                 color: Colors.black,
                      //                                 fontSize: 18,
                      //                                 fontFamily: "bold",
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                          const SizedBox(height: 2),

                      //                         Row(
                      //                         children: [
                                               
                      //                           Text(
                      //                             value.appointmentListOld[index].date != null
                      //                               ? DateFormat('MMMM dd, yyyy').format(value.appointmentListOld[index].date!)
                      //                               : '',
                      //                             style: const TextStyle(
                      //                               color: Colors.grey,
                      //                               fontSize: 14
                      //                             ),
                      //                           ),
                      //                           const SizedBox(width: 10),
                                                
                      //                         ],
                      //                       ),

                      //                        const SizedBox(height: 10),
                                             
                      //                         // 2.6 Status
                      //                       Row(
                      //                        children: [
                      //                       Expanded(
                      //                         child: Column(
                      //                           crossAxisAlignment: CrossAxisAlignment.start,
                      //                           children: [
                      //                             Text(
                      //                               "STATUS: ".tr,
                      //                               style: const TextStyle(
                      //                                 color: Colors.black,
                      //                                 fontSize: 18,
                      //                                 fontFamily: "bold",
                      //                               ),
                      //                             ),
                      //                             Text(
                      //                               value.appointmentListOld[index].status.toString(),
                      //                               style: const TextStyle(
                      //                                 color: Colors.black,
                      //                                 fontSize: 18,
                      //                                 fontFamily: "bold",
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                       ElevatedButton(
                      //                         onPressed: () async {
                      //                           Get.dialog(NewEventRequestDialog(
                      //                         eventContractData: value
                      //                             .appointmentListOld[index]));
                      //                         },
                      //                         style: ElevatedButton.styleFrom(
                      //                           primary: ThemeProvider.appColor, // Set the background color
                      //                         ),
                      //                         child: Text(
                      //                           "View",
                      //                           style: TextStyle(
                      //                             color: Colors.white,
                      //                             fontSize: 18,
                      //                             fontFamily: "bold",
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                       ],
                      //                     ),
                      //                 ),
                      //               ),
                      //             ),
                      //           )
                      //         : Center(
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: [
                      //                 Image.asset('assets/images/no-data.png',
                      //                     width: 60, height: 60),
                      //                 const SizedBox(height: 30),
                      //                 Text(
                      //                   'No Past Appointment Found!'.tr,
                      //                   style: const TextStyle(
                      //                       fontFamily: 'bold',
                      //                       color: ThemeProvider.appColor),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //   ),
                      // ),
                    ],
                  )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/no-data.png',
                        width: 60, height: 60),
                    const SizedBox(height: 30),
                    TextButton(
                        onPressed: () {
                          value.onLoginRoutes();
                        },
                        child: Text(
                          'Opps, Please Login or Register first!'.tr,
                          style: const TextStyle(
                              fontFamily: 'bold',
                              color: ThemeProvider.appColor),
                        )),
                  ],
                ),
              ),
      );
    });
  }
}
