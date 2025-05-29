import 'package:get/get.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';

import '../../quiz_levels/controller/quiz_result_controller.dart';

class ResultController extends GetxController {
  // Observable variables
  final int totalQuestions = 20;
  final RxInt correctAnswers = 0.obs;
  final RxInt wrongAnswers = 0.obs;
  final RxInt currentStep = 0.obs;

  /// Calculate results from the quiz data using topicIndex and categoryIndex
  void calculateResults(int topicIndex, int categoryIndex) {
    final questionsController = Get.find<QuizController>();
    final questions = questionsController.questions;
    final selectedAnswers = questionsController.selectedAnswers;

    int correct = 0;
    for (int i = 0; i < totalQuestions; i++) {
      if (selectedAnswers[i] != null &&
          selectedAnswers[i] == questions[i].answer) {
        correct++;
      }
    }

    correctAnswers.value = correct;
    wrongAnswers.value = totalQuestions - correct;

    // Use double division for more accurate percentage calculation
    currentStep.value =
        totalQuestions > 0 ? ((correct * 100) / totalQuestions).round() : 0;

    // Save the result using topicIndex and categoryIndex
    Get.put(QuizResultController()).saveQuizResult(
      topicIndex: topicIndex,
      categoryIndex: categoryIndex,
      correctAnswers: correctAnswers.value,
      wrongAnswers: wrongAnswers.value,
      percentage: currentStep.value.toDouble(),
    );
  }

  /// Get percentage string
  String get resultPercentage => '${currentStep.value}%';

  void resetQuiz() {
    correctAnswers.value = 0;
    wrongAnswers.value = 0;
    currentStep.value = 0;
    final questionsController = Get.find<QuizController>();
    questionsController.resetQuizState();
  }
}
