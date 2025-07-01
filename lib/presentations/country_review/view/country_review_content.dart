import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/presentations/country_review/controller/country_review_controller.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/models/questions_data.dart';
import 'country_review_card.dart';

class CountryReviewContent extends StatelessWidget {
  final bool isLoading;
  final List<QuestionsModel> questions;
  final RxMap<int, String> selectedAnswers;
  final CountryReviewController controller;
  final PageController pageController;
  final Function(int) onPageChanged;
  final String topic;
  final int topicIndex;
  final int categoryIndex;

  const CountryReviewContent({
    super.key,
    required this.isLoading,
    required this.questions,
    required this.selectedAnswers,
    required this.controller,
    required this.topic,
    required this.topicIndex,
    required this.categoryIndex,
    required this.pageController,
    required this.onPageChanged,
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
        physics: const BouncingScrollPhysics(),
        controller: pageController,
        itemCount: questions.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          return CountryReviewCard(
            question: questions[index],
            questionIndex: index,
            totalQuestions: questions.length,
            selectedAnswers: selectedAnswers,
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
