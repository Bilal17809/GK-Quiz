import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:template/core/ads/interstitial_ad/view/interstitial_ad.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/country/controller/country_controller.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';

import '../../../core/ads/banner_ad/view/banner_ad.dart';
import '../../../core/common_widgets/country_grid.dart';
import '../../../core/constant/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../country_levels/controller/country_levels_controller.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final CountryController countryController = Get.put(CountryController());
  final quizController = Get.put(QuizController());
  final CountryLevelsController levelsController = Get.put(
    CountryLevelsController(),
  );

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      countryController.loadAllQuestions();
      levelsController.refreshAllResults();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InterstitialAdWidget(
      child: Scaffold(
        appBar: CustomAppBar(subtitle: 'Global Challenge'),
        body: SafeArea(
          child: Stack(
            children: [
              //Animated BG
              Obx(() {
                return Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: -countryController.shift.value,
                      child: Image.asset(
                        'assets/images/world_map.png',
                        color: kTealGreen1.withValues(alpha: 0.9),
                        width: countryController.imageWidth,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left:
                          countryController.imageWidth -
                          countryController.shift.value,
                      child: Image.asset(
                        'assets/images/world_map.png',
                        color: kTealGreen1.withValues(alpha: 0.9),
                        width: countryController.imageWidth,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              }),
              GridView.builder(
                padding: kGridPadding,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1 / 1,
                ),
                itemCount: countryIcons.length,
                itemBuilder: (context, index) {
                  final icon = countryIcons[index % countryIcons.length];
                  final topic = countryTexts[index % countryTexts.length];

                  return InkWell(
                    onTap: () {
                      Get.toNamed(
                        RoutesName.countryLevelsScreen,
                        arguments: {'topic': topic, 'index': index},
                      );
                      _refreshTimer?.cancel();
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: roundedDecoration.copyWith(
                            color: kTealGreen1.withValues(alpha: 0.9),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 35),
                              Container(
                                decoration: roundedDecorationWithShadow
                                    .copyWith(color: kWhite.withAlpha(50)),
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(
                                  icon,
                                  color: kWhite,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    topic,
                                    style: context.textTheme.titleSmall
                                        ?.copyWith(
                                          color: textWhiteColor,
                                          fontSize: 14,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => Positioned(
                            top: -6,
                            left: -6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: kTealGreen1.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(6),
                              child: Text(
                                '${(countryController.topicCounts[topic] ?? 0) - ((countryController.topicCounts[topic] ?? 0) % 20)}',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: textWhiteColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        // Progress Indicator
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: Container(
                            height: 24,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: roundedDecoration.copyWith(
                              color: kWhite.withValues(alpha: 0.75),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Obx(() {
                              // Get progress data
                              final result = levelsController
                                  .getOverallResultSync(index);
                              final totalQuestions =
                                  countryController.topicCounts[topic] ?? 0;
                              final correctAnswers = result['correct'] as int;
                              final currentStep = correctAnswers;

                              return StepProgressIndicator(
                                totalSteps:
                                    totalQuestions > 0 ? totalQuestions : 1,
                                currentStep: currentStep.clamp(
                                  0,
                                  totalQuestions,
                                ),
                                size: 8,
                                padding: 0,
                                roundedEdges: const Radius.circular(10),
                                selectedGradientColor: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    kTealGreen1.withValues(alpha: 0.2),
                                    kTealGreen1,
                                  ],
                                ),
                                unselectedColor: greyColor.withValues(
                                  alpha: 0.2,
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: const Padding(
          padding: kBottomNav,
          child: BannerAdWidget(),
        ),
      ),
    );
  }
}
