import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/presentations/customized_quiz/controller/cutomized_quiz_controller.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../widgets/customized_quiz_content.dart';

class CustomizedQuizScreen extends StatelessWidget {
  const CustomizedQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customizedQuizController = Get.put(CustomizedQuizController());
    final args = Get.arguments as Map<String, dynamic>;
    final topic = args['topic'] ?? '';
    final questionCount = args['questionCount'] ?? 0;

    return Scaffold(
      backgroundColor: kWhite,
      appBar: CustomAppBar(
        subtitle: '$topic - Questions: $questionCount',
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
        () => CustomizedQuizContent(
          isLoading: customizedQuizController.isLoading.value,
          questions: customizedQuizController.questionsList,
          pageController: customizedQuizController.quizPageController,
          currentIndex: customizedQuizController.currentQuestionIndex.value,
          onPageChanged: customizedQuizController.onPageChanged,
          selectedAnswers: customizedQuizController.selectedAnswers,
          showAnswers: customizedQuizController.shouldShowAnswerResults,
          onAnswerSelected: customizedQuizController.handleAnswerSelection,
        ),
      ),
    );
  }
}
