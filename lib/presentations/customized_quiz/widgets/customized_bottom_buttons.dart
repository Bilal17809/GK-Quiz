import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/elongated_button.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/presentations/customized_quiz/controller/cutomized_quiz_controller.dart';

class CustomizedBottomButtons extends StatelessWidget {
  final double height;
  final double width;
  final int currentIndex;
  final int totalQuestions;

  const CustomizedBottomButtons({
    super.key,
    required this.height,
    required this.width,
    required this.currentIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomizedQuizController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElongatedButton(
          height: height * 0.06,
          width: width * 0.38,
          color: skyColor,
          borderRadius: BorderRadius.circular(25),
          onTap: controller.use5050Hint,
          child: Text(
            '50:50',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 15),
        ElongatedButton(
          height: height * 0.06,
          width: width * 0.38,
          color: kViolet,
          borderRadius: BorderRadius.circular(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: controller.goToPreviousQuestion,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Image.asset(
                    'assets/images/back.png',
                    color: kWhite,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
              Text(
                '${currentIndex + 1}',
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: kWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: controller.goToNextQuestion,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Image.asset(
                    'assets/images/next.png',
                    color: kWhite,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
