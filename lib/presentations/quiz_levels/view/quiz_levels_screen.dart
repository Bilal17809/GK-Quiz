
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/grid_data.dart';
import '../../quiz/controller/quiz_controller.dart';
import '../controller/quiz_result_controller.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/constant/constant.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

import '../widgets/levels_card.dart';

class QuizLevelsScreen extends StatefulWidget {
  const QuizLevelsScreen({super.key});

  @override
  State<QuizLevelsScreen> createState() => _QuizLevelsScreenState();
}

class _QuizLevelsScreenState extends State<QuizLevelsScreen> {
  final InterstitialAdController interstitialAd=Get.put(InterstitialAdController());
  final BannerAdController bannerAdController=Get.put(BannerAdController());
  final QuizController controller = Get.put(QuizController());
  final resultController = Get.put(QuizResultController());


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
    Get.put(QuizResultController());
    if (topic.isNotEmpty) {
      controller.loadCategoriesForTopic(topic);
    } else {
      Get.snackbar(
        'AN UNEXPECTED ERROR OCCURRED',
        'Unable to fetch categories from the database at the moment, please try later',
      );
    }

    return  Scaffold(
      appBar: CustomAppBar(subtitle: 'Levels'),
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
                  color: gridColors[(gridTexts.contains(topic)
                      ? gridTexts.indexOf(topic)
                      : 0) %
                      gridColors.length]
                      .withValues(alpha: 0.9),
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
                        'Total Questions: ${(controller.topicCounts[topic] ?? 0) - ((controller.topicCounts[topic] ?? 0) % 20)}',
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
                if (controller.isLoadingCategories.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.questionCategories.length,
                  itemBuilder: (context, categoryIndex) {
                    final category =
                    controller.questionCategories[categoryIndex];
                    return LevelsCard(
                      category: category,
                      topicIndex: topicIndex,
                      categoryIndex: categoryIndex,
                      onTap: () {
                        controller.resetQuizState();
                        Get.toNamed(
                          RoutesName.quizScreen,
                          arguments: {
                            'topic': category.topic,
                            'categoryIndex': category.categoryIndex,
                            'isCategory': true,
                            'topicIndex':
                            topicIndex,
                            'categoryIndexForResult':
                            categoryIndex,
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
      bottomNavigationBar:interstitialAd.isAdReady?SizedBox(): Obx(() {
          return bannerAdController.getBannerAdWidget('ad15');
      }),
    );
  }
}
