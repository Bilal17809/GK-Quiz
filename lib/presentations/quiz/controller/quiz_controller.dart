import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_audios/quiz_sounds.dart';
import 'package:template/core/db_service/question_db_service.dart';
import 'package:template/core/models/category_model.dart';
import 'package:template/core/models/questions_data.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:toastification/toastification.dart';

import '../../../core/common_widgets/grid_data.dart';

class QuizController extends GetxController {
  // Observable collections and state
  final RxList<QuestionsModel> questionsList = <QuestionsModel>[].obs;
  final RxBool isLoadingQuestions = true.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxMap<int, String> selectedAnswers = <int, String>{}.obs;
  final RxMap<int, bool> shouldShowAnswerResults = <int, bool>{}.obs;
  final RxMap<String, int> topicCounts = <String, int>{}.obs;
  final RxInt totalQuestionsInTopic = 0.obs;

  final RxList<CategoryModel> questionCategories = <CategoryModel>[].obs;
  final RxBool isLoadingCategories = false.obs;
  final RxString currentTopic = ''.obs;

  int? _categoryIndex;
  int? get categoryIndex => _categoryIndex;

  late PageController questionsPageController = PageController();

  @override
  void onInit() {
    super.onInit();
    _initializeArguments();
  }

  void _initializeArguments() {
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _categoryIndex = args['categoryIndex'];
    }
  }

  void updateArguments(Map<String, dynamic>? arguments) {
    if (arguments != null) {
      _categoryIndex = arguments['categoryIndex'];
    }
  }

  void loadQuestionsForTopic(String topic) {
    _loadQuestionsForTopic(topic);
  }

  void loadCategoriesForTopic(String topic) {
    currentTopic.value = topic;
    _loadCategoriesForTopic(topic);
  }

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

  Future<void> _loadQuestionsForTopic(String topic) async {
    isLoadingQuestions.value = true;
    final questionsFromDb = await DBService.getQuestionsByTopic(topic);
    questionsList.assignAll(questionsFromDb);
    isLoadingQuestions.value = false;
  }

  Future<void> _loadQuestionsForCategory(
    String topic,
    int categoryIndex,
  ) async {
    isLoadingQuestions.value = true;
    final allQuestionsForTopic = await DBService.getQuestionsByTopic(topic);
    final startIndex = (categoryIndex - 1) * 20;

    if (allQuestionsForTopic.length > startIndex) {
      final categoryQuestions =
          allQuestionsForTopic.skip(startIndex).take(20).toList();
      questionsList.assignAll(categoryQuestions);
    } else {
      questionsList.clear();
      Get.snackbar(
        'Error',
        'No questions are available for this Category at the moment.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    isLoadingQuestions.value = false;
  }

  void resetQuizState() {
    currentQuestionIndex.value = 0;
    selectedAnswers.clear();
    shouldShowAnswerResults.clear();
    questionsPageController = PageController();
  }

  int getProgressPercentage() {
    if (questionsList.isEmpty) return 0;
    return ((currentQuestionIndex.value + 1) * 100 / questionsList.length)
        .round();
  }

  void handleAnswerSelection(int questionIndex, String selectedOption) {
    selectedAnswers[questionIndex] = selectedOption;
    shouldShowAnswerResults[questionIndex] = true;

    final correctAnswer = questionsList[questionIndex].answer;
    if (selectedOption == correctAnswer) {
      QuizSounds.playCorrectSound();
    } else {
      QuizSounds.playWrongSound();
    }

    selectedAnswers.refresh();
    shouldShowAnswerResults.refresh();
  }

  void onPageChanged(int index) {
    currentQuestionIndex.value = index;
    QuizSounds.clearSound();
  }

  void goToNextQuestion() {
    if (selectedAnswers.containsKey(currentQuestionIndex.value)) {
      if (currentQuestionIndex.value < questionsList.length - 1) {
        questionsPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        final topicName = currentTopic.value;
        int topicIndex = gridTexts.indexOf(topicName);
        if (topicIndex == -1) topicIndex = 0;
        // final catIndex = _categoryIndex ?? 1;
        QuizSounds.playCompletionSound();
        Get.toNamed(
          RoutesName.resultScreen,
          arguments: {
            'topicIndex': topicIndex,
            'categoryIndex': categoryIndex,
            'topic': topicName,
            'fromCustomQuiz': false,
          },
        );
      }
    } else {
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

  void goToPreviousQuestion() {
    if (currentQuestionIndex.value > 0) {
      questionsPageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void use5050Hint() {
    Get.snackbar(
      'Hint Used',
      '50:50 hint activated!',
      snackPosition: SnackPosition.TOP,
    );
  }
}
