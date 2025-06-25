import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/quiz_controller.dart';
import '../widgets/quiz_content.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final InterstitialAdController interstitialAd=Get.put(InterstitialAdController());
  final BannerAdController bannerAdController=Get.put(BannerAdController());

  @override
  void initState() {
    super.initState();
    interstitialAd.checkAndShowAd();
  }
  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments == null) {
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

    QuizController controller = Get.put(QuizController(), permanent: false);

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
      appBar: CustomAppBar(subtitle: '$topic - Level $categoryIndex'),
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
      bottomNavigationBar:interstitialAd.isAdReady?SizedBox(): Obx(() {
          return bannerAdController.getBannerAdWidget('ad14');
      }),
    );
  }
}
