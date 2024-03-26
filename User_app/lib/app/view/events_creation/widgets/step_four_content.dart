import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/util/theme.dart';

//STEP FOUR
class StepFourContent extends StatelessWidget {
  const StepFourContent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventsCreationController>(builder: (controller) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Title
          Text(
            "Enter Fee".tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeProvider.appColor,
            ),
          ),

          // 2. Simple Input Field
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 20),
            child: TextField(
              controller: controller.feeController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
              ],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: Colors.white), // White text color
              decoration: InputDecoration(
                labelText: "",
                labelStyle: TextStyle(color: Colors.white), // White label text
                filled: true,
                fillColor: Colors.grey[800], // Dark grey background
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[800]!),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[800]!),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),

          // Text(
          //     "Select Payment Method ",
          //     style: TextStyle(
          //       fontSize: 20,
          //       fontWeight: FontWeight.bold,
          //       color: ThemeProvider.appColor,
          //     ),
          //   ),
          //   ...controller.paymentsM.map(
          //     (text) => Row(
          //       children: [
          //         Checkbox(
          //           value: controller.selectedPaymentMethod == text,
          //           onChanged: (value) => controller.selectPayment(text),
          //         ),
          //         Text(
          //           text,
          //           style: const TextStyle(
          //               fontSize: 20,
          //               fontFamily: 'bold',
          //               color: Color.fromARGB(255, 255, 255, 255)),
          //         ),
          //       ],
          //     ),
          //   ),

          // 3. Next Button (to move to the next step)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              onPressed:
                  //  controller.feeController.text != '' ?
                  () {
                controller.selectStep(5);
              }
              // : null
              ,
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
                child: Text("Next".tr),
              ),
            ),
          ),
        ],
      );
    });
  }
}
