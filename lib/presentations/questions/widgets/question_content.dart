import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:template/core/constant/constant.dart';
import 'package:template/core/models/questions_data.dart';
import 'package:template/presentations/questions/widgets/question_card.dart';

class QuestionsContent extends StatelessWidget {
  final bool isLoading;
  final List<QuestionsModel> questions;
  final PageController pageController;
  final int currentIndex;
  final Function(int) onPageChanged;
  final RxMap<int, String> selectedAnswers;
  final RxMap<int, bool> showAnswers;
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
            currentIndex: index,
            totalQuestions: questions.length,
            selectedAnswers: selectedAnswers,
            showAnswers: showAnswers,
            onOptionSelected: onAnswerSelected,
          );
        },
      ),
    );
  }
}
