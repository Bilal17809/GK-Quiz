import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';
import 'package:template/presentations/quiz/widgets/quiz_content.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments with proper null checking
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments == null) {
      // Handle case where no arguments are passed
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: Missing quiz parameters'),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final String topic = arguments['topic'] ?? '';
    final int topicIndex = arguments['topicIndex'] ?? arguments['index'] ?? 1;
    final int categoryIndex = arguments['categoryIndex'] ?? 1;

    final QuizController controller = Get.put(QuizController());

    // Update controller arguments after initialization
    controller.updateArguments({
      'topic': topic,
      'topicIndex': topicIndex,
      'categoryIndex': categoryIndex,
    });

    // Load questions based on category
    controller.loadQuestionsForCategory(topic, categoryIndex);

    return Scaffold(
      backgroundColor: kWhite,
      appBar: CustomAppBar(
        subtitle: '$topic - Level $categoryIndex',
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 24),
            height: 35,
            width: 35,
            decoration: roundedDecoration.copyWith(
              color: kOrange,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset('assets/images/notes.png', color: kWhite),
          ),
        ],
      ),
      body: Obx(
        () => QuizContent(
          isLoading: controller.isLoadingQuestions.value,
          questions: controller.questionsList,
          pageController: controller.questionsPageController,
          currentIndex: controller.currentQuestionIndex.value,
          onPageChanged: controller.onPageChanged,
          selectedAnswers: controller.selectedAnswers,
          showAnswers: controller.shouldShowAnswerResults,
          onAnswerSelected: controller.handleAnswerSelection,
        ),
      ),
    );
  }
}
