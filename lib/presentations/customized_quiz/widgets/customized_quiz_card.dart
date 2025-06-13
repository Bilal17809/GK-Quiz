import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:template/core/models/questions_data.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/customized_quiz/controller/cutomized_quiz_controller.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';

import '../../../core/common_widgets/elongated_button.dart';
import '../../../core/common_widgets/round_image.dart';
import '../../../core/utils/ui_helpers.dart';

class CustomizedQuizCard extends StatelessWidget {
  final QuestionsModel question;
  final int currentIndex;
  final int totalQuestions;
  final RxMap<int, String> selectedAnswers;
  final RxMap<int, bool> showAnswers;
  final Function(int, String) onOptionSelected;

  const CustomizedQuizCard({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.selectedAnswers,
    required this.showAnswers,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final mobileWidth = MediaQuery.of(context).size.width;
    final controller = Get.find<CustomizedQuizController>();
    final quizController = Get.find<QuizController>();

    return Card(
      elevation: 2,
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    decoration: roundedDecoration.copyWith(color: kWhite),
                    padding: const EdgeInsets.all(12),
                    child: Obx(
                      () => StepProgressIndicator(
                        totalSteps: 100,
                        currentStep: controller.getProgressPercentage(),
                        size: 12,
                        padding: 0,
                        roundedEdges: const Radius.circular(10),
                        selectedGradientColor: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [skyColor.withValues(alpha: 0.2), skyColor],
                        ),
                        unselectedColor: greyColor.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                RoundedButton(
                  onTap: quizController.toggleFontSize,
                  backgroundColor: skyColor,
                  child: Icon(Icons.text_fields, color: kWhite),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                question.topicName,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: skyColor,
                  fontSize: 22,
                ),
              ),
            ),
            CustomizedQuestionHeader(totalQuestions: totalQuestions),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        question.question,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontSize: quizController.getQuestionFontSize(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Obx(
                      () => CustomizedQuestionOptions(
                        question: question,
                        currentIndex: currentIndex,
                        showAnswer: showAnswers[currentIndex] ?? false,
                        selectedOption: selectedAnswers[currentIndex],
                        onOptionSelected:
                            (option) => onOptionSelected(currentIndex, option),
                        controller: controller,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(() {
                  bool is5050Used = controller.is5050UsedForCurrentQuestion();
                  bool isAnswered = selectedAnswers.containsKey(currentIndex);
                  return ElongatedButton(
                    height: 50,
                    width: mobileWidth * 0.3,
                    color:
                        is5050Used
                            ? greyColor.withValues(alpha: 0.5)
                            : isAnswered
                            ? greyColor.withValues(alpha: 0.5)
                            : skyColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(25),
                    onTap:
                        (is5050Used || isAnswered)
                            ? null
                            : controller.use5050Hint,
                    child: Text(
                      '50:50',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: kWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
                Obx(() {
                  bool isAnswered = selectedAnswers.containsKey(currentIndex);
                  return ElongatedButton(
                    onTap: isAnswered ? controller.goToNextQuestion : null,
                    height: 70,
                    width: 70,
                    color:
                        isAnswered
                            ? skyColor
                            : greyColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      'assets/images/next.png',
                      color: kWhite,
                      height: 20,
                      width: 20,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomizedQuestionHeader extends StatelessWidget {
  final int totalQuestions;

  const CustomizedQuestionHeader({super.key, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Total Questions: $totalQuestions',
        style: context.textTheme.bodyMedium,
      ),
    );
  }
}

class CustomizedQuestionOptions extends StatelessWidget {
  final QuestionsModel question;
  final int currentIndex;
  final bool showAnswer;
  final String? selectedOption;
  final Function(String) onOptionSelected;
  final CustomizedQuizController controller;

  const CustomizedQuestionOptions({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.showAnswer,
    this.selectedOption,
    required this.onOptionSelected,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          children: [
            // Option A
            if (!controller.isOptionHidden(currentIndex, 'A')) ...[
              CustomizedOptionItem(
                letter: 'A',
                option: question.option1,
                showAnswer: showAnswer,
                correctAnswer: question.answer,
                selectedOption: selectedOption,
                onOptionSelected: onOptionSelected,
              ),
              const SizedBox(height: 12),
            ],
            // Option B
            if (!controller.isOptionHidden(currentIndex, 'B')) ...[
              CustomizedOptionItem(
                letter: 'B',
                option: question.option2,
                showAnswer: showAnswer,
                correctAnswer: question.answer,
                selectedOption: selectedOption,
                onOptionSelected: onOptionSelected,
              ),
              const SizedBox(height: 12),
            ],
            // Option C
            if (!controller.isOptionHidden(currentIndex, 'C')) ...[
              CustomizedOptionItem(
                letter: 'C',
                option: question.option3,
                showAnswer: showAnswer,
                correctAnswer: question.answer,
                selectedOption: selectedOption,
                onOptionSelected: onOptionSelected,
              ),
              const SizedBox(height: 12),
            ],
            // Option D
            if (!controller.isOptionHidden(currentIndex, 'D')) ...[
              CustomizedOptionItem(
                letter: 'D',
                option: question.option4,
                showAnswer: showAnswer,
                correctAnswer: question.answer,
                selectedOption: selectedOption,
                onOptionSelected: onOptionSelected,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomizedOptionItem extends StatelessWidget {
  final String letter;
  final String option;
  final bool showAnswer;
  final String correctAnswer;
  final String? selectedOption;
  final Function(String) onOptionSelected;

  const CustomizedOptionItem({
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
    final quizController = Get.find<QuizController>();
    return InkWell(
      onTap: showAnswer ? null : () => onOptionSelected(letter),
      child: Container(
        constraints: BoxConstraints(minHeight: 56),
        decoration: BoxDecoration(
          border: Border.all(color: kBlack.withValues(alpha: 0.15)),
          color: getOptionBackgroundColor(
            showAnswer,
            correctAnswer,
            letter,
            selectedOption,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 8),
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
                  style: context.textTheme.titleMedium?.copyWith(
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        option,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: quizController.getOptionFontSize(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
