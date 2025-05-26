import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:template/core/db_service/question_db_service.dart';
import 'package:template/core/models/category_model.dart';
import 'package:template/core/models/questions_data.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:toastification/toastification.dart';

class QuestionsController extends GetxController {
  // Observable collections and state
  final RxList<QuestionsModel> questions = <QuestionsModel>[].obs;
  final RxBool isLoadingQuestions = true.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxMap<int, String> selectedAnswers = <int, String>{}.obs;
  final RxMap<int, bool> shouldShowAnswerResults = <int, bool>{}.obs;
  final RxMap<String, int> topicCounts = <String, int>{}.obs;
  final RxInt totalQuestionsInTopic = 0.obs;

  // Categories state
  final RxList<CategoryModel> questionCategories = <CategoryModel>[].obs;
  final RxBool isLoadingCategories = false.obs;
  final RxString currentTopic = ''.obs;

  // Page navigation controller
  late PageController questionsPageController = PageController();

  // Call this method from the screen to load questions for a specific topic
  void loadQuestionsForTopic(String topic) {
    _loadQuestionsForTopic(topic);
  }

  // Call this method to load categories for a specific topic
  void loadCategoriesForTopic(String topic) {
    currentTopic.value = topic;
    _loadCategoriesForTopic(topic);
  }

  // Load questions for a specific category (20 questions each)
  void loadQuestionsForCategory(String topic, int categoryIndex) {
    _loadQuestionsForCategory(topic, categoryIndex);
  }

  @override
  void onClose() {
    questionsPageController.dispose();
    super.onClose();
  }

  Future<void> loadAllTopicCounts(List<String> topicNames) async {
    for (String topic in topicNames) {
      final questionsForTopic = await DBService.getQuestionsByTopic(topic);
      topicCounts[topic] = questionsForTopic.length;
    }
  }

  // Loads categories for the specified topic
  Future<void> _loadCategoriesForTopic(String topic) async {
    isLoadingCategories.value = true;

    final allQuestionsForTopic = await DBService.getQuestionsByTopic(topic);

    if (allQuestionsForTopic.isNotEmpty) {
      final totalQuestions = allQuestionsForTopic.length;
      final numberOfCategories = (totalQuestions / 20).floor();
      final categories = <CategoryModel>[];

      for (int i = 0; i < numberOfCategories; i++) {
        final startIndex = i * 20;
        final endIndex = startIndex + 20;

        categories.add(
          CategoryModel(
            categoryIndex: i + 1,
            title: 'Category ${i + 1}',
            questionsRange: '${startIndex + 1} - $endIndex',
            totalQuestions: 20,
            topic: topic,
          ),
        );
      }

      questionCategories.assignAll(categories);
    } else {
      questionCategories.clear();
      Get.snackbar(
        'Error',
        'No questions available for this topic.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    isLoadingCategories.value = false;
  }

  // Loads questions for the specified topic from the database
  Future<void> _loadQuestionsForTopic(String topic) async {
    isLoadingQuestions.value = true;
    final questionsFromDb = await DBService.getQuestionsByTopic(topic);
    questions.assignAll(questionsFromDb);
    isLoadingQuestions.value = false;
  }

  // Loads questions for a specific category
  Future<void> _loadQuestionsForCategory(
    String topic,
    int categoryIndex,
  ) async {
    isLoadingQuestions.value = true;

    final allQuestionsForTopic = await DBService.getQuestionsByTopic(topic);

    // Check if the list has enough questions for the requested category
    final startIndex = (categoryIndex - 1) * 20;

    if (allQuestionsForTopic.length > startIndex) {
      final categoryQuestions =
          allQuestionsForTopic.skip(startIndex).take(20).toList();
      questions.assignAll(categoryQuestions);
    } else {
      questions.clear();
      Get.snackbar(
        'Error',
        'No questions are available for this Category at the moment.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    isLoadingQuestions.value = false;
  }

  // Reset states when starting a new quiz
  void resetQuizState() {
    currentQuestionIndex.value = 0;
    selectedAnswers.clear();
    shouldShowAnswerResults.clear();
    questionsPageController = PageController();
    // questionsPageController.dispose();
    // questionsPageController = PageController();
  }

  // Get progress percentage for step indicator (0-100)
  int getProgressPercentage() {
    if (questions.isEmpty) return 0;
    return ((currentQuestionIndex.value + 1) * 100 / questions.length).round();
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

  // Navigates to the next question
  void goToNextQuestion() {
    if (selectedAnswers.containsKey(currentQuestionIndex.value)) {
      if (currentQuestionIndex.value < questions.length - 1) {
        questionsPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // After last question, navigate to the result screen
        Get.toNamed(RoutesName.resultScreen);
      }
    } else {
      // This will now run if no answer is selected
      toastification.show(
        type: ToastificationType.warning,
        title: Text('Select an Option'),
        description: Text(
          'Please select an answer before moving to the next question.',
        ),
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 2),
        primaryColor: kCoral,
        margin: EdgeInsets.all(8),
        closeOnClick: true,
        alignment: Alignment.bottomCenter,
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

  // Shows the 50:50 snackbar
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
