import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/country_quiz_controller.dart';
import 'country_quiz_content.dart';

class CountryQuizScreen extends StatefulWidget {
  const CountryQuizScreen({super.key});

  @override
  State<CountryQuizScreen> createState() => _CountryQuizScreenState();
}

class _CountryQuizScreenState extends State<CountryQuizScreen> {
  late CountryQuizController countryQuizController;
  late String topic;
  late int topicIndex;
  late int categoryIndex;

  final InterstitialAdController interstitialAd = Get.put(
    InterstitialAdController(),
  );
  final BannerAdController bannerAdController = Get.put(BannerAdController());

  @override
  void initState() {
    super.initState();
    interstitialAd.checkAndShowAd();

    // Get arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments == null) {
      Get.back();
      return;
    }

    topic = arguments['topic'] ?? '';
    topicIndex = arguments['topicIndex'] ?? arguments['index'] ?? 1;
    categoryIndex = arguments['categoryIndex'] ?? 1;

    // Initialize controller
    countryQuizController = Get.put(CountryQuizController(), permanent: false);
    countryQuizController.updateArguments({
      'topic': topic,
      'topicIndex': topicIndex,
      'categoryIndex': categoryIndex,
    });
    countryQuizController.loadQuestionsForCategory(topic, categoryIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: CustomAppBar(subtitle: '$topic - Level $categoryIndex'),
      body: Obx(
        () => CountryQuizContent(
          isLoading: countryQuizController.isLoadingQuestions.value,
          questions: countryQuizController.questionsList,
          pageController: countryQuizController.questionsPageController,
          currentIndex: countryQuizController.currentQuestionIndex.value,
          onPageChanged: countryQuizController.onPageChanged,
          selectedAnswers: countryQuizController.selectedAnswers,
          showAnswers: countryQuizController.shouldShowAnswerResults,
          onAnswerSelected: _handleAnswerSelection,
          controller: countryQuizController,
          topic: topic,
          topicIndex: topicIndex,
          categoryIndex: categoryIndex,
        ),
      ),
      bottomNavigationBar:
          interstitialAd.isAdReady
              ? SizedBox()
              : Obx(() {
                return bannerAdController.getBannerAdWidget('ad6');
              }),
    );
  }

  void _handleAnswerSelection(int questionIndex, String selectedOption) {
    if (countryQuizController.shouldShowAnswerResults[questionIndex] == true) {
      return;
    }

    countryQuizController.handleAnswerSelection(questionIndex, selectedOption);
  }
}
