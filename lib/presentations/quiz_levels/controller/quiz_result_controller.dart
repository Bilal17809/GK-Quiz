import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/common_widgets/grid_data.dart';
import '../../../core/local_storage/shared_preferences_storage.dart';
import '../../quiz/controller/quiz_controller.dart';

class QuizResultController extends GetxController {
  final SharedPreferencesService _prefsService = SharedPreferencesService.to;
  final RxMap<int, Map<String, dynamic>> _cachedResults =
      <int, Map<String, dynamic>>{}.obs;
  final RxInt _refreshTrigger = 0.obs;

  int get refreshTrigger => _refreshTrigger.value;
  SharedPreferencesService get prefsService => _prefsService;

  @override
  void onInit() {
    super.onInit();
    loadAllCachedResults();
  }

  Future<void> loadAllCachedResults() async{
    try {
      final quizController = Get.find<QuizController>();
      if (gridTexts.isEmpty) {
        debugPrint('gridTexts is empty, skipping cache load');
        return;
      }
      for (int topicIndex = 0; topicIndex < gridTexts.length; topicIndex++) {
        final topicName = gridTexts[topicIndex];
        final totalQuestionsInTopic =
            quizController.topicCounts[topicName] ?? 0;
        final result = _prefsService.calculateOverallResult(
          topicIndex,
          totalQuestionsInTopic,
          keyPrefix: 'result',
        );
        _cachedResults[topicIndex] = result;
      }
      _refreshTrigger.value++;
    } catch (e) {
      debugPrint('Error loading cached results: $e');
    }
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
      keyPrefix: 'result',
    );

    final quizController = Get.find<QuizController>();
    final topicName = gridTexts[topicIndex];
    final totalQuestionsInTopic = quizController.topicCounts[topicName] ?? 0;
    final updatedResult = _prefsService.calculateOverallResult(
      topicIndex,
      totalQuestionsInTopic,
      keyPrefix: 'result',
    );
    _cachedResults[topicIndex] = updatedResult;
    _refreshTrigger.value++;
  }

  Future<Map<String, dynamic>> getQuizResult(
    int topicIndex,
    int categoryIndex,
  ) async {
    return _prefsService.getQuizResult(
      topicIndex,
      categoryIndex,
      keyPrefix: 'result',
    );
  }

  Map<String, dynamic> getOverallResult(int topicIndex) {
    final quizController = Get.find<QuizController>();
    final topicName = gridTexts[topicIndex];
    final totalQuestionsInTopic = quizController.topicCounts[topicName] ?? 0;
    return _prefsService.calculateOverallResult(
      topicIndex,
      totalQuestionsInTopic,
      keyPrefix: 'result',
    );
  }

  Map<String, dynamic> getOverallResultSync(int topicIndex) {
    _refreshTrigger.value; // Make reactive
    return _cachedResults[topicIndex] ??
        {'correct': 0, 'wrong': 0, 'percentage': 0.0};
  }

  Future<void> refreshAllResults() async {
    loadAllCachedResults();
  }

  void refreshTopicResult(int topicIndex) {
    final quizController = Get.find<QuizController>();
    final topicName = gridTexts[topicIndex];
    final totalQuestionsInTopic = quizController.topicCounts[topicName] ?? 0;
    final result = _prefsService.calculateOverallResult(
      topicIndex,
      totalQuestionsInTopic,
      keyPrefix: 'result',
    );
    _cachedResults[topicIndex] = result;
    _refreshTrigger.value++;
  }
}
