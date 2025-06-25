import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/common_widgets/country_grid.dart';
import '../../../core/local_storage/shared_preferences_storage.dart';
import '../../quiz/controller/quiz_controller.dart';

class CountryLevelsController extends GetxController {
  final SharedPreferencesService _prefsService = SharedPreferencesService.to;
  final RxMap<int, Map<String, dynamic>> _cachedResults =
      <int, Map<String, dynamic>>{}.obs;
  final RxInt refreshTrigger = 0.obs;

  SharedPreferencesService get prefsService => _prefsService;

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() => loadAllCachedResults());
  }

  void loadAllCachedResults() {
    final quizController = Get.find<QuizController>();
    for (int topicIndex = 0; topicIndex < countryTexts.length; topicIndex++) {
      final topicName = countryTexts[topicIndex];
      final totalQuestionsInTopic = quizController.topicCounts[topicName] ?? 0;
      final result = _prefsService.calculateOverallResult(
        topicIndex,
        totalQuestionsInTopic,
        keyPrefix: 'country_result',
      );
      _cachedResults[topicIndex] = result;
    }
    refreshTrigger.value++;
  }

  Future<void> saveQuizResult({
    required int topicIndex,
    required int categoryIndex,
    required int correctAnswers,
    required int wrongAnswers,
    required double percentage,
  }) async {
    await _prefsService.saveQuizResult(
      topicIndex: topicIndex,
      categoryIndex: categoryIndex,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      percentage: percentage,
      keyPrefix: 'country_result',
    );

    final quizController = Get.find<QuizController>();
    final topicName = countryTexts[topicIndex];
    final totalQuestionsInTopic = quizController.topicCounts[topicName] ?? 0;
    final updatedResult = _prefsService.calculateOverallResult(
      topicIndex,
      totalQuestionsInTopic,
      keyPrefix: 'country_result',
    );
    _cachedResults[topicIndex] = updatedResult;
    refreshTrigger.value++;

    String baseKey = 'country_result$topicIndex$categoryIndex';
    final savedCorrect = _prefsService.getInt('${baseKey}_correct');
    final savedWrong = _prefsService.getInt('${baseKey}_wrong');
    final savedPercentage = _prefsService.getDouble('${baseKey}percentage');
    debugPrint(
      'Verified saved data - Correct: $savedCorrect, Wrong: $savedWrong, Percentage: $savedPercentage',
    );
  }

  Future<Map<String, dynamic>> getQuizResult(
    int topicIndex,
    int categoryIndex,
  ) async {
    return _prefsService.getQuizResult(
      topicIndex,
      categoryIndex,
      keyPrefix: 'country_result',
    );
  }

  Map<String, dynamic> getOverallResult(int topicIndex) {
    final quizController = Get.find<QuizController>();
    final topicName = countryTexts[topicIndex];
    final totalQuestionsInTopic = quizController.topicCounts[topicName] ?? 0;
    return _prefsService.calculateOverallResult(
      topicIndex,
      totalQuestionsInTopic,
      keyPrefix: 'country_result',
    );
  }

  Map<String, dynamic> getOverallResultSync(int topicIndex) {
    refreshTrigger.value;
    return _cachedResults[topicIndex] ??
        {'correct': 0, 'wrong': 0, 'percentage': 0.0};
  }

  Future<void> refreshAllResults() async {
    loadAllCachedResults();
  }

  void refreshTopicResult(int topicIndex) {
    final quizController = Get.find<QuizController>();
    final topicName = countryTexts[topicIndex];
    final totalQuestionsInTopic = quizController.topicCounts[topicName] ?? 0;
    final result = _prefsService.calculateOverallResult(
      topicIndex,
      totalQuestionsInTopic,
      keyPrefix: 'country_result',
    );
    _cachedResults[topicIndex] = result;
    refreshTrigger.value++;
  }
}
