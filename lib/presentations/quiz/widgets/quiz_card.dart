import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:template/core/models/questions_data.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';
import 'package:template/presentations/quiz/widgets/bottom_buttons.dart';

class QuizCard extends StatelessWidget {
  final QuestionsModel question;
  final int currentIndex;
  final int totalQuestions;
  final RxMap<int, String> selectedAnswers;
  final RxMap<int, bool> showAnswers;
  final Function(int, String) onOptionSelected;

  const QuizCard({
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
    final mobileHeight = MediaQuery.of(context).size.height;
    final mobileWidth = MediaQuery.of(context).size.width;
    final controller = Get.find<QuizController>();

    return Card(
      elevation: 2,
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                    colors: [kCoral.withValues(alpha: 0.2), kOrange],
                  ),
                  unselectedColor: greyColor.withValues(alpha: 0.2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                question.topicName,
                style: Get.textTheme.headlineMedium?.copyWith(
                  color: kRed,
                  fontSize: 22,
                ),
              ),
            ),
            QuestionHeader(totalQuestions: totalQuestions),
            const SizedBox(height: 12),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.question,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: mobileHeight * 0.03),
                  Obx(
                    () => QuestionOptions(
                      question: question,
                      showAnswer: showAnswers[currentIndex] ?? false,
                      selectedOption: selectedAnswers[currentIndex],
                      onOptionSelected:
                          (option) => onOptionSelected(currentIndex, option),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            BottomButtons(
              height: mobileHeight,
              width: mobileWidth,
              currentIndex: currentIndex,
              totalQuestions: totalQuestions,
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionHeader extends StatelessWidget {
  final int totalQuestions;

  const QuestionHeader({super.key, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            Text(
              'Total Questions: $totalQuestions',
              style: Get.textTheme.bodyMedium,
            ),
            Container(
              margin: const EdgeInsets.only(left: 24),
              height: 28,
              width: 28,
              decoration: roundedDecoration.copyWith(
                color: kOrange,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset('assets/images/forward.png', color: kWhite),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16),
              height: 28,
              width: 28,
              decoration: roundedDecoration.copyWith(
                color: kOrange,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset('assets/images/share.png', color: kWhite),
            ),
          ],
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
    final controller = Get.find<QuizController>();
    return InkWell(
      onTap: showAnswer ? null : () => onOptionSelected(letter),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 56, // minimum height for the container
        ),
        decoration: BoxDecoration(
          border: Border.all(color: kBlack.withValues(alpha: 0.15)),
          color: controller.getOptionBackgroundColor(
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
                color: controller.getLetterContainerColor(
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
            Expanded(
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
          ],
        ),
      ),
    );
  }
}
