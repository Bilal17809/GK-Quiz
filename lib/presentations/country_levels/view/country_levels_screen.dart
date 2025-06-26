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
  late final InterstitialAdController interstitialAd;
  late final BannerAdController bannerAdController;
  late final CountryLevelsController resultController;
  late final QuizController quizController;

  @override
  void initState() {
    super.initState();

    try {
      interstitialAd = Get.put(InterstitialAdController());
      bannerAdController = Get.put(BannerAdController());
      quizController = Get.put(QuizController());
      resultController = Get.put(CountryLevelsController());
    } catch (e) {
      debugPrint('Error initializing controllers: $e');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTopicData();
    });
  }

  void _initializeTopicData() {
    try {
      final arguments = Get.arguments as Map<String, dynamic>?;
      if (arguments == null) {
        _showError('No arguments provided');
        return;
      }

      final topic = arguments['topic'] as String?;
      if (topic == null || topic.isEmpty) {
        _showError('Topic not provided');
        return;
      }

      quizController.loadCategoriesForTopic(topic);
    } catch (e) {
      debugPrint('Error initializing topic data: $e');
      _showError('Failed to load topic data');
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments == null) {
      return Scaffold(
        appBar: CustomAppBar(subtitle: 'Country Levels'),
        body: Center(child: Text('Error: No data provided')),
      );
    }

    final topic = arguments['topic'] as String? ?? '';
    final topicIndex = arguments['index'] as int? ?? 0;

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
                    GetBuilder<QuizController>(
                      builder:
                          (controller) => Text(
                            'Total Questions: ${controller.topicCounts[topic] ?? 0}',
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
              child: GetBuilder<QuizController>(
                builder: (controller) {
                  if (controller.isLoadingCategories.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.questionCategories.isEmpty) {
                    return Center(child: Text('No categories available'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.questionCategories.length,
                    itemBuilder: (context, categoryIndex) {
                      final category =
                          controller.questionCategories[categoryIndex];
                      return CountryLevelsCard(
                        category: category,
                        topicIndex: topicIndex,
                        categoryIndex: categoryIndex,
                        onTap: () {
                          try {
                            controller.resetQuizState();
                            Get.toNamed(
                              RoutesName.countryQuizScreen,
                              arguments: {
                                'topic': category.topic,
                                'categoryIndex': category.categoryIndex,
                                'isCategory': true,
                                'topicIndex': topicIndex,
                                'categoryIndexForResult': categoryIndex,
                              },
                            );
                          } catch (e) {
                            debugPrint('Error navigating to quiz: $e');
                            _showError('Failed to start quiz');
                          }
                        },
                        topic: topic,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GetBuilder<InterstitialAdController>(
        builder:
            (controller) =>
                controller.isAdReady
                    ? SizedBox()
                    : GetBuilder<BannerAdController>(
                      builder:
                          (bannerController) =>
                              bannerController.getBannerAdWidget('ad4'),
                    ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
