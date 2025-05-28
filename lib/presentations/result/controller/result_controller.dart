import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';

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
    Get.put(QuizResultController1()).saveQuizResult(
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

class QuizResultController1 extends GetxController {
  Future<void> saveQuizResult({
    required int topicIndex,
    required int categoryIndex,
    required int correctAnswers,
    required int wrongAnswers,
    required double percentage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String baseKey = 'result${topicIndex}_$categoryIndex';

    await prefs.setInt('${baseKey}_correct', correctAnswers);
    await prefs.setInt('${baseKey}_wrong', wrongAnswers);
    // Fixed: Added missing underscore in the key
    await prefs.setDouble('${baseKey}_percentage', percentage);

    // Verify the data was saved
    final savedCorrect = prefs.getInt('${baseKey}_correct');
    final savedWrong = prefs.getInt('${baseKey}_wrong');
    final savedPercentage = prefs.getDouble('${baseKey}_percentage');
    debugPrint(
      'Verified saved data - Correct: $savedCorrect, Wrong: $savedWrong, Percentage: $savedPercentage',
    );
  }

  Future<Map<String, dynamic>> getQuizResult(
    int topicIndex,
    int categoryIndex,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String baseKey = 'result${topicIndex}_$categoryIndex';

    final result = {
      'correct': prefs.getInt('${baseKey}_correct') ?? 0,
      'wrong': prefs.getInt('${baseKey}_wrong') ?? 0,
      'percentage': prefs.getDouble('${baseKey}_percentage') ?? 0.0,
    };
    return result;
  }

  /// Get overall topic results
  Future<Map<String, dynamic>> getOverallResult(int topicIndex) async {
    final prefs = await SharedPreferences.getInstance();
    int totalCorrect = 0;
    int totalWrong = 0;
    double totalPercentage = 0.0;
    int categoriesWithData = 0;
    int maxCategories = 10;

    for (
      int categoryIndex = 1;
      categoryIndex <= maxCategories;
      categoryIndex++
    ) {
      String baseKey = 'result${topicIndex}_$categoryIndex';
      int correct = prefs.getInt('${baseKey}_correct') ?? 0;
      int wrong = prefs.getInt('${baseKey}_wrong') ?? 0;
      double percentage = prefs.getDouble('${baseKey}_percentage') ?? 0.0;

      if (correct > 0 || wrong > 0) {
        totalCorrect += correct;
        totalWrong += wrong;
        totalPercentage += percentage;
        categoriesWithData++;
      }
    }

    // Calculate average percentage
    double averagePercentage =
        categoriesWithData > 0 ? totalPercentage / categoriesWithData : 0.0;

    return {
      'correct': totalCorrect,
      'wrong': totalWrong,
      'percentage': averagePercentage,
    };
  }
}
