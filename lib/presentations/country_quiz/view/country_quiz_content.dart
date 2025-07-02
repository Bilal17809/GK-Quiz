import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/models/questions_data.dart';
import '../controller/country_quiz_controller.dart';
import 'country_quiz_card.dart';

class CountryQuizContent extends StatelessWidget {
  final bool isLoading;
  final List<QuestionsModel> questions;
  final PageController pageController;
  final int currentIndex;
  final Function(int) onPageChanged;
  final RxMap<int, String> selectedAnswers;
  final RxMap<int, bool> showAnswers;
  final Function(int, String) onAnswerSelected;
  final CountryQuizController controller;
  final String topic;
  final int topicIndex;
  final int categoryIndex;

  const CountryQuizContent({
    super.key,
    required this.isLoading,
    required this.questions,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
    required this.selectedAnswers,
    required this.showAnswers,
    required this.onAnswerSelected,
    required this.controller,
    required this.topic,
    required this.topicIndex,
    required this.categoryIndex,
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
          return CountryQuizCard(
            question: questions[index],
            currentIndex: index,
            totalQuestions: questions.length,
            selectedAnswers: selectedAnswers,
            showAnswers: showAnswers,
            onOptionSelected: onAnswerSelected,
            controller: controller,
            topic: topic,
            topicIndex: topicIndex,
            categoryIndex: categoryIndex,
          );
        },
      ),
    );
  }
}
