import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/presentations/customized_quiz/controller/cutomized_quiz_controller.dart';

import '../../../core/common_widgets/round_image.dart';
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
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customized Quiz',
              style: Get.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text(
              '$topic - Questions: $questionCount',
              style: Get.textTheme.bodyLarge,
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: RoundedButton(
            backgroundColor: kRed,
            onTap: () {
              customizedQuizController.resetQuizState();
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/back.png', color: kWhite),
            ),
          ),
        ),
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
