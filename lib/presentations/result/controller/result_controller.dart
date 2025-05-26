import 'package:get/get.dart';
import 'package:template/presentations/questions/controller/questions_controller.dart';
import 'package:template/presentations/questions_categories/controller/quiz_result_controller.dart';

class ResultController extends GetxController {
  // Observable variables
  final int totalQuestions = 20;
  final RxInt correctAnswers = 0.obs;
  final RxInt wrongAnswers = 0.obs;
  final RxInt currentStep = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _calculateResults();
  }

  /// Calculate results from the quiz data
  void _calculateResults() {
    try {
      // Get the QuestionsController instance
      final questionsController = Get.find<QuestionsController>();
      final questions = questionsController.questions;
      final selectedAnswers = questionsController.selectedAnswers;

      // Calculate correct and wrong answers
      int correct = 0;

      for (int i = 0; i < totalQuestions; i++) {
        final selectedAnswer = selectedAnswers[i];
        final correctAnswer = questions[i].answer;

        if (selectedAnswer != null && selectedAnswer == correctAnswer) {
          correct++;
        }
      }

      correctAnswers.value = correct;
      wrongAnswers.value = totalQuestions - correct;

      // Calculate progress step
      currentStep.value =
          totalQuestions > 0 ? ((correct * 100) ~/ totalQuestions) : 0;

      // Save the result to shared preferences
      Get.find<QuizResultController>().saveQuizResult(
        correctAnswers: correctAnswers.value,
        wrongAnswers: wrongAnswers.value,
        percentage: currentStep.value.toDouble(),
      );
    } catch (e) {
      throw Exception('Error calculating results: $e');
    }
  }

  /// Get percentage string
  String get resultPercentage => '${currentStep.value}%';

  void resetQuiz() {
    //Resets Result Controller.dart
    correctAnswers.value = 0;
    wrongAnswers.value = 0;
    currentStep.value = 0;

    // Reset QuestionsController data
    final questionsController = Get.find<QuestionsController>();
    questionsController.resetQuizState();
  }
}
