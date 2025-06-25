import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../customized_quiz/controller/cutomized_quiz_controller.dart';
import '../../quiz/controller/quiz_controller.dart';
import '../../quiz_levels/controller/quiz_result_controller.dart';

class ResultController extends GetxController {
  final RxInt totalQuestions = 20.obs;
  final RxInt correctAnswers = 0.obs;
  final RxInt wrongAnswers = 0.obs;
  final RxInt currentStep = 0.obs;
  final RxBool isInitialized = false.obs;

  void calculateResults(int topicIndex, int categoryIndex) {
    bool isCustomizedQuiz = Get.isRegistered<CustomizedQuizController>();
    List<dynamic> questions;
    Map<int, String> selectedAnswers;
    int totalQuestionsCount;

    if (isCustomizedQuiz) {
      try {
        final customizedController = Get.find<CustomizedQuizController>();
        questions = customizedController.questionsList;
        selectedAnswers = customizedController.selectedAnswers;
        totalQuestionsCount = customizedController.questionsList.length;
      } catch (e) {
        throw Exception('Error accessing CustomizedQuizController: $e');
      }
    } else {
      try {
        final questionsController = Get.find<QuizController>();
        questions = questionsController.questionsList;
        selectedAnswers = questionsController.selectedAnswers;
        totalQuestionsCount = 20; // Regular quiz always has 20 questions
      } catch (e) {
        throw Exception('Error accessing QuizController: $e');
      }
    }

    totalQuestions.value = totalQuestionsCount;

    // Calculate correct answers
    int correct = 0;
    for (int i = 0; i < totalQuestionsCount; i++) {
      if (selectedAnswers[i] != null &&
          selectedAnswers[i] == questions[i].answer) {
        correct++;
      }
    }

    correctAnswers.value = correct;
    wrongAnswers.value = totalQuestionsCount - correct;

    // Calculate percentage
    currentStep.value =
        totalQuestionsCount > 0
            ? ((correct * 100) / totalQuestionsCount).round()
            : 0;

    debugPrint(
      'Results: $correct/$totalQuestionsCount (${currentStep.value}%)',
    );

    Get.put(QuizResultController()).saveQuizResult(
      topicIndex: topicIndex,
      categoryIndex: categoryIndex,
      correctAnswers: correctAnswers.value,
      wrongAnswers: wrongAnswers.value,
      percentage: currentStep.value.toDouble(),
    );
  }

  String get resultPercentage => '${currentStep.value}%';

  void resetQuiz() {
    correctAnswers.value = 0;
    wrongAnswers.value = 0;
    currentStep.value = 0;
    totalQuestions.value = 20;
    isInitialized.value = false;

    if (Get.isRegistered<CustomizedQuizController>()) {
      try {
        final customizedController = Get.find<CustomizedQuizController>();
        customizedController.resetQuizState();
      } catch (e) {
        throw Exception('Error resetting CustomizedQuizController: $e');
      }
    } else if (Get.isRegistered<QuizController>()) {
      try {
        final questionsController = Get.find<QuizController>();
        questionsController.resetQuizState();
      } catch (e) {
        throw Exception('Error resetting QuizController: $e');
      }
    }
  }

  @override
  void onClose() {
    isInitialized.value = false;
    super.onClose();
  }
}
