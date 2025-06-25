import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/questions_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/ui_helpers.dart';
import '../controller/country_review_controller.dart';

class CountryReviewOptions extends StatelessWidget {
  final QuestionsModel question;
  final int questionIndex;
  final CountryReviewController controller;

  const CountryReviewOptions({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReviewOptionItem(
          letter: 'A',
          option: question.option1,
          correctAnswer: question.answer,
          selectedOption: controller.getUserSelectedAnswer(questionIndex),
        ),
        const SizedBox(height: 12),
        ReviewOptionItem(
          letter: 'B',
          option: question.option2,
          correctAnswer: question.answer,
          selectedOption: controller.getUserSelectedAnswer(questionIndex),
        ),
        const SizedBox(height: 12),
        ReviewOptionItem(
          letter: 'C',
          option: question.option3,
          correctAnswer: question.answer,
          selectedOption: controller.getUserSelectedAnswer(questionIndex),
        ),
        const SizedBox(height: 12),
        ReviewOptionItem(
          letter: 'D',
          option: question.option4,
          correctAnswer: question.answer,
          selectedOption: controller.getUserSelectedAnswer(questionIndex),
        ),
      ],
    );
  }
}

class ReviewOptionItem extends StatelessWidget {
  final String letter;
  final String option;
  final String correctAnswer;
  final String? selectedOption;

  const ReviewOptionItem({
    super.key,
    required this.letter,
    required this.option,
    required this.correctAnswer,
    this.selectedOption,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 56),
      decoration: BoxDecoration(
        border: Border.all(
          color: greyBorderColor.withValues(alpha: 0.5),
          width: 1,
        ),
        color: getOptionBackgroundColor(
          true,
          correctAnswer,
          letter,
          selectedOption,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Letter container
            Container(
              margin: const EdgeInsets.only(right: 8),
              height: 35,
              width: 35,
              decoration: roundedDecoration.copyWith(
                color: getLetterContainerColor(
                  true, // Always show answer in review mode
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
                        true &&
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
