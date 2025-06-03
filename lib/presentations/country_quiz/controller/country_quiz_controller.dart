import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/common_audios/quiz_sounds.dart';
import '../../../core/db_service/question_db_service.dart';
import '../../../core/models/category_model.dart';
import '../../../core/models/questions_data.dart';

class CountryQuizController extends GetxController {
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
    // Update the selected answer and show results
    selectedAnswers[questionIndex] = selectedOption;
    shouldShowAnswerResults[questionIndex] = true;

    final correctAnswer = questionsList[questionIndex].answer;

    // Play appropriate sound
    if (selectedOption == correctAnswer) {
      QuizSounds.playCorrectSound();
    } else {
      QuizSounds.playWrongSound();
    }

    // Force update the reactive maps
    selectedAnswers.refresh();
    shouldShowAnswerResults.refresh();
  }

  void onPageChanged(int index) {
    currentQuestionIndex.value = index;
    QuizSounds.clearSound();
  }
}
