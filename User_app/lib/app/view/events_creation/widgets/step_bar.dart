import 'package:flutter/material.dart';
import 'package:app_user/app/util/theme.dart';

class StepBar extends StatelessWidget {
  final int currentStep;
  final Function(int) onStepSelected;

  const StepBar({
    super.key,
    required this.currentStep,
    required this.onStepSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color.fromARGB(0, 238, 238, 238),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          6,
          (index) {
            final stepNumber = index + 1;
            final isSelected = stepNumber == currentStep;
            return GestureDetector(
              onTap: () {
                onStepSelected(stepNumber);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? ThemeProvider.appColor : Colors.grey,
                ),
                child: Center(
                  child: Text(
                    stepNumber.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
