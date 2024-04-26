import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/event_contract_model.dart';
import 'package:ultimate_band_owner_flutter/app/controller/appointment_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/notification_screen_controller.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';
import 'package:ultimate_band_owner_flutter/app/view/notification_screen/widgets/notification_list_widget.dart';
import './nego_dialog.dart';

class NewEventRequestDialogPending extends StatelessWidget {
  final EventContractModel eventContractData;
  const NewEventRequestDialogPending(
      {super.key, required this.eventContractData});

  // @override
  // void initState() {
  //   super.initState();
//
  //   _selectedDay = _focusedDay;
  //   final kEventSource = {
  //     for (final item in controller.savedEventContractsList)
  //       item.date!: [
  //         "Data Selection (${DateFormat.yMMMMEEEEd().format(item.date!)}, ${item.time})"
  //       ]
  //   };
  //   // if (controller.selectedDay != null) {
  //   //   kEventSource.addAll({
  //   //     controller.selectedDay!: [
  //   //       "Data Selection (${DateFormat.yMMMMEEEEd().format(controller.selectedDay!)} ${controller.selectedTime})"
  //   //     ],
  //   //   });
  //   // }

  //   eventsList = LinkedHashMap<DateTime, List<String>>(
  //     equals: isSameDay,
  //     hashCode: getHashCode,
  //   )..addAll(kEventSource);

  //   _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  // }

   double calculateAgencyFee(double fee) {
    if (fee >= 1 && fee <= 299) {
      return 25;
    } else {
      return fee * 0.1; // 10% of the fee
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentController>(
      builder: (controller) {
          String timeoneString = eventContractData!.date != null
    ? DateFormat('HH:mm').format(eventContractData!.date!)
    : '';
    

double timeone = timeoneString.isNotEmpty
    ? double.parse(timeoneString.split(':')[0]) + double.parse(timeoneString.split(':')[1]) / 60
    : 0.0;

    // Ensure the resulting time doesn't go below 0:00
timeone = timeone - 1.00 < 0.0 ? 0.0 : timeone - 1.00;

// Convert the result back to HH:mm format using only floating-point division
String resultTime = '${(timeone.floor()).toString().padLeft(2, '0')}:${((timeone % 1) * 60).toInt().toString().padLeft(2, '0')}';
double fee = double.parse(eventContractData!.fee.toString());
    double agencyFee = calculateAgencyFee(fee);
        return Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width *
                  .85, // Adjust the width as needed
              padding: EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //   color: Colors.white, // Background color of the popup
              //   // borderRadius: BorderRadius.circular(10),
              //   // image: DecorationImage(
              //   //   image: AssetImage('your_image_path.png'), // Background image
              //   //   fit: BoxFit.cover,
              //   // ),
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the popup
                        },
                      ),
                    ],
                  ),

