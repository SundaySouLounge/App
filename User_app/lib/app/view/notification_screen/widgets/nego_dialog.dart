import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:app_user/app/controller/notification_screen_controller.dart';
import 'package:app_user/app/util/theme.dart';

class NegoDialog extends StatelessWidget {
  const NegoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return Dialog.fullscreen(
          child: Center(
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
                  SizedBox(height: 20),
                  Text(
                    "Negotiation", // Title at the center
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   SizedBox(height: 10),
                  
                  TextField(
                    controller: controller.infoTextEditor,
                    textInputAction: TextInputAction.done,
                    maxLines: 5,
                    minLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ThemeProvider.whiteColor,
                      hintText: 'Add some notes here if needed...'.tr,
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
                  TextField(
                    controller: controller.priceTextEditor,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ThemeProvider.whiteColor,
                      hintText: 'Add a new price mandatory'.tr,
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
                          Navigator.of(context).pop();
                          double newFee = double.tryParse(controller.priceTextEditor.text) ?? 0.0;
                          controller.onNegoSubmit(newFee);
                          controller.update(); 
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
