import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/event_contract_model.dart';
import 'package:ultimate_band_owner_flutter/app/controller/appointment_controller.dart';
import 'package:ultimate_band_owner_flutter/app/controller/notification_screen_controller.dart';
import 'package:ultimate_band_owner_flutter/app/util/toast.dart';


class DateChangeDialog extends StatelessWidget {
  final EventContractModel eventContractData;

  // Add a default value (null in this case) to the named parameter
  const DateChangeDialog({Key? key, required this.eventContractData})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentController>(
      builder: (controller) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width *
                .85, // Adjust the width as needed
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the popup
              borderRadius: BorderRadius.circular(10),

            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.event, // Icon at the center
                  size: 34,
                  color: Colors.black, // Icon color
                ),
                Text(
                  "The event date has been modified", // Title at the center
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none, 
                  ),
                ),
                SizedBox(height: 20),
               
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Colors.black, size: 16 // White icon
                        ),
                    const SizedBox(width: 10),
                    Text(
                      "Date: ".tr,
                      style: const TextStyle(color: Colors.black, fontSize: 14, decoration: TextDecoration.none, ),
                    ),
                   Text(
                    eventContractData!.date != null
                        ? DateFormat('EEEE dd/MM/yyyy').format(eventContractData!.date!)
                        : '',
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  ],
                ),


                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                    onPressed: () async {
                      // Call the onAcceptSubmit function from NotificationController
                      await Get.find<NotificationController>().onAcceptSubmit();
                      Navigator.of(context).pop(); // Close the popup
                       successToast("Request Accepted");
                    },
                    child: Text("Accept"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: eventContractData!.status != 'Declined'
                        ? () async {
                            // Call the onDeclineSubmit function from NotificationController
                            await Get.find<NotificationController>().onDeclineSubmit();
                            Navigator.of(context).pop(); // Close the popup
                            showToast("Request Declined");
                          }
                        : null,
                    child: Text("Decline"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
