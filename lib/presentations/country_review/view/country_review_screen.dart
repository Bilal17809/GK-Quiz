import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/presentations/country_review/controller/country_review_controller.dart';

import '../../../core/models/questions_data.dart';
import '../../home/view/home_screen.dart';
import 'country_review_page.dart';

class CountryReviewScreen extends StatelessWidget {
  const CountryReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CountryReviewController countryReviewController = Get.put(
      CountryReviewController(),
      permanent: false,
    );
    final arguments = Get.arguments as Map<String, dynamic>;
    final questionsList =
        arguments['questionsList'] as List<QuestionsModel>? ?? [];
    final selectedAnswers =
        arguments['selectedAnswers'] as Map<int, String>? ?? {};
    final topic = arguments['topic'] as String? ?? 'Quiz Review';

    countryReviewController.initializeReview(
      questionsList,
      selectedAnswers,
      topic,
    );

    final mobileSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          controller: countryReviewController.pageController,
          onPageChanged: (index) {
            if (index >= countryReviewController.questionsList.length) {
              Get.offAll(
                () => const HomeScreen(),
                transition: Transition.rightToLeft,
                duration: Duration(milliseconds: 300),
              );
              return;
            }
            countryReviewController.onPageChanged(index);
          },
          itemCount: countryReviewController.questionsList.length + 1,
          itemBuilder: (context, pageIndex) {
            if (pageIndex >= countryReviewController.questionsList.length) {
              return Container();
            }
            final question = countryReviewController.questionsList[pageIndex];
            return CountryReviewPage(
              question: question,
              currentIndex: pageIndex,
              totalQuestions: countryReviewController.questionsList.length,
              controller: countryReviewController,
              mobileSize: mobileSize,
              topic: topic,
            );
          },
        );
      }),
    );
  }
}
