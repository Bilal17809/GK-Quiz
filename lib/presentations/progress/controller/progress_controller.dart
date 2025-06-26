import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/country_grid.dart';
import '../../../core/common_widgets/grid_data.dart';
import '../../../core/local_storage/shared_preferences_storage.dart';
import '../../quiz/controller/quiz_controller.dart';

class ProgressController extends GetxController {
  final SharedPreferencesService _prefs = SharedPreferencesService.to;
  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs; // Add this for refresh state

  // Quiz Progress
  final RxInt totalAttempted = 0.obs;
  final RxInt totalAvailable = 0.obs;
  final RxInt totalCorrect = 0.obs;
  final RxInt totalWrong = 0.obs;
  final RxDouble weakPercentage = 0.0.obs;
  final RxDouble goodPercentage = 0.0.obs;
  final RxDouble excellentPercentage = 0.0.obs;

  // Learn Progress
  final RxInt totalLearnProgress = 0.obs;
  final RxInt totalLearnAvailable = 0.obs;
  final RxDouble learnWeakPercentage = 0.0.obs;
  final RxDouble learnGoodPercentage = 0.0.obs;
  final RxDouble learnExcellentPercentage = 0.0.obs;

  // Daily Performance Chart Data
  final RxMap<String, double> dailyPerformance = <String, double>{}.obs;

