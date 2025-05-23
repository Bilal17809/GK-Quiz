import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/questions/controller/questions_controller.dart';
import 'package:template/presentations/questions/widgets/question_content.dart';

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String topic = Get.arguments['topic'];
    final int? categoryIndex = Get.arguments['categoryIndex'];

    final QuestionsController controller = Get.put(QuestionsController());

    // Load questions based on whether category

    controller.loadQuestionsForCategory(topic, categoryIndex!);

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz',
              style: Get.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text(
              '$topic - Category $categoryIndex',
              style: context.textTheme.bodyLarge,
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: RoundedButton(
            backgroundColor: kRed,
            onTap: () {
              controller.resetQuizState();
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
        () => QuestionsContent(
          isLoading: controller.isLoadingQuestions.value,
          questions: controller.questions,
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
