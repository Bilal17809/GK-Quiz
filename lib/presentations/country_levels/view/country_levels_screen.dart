import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/constant/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../quiz/controller/quiz_controller.dart';
import '../controller/country_levels_controller.dart';

import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/routes/routes_name.dart';
import '../widgets/country_levels_card.dart';

class CountryLevelsScreen extends StatefulWidget {
  const CountryLevelsScreen({super.key});
  @override
  State<CountryLevelsScreen> createState() => _CountryLevelsScreenState();
}
class _CountryLevelsScreenState extends State<CountryLevelsScreen> {
  final InterstitialAdController interstitialAd = Get.put(
    InterstitialAdController(),
  );
  final BannerAdController bannerAdController = Get.put(BannerAdController());

  final resultController = Get.put(CountryLevelsController());

  @override
  void initState() {
    super.initState();
    interstitialAd.checkAndShowAd();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final topic = arguments['topic'];
    final topicIndex = arguments['index'];
    final QuizController quizController = Get.put(QuizController());
    // Get.put(CountryLevelsController());

    if (topic.isNotEmpty) {
      quizController.loadCategoriesForTopic(topic);
    } else {
      Get.snackbar(
        'AN UNEXPECTED ERROR OCCURRED',
        'Unable to fetch categories from the database at the moment, please try later',
      );
    }
    return Scaffold(
      appBar: CustomAppBar(subtitle: 'Country Levels'),
      body: SafeArea(
        child: Column(
          children: [
            // Topic Header
            if (topic.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(kBodyHp),
                padding: const EdgeInsets.all(kBodyHp),
                decoration: roundedDecoration.copyWith(
                  color: kTealGreen1.withValues(alpha: 0.9),
                  border: Border.all(color: greyBorderColor),
                ),
                child: Column(
                  children: [
                    Text(
                      topic,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: kWhite,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Text(
                        'Total Questions: ${quizController.topicCounts[topic] ?? 0}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: kWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Categories List
            Expanded(
              child: Obx(() {
                if (quizController.isLoadingCategories.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: quizController.questionCategories.length,
                  itemBuilder: (context, categoryIndex) {
                    final category =
                        quizController.questionCategories[categoryIndex];
                    return CountryLevelsCard(
                      category: category,
                      topicIndex: topicIndex,
                      categoryIndex: categoryIndex,
                      onTap: () {
                        quizController.resetQuizState();
                        Get.toNamed(
                          RoutesName.countryQuizScreen,
                          arguments: {
                            'topic': category.topic,
                            'categoryIndex': category.categoryIndex,
                            'isCategory': true,
                            'topicIndex':
                                topicIndex, // Pass the topic grid index
                            'categoryIndexForResult':
                                categoryIndex, // Pass the category index for result
                          },
                        );
                      },
                      topic: topic,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          interstitialAd.isAdReady
              ? SizedBox()
              : Obx(() {
                return bannerAdController.getBannerAdWidget('ad4');
              }),
    );
  }
}
