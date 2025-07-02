import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../../../core/common_widgets/elongated_button.dart';
import '../../../../core/common_widgets/round_image.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/models/questions_data.dart';
import '../../../../core/routes/routes_name.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../controller/country_quiz_controller.dart';

class CountryQuizCard extends StatelessWidget {
  final QuestionsModel question;
  final int currentIndex;
  final int totalQuestions;
  final RxMap<int, String> selectedAnswers;
  final RxMap<int, bool> showAnswers;
  final Function(int, String) onOptionSelected;
  final CountryQuizController controller;
  final String topic;
  final int topicIndex;
  final int categoryIndex;

  const CountryQuizCard({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.selectedAnswers,
    required this.showAnswers,
    required this.onOptionSelected,
    required this.controller,
    required this.topic,
    required this.topicIndex,
    required this.categoryIndex,
  });

  String getCorrectAnswerText() {
    switch (question.answer.toUpperCase()) {
      case 'A':
        return question.option1;
      case 'B':
        return question.option2;
      case 'C':
        return question.option3;
      case 'D':
        return question.option4;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobileWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 2,
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar and font size toggle
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    width: double.infinity,
                    decoration: roundedDecoration.copyWith(color: kWhite),
                    padding: const EdgeInsets.all(12),
                    child: Obx(() {
                      return StepProgressIndicator(
                        totalSteps: 100,
                        currentStep: controller.getProgressPercentage(),
                        size: 12,
                        padding: 0,
                        roundedEdges: const Radius.circular(10),
                        selectedGradientColor: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            kSkyBlueColor.withValues(alpha: 0.2),
                            kSkyBlueColor,
                          ],
                        ),
                        unselectedColor: greyColor.withValues(alpha: 0.2),
                      );
                    }),
                  ),
                ),
                SizedBox(width: 8),
                RoundedButton(
                  onTap: controller.toggleFontSize,
                  backgroundColor: kSkyBlueColor,
                  child: Icon(Icons.text_fields, color: kWhite),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Topic title
            Center(
              child: Text(
                topic,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: kSkyBlueColor,
                  fontSize: 22,
                ),
              ),
            ),

            // Question header
            QuestionHeader(
              totalQuestions: totalQuestions,
              currentIndex: currentIndex,
            ),
            const SizedBox(height: 12),

            // Question content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        question.question,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontSize: controller.getQuestionFontSize(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Options
                    Obx(
                      () => CountryQuestionOptions(
                        question: question,
                        currentIndex: currentIndex,
                        showAnswer: showAnswers[currentIndex] ?? false,
                        selectedOption: selectedAnswers[currentIndex],
                        onOptionSelected:
                            (option) => onOptionSelected(currentIndex, option),
                        controller: controller,
                      ),
                    ),
                    SizedBox(height: kBodyHp * 2),

                    // Correct answer display
                    GestureDetector(
                      onTap: () {
                        final selectedLetter = selectedAnswers[currentIndex];
                        String selectedOptionText = '';
                        switch (selectedLetter) {
                          case 'A':
                            selectedOptionText = question.option1;
                            break;
                          case 'B':
                            selectedOptionText = question.option2;
                            break;
                          case 'C':
                            selectedOptionText = question.option3;
                            break;
                          case 'D':
                            selectedOptionText = question.option4;
                            break;
                        }
                        Get.toNamed(
                          RoutesName.explanationScreen,
                          arguments: {
                            'topic': topic,
                            'question': question.question,
                            'selectedOption': selectedOptionText,
                            'correctAnswer': getCorrectAnswerText(),
                          },
                        );
                      },
                      child: Obx(() {
                        bool isAnswered = selectedAnswers.containsKey(
                          currentIndex,
                        );
                        if (isAnswered) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '>> ',
                                style: context.textTheme.titleLarge?.copyWith(
                                  color: kSkyBlueColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '(${question.answer}) ${getCorrectAnswerText()}',
                                style: context.textTheme.titleSmall?.copyWith(
                                  color: kSkyBlueColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4),

            // Bottom buttons
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
                            : kSkyBlueColor.withValues(alpha: 0.8),
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
                    onTap:
                        isAnswered
                            ? () => controller.goToNextQuestion(
                              topic: topic,
                              topicIndex: topicIndex,
                              categoryIndex: categoryIndex,
                            )
                            : null,
                    height: 70,
                    width: 70,
                    color:
                        isAnswered
                            ? kSkyBlueColor
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

class QuestionHeader extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;

  const QuestionHeader({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Question: ${currentIndex + 1} / $totalQuestions',
        style: context.textTheme.bodyMedium,
      ),
    );
  }
}

class CountryQuestionOptions extends StatelessWidget {
  final QuestionsModel question;
  final int currentIndex;
  final bool showAnswer;
  final String? selectedOption;
  final Function(String) onOptionSelected;
  final CountryQuizController controller;

  const CountryQuestionOptions({
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
      () => Column(
        children: [
          // Option A
          if (!controller.isOptionHidden(currentIndex, 'A')) ...[
            CountryOptionItem(
              letter: 'A',
              option: question.option1,
              showAnswer: showAnswer,
              correctAnswer: question.answer,
              selectedOption: selectedOption,
              onOptionSelected: onOptionSelected,
              controller: controller,
            ),
            const SizedBox(height: 12),
          ],
          // Option B
          if (!controller.isOptionHidden(currentIndex, 'B')) ...[
            CountryOptionItem(
              letter: 'B',
              option: question.option2,
              showAnswer: showAnswer,
              correctAnswer: question.answer,
              selectedOption: selectedOption,
              onOptionSelected: onOptionSelected,
              controller: controller,
            ),
            const SizedBox(height: 12),
          ],
          // Option C
          if (!controller.isOptionHidden(currentIndex, 'C')) ...[
            CountryOptionItem(
              letter: 'C',
              option: question.option3,
              showAnswer: showAnswer,
              correctAnswer: question.answer,
              selectedOption: selectedOption,
              onOptionSelected: onOptionSelected,
              controller: controller,
            ),
            const SizedBox(height: 12),
          ],
          // Option D
          if (!controller.isOptionHidden(currentIndex, 'D')) ...[
            CountryOptionItem(
              letter: 'D',
              option: question.option4,
              showAnswer: showAnswer,
              correctAnswer: question.answer,
              selectedOption: selectedOption,
              onOptionSelected: onOptionSelected,
              controller: controller,
            ),
          ],
        ],
      ),
    );
  }
}

class CountryOptionItem extends StatelessWidget {
  final String letter;
  final String option;
  final bool showAnswer;
  final String correctAnswer;
  final String? selectedOption;
  final Function(String) onOptionSelected;
  final CountryQuizController controller;

  const CountryOptionItem({
    super.key,
    required this.letter,
    required this.option,
    required this.showAnswer,
    required this.correctAnswer,
    this.selectedOption,
    required this.onOptionSelected,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
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
                          fontSize: controller.getOptionFontSize(),
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
