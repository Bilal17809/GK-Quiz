import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/cutomized_quiz_controller.dart';
import '../widgets/customized_quiz_content.dart';

class CustomizedQuizScreen extends StatefulWidget {
  const CustomizedQuizScreen({super.key});

  @override
  State<CustomizedQuizScreen> createState() => _CustomizedQuizScreenState();
}

class _CustomizedQuizScreenState extends State<CustomizedQuizScreen> {
  final InterstitialAdController interstitialAd = Get.put(
    InterstitialAdController(),
  );
  final BannerAdController bannerAdController = Get.put(BannerAdController());

  @override
  void initState() {
    super.initState();
    interstitialAd.checkAndShowAd();
  }

  @override
  Widget build(BuildContext context) {
    final customizedQuizController = Get.put(CustomizedQuizController());
    final args = Get.arguments as Map<String, dynamic>;
    final topic = args['topic'] ?? '';
    final questionCount = args['questionCount'] ?? 0;

    return Scaffold(
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
      bottomNavigationBar:
          interstitialAd.isAdReady
              ? SizedBox()
              : Obx(() {
                return bannerAdController.getBannerAdWidget('ad10');
              }),
    );
  }
}
