import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_audios/quiz_sounds.dart';
import '../../../core/common_widgets/grid_data.dart';
import '../../../core/local_storage/shared_preferences_storage.dart';
import '../../../core/service/question_db_service.dart';
import '../../../core/models/category_model.dart';
import '../../../core/models/questions_data.dart';
import '../../../core/routes/routes_name.dart';

class CountryReviewController extends GetxController {
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

  // 50:50 functionality
  final RxMap<int, bool> is5050Used = <int, bool>{}.obs;
  final RxMap<int, List<String>> hiddenOptions = <int, List<String>>{}.obs;

  // Font size functionality
  final RxInt _fontSizeLevel = 0.obs;
  final RxBool _isIncreasing = true.obs;

  static const double _normalQuestionSize = 20.0;
  static const double _bigQuestionSize = 24.0;
  static const double _biggerQuestionSize = 26.0;
  static const double _normalOptionSize = 16.0;
  static const double _bigOptionSize = 18.0;
  static const double _biggerOptionSize = 19.0;

  int? _categoryIndex;
  int? get categoryIndex => _categoryIndex;

  late PageController questionsPageController = PageController();

  @override
  void onInit() {
    super.onInit();
    _initializeArguments();
    _loadFontSizeSettings();
  }

  void _initializeArguments() {
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _categoryIndex = args['categoryIndex'];
    }
  }

  void _loadFontSizeSettings() {
    final savedLevel = SharedPreferencesService.to.getFontSizeLevel();
    final savedDirection = SharedPreferencesService.to.getFontSizeDirection();
    _fontSizeLevel.value = savedLevel;
    _isIncreasing.value = savedDirection;
  }

  Future<void> _saveFontSizeSettings() async {
    await SharedPreferencesService.to.saveFontSizeSettings(
      _fontSizeLevel.value,
      _isIncreasing.value,
    );
  }

  void updateArguments(Map<String, dynamic>? arguments) {
    if (arguments != null) {
      _categoryIndex = arguments['categoryIndex'];
      currentTopic.value = arguments['topic'] ?? '';
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
    currentTopic.value = topic;
    _loadQuestionsForCategory(topic, categoryIndex);
  }

  void preSelectAnswers(Map<int, String> answers) {
    selectedAnswers.addAll(answers);
    for (int index in answers.keys) {
      shouldShowAnswerResults[index] = true;
    }
    selectedAnswers.refresh();
    shouldShowAnswerResults.refresh();
  }

  @override
  void onClose() {
    questionsPageController.dispose();
    super.onClose();
  }

  // Font size methods
  void toggleFontSize() async {
    if (_isIncreasing.value) {
      _fontSizeLevel.value++;
      if (_fontSizeLevel.value >= 2) {
        _isIncreasing.value = false;
      }
    } else {
      _fontSizeLevel.value--;
      if (_fontSizeLevel.value <= 0) {
        _isIncreasing.value = true;
      }
    }
    await _saveFontSizeSettings();
  }

  double getQuestionFontSize() {
    switch (_fontSizeLevel.value) {
      case 0:
        return _normalQuestionSize;
      case 1:
        return _bigQuestionSize;
      case 2:
        return _biggerQuestionSize;
      default:
        return _normalQuestionSize;
    }
  }

  double getOptionFontSize() {
    switch (_fontSizeLevel.value) {
      case 0:
        return _normalOptionSize;
      case 1:
        return _bigOptionSize;
      case 2:
        return _biggerOptionSize;
      default:
        return _normalOptionSize;
    }
  }

  int get fontSizeLevel => _fontSizeLevel.value;

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
    is5050Used.clear();
    hiddenOptions.clear();
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
    hiddenOptions.refresh();
    is5050Used.refresh();
  }

  void goToNextQuestion({
    required String topic,
    required int topicIndex,
    required int categoryIndex,
  }) {
    if (selectedAnswers.containsKey(currentQuestionIndex.value)) {
      if (currentQuestionIndex.value < questionsList.length - 1) {
        questionsPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // Quiz completed, navigate to results screen
        QuizSounds.playCompletionSound();
        Get.toNamed(
          RoutesName.countryResultScreen,
          arguments: {
            'topicIndex': topicIndex,
            'categoryIndex': categoryIndex,
            'topic': topic,
            'fromCustomQuiz': false,
            'selectedAnswers': selectedAnswers,
            'questionsList': questionsList,
          },
        );
      }
    }
  }

  void use5050Hint() {
    final currentIndex = currentQuestionIndex.value;
    if (currentIndex < questionsList.length) {
      final question = questionsList[currentIndex];
      final correctAnswer = question.answer;
      final allOptions = ['A', 'B', 'C', 'D'];
      final incorrectOptions =
          allOptions.where((option) => option != correctAnswer).toList();

      final random = Random();
      final keepIncorrectOption =
          incorrectOptions[random.nextInt(incorrectOptions.length)];

      final optionsToHide =
          incorrectOptions
              .where((option) => option != keepIncorrectOption)
              .toList();

      hiddenOptions[currentIndex] = optionsToHide;
      is5050Used[currentIndex] = true;

      hiddenOptions.refresh();
      is5050Used.refresh();
    }
  }

  bool isOptionHidden(int questionIndex, String option) {
    return hiddenOptions[questionIndex]?.contains(option) ?? false;
  }

  bool is5050UsedForCurrentQuestion() {
    return is5050Used[currentQuestionIndex.value] ?? false;
  }
}
