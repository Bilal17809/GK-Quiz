import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../country_levels/controller/country_levels_controller.dart';
import '../../country_quiz/controller/country_quiz_controller.dart';

class CountryResultController extends GetxController {
  // Observable variables
  final RxInt totalQuestions = 20.obs;
  final RxInt correctAnswers = 0.obs;
  final RxInt wrongAnswers = 0.obs;
  final RxInt currentStep = 0.obs;

  /// Calculate results from the country quiz data
  void calculateResults(int topicIndex, int categoryIndex) {
    try {
      // Get data from CountryQuizController
      final countryQuizController = Get.find<CountryQuizController>();
      final questions = countryQuizController.questionsList;
      final selectedAnswers = countryQuizController.selectedAnswers;
      final int totalQuestionsCount = questions.length;

      // Update total questions count
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
        'Country Quiz Results: $correct/$totalQuestionsCount (${currentStep.value}%)',
      );

      // Save the result
      Get.put(CountryLevelsController()).saveQuizResult(
        topicIndex: topicIndex,
        categoryIndex: categoryIndex,
        correctAnswers: correctAnswers.value,
        wrongAnswers: wrongAnswers.value,
        percentage: currentStep.value.toDouble(),
      );
    } catch (e) {
      debugPrint('Error calculating country quiz results: $e');
      // Set default values in case of error
      totalQuestions.value = 0;
      correctAnswers.value = 0;
      wrongAnswers.value = 0;
      currentStep.value = 0;

      throw Exception('Error accessing CountryQuizController: $e');
    }
  }

  /// Get percentage string
  String get resultPercentage => '${currentStep.value}%';

  void resetQuiz() {
    correctAnswers.value = 0;
    wrongAnswers.value = 0;
    currentStep.value = 0;
    totalQuestions.value = 20;

    // Reset the CountryQuizController
    try {
      final countryQuizController = Get.find<CountryQuizController>();
      countryQuizController.resetQuizState();
    } catch (e) {
      debugPrint('Error resetting CountryQuizController: $e');
      throw Exception('Error resetting CountryQuizController: $e');
    }
  }
}
