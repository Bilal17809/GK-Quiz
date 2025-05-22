import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:template/core/db_service/question_db_service.dart';
import 'package:template/core/models/questions_data.dart';
import 'package:template/core/theme/app_colors.dart';

class QuestionsController extends GetxController {
  // Observable collections and state
  final RxList<QuestionsModel> questions = <QuestionsModel>[].obs;
  final RxBool isLoadingQuestions = true.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxMap<int, String> selectedAnswers = <int, String>{}.obs;
  final RxMap<int, bool> shouldShowAnswerResults = <int, bool>{}.obs;

  // Page navigation controller
  late PageController questionsPageController = PageController();

  // Get the topic from navigation arguments
  String get currentTopic => Get.arguments['topic'] ?? '';

  @override
  void onInit() {
    super.onInit();
    _loadQuestionsForTopic();
  }

  @override
  void onClose() {
    questionsPageController.dispose();
    super.onClose();
  }

  // Retrieves all topics with their question counts from the database
  Future<Map<String, int>> getTopicsWithQuestionCounts() async {
    final allQuestions = await DBService.getAllQuestions();
    final Map<String, int> topicCounts = {};

    for (var question in allQuestions) {
      topicCounts[question.topicName] =
          (topicCounts[question.topicName] ?? 0) + 1;
    }

    return topicCounts;
  }

  // Loads questions for the current topic from the database
  Future<void> _loadQuestionsForTopic() async {
    try {
      isLoadingQuestions.value = true;
      final questionsFromDb = await DBService.getQuestionsByTopic(currentTopic);
      questions.assignAll(questionsFromDb);
    } catch (e) {
      // Shows an error snackbar with the given message
      Get.snackbar(
        'Error',
        'Failed to loading questions from the database: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingQuestions.value = false;
    }
  }

  // Handles user's answer selection for a specific question
  void handleAnswerSelection(int questionIndex, String selectedOption) {
    selectedAnswers[questionIndex] = selectedOption;
    shouldShowAnswerResults[questionIndex] = true;

    // Refresh observables to trigger UI updates
    selectedAnswers.refresh();
    shouldShowAnswerResults.refresh();
  }

  // Updates the current question index when page changes
  void onPageChanged(int index) {
    currentQuestionIndex.value = index;
  }

  // Navigates to the next question if available
  void goToNextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      questionsPageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Navigates to the previous question if available
  void goToPreviousQuestion() {
    if (currentQuestionIndex.value > 0) {
      questionsPageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Shows the 50:50 snanckbar
  void use5050Hint() {
    Get.snackbar(
      'Hint Used',
      '50:50 hint activated!',
      snackPosition: SnackPosition.TOP,
    );
  }

  // Determines the background color for an answer option based on correctness and selection
  Color getOptionBackgroundColor(
    bool showAnswer,
    String correctLetter,
    String currentLetter,
    String? selectedLetter,
  ) {
    if (!showAnswer) return Colors.transparent;
    final isCorrect = correctLetter == currentLetter;
    final isSelected = selectedLetter == currentLetter;

    if (isCorrect) {
      return kDarkGreen1.withValues(alpha: 0.25);
    } else if (isSelected) {
      return kRed.withValues(alpha: 0.25);
    }
    return Colors.transparent;
  }

  // Determines the color for the option letter container
  Color getLetterContainerColor(
    bool showAnswer,
    String correctAnswer,
    String letter,
    String? selectedOption,
  ) {
    if (!showAnswer) return greyColor.withOpacity(0.1);
    final isCorrect = correctAnswer == letter;
    final isSelected = selectedOption == letter;

    if (isCorrect) {
      return kDarkGreen1;
    } else if (isSelected) {
      return kRed;
    }
    return greyColor.withOpacity(0.1);
  }
}
