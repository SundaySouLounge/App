import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:app_user/app/controller/events_creation_controller.dart';
import 'package:app_user/app/controller/notification_screen_controller.dart';
import 'package:app_user/app/helper/router.dart';
import 'package:app_user/app/util/theme.dart';
import './widgets/step_bar.dart';
import './widgets/step_one_content.dart';
import './widgets/step_two_content.dart';
import './widgets/step_three_content.dart';
import './widgets/step_four_content.dart';
import './widgets/step_five_content.dart';
import './widgets/step_six_content.dart';

class EventsCreationScreen extends StatelessWidget {
  const EventsCreationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventsCreationController>(builder: (controller) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          backgroundColor: ThemeProvider.appColor,
          title: Text("Events Creation".tr),
          centerTitle: true,
        ),
        body: controller.apiCalled == false
            ? const Center(
                child: CircularProgressIndicator(color: ThemeProvider.appColor),
              )
            : Column(
                children: [
                  StepBar(
                    currentStep: controller.currentStep,
                    onStepSelected: controller.selectStep,
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        switch (controller.currentStep) {
                          case 1:
                            return StepOneContent();
                          case 2:
                            return StepTwoContent();
                          case 3:
                            return StepThreeContent();
                          case 4:
                            return StepFourContent();
                          case 5:
                            return StepFiveContent();
                          case 6:
                            return StepSixContent();
                          default:
                            return Center(
                                child: Text(
                                    "Step ${controller.currentStep} Content"));
                        }
                      },
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
