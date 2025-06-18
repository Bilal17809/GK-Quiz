import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:template/core/ads/interstitial_ad/view/interstitial_ad.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/presentations/customized_quiz/controller/cutomized_quiz_controller.dart';

import '../../../core/ads/banner_ad/view/banner_ad.dart';
import '../../../core/constant/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/customized_quiz_content.dart';

class CustomizedQuizScreen extends StatelessWidget {
  const CustomizedQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customizedQuizController = Get.put(CustomizedQuizController());
    final args = Get.arguments as Map<String, dynamic>;
    final topic = args['topic'] ?? '';
    final questionCount = args['questionCount'] ?? 0;

    return InterstitialAdWidget(
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: CustomAppBar(subtitle: '$topic - Questions: $questionCount'),

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
        bottomNavigationBar: const Padding(
          padding: kBottomNav,
          child: BannerAdWidget(adSize: AdSize.banner),
        ),
      ),
    );
  }
}
