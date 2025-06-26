import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/local_storage/shared_preferences_storage.dart';
import '../../../core/models/questions_data.dart';
import '../../../core/service/question_db_service.dart';
import '../../progress/controller/progress_controller.dart';

class CountryQnaController extends GetxController {
  final RxList<QuestionsModel> questionsList = <QuestionsModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString currentTopic = ''.obs;
  final RxMap<int, bool> revealedAnswers = <int, bool>{}.obs;
  final SharedPreferencesService _prefsService = SharedPreferencesService.to;

  String? _topic; // Arguments
  String? get topic => _topic;
  SharedPreferencesService get prefsService => _prefsService;

  @override
  void onInit() {
    super.onInit();
    _initializeArguments();
  }

  void _initializeArguments() {
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _topic = args['topic'];
      if (_topic != null) {
        currentTopic.value = _topic!;
        loadQuestionsForTopic(_topic!);
      }
    }
  }

  Future<void> loadQuestionsForTopic(String topic) async {
    isLoading.value = true;
    try {
      final questionsFromDb = await DBService.getQuestionsByTopic(topic);
      questionsList.assignAll(questionsFromDb);
      await _loadRevealedAnswersFromPrefs(topic);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load questions: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadRevealedAnswersFromPrefs(String topic) async {
    revealedAnswers.clear();
    for (int i = 0; i < questionsList.length; i++) {
      String key = 'revealed_answer_${topic}_$i';
      bool isRevealed = _prefsService.getBool(key, defaultValue: false);
      if (isRevealed) {
        revealedAnswers[i] = true;
      }
    }
  }

  Future<void> revealAnswer(int questionIndex) async {
    bool wasAlreadyRevealed = revealedAnswers[questionIndex] ?? false;
    revealedAnswers[questionIndex] = true;

    // Save to SharedPreferences
    if (_topic != null) {
      String key = 'revealed_answer_${_topic}_$questionIndex';
      await _prefsService.setBool(key, true);

      // Only update progress if this is a new reveal
      if (!wasAlreadyRevealed) {
        await _updateLearnProgress();
      }
    }
  }

  // Update learn progress count in SharedPreferences
  Future<void> _updateLearnProgress() async {
    if (_topic == null) return;

    String progressKey = 'learn_progress_${_topic}';

    // FIXED: Use revealedAnswers.length instead of incrementing
    // This matches the QnaController implementation
    int newProgress = revealedAnswers.length;
    int currentProgress = _prefsService.getInt(progressKey, defaultValue: 0);

    // Only update if progress has increased
    if (newProgress > currentProgress) {
      await _prefsService.setInt(progressKey, newProgress);

      try {
        final progressController = Get.find<ProgressController>();
        progressController.refreshLearnProgress();
      } catch (e) {
        debugPrint('ProgressController not found: $e');
      }
    }
  }

  bool isAnswerRevealed(int questionIndex) {
    return revealedAnswers[questionIndex] ?? false;
  }

  String getCorrectOptionText(QuestionsModel question) {
    switch (question.answer.toUpperCase()) {
      case 'A':
        return question.option1;
      case 'B':
        return question.option2;
      case 'C':
        return question.option3;
      case 'D':
        return question.option4;
      default:
        return question.answer;
    }
  }

  int getTotalRevealedAnswers() {
    return revealedAnswers.length;
  }

  int getTotalQuestions() {
    return questionsList.length;
  }

  Future<void> clearRevealedAnswers() async {
    if (_topic == null) return;

    for (int i = 0; i < questionsList.length; i++) {
      String key = 'revealed_answer_${_topic}_$i';
      await _prefsService.remove(key);
    }

    // Clear progress
    String progressKey = 'learn_progress_${_topic}';
    await _prefsService.remove(progressKey);

    revealedAnswers.clear();
  }
}
