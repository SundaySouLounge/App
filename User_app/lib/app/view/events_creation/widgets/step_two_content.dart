import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/util/theme.dart';

//STEP TWO
class StepTwoContent extends StatelessWidget {
  const StepTwoContent({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventsCreationController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Checkbox with Text
            Text(
              "Select Time ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ThemeProvider.appColor,
              ),
            ),
            ...controller.setTimeList.map(
              (text) => Row(
                children: [
                  Checkbox(
                    value: controller.selectedTime == text,
                    onChanged: (value) => controller.selectTime(text),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'bold',
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ],
              ),
            ),

            // 4. Next Button (to move to the next step)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: controller.selectedTime != ''
                    ? () {
                        controller.selectStep(3);
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
                  child: Text("Next"),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
