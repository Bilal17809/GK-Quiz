import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../core/constant/constant.dart';
import '../../../core/models/questions_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../quiz/widgets/quiz_card.dart';
import '../controller/country_quiz_controller.dart';

class CountryQuizPage extends StatelessWidget {
  final QuestionsModel question;
  final int currentIndex;
  final int totalQuestions;
  final CountryQuizController controller;
  final Size mobileSize;
  final int topicIndex;
  final String topic;
  final Function(int, String) onAnswerSelected;

  const CountryQuizPage({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.controller,
    required this.mobileSize,
    required this.onAnswerSelected,
    required this.topicIndex,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: mobileSize.height * 0.35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: kTealGreen1,
          ),
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              // Question card
              Positioned(
                top: mobileSize.height * 0.25,
                left: mobileSize.width * 0.05,
                right: mobileSize.width * 0.05,
                child: Container(
                  height: mobileSize.height * 0.30,

                  decoration: roundedDecoration.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: kWhite,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          question.question,
                          textAlign: TextAlign.start,
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: kBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Circular progress indicator
              Positioned(
                top: mobileSize.height * 0.17,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: mobileSize.width * 0.35,
                    height: mobileSize.width * 0.35,
                    decoration: BoxDecoration(
                      color: kWhite,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: greyBorderColor.withValues(alpha: 0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CircularStepProgressIndicator(
                            totalSteps: 100,
                            currentStep:
                                ((currentIndex + 1) / totalQuestions * 100)
                                    .toInt(),
                            stepSize: mobileSize.width * 0.02,
                            selectedColor: kTealGreen1.withValues(alpha: 0.9),
                            unselectedColor: greyBorderColor.withAlpha(25),
                            padding: 0,
                            width: mobileSize.width * 0.35,
                            height: mobileSize.width * 0.35,
                            selectedStepSize: mobileSize.width * 0.02,
                            roundedCap: (_, __) => true,
                          ),
                        ),
                        Center(
                          child: Text(
                            '${currentIndex + 1}', // Use currentIndex instead of reactive value
                            style: Get.textTheme.displayMedium?.copyWith(
                              color: kTealGreen1.withValues(alpha: 0.9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Title
              Positioned(
                top: mobileSize.height * 0.1,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    '$topic - Level $topicIndex',
                    style: Get.textTheme.titleLarge?.copyWith(
                      color: kWhite,
                      shadows: [
                        Shadow(
                          color: kBlack.withValues(alpha: 0.07),
                          offset: Offset(3, 3),
                          blurRadius: 2,
                        ),
                      ],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: mobileSize.height * 0.15),
        Padding(
          padding: const EdgeInsets.all(kBodyHp),
          child: Card(
            elevation: 0,
            color: kWhite,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => QuestionOptions(
                  question: question,
                  showAnswer:
                      controller.shouldShowAnswerResults[currentIndex] ?? false,
                  selectedOption: controller.selectedAnswers[currentIndex],
                  onOptionSelected:
                      (option) => onAnswerSelected(currentIndex, option),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