  SharedPreferencesService get prefsService => _prefs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    try {
      isLoading.value = true;
      debugPrint('Starting to load all data...');

      await calcCombinedQuizStats();
      await calcLearnProgress();
      await loadDailyPerformance();

      debugPrint('All data loaded successfully');
    } catch (e) {
      debugPrint('Error loading progress data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Optimized refresh method that doesn't show loading indicator
  Future<void> refreshStats() async {
    if (isRefreshing.value) return; // Prevent multiple simultaneous refreshes

    try {
      isRefreshing.value = true;
      debugPrint('Refreshing progress stats...');

      await calcCombinedQuizStats();
      await calcLearnProgress();
      // Skip daily performance refresh for faster updates
      // await loadDailyPerformance();

      debugPrint('Progress stats refreshed successfully');
    } catch (e) {
      debugPrint('Error refreshing progress data: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> loadDailyPerformance() async {
    try {
      final grid = _prefs.getDailyPerformance(
        topicNames: gridTexts,
        keyPrefix: 'result',
      );
      final country = _prefs.getDailyPerformance(
        topicNames: countryTexts,
        keyPrefix: 'country_result',
      );

      final days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];

      final combined = {
        for (var day in days)
          day: _average(grid[day] ?? 0.0, country[day] ?? 0.0),
      };

      dailyPerformance.value = combined;
      debugPrint('Daily Performance loaded: $combined');
    } catch (e) {
      debugPrint('Error loading daily performance: $e');
    }
  }

  double _average(double a, double b) =>
      (a > 0 && b > 0) ? (a + b) / 2 : (a > 0 ? a : b);

  Future<void> calcCombinedQuizStats() async {
    try {
      // Use Get.find to get existing controller instead of Get.put
      final QuizController quizController = Get.find<QuizController>();

      if (quizController.topicCounts.isEmpty) {
        debugPrint('Topic counts not initialized, loading...');
        await quizController.loadAllTopicCounts([
          ...gridTexts,
          ...countryTexts,
        ]);
        // Reduced delay from 500ms to 50ms for faster updates
        await Future.delayed(Duration(milliseconds: 50));
      }

      // Get grid data statistics
      final gridStatsResult = _prefs.getAllQuizStats(
        gridTexts,
        quizController.topicCounts,
        keyPrefix: 'result',
      );

      // Get country data statistics
      final countryStatsResult = _prefs.getAllQuizStats(
        countryTexts,
        quizController.topicCounts,
        keyPrefix: 'country_result',
      );

      totalCorrect.value =
          gridStatsResult['totalCorrect'] + countryStatsResult['totalCorrect'];
      totalWrong.value =
          gridStatsResult['totalWrong'] + countryStatsResult['totalWrong'];
      totalAttempted.value =
          gridStatsResult['totalAttempted'] +
          countryStatsResult['totalAttempted'];
      totalAvailable.value =
          gridStatsResult['totalAvailable'] +
          countryStatsResult['totalAvailable'];

      final List<double> gridPercentages = List<double>.from(
        gridStatsResult['percentages'],
      );
      final List<double> countryPercentages = List<double>.from(
        countryStatsResult['percentages'],
      );
      final List<double> allPercentages = [
        ...gridPercentages,
        ...countryPercentages,
      ];

      calcPerformance(allPercentages);

      debugPrint(
        'Combined Stats - Attempted: ${totalAttempted.value}/${totalAvailable.value}, '
        'Correct: ${totalCorrect.value}, Wrong: ${totalWrong.value}',
      );
    } catch (e) {
      debugPrint('Error in calcCombinedQuizStats: $e');
      // Initialize QuizController if it doesn't exist
      if (e.toString().contains('not found')) {
        Get.put(QuizController());
        await calcCombinedQuizStats(); // Retry
      }
    }
  }

  Future<void> calcLearnProgress() async {
    try {
      final QuizController quizController = Get.find<QuizController>();
      Set<String> uniqueTopics = {...gridTexts, ...countryTexts};
      List<String> allTopics = uniqueTopics.toList();

      int totalAvailable = 0;
      for (String topic in allTopics) {
        totalAvailable += quizController.topicCounts[topic] ?? 0;
      }

      totalLearnAvailable.value = totalAvailable;
      totalLearnProgress.value = _prefs.getTotalLearnProgress(allTopics);

      List<double> learnPercentages = [];
      for (String topic in allTopics) {
        int topicProgress = _prefs.getLearnProgress(topic);
        int topicTotal = quizController.topicCounts[topic] ?? 0;
        if (topicTotal > 0 && topicProgress > 0) {
          double percentage = (topicProgress / topicTotal) * 100;
          learnPercentages.add(percentage);
        }
      }

      calcLearnPerformance(learnPercentages);

      debugPrint(
        'Learn Progress - Total: ${totalLearnProgress.value}/${totalLearnAvailable.value}',
      );
    } catch (e) {
      debugPrint('Error in calcLearnProgress: $e');
      if (e.toString().contains('not found')) {
        Get.put(QuizController());
        await calcLearnProgress(); // Retry
      }
    }
  }

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
      'Performance - Weak: ${weakPercentage.value}%, '
      'Good: ${goodPercentage.value}%, '
      'Excellent: ${excellentPercentage.value}%',
    );
  }

  void calcLearnPerformance(List<double> percentages) {
    if (percentages.isEmpty) {
      learnWeakPercentage.value = 0.0;
      learnGoodPercentage.value = 0.0;
      learnExcellentPercentage.value = 0.0;
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
    learnWeakPercentage.value =
        totalAttempts > 0 ? (weakCount / totalAttempts) * 100 : 0.0;
    learnGoodPercentage.value =
        totalAttempts > 0 ? (goodCount / totalAttempts) * 100 : 0.0;
    learnExcellentPercentage.value =
        totalAttempts > 0 ? (excellentCount / totalAttempts) * 100 : 0.0;

    debugPrint(
      'Learn Performance - Weak: ${learnWeakPercentage.value}%, '
      'Good: ${learnGoodPercentage.value}%, '
      'Excellent: ${learnExcellentPercentage.value}%',
    );
  }

  Future<void> refreshLearnProgress() => calcLearnProgress();

  // Full refresh including daily performance
  Future<void> fullRefresh() => loadAllData();

  Map<String, dynamic> getQuizResult(int topicIndex, int categoryIndex) {
    return _prefs.getQuizResult(topicIndex, categoryIndex, keyPrefix: 'result');
  }

  Map<String, dynamic> getOverallResult(int topicIndex) {
    final QuizController quizController = Get.find<QuizController>();
    final topicName = gridTexts[topicIndex];
    final totalQuestionsInTopic = quizController.topicCounts[topicName] ?? 0;

    return _prefs.calculateOverallResult(
      topicIndex,
      totalQuestionsInTopic,
      keyPrefix: 'result',
    );
  }

  Map<String, dynamic> getCountryQuizResult(int topicIndex, int categoryIndex) {
    return _prefs.getQuizResult(
      topicIndex,
      categoryIndex,
      keyPrefix: 'country_result',
    );
  }

  Map<String, dynamic> getCountryOverallResult(int topicIndex) {
    final QuizController quizController = Get.find<QuizController>();
    final topicName = countryTexts[topicIndex];
    final totalQuestionsInTopic = quizController.topicCounts[topicName] ?? 0;

    return _prefs.calculateOverallResult(
      topicIndex,
      totalQuestionsInTopic,
      keyPrefix: 'country_result',
    );
  }

  Future<void> saveQuizResult({
    required int topicIndex,
    required int categoryIndex,
    required int correctAnswers,
    required int wrongAnswers,
    required double percentage,
  }) async {
    await _prefs.saveQuizResult(
      topicIndex: topicIndex,
      categoryIndex: categoryIndex,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      percentage: percentage,
      keyPrefix: 'result',
    );
    await refreshStats();
  }

  Future<void> saveCountryQuizResult({
    required int topicIndex,
    required int categoryIndex,
    required int correctAnswers,
    required int wrongAnswers,
    required double percentage,
  }) async {
    await _prefs.saveQuizResult(
      topicIndex: topicIndex,
      categoryIndex: categoryIndex,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      percentage: percentage,
      keyPrefix: 'country_result',
    );
    await refreshStats();
  }

  bool get hasDataLoaded =>
      !isLoading.value &&
      (totalAvailable.value > 0 || totalAttempted.value >= 0);
}
