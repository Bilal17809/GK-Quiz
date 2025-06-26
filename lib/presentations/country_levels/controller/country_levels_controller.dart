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
  final RxInt refreshTrigger = 0.obs;

  SharedPreferencesService get prefsService => _prefsService;

  @override
  void onInit() {
    super.onInit();
    ever(_checkQuizControllerReady(), (ready) {
      if (ready) {
        loadAllCachedResults();
      }
    });
  }

  RxBool _checkQuizControllerReady() {
    final ready = false.obs;
    Future.microtask(() {
      try {
        Get.find<QuizController>();
        ready.value = true;
      } catch (e) {
        Future.delayed(Duration(milliseconds: 100), () {
          try {
            Get.find<QuizController>();
            ready.value = true;
          } catch (e) {
            debugPrint('QuizController not ready: $e');
          }
        });
      }
    });
    return ready;
  }

  void loadAllCachedResults() {
    try {
      QuizController? quizController;

      // Safely get QuizController
      try {
        quizController = Get.find<QuizController>();
      } catch (e) {
        debugPrint('QuizController not found: $e');
        return;
      }

      if (countryTexts.isEmpty) {
        debugPrint('countryTexts is empty');
        return;
      }

      for (int topicIndex = 0; topicIndex < countryTexts.length; topicIndex++) {
        final topicName = countryTexts[topicIndex];
        final totalQuestionsInTopic =
            quizController.topicCounts[topicName] ?? 0;

        final result = _prefsService.calculateOverallResult(
          topicIndex,
          totalQuestionsInTopic,
          keyPrefix: 'country_result',
        );

        _cachedResults[topicIndex] = result;
      }

      refreshTrigger.value++;
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
    try {
      await _prefsService.saveQuizResult(
        topicIndex: topicIndex,
        categoryIndex: categoryIndex,
        correctAnswers: correctAnswers,
        wrongAnswers: wrongAnswers,
        percentage: percentage,
        keyPrefix: 'country_result',
      );

      QuizController? quizController;
      try {
        quizController = Get.find<QuizController>();
      } catch (e) {
        debugPrint('QuizController not found during save: $e');
        return;
      }

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
        refreshTrigger.value++;
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
      QuizController? quizController;
      try {
        quizController = Get.find<QuizController>();
      } catch (e) {
        debugPrint('QuizController not found: $e');
        return {'correct': 0, 'wrong': 0, 'percentage': 0.0};
      }

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
      refreshTrigger.value; // Make reactive
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
      QuizController? quizController;
      try {
        quizController = Get.find<QuizController>();
      } catch (e) {
        debugPrint('QuizController not found: $e');
        return;
      }

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
      refreshTrigger.value++;
    } catch (e) {
      debugPrint('Error refreshing topic result: $e');
    }
  }

  @override
  void onClose() {
    _cachedResults.clear();
    super.onClose();
  }
}
