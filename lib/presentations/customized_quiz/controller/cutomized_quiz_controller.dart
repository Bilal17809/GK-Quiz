import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:template/core/db_service/question_db_service.dart';
import 'package:template/core/models/questions_data.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';

import '../../../core/common_audios/quiz_sounds.dart';
import '../../../core/routes/routes_name.dart';

class CustomizedQuizController extends GetxController {
  final RxList<QuestionsModel> questionsList = <QuestionsModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString currentTopic = ''.obs;
  final RxInt questionCount = 0.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxMap<int, String> selectedAnswers = <int, String>{}.obs;
  final RxMap<int, bool> shouldShowAnswerResults = <int, bool>{}.obs;

  final RxMap<int, bool> is5050Used = <int, bool>{}.obs;
  final RxMap<int, List<String>> hiddenOptions = <int, List<String>>{}.obs;

  // Arguments
  String? _topic;
  int? _questionCount;

  late PageController quizPageController = PageController();

  // Getters
  String? get topic => _topic;
  int? get selectedQuestionCount => _questionCount;

  @override
  void onInit() {
    super.onInit();
    _initializeArguments();
    Get.put(QuizController());
  }

  @override
  void onClose() {
    quizPageController.dispose();
    super.onClose();
  }

  void _initializeArguments() {
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _topic = args['topic'];
      _questionCount = args['questionCount'];

      if (_topic != null) {
        currentTopic.value = _topic!;
        questionCount.value = _questionCount!;
        loadQuestionsForTopic(_topic!, _questionCount!);
      }
    }
  }

  Future<void> loadQuestionsForTopic(String topic, int count) async {
    isLoading.value = true;
    try {
      final allQuestionsFromDb = await DBService.getQuestionsByTopic(topic);
      allQuestionsFromDb.shuffle();
      final limitedQuestions = allQuestionsFromDb.take(count).toList();

      questionsList.assignAll(limitedQuestions);
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

  // Quiz interaction methods
  void resetQuizState() {
    currentQuestionIndex.value = 0;
    selectedAnswers.clear();
    shouldShowAnswerResults.clear();
    quizPageController = PageController();
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

  void goToNextQuestion() {
    if (selectedAnswers.containsKey(currentQuestionIndex.value)) {
      if (currentQuestionIndex.value < questionsList.length - 1) {
        quizPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        QuizSounds.playCompletionSound();
        Get.toNamed(
          RoutesName.resultScreen,
          arguments: {
            'topic': currentTopic.value,
            'isCustomizedQuiz': true,
            'questionCount': questionCount.value,
            'fromCustomQuiz': true,
          },
        );
      }
    }
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex.value > 0) {
      quizPageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
