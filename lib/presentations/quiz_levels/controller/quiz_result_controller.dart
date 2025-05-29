import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/grid_data.dart';
import '../../quiz/controller/quiz_controller.dart';

class QuizResultController extends GetxController {
  // Add reactive cache for results
  final RxMap<int, Map<String, dynamic>> _cachedResults =
      <int, Map<String, dynamic>>{}.obs;
  final RxInt _refreshTrigger = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Load all cached results on initialization
    _loadAllCachedResults();
  }

  /// Load all cached results from SharedPreferences
  Future<void> _loadAllCachedResults() async {
    final prefs = await SharedPreferences.getInstance();
    // Load results for all topics (assuming you have up to 20 topics)
    for (int topicIndex = 0; topicIndex < 20; topicIndex++) {
      final result = await _calculateOverallResultFromPrefs(topicIndex, prefs);
      _cachedResults[topicIndex] = result;
    }
    // Trigger UI update
    _refreshTrigger.value++;
  }

  /// Calculate overall result from SharedPreferences
  Future<Map<String, dynamic>> _calculateOverallResultFromPrefs(
    int topicIndex,
    SharedPreferences prefs,
  ) async {
    int totalCorrect = 0;
    int totalWrong = 0;
    int maxCategories = 10;

    for (
      int categoryIndex = 1;
      categoryIndex <= maxCategories;
      categoryIndex++
    ) {
      String baseKey = 'result${topicIndex}_$categoryIndex';
      int correct = prefs.getInt('${baseKey}_correct') ?? 0;
      int wrong = prefs.getInt('${baseKey}_wrong') ?? 0;

      if (correct > 0 || wrong > 0) {
        totalCorrect += correct;
        totalWrong += wrong;
      }
    }

    // Get total questions for this topic from QuizController
    final quizController = Get.find<QuizController>();
    final topicName = gridTexts[topicIndex];
    final totalQuestionsInTopic = quizController.topicCounts[topicName] ?? 0;

    // Calculate percentage based on total attempted vs total available
    int totalAttempted = totalCorrect + totalWrong;
    double overallPercentage = 0.0;
    if (totalAttempted > 0 && totalQuestionsInTopic > 0) {
      overallPercentage = (totalCorrect / totalQuestionsInTopic) * 100;
    }

    return {
      'correct': totalCorrect,
      'wrong': totalWrong,
      'percentage': overallPercentage,
    };
  }

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

    // Update cached result for this topic
    final updatedResult = await _calculateOverallResultFromPrefs(
      topicIndex,
      prefs,
    );
    _cachedResults[topicIndex] = updatedResult;

    // Trigger UI update
    _refreshTrigger.value++;

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

  /// Get overall topic results (original async method)
  Future<Map<String, dynamic>> getOverallResult(int topicIndex) async {
    final prefs = await SharedPreferences.getInstance();
    return await _calculateOverallResultFromPrefs(topicIndex, prefs);
  }

  /// Get overall result synchronously (for reactive UI)
  Map<String, dynamic> getOverallResultSync(int topicIndex) {
    // Access refresh trigger to make this reactive
    _refreshTrigger.value;
    return _cachedResults[topicIndex] ??
        {'correct': 0, 'wrong': 0, 'percentage': 0.0};
  }

  /// Manually refresh all cached results
  Future<void> refreshAllResults() async {
    await _loadAllCachedResults();
  }

  /// Refresh result for a specific topic
  Future<void> refreshTopicResult(int topicIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await _calculateOverallResultFromPrefs(topicIndex, prefs);
    _cachedResults[topicIndex] = result;
    _refreshTrigger.value++;
  }
}
