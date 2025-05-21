import 'package:flutter/material.dart';
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
  Color _getOptionColor(String option, String letter) {
    if (!widget.showAnswer) return Colors.transparent;

    final isCorrect = widget.question.answer == letter;
    final isSelected = widget.selectedOption == letter;

    if (isCorrect) {
      return kDarkGreen1.withValues(alpha: 0.25);
    } else if (isSelected) {
      return kRed.withValues(alpha: 0.25);
    }

    return Colors.transparent;
  }

  Color _getLetterContainerColor(String letter) {
    if (!widget.showAnswer) return greyColor.withValues(alpha: 0.5);

    final isCorrect = widget.question.answer == letter;
    final isSelected = widget.selectedOption == letter;

    if (isCorrect) {
      return kDarkGreen1;
    } else if (isSelected) {
      return kRed;
    }

    return greyColor.withValues(alpha: 0.5);
  }

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
            _buildQuestionHeader(context),
            const SizedBox(height: 12),
            _buildQuestionText(context),
            const SizedBox(height: 24),
            _buildOption('A', widget.question.option1, context),
            const SizedBox(height: 24),
            _buildOption('B', widget.question.option2, context),
            const SizedBox(height: 24),
            _buildOption('C', widget.question.option3, context),
            const SizedBox(height: 24),
            _buildOption('D', widget.question.option4, context),
            const Spacer(),
            _buildBottomButtons(mobileHeight, mobileWidth, context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Total Questions: ${widget.totalQuestions}',
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

  Widget _buildQuestionText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.question,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildOption(String letter, String option, BuildContext context) {
    return InkWell(
      onTap: () => _handleOptionSelect(letter),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: _getOptionColor(option, letter),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16),
              height: 40,
              width: 40,
              decoration: roundedDecoration.copyWith(
                color: _getLetterContainerColor(letter),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  letter,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: 24,
                    color:
                        widget.showAnswer &&
                                (widget.question.answer == letter ||
                                    widget.selectedOption == letter)
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

  Widget _buildBottomButtons(
    double height,
    double width,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // First button
        Container(
          height: height * 0.06,
          width: width * 0.38,
          decoration: roundedDecoration.copyWith(
            color: skyColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              '50:50',
              style: context.textTheme.bodyMedium?.copyWith(
                color: kWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Second button
        const SizedBox(width: 15),
        Container(
          height: height * 0.06,
          width: width * 0.38,
          decoration: roundedDecoration.copyWith(
            color: kViolet,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Back icon
              GestureDetector(
                onTap: () {
                  if (widget.currentIndex > 0) {
                    widget.pageController.previousPage(
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
              // Question index text
              Text(
                '${widget.currentIndex + 1}',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: kWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Forward icon
              GestureDetector(
                onTap: () {
                  if (widget.currentIndex < widget.totalQuestions - 1) {
                    widget.pageController.nextPage(
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
