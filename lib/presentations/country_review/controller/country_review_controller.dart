import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/questions_data.dart';

class CountryReviewController extends GetxController {
  final RxList<QuestionsModel> questionsList = <QuestionsModel>[].obs;
  final RxMap<int, String> selectedAnswers = <int, String>{}.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxString currentTopic = ''.obs;

  late PageController pageController = PageController();

  void initializeReview(
    List<QuestionsModel> questions,
    Map<int, String> answers,
    String topic,
  ) {
    questionsList.assignAll(questions);
    selectedAnswers.assignAll(answers);
    currentTopic.value = topic;
    currentQuestionIndex.value = 0;
  }

  void onPageChanged(int index) {
    currentQuestionIndex.value = index;
  }

  bool isCorrectAnswer(int questionIndex) {
    final question = questionsList[questionIndex];
    final selectedAnswer = selectedAnswers[questionIndex];
    return selectedAnswer == question.answer;
  }

  String? getUserSelectedAnswer(int questionIndex) {
    return selectedAnswers[questionIndex];
  }

  String getCorrectAnswer(int questionIndex) {
    return questionsList[questionIndex].answer;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
