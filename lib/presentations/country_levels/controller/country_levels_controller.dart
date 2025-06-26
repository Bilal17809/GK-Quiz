import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/country_grid.dart';
import '../../../core/local_storage/shared_preferences_storage.dart';
import '../../progress/controller/progress_controller.dart';
import '../../quiz/controller/quiz_controller.dart';

class CountryLevelsController extends GetxController {
  final SharedPreferencesService _prefsService = SharedPreferencesService.to;
  final RxMap<int, Map<String, dynamic>> _cachedResults =
      <int, Map<String, dynamic>>{}.obs;
  final RxMap<String, Map<String, dynamic>> _cachedCategoryResults =
      <String, Map<String, dynamic>>{}.obs;
  final RxInt _refreshTrigger = 0.obs;

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
      for (int categoryIndex = 1; categoryIndex <= 20; categoryIndex++) {
        final categoryKey = '${topicIndex}_$categoryIndex';
        final categoryResult = _prefsService.getQuizResult(
          topicIndex,
          categoryIndex,
          keyPrefix: 'country_result',
        );
        _cachedCategoryResults[categoryKey] = categoryResult;
      }
    }
    _refreshTrigger.value++;
  }

  Map<String, dynamic> getCategoryResultSync(
    int topicIndex,
    int categoryIndex,
  ) {
    try {
      _refreshTrigger.value;
      final categoryKey = '${topicIndex}_$categoryIndex';
      return _cachedCategoryResults[categoryKey] ??
          {'correct': 0, 'wrong': 0, 'percentage': 0.0};
    } catch (e) {
      debugPrint('Error getting category result sync: $e');
      return {'correct': 0, 'wrong': 0, 'percentage': 0.0};
    }
  }

  Future<void> saveQuizResult({
    required int topicIndex,
    required int categoryIndex,
    required int correctAnswers,
    required int wrongAnswers,
    required double percentage,
  }) async {
    try {
      await _prefsService.saveQuizResult(
        topicIndex: topicIndex,
        categoryIndex: categoryIndex,
        correctAnswers: correctAnswers,
        wrongAnswers: wrongAnswers,
        percentage: percentage,
        keyPrefix: 'country_result',
      );
      final categoryKey = '${topicIndex}_$categoryIndex';
      _cachedCategoryResults[categoryKey] = {
        'correct': correctAnswers,
        'wrong': wrongAnswers,
        'percentage': percentage,
      };

      final quizController = Get.find<QuizController>();
      if (topicIndex >= 0 && topicIndex < countryTexts.length) {
        final topicName = countryTexts[topicIndex];
        final totalQuestionsInTopic =
            quizController.topicCounts[topicName] ?? 0;
        final updatedResult = _prefsService.calculateOverallResult(
          topicIndex,
          totalQuestionsInTopic,
          keyPrefix: 'country_result',
        );
        _cachedResults[topicIndex] = updatedResult;
        _refreshTrigger.value++;
      }
      String baseKey = 'country_result$topicIndex$categoryIndex';
      final savedCorrect = _prefsService.getInt('${baseKey}_correct');
      final savedWrong = _prefsService.getInt('${baseKey}_wrong');
      final savedPercentage = _prefsService.getDouble('${baseKey}_percentage');

      debugPrint(
        'Verified saved data - Correct: $savedCorrect, Wrong: $savedWrong, Percentage: $savedPercentage',
      );

      _notifyProgressController();
    } catch (e) {
      debugPrint('Error saving quiz result: $e');
    }
  }

  void _notifyProgressController() {
    try {
      final progressController = Get.find<ProgressController>();
      Future.delayed(Duration(milliseconds: 50), () {
        progressController.refreshStats();
        progressController.loadDailyPerformance();
      });
    } catch (e) {
      debugPrint('ProgressController not found: $e');
    }
  }

  Future<Map<String, dynamic>> getQuizResult(
    int topicIndex,
    int categoryIndex,
  ) async {
    try {
      return _prefsService.getQuizResult(
        topicIndex,
        categoryIndex,
        keyPrefix: 'country_result',
      );
    } catch (e) {
      debugPrint('Error getting quiz result: $e');
      return {'correct': 0, 'wrong': 0, 'percentage': 0.0};
    }
  }

  Map<String, dynamic> getOverallResult(int topicIndex) {
    try {
      final quizController = Get.find<QuizController>();
      if (topicIndex < 0 || topicIndex >= countryTexts.length) {
        debugPrint('Invalid topicIndex: $topicIndex');
        return {'correct': 0, 'wrong': 0, 'percentage': 0.0};
      }
      final topicName = countryTexts[topicIndex];
      final totalQuestionsInTopic = quizController.topicCounts[topicName] ?? 0;
      return _prefsService.calculateOverallResult(
        topicIndex,
        totalQuestionsInTopic,
        keyPrefix: 'country_result',
      );
    } catch (e) {
      debugPrint('Error getting overall result: $e');
      return {'correct': 0, 'wrong': 0, 'percentage': 0.0};
    }
  }

  Map<String, dynamic> getOverallResultSync(int topicIndex) {
    try {
      _refreshTrigger.value;
      return _cachedResults[topicIndex] ??
          {'correct': 0, 'wrong': 0, 'percentage': 0.0};
    } catch (e) {
      debugPrint('Error getting overall result sync: $e');
      return {'correct': 0, 'wrong': 0, 'percentage': 0.0};
    }
  }

  Future<void> refreshAllResults() async {
    loadAllCachedResults();
  }

  void refreshTopicResult(int topicIndex) {
    try {
      final quizController = Get.find<QuizController>();
      if (topicIndex < 0 || topicIndex >= countryTexts.length) {
        debugPrint('Invalid topicIndex: $topicIndex');
        return;
      }
      final topicName = countryTexts[topicIndex];
      final totalQuestionsInTopic = quizController.topicCounts[topicName] ?? 0;

      final result = _prefsService.calculateOverallResult(
        topicIndex,
        totalQuestionsInTopic,
        keyPrefix: 'country_result',
      );
      _cachedResults[topicIndex] = result;

      for (int categoryIndex = 1; categoryIndex <= 20; categoryIndex++) {
        final categoryKey = '${topicIndex}_$categoryIndex';
        final categoryResult = _prefsService.getQuizResult(
          topicIndex,
          categoryIndex,
          keyPrefix: 'country_result',
        );
        _cachedCategoryResults[categoryKey] = categoryResult;
      }

      _refreshTrigger.value++;
    } catch (e) {
      debugPrint('Error refreshing topic result: $e');
    }
  }

  void clearAllCaches() {
    try {
      _cachedResults.clear();
      _cachedCategoryResults.clear();

      for (int topicIndex = 0; topicIndex < countryTexts.length; topicIndex++) {
        _cachedResults[topicIndex] = {
          'correct': 0,
          'wrong': 0,
          'percentage': 0.0,
        };

        for (int categoryIndex = 1; categoryIndex <= 20; categoryIndex++) {
          final categoryKey = '${topicIndex}_$categoryIndex';
          _cachedCategoryResults[categoryKey] = {
            'correct': 0,
            'wrong': 0,
            'percentage': 0.0,
          };
        }
      }
      _refreshTrigger.value++;

      debugPrint('All caches cleared successfully');
    } catch (e) {
      debugPrint('Error clearing caches: $e');
    }
  }

  @override
  void onClose() {
    _cachedResults.clear();
    _cachedCategoryResults.clear();
    super.onClose();
  }
}
