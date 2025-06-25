import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/questions_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/ui_helpers.dart';

class CountryQuestionOptions extends StatelessWidget {
  final QuestionsModel question;
  final bool showAnswer;
  final String? selectedOption;
  final Function(String) onOptionSelected;

  const CountryQuestionOptions({
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
      onTap:
          showAnswer
              ? null
              : () {
                debugPrint('Option $letter tapped'); // Debug print
                onOptionSelected(letter);
              },
      child: Container(
        constraints: BoxConstraints(minHeight: 56),
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
            ],
          ),
        ),
      ),
    );
  }
}
