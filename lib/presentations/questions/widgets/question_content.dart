import 'package:flutter/material.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/models/questions_data.dart';
import 'package:template/presentations/questions/widgets/question_card.dart';

class QuestionsContent extends StatelessWidget {
  final bool isLoading;
  final List<QuestionsData> questions;
  final PageController pageController;
  final int currentIndex;
  final Function(int) onPageChanged;
  final Map<int, String> selectedAnswers;
  final Map<int, bool> showAnswers;
  final Function(int, String) onAnswerSelected;

  const QuestionsContent({
    super.key,
    required this.isLoading,
    required this.questions,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
    required this.selectedAnswers,
    required this.showAnswers,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (questions.isEmpty) {
      return const Center(child: Text('No questions found'));
    }
    return Padding(
      padding: const EdgeInsets.all(kBodyHp),
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        itemCount: questions.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          return QuestionCard(
            question: questions[index],
            currentIndex: currentIndex,
            totalQuestions: questions.length,
            pageController: pageController,
            selectedOption: selectedAnswers[index],
            showAnswer: showAnswers[index] ?? false,
            onOptionSelected: (option) => onAnswerSelected(index, option),
          );
        },
      ),
    );
  }
}