                  Text(
                    "Contract", // Title at the center
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       child: Container(
                  //         padding:
                  //             EdgeInsets.all(8), // Adjust padding as needed
                  //         decoration: BoxDecoration(
                  //           color:
                  //               Colors.grey[800], // Dark gray background color
                  //           borderRadius: BorderRadius.circular(
                  //               10), // Adjust the radius as needed
                  //         ),
                  //         child: Text(
                  //           "Soulaunge is happy to announce you recivew a new contract from a venue respond fast.",
                  //           style: TextStyle(
                  //             color: const Color.fromARGB(255, 255, 255, 255),
                  //             fontSize: 16, // Adjust the font size as needed
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     // Add other widgets if needed
                  //   ],
                  // ),
                  SizedBox(height: 20),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Icon(
                            //   Icons.supervised_user_circle,
                            //   color: Colors.white,
                            //   size: 16, // White icon
                            // ),
                            SizedBox(width: 10),
                            Text(
                              "Venue", // Add your bigger title here
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20, // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Text(
                         eventContractData.nameVenue.toString(),
                          style: TextStyle(
                            color: ThemeProvider.orangeColor,
                            fontFamily: 'bold',
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Other widgets...
                  ],
                ),

                SizedBox(height: 20),
                  // 1.0 Venue Contact
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Icon(
                            //   Icons.contact_page,
                            //   color: Colors.white,
                            //   size: 16, // White icon
                            // ),
                            SizedBox(width: 10),
                            Text(
                              "Venue Contact", // Add your bigger title here
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20, // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Text(
                          eventContractData.venueMobile.toString(),
                          style: TextStyle(
                            color: ThemeProvider.orangeColor,
                            fontFamily: 'bold',
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Other widgets...
                  ],
                ),

                SizedBox(height: 20),
                  // 1.0 Venue Contact
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Icon(
                            //   Icons.edit_road_sharp,
                            //   color: Colors.white,
                            //   size: 16, // White icon
                            // ),
                            SizedBox(width: 10),
                            Text(
                              "Venue Address", // Add your bigger title here
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20, // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                         Expanded(
                       child: Text(
                          eventContractData.addressVenue.toString(),
                          style: TextStyle(
                            color: ThemeProvider.orangeColor,
                            fontFamily: 'bold',
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                           textAlign: TextAlign.right,
                        ),
                         )
                      ],
                    ),
                    SizedBox(height: 10),
                    // Other widgets...
                  ],
                ),

                  SizedBox(height: 20),
                  // 2.1 Date and Time
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Icon(
                            //   Icons.calendar_today,
                            //   color: Colors.white,
                            //   size: 16, // White icon
                            // ),
                            SizedBox(width: 10),
                            Text(
                              "Performance Date", // Add your bigger title here
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20, // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Text(
                          eventContractData.date != null
                              ? DateFormat('MMMM d, y').format(eventContractData.date!)
                              : '',
                          style: TextStyle(
                            color: ThemeProvider.orangeColor,
                            fontFamily: 'bold',
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Other widgets...
                  ],
                ),


                SizedBox(height: 20),
                  // 1.0 Musician Name
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Icon(
                            //   Icons.contact_page,
                            //   color: Colors.white,
                            //   size: 16, // White icon
                            // ),
                            SizedBox(width: 10),
                            Text(
                              "Musician", // Add your bigger title here
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20, // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Text(
                          eventContractData.musician.toString(),
                          style: TextStyle(
                            color: ThemeProvider.orangeColor,
                            fontFamily: 'bold',
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Other widgets...
                  ],
                ),


                  SizedBox(height: 20),
                  // 2.2 Minutes
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            // Icon(
                            //   Icons.timer,
                            //   color: Colors.white,
                            //   size: 16,
                            // ),
                            SizedBox(width: 10),
                            Text(
                              "Set Time(s)",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Text(
                          "${timeoneString}  /",
                          style: const TextStyle(
                            color: ThemeProvider.orangeColor,
                            fontFamily: 'bold',
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          eventContractData.time.toString(),
                          style: const TextStyle(
                            color: ThemeProvider.orangeColor,
                            fontFamily: 'bold',
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Other widgets...
                  ],
                ),

                  SizedBox(height: 20),
                  // 2.2 Minutes
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                "Band Size",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Text(
                            eventContractData.bandSize.toString(),
                            style: const TextStyle(
                              color: ThemeProvider.orangeColor,
                              fontFamily: 'bold',
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Other widgets...
                    ],
                  ),

                  SizedBox(height: 20),

                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Text(
                              "Sound Check", // Add your bigger title here
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20, // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                         Text(
                        resultTime, // Convert the result back to String for Text widget
                        style: TextStyle(
                          color: ThemeProvider.orangeColor,
                          fontFamily: 'bold',
                          fontSize: 14,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Other widgets...
                  ],
                ),


                  SizedBox(height: 20),
                  // 2.4 Fees
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Icon(
                            //   Icons.attach_money,
                            //   color: Colors.white,
                            //   size: 16, // White icon
                            // ),
                            SizedBox(width: 10),
                            Text(
                              "Price", // Add your bigger title here
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20, // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Text(
                          '£ ${eventContractData.fee.toString()}',
                          style: TextStyle(
                            color: ThemeProvider.orangeColor,
                            fontFamily: 'bold',
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Adjust the height as needed
                    // Other widgets...
                  ],
                ),

                SizedBox(height: 20),
                  // 2.4 Fees
                   Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Icon(
                            //   Icons.attach_money,
                            //   color: Colors.white,
                            //   size: 16, // White icon
                            // ),
                            SizedBox(width: 10),
                            Text(
                              "Agency Fee", // Add your bigger title here
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20, // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Text(
                          '£ ${agencyFee.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: ThemeProvider.orangeColor,
                            fontFamily: 'bold',
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Adjust the height as needed
                    // Other widgets...
                  ],
                ),

                 SizedBox(height: 20),
                  // 2.4 Fees
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Icon(
                            //   Icons.attach_money,
                            //   color: Colors.white,
                            //   size: 16, // White icon
                            // ),
                            SizedBox(width: 10),
                            Text(
                              "Payment Method", // Add your bigger title here
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20, // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Text(
                          eventContractData.paymentMethod.toString(),
                          style: TextStyle(
                            color: ThemeProvider.orangeColor,
                            fontFamily: 'bold',
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Adjust the height as needed
                    // Other widgets...
                  ],
                ),

                  SizedBox(height: 20),

                  // 2.5 Info
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(), // Divider on top
                    Row(
                      children: [
                        // Icon(
                        //   Icons.description,
                        //   color: Colors.white,
                        //   size: 16, // White icon
                        // ),
                        SizedBox(width: 10),
                        Text(
                          "Notes", // Add your bigger title here
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20, // Adjust the font size as needed
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Adjust the height as needed

                    Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          "Info: ".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .85 - 100,
                          child: Text(
                            eventContractData.extraField.toString(),
                            style: TextStyle(
                              color: ThemeProvider.orangeColor,
                              fontFamily: 'bold',
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Adjust the height as needed
                    Divider(), // Divider on bottom
                  ],
                ),


                  SizedBox(height: 10),
                  // 2.6 Status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Icon(
                          //   Icons.policy,
                          //   color: Colors.white,
                          //   size: 16, // White icon
                          // ),
                          SizedBox(width: 10),
                          Text(
                            "Status", // Add your bigger title here
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20, // Adjust the font size as needed
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10), // Adjust the height as needed

                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            "Status: ".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            eventContractData.status.toString(),
                            style: TextStyle(
                              color: ThemeProvider.orangeColor,
                              fontFamily: 'bold',
                              fontSize: 14,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                  //HISTORY SECTION
                  SizedBox(height: 40),
                  Row(
                    children: [
                      // Icon(
                      //   Icons.history,
                      //   color: Colors.white,
                      //   size: 16, // White icon
                      // ),
                      SizedBox(width: 10),
                      Text(
                        "HISTORY", // Add your bigger title here
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20, // Adjust the font size as needed
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 20),

                  // Add here
                  SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 25.0,
                      runSpacing: 50.0,
                      children: eventContractData.bodys!.split("/n").map((body) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   width: 20,
                            //   height: 20,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: Colors.white,
                            //   ),
                            // ),
                            SizedBox(width: 50),
                            Container(
                              constraints: BoxConstraints(maxWidth: 200), // Adjust the maxWidth as needed
                              child: Text(
                                body.trim(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),



                   
                  //         Row(
                  //           children: [
                  //             Icon(
                  //               Icons.money_outlined,
                  //               color: Colors.black,
                  //               size: 16, // White icon
                  //             ),
                  //             SizedBox(width: 10),
                  //             Text(
                  //               "Final Price ", // Add your bigger title here
                  //               style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 20, // Adjust the font size as needed
                  //                 fontWeight: FontWeight.bold,
                  //                 decoration: TextDecoration.none,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         Text(
                  //           "Contract Price ${eventContractData.fee.toString()}",
                  //           style: TextStyle(
                  //             color: ThemeProvider.appColor,
                  //             fontFamily: 'semibold',
                  //             fontSize: 20,
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //         Text(
                  //           "App commission -20",
                  //           style: TextStyle(
                  //             color: ThemeProvider.appColor,
                  //             fontFamily: 'semibold',
                  //             fontSize: 20,
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),
                  //          SizedBox(width: 5), 
                  //          Divider(
                  //           color: ThemeProvider.appColor, // Change the color as needed
                  //           height: 15, // Adjust the height of the line as needed
                  //         ),
                  //         Text(
                  //           (eventContractData.fee! - 20).toString(),
                  //           style: TextStyle(
                  //             color: ThemeProvider.appColor,
                  //             fontFamily: 'bold',
                  //             fontSize: 25,
                  //             decoration: TextDecoration.none,
                  //           ),
                  //         ),

                  SizedBox(height: 50),
                  Visibility(
                    visible: eventContractData.status != 'Deleted' &&
                        eventContractData.suggester == 'user',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Add space between buttons
                      children: [
                        Visibility(
                          visible: eventContractData.status == 'pending',
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the popup
                             
                              controller.updateEventContractStatus(
                                  eventContractData, 'Accepted');
                                  controller.onAcceptContract(eventContractData);
                                   controller.onChat(eventContractData);
                            },
                            child: Text("Accept"),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Rounded buttons
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: eventContractData.status != 'Deleted' &&
                              (eventContractData.status == 'pending' ||
                                  eventContractData.status != 'Accepted'),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.dialog(NegoDialog(eventContractData: eventContractData));
                              // controller.updateEventContractStatusById('decline');
                              // Navigator.of(context).pop(); // Close the popup
                            },
                            child: Text("Negotiate"),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Rounded buttons
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: eventContractData.status == 'pending',
                          child: ElevatedButton(
                            onPressed: eventContractData.status != 'Declined'
                                ? () {
                                    Navigator.of(context).pop();
                                    controller.updateEventContractStatus(
                                        eventContractData, 'Declined');
                                        controller.onDeclineContract(eventContractData);
                                         controller.onChat(eventContractData);
                                                                            // Perform your desired action
                                    // For example, you can navigate to another screen.
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnotherScreen()));
                                  }
                                : null,
                            child: Text("Decline"),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Rounded buttons
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
