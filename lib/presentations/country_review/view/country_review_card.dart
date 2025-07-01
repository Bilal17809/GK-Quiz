import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/presentations/country_review/controller/country_review_controller.dart';
import '../../../../core/common_widgets/round_image.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/models/questions_data.dart';
import '../../../../core/routes/routes_name.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class CountryReviewCard extends StatelessWidget {
  final QuestionsModel question;
  final int questionIndex;
  final int totalQuestions;
  final RxMap<int, String> selectedAnswers;
  final CountryReviewController controller;
  final String topic;
  final int topicIndex;
  final int categoryIndex;

  const CountryReviewCard({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.totalQuestions,
    required this.selectedAnswers,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${questionIndex + 1} of $totalQuestions',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: kSkyBlueColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                RoundedButton(
                  onTap: controller.toggleFontSize,
                  backgroundColor: kSkyBlueColor,
                  child: Icon(Icons.text_fields, color: kWhite),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Question content
            Obx(
              () => Text(
                question.question,
                style: context.textTheme.titleMedium?.copyWith(
                  fontSize: controller.getQuestionFontSize(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Options - All visible, pre-selected
            CountryQuestionOptions(
              question: question,
              questionIndex: questionIndex,
              selectedOption: selectedAnswers[questionIndex],
              controller: controller,
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                final selectedLetter = selectedAnswers[questionIndex];
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
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: roundedSkyBlueBorderDecoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: kSkyBlueColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Correct Answer: (${question.answer}) ${getCorrectAnswerText()}',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: kSkyBlueColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
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

class CountryQuestionOptions extends StatelessWidget {
  final QuestionsModel question;
  final int questionIndex;
  final String? selectedOption;
  final CountryReviewController controller;

  const CountryQuestionOptions({
    super.key,
    required this.question,
    required this.questionIndex,
    this.selectedOption,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Option A
        CountryOptionItem(
          letter: 'A',
          option: question.option1,
          correctAnswer: question.answer,
          selectedOption: selectedOption,
          controller: controller,
        ),
        const SizedBox(height: 12),
        // Option B
        CountryOptionItem(
          letter: 'B',
          option: question.option2,
          correctAnswer: question.answer,
          selectedOption: selectedOption,
          controller: controller,
        ),
        const SizedBox(height: 12),
        // Option C
        CountryOptionItem(
          letter: 'C',
          option: question.option3,
          correctAnswer: question.answer,
          selectedOption: selectedOption,
          controller: controller,
        ),
        const SizedBox(height: 12),
        // Option D
        CountryOptionItem(
          letter: 'D',
          option: question.option4,
          correctAnswer: question.answer,
          selectedOption: selectedOption,
          controller: controller,
        ),
      ],
    );
  }
}

class CountryOptionItem extends StatelessWidget {
  final String letter;
  final String option;
  final String correctAnswer;
  final String? selectedOption;
  final CountryReviewController controller;

  const CountryOptionItem({
    super.key,
    required this.letter,
    required this.option,
    required this.correctAnswer,
    this.selectedOption,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if this option is correct, selected, or wrong
    bool isCorrect = correctAnswer == letter;
    bool isSelected = selectedOption == letter;

    Color backgroundColor;
    Color letterContainerColor;
    Color textColor = Colors.black;

    if (isCorrect) {
      backgroundColor = Colors.green.withOpacity(0.1);
      letterContainerColor = Colors.green;
      textColor = Colors.green.shade700;
    } else if (isSelected) {
      backgroundColor = Colors.red.withOpacity(0.1);
      letterContainerColor = Colors.red;
      textColor = Colors.red.shade700;
    } else {
      backgroundColor = Colors.grey.withOpacity(0.05);
      letterContainerColor = Colors.grey.shade300;
    }

    return Container(
      constraints: BoxConstraints(minHeight: 56),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              isCorrect
                  ? Colors.green
                  : isSelected
                  ? Colors.red
                  : Colors.grey.shade300,
          width: isCorrect || isSelected ? 2 : 1,
        ),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 8),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: letterContainerColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                letter,
                style: context.textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  color:
                      (isCorrect || isSelected) ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Obx(
                () => Text(
                  option,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: controller.getOptionFontSize(),
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
