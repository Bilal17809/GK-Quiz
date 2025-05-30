import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:template/core/db_service/question_db_service.dart';
import 'package:template/core/models/questions_data.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';
import 'package:toastification/toastification.dart';

import '../../../core/common_audios/quiz_sounds.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';

class CustomizedQuizController extends GetxController {
  // Observable collections and state
  final RxList<QuestionsModel> questionsList = <QuestionsModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString currentTopic = ''.obs;
  final RxInt questionCount = 0.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxMap<int, String> selectedAnswers = <int, String>{}.obs;
  final RxMap<int, bool> shouldShowAnswerResults = <int, bool>{}.obs;

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

  // Load limited questions for specific topic
  Future<void> loadQuestionsForTopic(String topic, int count) async {
    isLoading.value = true;
    try {
      final allQuestionsFromDb = await DBService.getQuestionsByTopic(topic);

      // Shuffle and take only the requested number of questions
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
  }

  void goToNextQuestion() {
    if (selectedAnswers.containsKey(currentQuestionIndex.value)) {
      if (currentQuestionIndex.value < questionsList.length - 1) {
        quizPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // Navigate to result screen
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
      quizPageController.previousPage(
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
