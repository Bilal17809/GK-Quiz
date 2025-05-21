import 'package:flutter/material.dart';
import 'package:template/core/common_widgets/common_rounded_elongated_button.dart';
import 'package:template/core/models/questions_data.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/extension/extension.dart';

class QuestionCard extends StatefulWidget {
  final QuestionsData question;
  final int currentIndex;
  final int totalQuestions;
  final PageController pageController;
  final String? selectedOption;
  final bool showAnswer;
  final Function(String) onOptionSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.pageController,
    this.selectedOption,
    this.showAnswer = false,
    required this.onOptionSelected,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  void _handleOptionSelect(String letter) {
    if (widget.showAnswer) return; // Prevent selecting after answer is shown
    widget.onOptionSelected(letter);
  }

  @override
  Widget build(BuildContext context) {
    final mobileHeight = MediaQuery.of(context).size.height;
    final mobileWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 2,
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.question.topic,
              style: context.textTheme.headlineMedium?.copyWith(
                color: kRed,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 12),
            QuestionHeader(totalQuestions: widget.totalQuestions),
            const SizedBox(height: 12),
            QuestionText(question: widget.question.question),
            const SizedBox(height: 24),
            OptionItem(
              letter: 'A',
              option: widget.question.option1,
              showAnswer: widget.showAnswer,
              correctAnswer: widget.question.answer,
              selectedOption: widget.selectedOption,
              onOptionSelected: _handleOptionSelect,
            ),
            const SizedBox(height: 24),
            OptionItem(
              letter: 'B',
              option: widget.question.option2,
              showAnswer: widget.showAnswer,
              correctAnswer: widget.question.answer,
              selectedOption: widget.selectedOption,
              onOptionSelected: _handleOptionSelect,
            ),
            const SizedBox(height: 24),
            OptionItem(
              letter: 'C',
              option: widget.question.option3,
              showAnswer: widget.showAnswer,
              correctAnswer: widget.question.answer,
              selectedOption: widget.selectedOption,
              onOptionSelected: _handleOptionSelect,
            ),
            const SizedBox(height: 24),
            OptionItem(
              letter: 'D',
              option: widget.question.option4,
              showAnswer: widget.showAnswer,
              correctAnswer: widget.question.answer,
              selectedOption: widget.selectedOption,
              onOptionSelected: _handleOptionSelect,
            ),
            const Spacer(),
            BottomButtons(
              height: mobileHeight,
              width: mobileWidth,
              pageController: widget.pageController,
              currentIndex: widget.currentIndex,
              totalQuestions: widget.totalQuestions,
            ),
            const SizedBox(height: 20),
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
        Text(
          'Total Questions: $totalQuestions',
          style: context.textTheme.bodyMedium,
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
    );
  }
}

class QuestionText extends StatelessWidget {
  final String question;

  const QuestionText({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: Theme.of(context).textTheme.titleMedium),
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

  Color _getOptionColor() {
    if (!showAnswer) return Colors.transparent;

    final isCorrect = correctAnswer == letter;
    final isSelected = selectedOption == letter;

    if (isCorrect) {
      return kDarkGreen1.withValues(alpha: 0.25);
    } else if (isSelected) {
      return kRed.withValues(alpha: 0.25);
    }

    return Colors.transparent;
  }

  Color _getLetterContainerColor() {
    if (!showAnswer) return greyColor.withValues(alpha: 0.5);

    final isCorrect = correctAnswer == letter;
    final isSelected = selectedOption == letter;

    if (isCorrect) {
      return kDarkGreen1;
    } else if (isSelected) {
      return kRed;
    }

    return greyColor.withValues(alpha: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!showAnswer) {
          onOptionSelected(letter);
        }
      },
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: _getOptionColor(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16),
              height: 40,
              width: 40,
              decoration: roundedDecoration.copyWith(
                color: _getLetterContainerColor(),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  letter,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: 24,
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
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: context.textTheme.bodyMedium?.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomButtons extends StatelessWidget {
  final double height;
  final double width;
  final PageController pageController;
  final int currentIndex;
  final int totalQuestions;
  const BottomButtons({
    super.key,
    required this.height,
    required this.width,
    required this.pageController,
    required this.currentIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 50:50 Button
        CommonRoundedElongatedButton(
          height: height * 0.06,
          width: width * 0.38,
          color: skyColor,
          borderRadius: BorderRadius.circular(25),
          child: Text(
            '50:50',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            // 50:50 logic here
          },
        ),

        const SizedBox(width: 15),

        // Navigation Button
        CommonRoundedElongatedButton(
          height: height * 0.06,
          width: width * 0.38,
          color: kViolet,
          borderRadius: BorderRadius.circular(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Back Icon
              GestureDetector(
                onTap: () {
                  if (currentIndex > 0) {
                    pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
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
              // Question Index
              Text(
                '${currentIndex + 1}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: kWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Forward Icon
              GestureDetector(
                onTap: () {
                  if (currentIndex < totalQuestions - 1) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
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
