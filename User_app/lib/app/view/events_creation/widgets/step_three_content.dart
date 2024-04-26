import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/controller/services_controller.dart';
import 'package:app_user/app/controller/specialist_controller.dart';
import 'package:app_user/app/util/theme.dart';

//STEP THREE
class StepThreeContent extends StatelessWidget {
  const StepThreeContent({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventsCreationController>(builder: (controller) {
      bool isSpecialist = controller.isSpecialist;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Title
          Text(
            "Band Size".tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeProvider.appColor,
            ),
          ),

          // 2. Dropdown
          // Container(
          //   margin: const EdgeInsets.symmetric(vertical: 20),
          //   child: DropdownButton<String>(
          //     value: controller.selectedBrandSize,
          //     onChanged: (String? newValue) {
          //       // No need for setState here for the UI styling
          //       controller.selectedBrandSize = newValue ?? '';
          //     },
          //     style: const TextStyle(color: Colors.white), // White text color
          //     items: controller.brandSizeList
          //         .map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(
          //           value,
          //           style: const TextStyle(
          //               color: Colors.white), // White text color
          //         ),
          //       );
          //     }).toList(),
          //     dropdownColor: Colors.grey[800], // Dark grey background color
          //     icon: const Icon(Icons.arrow_drop_down,
          //         color: Colors.white), // White dropdown icon
          //     underline: Container(), // Remove the underline
          //   ),
          // ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: DropdownButton<String>(
                value: controller.selectedBrandSize,
                onChanged: (String? newValue) {
                  // No need for setState here for the UI styling
                  controller.selectBrands(newValue ?? '');
                },
                style: const TextStyle(color: Colors.white),
                items: controller.isSpecialist
                    ? ['solo', 'DJ']
                        .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        })
                        .toList()
                    : ['solo', 'duo', 'trio', 'quartet or higher']
                        .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        })
                        .toList(),
                dropdownColor: Colors.grey[800],
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                underline: Container(),
              ),
            ),


          // 3. Next Button (to move to the next step)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              onPressed: controller.selectedBrandSize != ''
                  ? () {
                      controller.selectStep(4);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeProvider.appColor,
                foregroundColor: ThemeProvider.whiteColor,
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
