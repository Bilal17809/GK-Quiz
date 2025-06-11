import 'package:get/get.dart';
import 'package:template/core/db_service/question_db_service.dart';
import 'package:template/core/local_storage/shared_preferences_storage.dart';
import 'package:template/core/models/questions_data.dart';
import 'package:template/presentations/progress/controller/progress_controller.dart';

class QnaController extends GetxController {
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

  // Load questions for specific topic
  Future<void> loadQuestionsForTopic(String topic) async {
    isLoading.value = true;
    try {
      final questionsFromDb = await DBService.getQuestionsByTopic(topic);
      questionsList.assignAll(questionsFromDb);

      // Load previously revealed answers from SharedPreferences
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

  // Load revealed answers from SharedPreferences
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

  // Method to reveal answer for a specific question
  Future<void> revealAnswer(int questionIndex) async {
    revealedAnswers[questionIndex] = true;

    // Save to SharedPreferences
    if (_topic != null) {
      String key = 'revealed_answer_${_topic}_$questionIndex';
      await _prefsService.setBool(key, true);

      // Update learn progress - increment revealed answers count
      await _updateLearnProgress();
    }
  }

  // Update learn progress count in SharedPreferences
  Future<void> _updateLearnProgress() async {
    if (_topic == null) return;

    String progressKey = 'learn_progress_${_topic}';
    int currentProgress = _prefsService.getInt(progressKey, defaultValue: 0);
    int newProgress = revealedAnswers.length;

    // Only update if progress has increased
    if (newProgress > currentProgress) {
      await _prefsService.setInt(progressKey, newProgress);

      // Trigger refresh in ProgressController if it exists
      try {
        final progressController = Get.find<ProgressController>();
        progressController.refreshLearnProgress();
      } catch (e) {
        // ProgressController might not be initialized yet
        print('ProgressController not found: $e');
      }
    }
  }

  // Method to check if answer is revealed for a specific question
  bool isAnswerRevealed(int questionIndex) {
    return revealedAnswers[questionIndex] ?? false;
  }

  // Method to get the actual option text based on the correct answer
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
        return question.answer; // fallback to answer field if it's not A,B,C,D
    }
  }

  // Get total revealed answers for current topic
  int getTotalRevealedAnswers() {
    return revealedAnswers.length;
  }

  // Get total questions for current topic
  int getTotalQuestions() {
    return questionsList.length;
  }

  // Clear revealed answers (if needed for reset functionality)
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

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}
