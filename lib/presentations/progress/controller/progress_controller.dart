import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/core/models/grid_data.dart';

import '../../quiz/controller/quiz_controller.dart';

class ProgressController extends GetxController {
  final RxBool isLoading = true.obs;

  // Observable variables for overall test section
  final RxInt totalAttempted = 0.obs;
  final RxInt totalAvailable = 0.obs;
  final RxInt totalCorrect = 0.obs;
  final RxInt totalWrong = 0.obs;
  final RxDouble weakPercentage = 0.0.obs;
  final RxDouble goodPercentage = 0.0.obs;
  final RxDouble excellentPercentage = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  // Load all data and update loading state
  Future<void> loadAllData() async {
    try {
      isLoading.value = true;
      await calcQuizStats();
    } catch (e) {
      debugPrint('Error loading progress data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Calculate overall test statistics
  Future<void> calcQuizStats() async {
    final prefs = await SharedPreferences.getInstance();

    int allCorrect = 0;
    int allWrong = 0;
    int allAttempted = 0;
    int allAvailable = 0;

    List<double> allQuizPercentages = [];

    final QuizController quizController = Get.put(QuizController());
    // Initialize topic counts if empty
    if (quizController.topicCounts.isEmpty) {
      debugPrint('Topic counts not initialized, loading all topic counts...');
      await quizController.loadAllTopicCounts(gridTexts);
      // Wait a bit for initialization
      await Future.delayed(Duration(milliseconds: 500));
    }

    for (int topicIndex = 0; topicIndex < gridTexts.length; topicIndex++) {
      final topicName = gridTexts[topicIndex];
      final int totalQuestionsInTopic =
          quizController.topicCounts[topicName] ?? 0;
      allAvailable += totalQuestionsInTopic;
      int topicCorrect = 0;
      int topicWrong = 0;

      for (int catIndex = 1; catIndex <= gridTexts.length; catIndex++) {
        String baseKey = 'result${topicIndex}_$catIndex';
        int correct = prefs.getInt('${baseKey}_correct') ?? 0;
        int wrong = prefs.getInt('${baseKey}_wrong') ?? 0;
        double percentage = prefs.getDouble('${baseKey}_percentage') ?? 0.0;

        if (correct > 0 || wrong > 0) {
          topicCorrect += correct;
          topicWrong += wrong;
          allQuizPercentages.add(percentage);
        }
      }
      allCorrect += topicCorrect;
      allWrong += topicWrong;
      allAttempted += (topicCorrect + topicWrong);
    }

    totalAttempted.value = allAttempted;
    totalAvailable.value = allAvailable;
    totalCorrect.value = allCorrect;
    totalWrong.value = allWrong;

    // Calculate performance categories based on quiz attempt percentages
    calcPerformance(allQuizPercentages);

    debugPrint(
      'Overall Stats - Attempted: $allAttempted/$allAvailable, Correct: $allCorrect, Wrong: $allWrong',
    );
  }

  // Calculate performance
  void calcPerformance(List<double> percentages) {
    if (percentages.isEmpty) {
      weakPercentage.value = 0.0;
      goodPercentage.value = 0.0;
      excellentPercentage.value = 0.0;
      return;
    }

    int weakCount = 0;
    int goodCount = 0;
    int excellentCount = 0;

    for (double percentage in percentages) {
      if (percentage <= 40.0) {
        weakCount++;
      } else if (percentage <= 80.0) {
        goodCount++;
      } else {
        excellentCount++;
      }
    }

    int totalAttempts = percentages.length;
    weakPercentage.value =
        totalAttempts > 0 ? (weakCount / totalAttempts) * 100 : 0.0;
    goodPercentage.value =
        totalAttempts > 0 ? (goodCount / totalAttempts) * 100 : 0.0;
    excellentPercentage.value =
        totalAttempts > 0 ? (excellentCount / totalAttempts) * 100 : 0.0;

    debugPrint(
      'Performance - Weak: ${weakPercentage.value}%, Good: ${goodPercentage.value}%, Excellent: ${excellentPercentage.value}%',
    );
  }

  // Refresh all statistics
  Future<void> refreshStats() async {
    await loadAllData();
  }

  // Check if data has been loaded
  bool get hasDataLoaded =>
      !isLoading.value &&
      (totalAvailable.value > 0 || totalAttempted.value >= 0);
}
