import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/presentations/country_quiz/controller/country_quiz_controller.dart';

import '../../../core/common_audios/quiz_sounds.dart';
import '../../../core/models/questions_data.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/ui_helpers.dart';
import '../widgets/country_quiz_page.dart';

class CountryQuizScreen extends StatefulWidget {
  const CountryQuizScreen({super.key});

  @override
  State<CountryQuizScreen> createState() => _CountryQuizScreenState();
}

class _CountryQuizScreenState extends State<CountryQuizScreen> {
  Timer? _autoProgressTimer;
  late CountryQuizController countryQuizController;
  late String topic;
  late int topicIndex;
  late int categoryIndex;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments as Map<String, dynamic>;
    topic = arguments['topic'] ?? '';
    topicIndex = arguments['topicIndex'] ?? arguments['index'] ?? 1;
    categoryIndex = arguments['categoryIndex'] ?? 1;

    countryQuizController = Get.put(CountryQuizController());

    // Update controller arguments
    countryQuizController.updateArguments({
      'topic': topic,
      'topicIndex': topicIndex,
      'categoryIndex': categoryIndex,
    });
    countryQuizController.loadQuestionsForCategory(topic, categoryIndex);
  }

  @override
  void dispose() {
    _autoProgressTimer?.cancel();
    super.dispose();
  }

  void _handleAnswerSelection(int questionIndex, String selectedOption) {
    // Prevent multiple selections for the same question
    if (countryQuizController.shouldShowAnswerResults[questionIndex] == true) {
      return;
    }

    // Cancel any existing timer
    _autoProgressTimer?.cancel();

    // Handle the answer selection in controller
    countryQuizController.handleAnswerSelection(questionIndex, selectedOption);

    // Start 2-second timer for auto-progression
    _autoProgressTimer = Timer(Duration(seconds: 1), () {
      _moveToNextQuestion();
    });
  }

  void _moveToNextQuestion() {
    if (countryQuizController.currentQuestionIndex.value <
        countryQuizController.questionsList.length - 1) {
      // Move to next question
      countryQuizController.questionsPageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Quiz completed - navigate to results
      _navigateToResults();
    }
  }

  void _navigateToResults() {
    QuizSounds.playCompletionSound();
    Get.toNamed(
      RoutesName.countryResultScreen,
      arguments: {
        'topicIndex': topicIndex,
        'categoryIndex': categoryIndex,
        'topic': topic,
        'fromCustomQuiz': false,
        'selectedAnswers': countryQuizController.selectedAnswers,
        'questionsList': countryQuizController.questionsList,
      },
    );

    debugPrint('Quiz completed! Navigate to results screen.');
  }

  @override
  Widget build(BuildContext context) {
    final mobileSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        if (countryQuizController.isLoadingQuestions.value) {
          return Center(child: CircularProgressIndicator());
        }

        return PageView.builder(
          controller: countryQuizController.questionsPageController,
          physics: NeverScrollableScrollPhysics(), // Disable manual scrolling
          onPageChanged: countryQuizController.onPageChanged,
          itemCount: countryQuizController.questionsList.length,
          itemBuilder: (context, pageIndex) {
            final question = countryQuizController.questionsList[pageIndex];
            return CountryQuizPage(
              question: question,
              currentIndex: pageIndex,
              totalQuestions: countryQuizController.questionsList.length,
              controller: countryQuizController,
              mobileSize: mobileSize,
              onAnswerSelected: _handleAnswerSelection,
              topicIndex: topicIndex,
              topic: topic,
            );
          },
        );
      }),
    );
  }
}

class QuestionOptions extends StatelessWidget {
  final QuestionsModel question;
  final bool showAnswer;
  final String? selectedOption;
  final Function(String) onOptionSelected;

  const QuestionOptions({
    super.key,
    required this.question,
    required this.showAnswer,
    this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OptionItem(
          letter: 'A',
          option: question.option1,
          showAnswer: showAnswer,
          correctAnswer: question.answer,
          selectedOption: selectedOption,
          onOptionSelected: onOptionSelected,
        ),
        const SizedBox(height: 12),
        OptionItem(
          letter: 'B',
          option: question.option2,
          showAnswer: showAnswer,
          correctAnswer: question.answer,
          selectedOption: selectedOption,
          onOptionSelected: onOptionSelected,
        ),
        const SizedBox(height: 12),
        OptionItem(
          letter: 'C',
          option: question.option3,
          showAnswer: showAnswer,
          correctAnswer: question.answer,
          selectedOption: selectedOption,
          onOptionSelected: onOptionSelected,
        ),
        const SizedBox(height: 12),
        OptionItem(
          letter: 'D',
          option: question.option4,
          showAnswer: showAnswer,
          correctAnswer: question.answer,
          selectedOption: selectedOption,
          onOptionSelected: onOptionSelected,
        ),
      ],
    );
  }
}

class OptionItem extends StatelessWidget {
  final String letter;
  final String option;
  final bool showAnswer;
  final String correctAnswer;
  final String? selectedOption;
  final Function(String) onOptionSelected;

  const OptionItem({
    super.key,
    required this.letter,
    required this.option,
    required this.showAnswer,
    required this.correctAnswer,
    this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          showAnswer
              ? null
              : () {
                debugPrint('Option $letter tapped'); // Debug print
                onOptionSelected(letter);
              },
      child: Container(
        constraints: BoxConstraints(
          minHeight: 56, // minimum height for the container
        ),
        decoration: BoxDecoration(
          border: Border.all(color: kTealGreen1, width: 3),
          color: getOptionBackgroundColor(
            showAnswer,
            correctAnswer,
            letter,
            selectedOption,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Expanded(
                // Option text
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Letter container
              Container(
                margin: const EdgeInsets.only(right: 8),
                height: 35,
                width: 35,
                decoration: roundedDecoration.copyWith(
                  color: getLetterContainerColor(
                    showAnswer,
                    correctAnswer,
                    letter,
                    selectedOption,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(6),
                child: Center(
                  child: Text(
                    letter,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      color:
                          showAnswer &&
                                  (correctAnswer == letter ||
                                      selectedOption == letter)
                              ? kWhite
                              : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
