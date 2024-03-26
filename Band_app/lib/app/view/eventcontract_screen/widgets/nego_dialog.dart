import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_band_owner_flutter/app/backend/models/event_contract_model.dart';
import 'package:ultimate_band_owner_flutter/app/controller/appointment_controller.dart';
import 'package:ultimate_band_owner_flutter/app/util/theme.dart';

class NegoDialog extends StatelessWidget {
  final EventContractModel eventContractData;
  const NegoDialog({super.key, required this.eventContractData});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentController>(
      builder: (controller) {
        return Material(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width *
                  .85, // Adjust the width as needed
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the popup
                borderRadius: BorderRadius.circular(10),
                // image: DecorationImage(
                //   image: AssetImage('your_image_path.png'), // Background image
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon(
                  //   Icons.event, // Icon at the center
                  //   size: 34,
                  //   color: Colors.black, // Icon color
                  // ),
                  // Text(
                  //   "Nego", // Title at the center
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  Text(
                    "Notes", // Title at the center
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    textInputAction: TextInputAction.done,
                    controller: controller.infoTextEditor,
                    maxLines: 5,
                    minLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ThemeProvider.whiteColor,
                      hintText: 'Add some notes if you needed..'.tr,
                      contentPadding: const EdgeInsets.only(
                          bottom: 8.0, top: 14.0, left: 10),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ThemeProvider.appColor),
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ThemeProvider.greyColor)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "New price", // Title at the center
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: controller.priceTextEditor,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ThemeProvider.whiteColor,
                      hintText: 'Add new price is mandatory'.tr,
                      contentPadding: const EdgeInsets.only(
                          bottom: 8.0, top: 14.0, left: 10),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ThemeProvider.appColor),
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ThemeProvider.greyColor)),
                    ),
                  ),
                  SizedBox(height: 10),
                  
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Add space between buttons
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // controller.updateEventContractStatusById('decline');
                          Navigator.of(context).pop(); // Close the popup
                        },
                        child: Text("Back"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded buttons
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          double newFee = double.tryParse(controller.priceTextEditor.text) ?? 0.0;
                          controller.onNegoSubmit(eventContractData, newFee);
                          Navigator.of(context).pop();
                          // controller.updateEventContractStatusById('accepted');
                          // Perform your desired action
                          // For example, you can navigate to another screen.
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnotherScreen()));
                        },
                        child: Text("Submit"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded buttons
                          ),
                        ),
                      ),
                    ],
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
