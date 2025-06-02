import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:template/presentations/country_quiz/controller/country_quiz_controller.dart';

import '../../../core/constant/constant.dart';
import '../../../core/models/questions_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../quiz/view/ui_helpers.dart';

class CountryQuizScreen extends StatelessWidget {
  const CountryQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileSize = MediaQuery.of(context).size;
    final arguments = Get.arguments as Map<String, dynamic>;
    final String topic = arguments['topic'] ?? '';
    final int topicIndex = arguments['topicIndex'] ?? arguments['index'] ?? 1;
    final int categoryIndex = arguments['categoryIndex'] ?? 1;

    final CountryQuizController countryQuizController = Get.put(
      CountryQuizController(),
    );

    // Update controller arguments
    countryQuizController.updateArguments({
      'topic': topic,
      'topicIndex': topicIndex,
      'categoryIndex': categoryIndex,
    });

    countryQuizController.loadQuestionsForCategory(topic, categoryIndex);
    return Scaffold(
      body: Obx(() {
        if (countryQuizController.isLoadingQuestions.value) {
          return Center(child: CircularProgressIndicator());
        }
        return PageView.builder(
          itemCount: countryQuizController.questionsList.length,
          itemBuilder: (context, pageIndex) {
            final question = countryQuizController.questionsList[pageIndex];

            return CountryQuizPage(
              question: question,
              currentIndex: pageIndex,
              totalQuestions: countryQuizController.questionsList.length,
              controller: countryQuizController,
              mobileSize: mobileSize,
            );
          },
        );
      }),
    );
  }
}

class CountryQuizPage extends StatelessWidget {
  final QuestionsModel question;
  final int currentIndex;
  final int totalQuestions;
  final CountryQuizController controller;
  final Size mobileSize;
  const CountryQuizPage({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.controller,
    required this.mobileSize,
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
              // Background card
              Positioned(
                top: mobileSize.height * 0.25,
                left: mobileSize.width * 0.05,
                right: mobileSize.width * 0.05,
                child: Container(
                  height: mobileSize.height * 0.25,
                  width: mobileSize.width * 0.9,
                  decoration: roundedDecoration.copyWith(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: kWhite,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          question.question,
                          textAlign: TextAlign.center,
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
                        // Progress circular bar
                        Positioned.fill(
                          child: Obx(
                            () => CircularStepProgressIndicator(
                              totalSteps: 100,
                              currentStep:
                                  ((currentIndex + 1) /
                                          controller.questionsList.length *
                                          100)
                                      .toInt(),

                              stepSize: mobileSize.width * 0.02,
                              selectedColor: kCoral,
                              unselectedColor: greyBorderColor.withAlpha(25),
                              padding: 0,
                              width: mobileSize.width * 0.35,
                              height: mobileSize.width * 0.35,
                              selectedStepSize: mobileSize.width * 0.02,
                              roundedCap: (_, __) => true,
                            ),
                          ),
                        ),
                        Center(
                          child: Obx(
                            () => Text(
                              '${controller.currentQuestionIndex + 1}',
                              style: Get.textTheme.displayMedium?.copyWith(
                                color: kCoral,
                                fontWeight: FontWeight.bold,
                              ),
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
                    'COUNTRY QUIZ',
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

              Positioned(
                top: mobileSize.height * 0.5,
                right: 0,
                left: 0,
                child: Padding(
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
                              controller
                                  .shouldShowAnswerResults[currentIndex] ??
                              false,
                          selectedOption:
                              controller.selectedAnswers[currentIndex],
                          onOptionSelected:
                              (option) => controller.handleAnswerSelection(
                                currentIndex,
                                option,
                              ),
                        ),
                      ),
                    ),
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

class QuestionOptions extends StatelessWidget {
  final QuestionsModel question;
  final bool showAnswer;
  final String? selectedOption;
  final Function(String) onOptionSelected;

  const QuestionOptions({
    super.key,
    required this.question,
    required this.showAnswer,
    this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OptionItem(
          letter: 'A',
          option: question.option1,
          showAnswer: showAnswer,
          correctAnswer: question.answer,
          selectedOption: selectedOption,
          onOptionSelected: onOptionSelected,
        ),
        const SizedBox(height: 12),
        OptionItem(
          letter: 'B',
          option: question.option2,
          showAnswer: showAnswer,
          correctAnswer: question.answer,
          selectedOption: selectedOption,
          onOptionSelected: onOptionSelected,
        ),
        const SizedBox(height: 12),
        OptionItem(
          letter: 'C',
          option: question.option3,
          showAnswer: showAnswer,
          correctAnswer: question.answer,
          selectedOption: selectedOption,
          onOptionSelected: onOptionSelected,
        ),
        const SizedBox(height: 12),
        OptionItem(
          letter: 'D',
          option: question.option4,
          showAnswer: showAnswer,
          correctAnswer: question.answer,
          selectedOption: selectedOption,
          onOptionSelected: onOptionSelected,
        ),
      ],
    );
  }
}

class OptionItem extends StatelessWidget {
  final String letter;
  final String option;
  final bool showAnswer;
  final String correctAnswer;
  final String? selectedOption;
  final Function(String) onOptionSelected;

  const OptionItem({
    super.key,
    required this.letter,
    required this.option,
    required this.showAnswer,
    required this.correctAnswer,
    this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showAnswer ? null : () => onOptionSelected(letter),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 56, // minimum height for the container
        ),
        decoration: BoxDecoration(
          border: Border.all(color: kTealGreen1, width: 3),
          color: getOptionBackgroundColor(
            showAnswer,
            correctAnswer,
            letter,
            selectedOption,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(
              // Option text
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              // Letter circle moved to right
              margin: const EdgeInsets.only(right: 8),
              height: 40,
              width: 40,
              decoration: roundedDecoration.copyWith(
                color: getLetterContainerColor(
                  showAnswer,
                  correctAnswer,
                  letter,
                  selectedOption,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(6),
              child: Center(
                child: Text(
                  letter,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    color:
                        showAnswer &&
                                (correctAnswer == letter ||
                                    selectedOption == letter)
                            ? kWhite
                            : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
