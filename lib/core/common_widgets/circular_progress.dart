import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../theme/app_colors.dart';

class CircularProgressWidget extends StatelessWidget {
  final String label;
  final double percentage;
  final Color progressColor;
  const CircularProgressWidget({
    super.key,
    required this.label,
    required this.percentage,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final mobileWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: mobileWidth * 0.2,
          height: mobileWidth * 0.2,
          decoration: BoxDecoration(color: kWhite, shape: BoxShape.circle),
          child: Stack(
            children: [
              // Progress circular bar
              CircularStepProgressIndicator(
                totalSteps: 100,
                currentStep: percentage.round(),
                stepSize: mobileWidth * 0.02,
                selectedColor: progressColor.withValues(alpha: 0.9),
                unselectedColor: progressColor.withValues(alpha: 0.1),
                padding: 0,
                selectedStepSize: mobileWidth * 0.02,
                roundedCap: (_, __) => true,
              ),

              Center(
                child: Text(
                  '${percentage.toInt()}%',
                  style: Get.textTheme.titleLarge?.copyWith(
                    color: kBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Text(
            label,
            style: Get.textTheme.titleLarge?.copyWith(
              color: progressColor.withValues(alpha: 0.9),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
