import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/constant/constant.dart';
import '../../../core/models/questions_data.dart';
import '../../home/view/home_screen.dart';
import '../controller/country_review_controller.dart';
import 'country_review_page.dart';

class CountryReviewScreen extends StatefulWidget {
  const CountryReviewScreen({super.key});

  @override
  State<CountryReviewScreen> createState() => _CountryReviewScreenState();
}

class _CountryReviewScreenState extends State<CountryReviewScreen> {
  final InterstitialAdController interstitialAd=Get.put(InterstitialAdController());
  final BannerAdController bannerAdController=Get.put(BannerAdController());


  @override
  void initState() {
    super.initState();
    interstitialAd.checkAndShowAd();
  }
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
      bottomNavigationBar:interstitialAd.isAdReady?SizedBox(): Obx(() {
          return bannerAdController.getBannerAdWidget('ad8');
      }),
    );
  }
}
