import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/presentations/country_review/controller/country_review_controller.dart';
import 'package:template/presentations/country_review/view/country_review_content.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/theme/app_colors.dart';

class CountryReviewScreen extends StatefulWidget {
  const CountryReviewScreen({super.key});

  @override
  State<CountryReviewScreen> createState() => _CountryQuizScreenState();
}

class _CountryQuizScreenState extends State<CountryReviewScreen> {
  late CountryReviewController countryQuizController;
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

    countryQuizController = Get.put(
      CountryReviewController(),
      permanent: false,
    );

    countryQuizController.updateArguments({
      'topic': topic,
      'topicIndex': topicIndex,
      'categoryIndex': categoryIndex,
    });

    // Pre-select all answers from arguments if available
    final selectedAnswers = arguments['selectedAnswers'] as Map<int, String>?;
    if (selectedAnswers != null) {
      countryQuizController.preSelectAnswers(selectedAnswers);
    }

    countryQuizController.loadQuestionsForCategory(topic, categoryIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: CustomAppBar(subtitle: '$topic - Level $categoryIndex'),
      body: Obx(
        () => CountryReviewContent(
          isLoading: countryQuizController.isLoadingQuestions.value,
          questions: countryQuizController.questionsList,
          pageController: countryQuizController.questionsPageController,
          selectedAnswers: countryQuizController.selectedAnswers,
          controller: countryQuizController,
          topic: topic,
          topicIndex: topicIndex,
          categoryIndex: categoryIndex,
          onPageChanged: countryQuizController.onPageChanged,
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
}
