import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:app_user/app/controller/edit_profile_controller.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/util/theme.dart';

//STEP SIX
class StepSixContent extends StatelessWidget {
  const StepSixContent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventsCreationController>(builder: (controller) {
      String venueName = Get.find<EditProfileController>().getVenueName();
      String venueAddress = Get.find<EditProfileController>().getVenueAddress();
      String mobile = Get.find<EditProfileController>().getMobile();
      String paymentMeths = Get.find<EditProfileController>().getPayment();
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Title
          Text(
            "SUMMARY".tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeProvider.appColor,
            ),
          ),

          // 2. Summary Box
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey[800], // Dark grey background
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                // 2.1 Date and Time
                Row(
                  children: [
                    // const Icon(
                    //   Icons.verified_user_sharp,
                    //   color: Colors.white, // White icon
                    // ),
                    Text(
                      "Venue Name: ".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      venueName,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                 SizedBox(height: 10,),
                 Row(
                  children: [
                    // const Icon(
                    //   Icons.add_road,
                    //   color: Colors.white, // White icon
                    // ),
                    Text(
                      "Venue Address: ".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      venueAddress,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                 Row(
                  children: [
                    // const Icon(
                    //   Icons.phone,
                    //   color: Colors.white, // White icon
                    // ),
                    Text(
                      "Venue Mobile: ".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      mobile,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                 SizedBox(height: 10,),
                Row(
                  children: [
                    // const Icon(
                    //   Icons.calendar_today,
                    //   color: Colors.white, // White icon
                    // ),
                    Text(
                      "Date and Time: ".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                    controller.selectedDay != null
                        ? "${DateFormat('d MMMM').format(controller.selectedDay!)} / ${DateFormat('jm').format(controller.selectedDay!)}"
                        : '',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  ],
                ),
 SizedBox(height: 10,),
                // 2.2 Minutes
                Row(
                  children: [
                    // const Icon(
                    //   Icons.timer,
                    //   color: Colors.white, // White icon
                    // ),
                    Text(
                      "Minutes: ".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      controller.selectedTime,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
 SizedBox(height: 10,),
                // 2.3 Band Size
                Row(
                  children: [
                    // const Icon(
                    //   Icons.people,
                    //   color: Colors.white, // White icon
                    // ),
                    Text(
                      "Band Size: ".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      controller.selectedBrandSize,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
 SizedBox(height: 10,),
                // 2.4 Fees
                Row(
                  children: [
                    // const Icon(
                    //   Icons.attach_money,
                    //   color: Colors.white, // White icon
                    // ),
                    Text(
                      "Fees: ".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      controller.feeController.text,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                // 2.5 Info
                Row(
                  children: [
                    // const Icon(
                    //   Icons.description,
                    //   color: Colors.white, // White icon
                    // ),
                    Text(
                      "Info: ".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      controller.extraFieldController.text,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                  SizedBox(height: 10,),
                Row(
                  children: [
                    // const Icon(
                    //   Icons.verified_user_sharp,
                    //   color: Colors.white, // White icon
                    // ),
                    Text(
                      "Payment Method ".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      paymentMeths,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                 SizedBox(height: 10,),
              ],
            ),
          ),

          // 3. Confirm Button
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              onPressed: controller.selectedDay != null &&
                      controller.selectedTime != '' &&
                      controller.selectedBrandSize != '' &&
                      controller.feeController.text != ''
                  ? () {
                    controller.setVenueDetails(venueName, venueAddress, mobile, paymentMeths);
                      controller.onSubmit();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeProvider.appColor,
                disabledBackgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded button
                ),
                elevation: 5, // Shadow
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Submit Event Application".tr),
              ),
            ),
          ),
        ],
      );
    });
  }
}
