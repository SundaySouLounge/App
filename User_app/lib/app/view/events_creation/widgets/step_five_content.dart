import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/util/theme.dart';

//STEP FIVE
class StepFiveContent extends StatelessWidget {
  const StepFiveContent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventsCreationController>(builder: (controller) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Title
          Text(
            "Anything else you'd like to add?".tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeProvider.appColor,
            ),
          ),

          // 2. Text Input Field
          Container(
            padding: const EdgeInsets.all(10), // Add padding of 10
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: TextField(
              maxLines: 4, // Allows multiple lines of text
              controller: controller.extraFieldController,
              style: const TextStyle(color: Colors.white), // White text color
              decoration: InputDecoration(
                labelText: "",
                filled: true,
                fillColor: Colors.grey[800], // Dark grey background
                labelStyle:
                    const TextStyle(color: Colors.white), // White label text
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

          // 3. Next Button (to move to the next step)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              onPressed:
                  // controller.extraFieldController.text != ''?
                  () {
                controller.selectStep(6);
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
