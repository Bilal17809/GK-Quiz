import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/round_image.dart';
import '../../../core/models/questions_data.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/constant/constant.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';

import '../../country_quiz/controller/country_quiz_controller.dart';
import '../controller/country_result_controller.dart';

class CountryResultScreen extends StatefulWidget {
  const CountryResultScreen({super.key});

  @override
  State<CountryResultScreen> createState() => _CountryResultScreenState();
}

class _CountryResultScreenState extends State<CountryResultScreen> {
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
    final mobileHeight = MediaQuery.of(context).size.height;
    final mobileWidth = MediaQuery.of(context).size.width;

    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments == null) {
      debugPrint('ERROR: No arguments passed to Country Result Screen');

      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final int topicIndex = arguments['topicIndex'] as int? ?? 1;
    final int categoryIndex = arguments['categoryIndex'] as int? ?? 1;
    final String topic = arguments['topic'] as String? ?? '';

    debugPrint("Arguments received: $arguments");
    debugPrint(
      "Topic Index: $topicIndex, Category Index: $categoryIndex, Topic: $topic",
    );

    final CountryResultController countryResultController = Get.put(
      CountryResultController(),
    );

    countryResultController.calculateResults(topicIndex, categoryIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      PanaraInfoDialog.show(
        context,
        title: 'Congratulations!',
        message:
            "You've completed the quiz with ${countryResultController.currentStep.value}% correct answers!",
        buttonText: "Okay",
        onTapDismiss: () {
          Get.back();
        },

        panaraDialogType: PanaraDialogType.custom,
        color: kSkyBlueColor,
      );
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Get.until(
            (route) => route.settings.name == RoutesName.countryLevelsScreen,
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            //SkyBlue Container
            Container(
              height: mobileHeight * 0.55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: kSkyBlueColor,
              ),
            ),
            //Title
            Positioned(
              top: mobileHeight * 0.075,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'COUNTRY QUIZ\nRESULT',
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: kWhite,
                    shadows: [
                      Shadow(
                        color: kBlack.withValues(alpha: 0.07),
                        offset: Offset(3, 3),
                        blurRadius: 2,
                      ),
                    ],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            //Percentage Circle
            Positioned(
              top: mobileHeight * 0.195,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: mobileWidth * 0.33,
                  height: mobileWidth * 0.33,
                  decoration: BoxDecoration(
                    color: kWhite,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kWhite.withValues(alpha: 0.5),
                        spreadRadius: 12,
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Progress circular bar
                      Positioned.fill(
                        child: CircularStepProgressIndicator(
                          totalSteps: 100,
                          currentStep:
                              countryResultController.currentStep.value,
                          stepSize: mobileWidth * 0.02,
                          selectedColor: kSkyBlueColor.withValues(alpha: 0.9),
                          unselectedColor: greyBorderColor.withAlpha(25),
                          padding: 0,
                          width: mobileWidth * 0.35,
                          height: mobileWidth * 0.35,
                          selectedStepSize: mobileWidth * 0.02,
                          roundedCap: (_, __) => true,
                        ),
                      ),
                      Center(
                        child: FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              '${countryResultController.currentStep.value}%',
                              style: context.textTheme.displaySmall?.copyWith(
                                color: kSkyBlueColor.withValues(alpha: 0.9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Stats Card
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: mobileHeight * 0.42,
                  left: mobileWidth * 0.05,
                  right: mobileWidth * 0.05,
                  child: Container(
                    height: mobileHeight * 0.25,
                    width: mobileWidth * 0.9,
                    decoration: roundedDecoration.copyWith(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: kWhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        color: kTealGreen1,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '${countryResultController.currentStep}%',
                                        style: context.textTheme.displaySmall
                                            ?.copyWith(
                                              color: kTealGreen1,
                                              fontSize: 28,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Percentage',
                                    style: context.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        color: skyColor,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '${countryResultController.totalQuestions}',
                                        style: context.textTheme.displaySmall
                                            ?.copyWith(
                                              color: skyColor,
                                              fontSize: 28,
                                            ),
                                      ),
                                    ],
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Total Questions',
                                      style: context.textTheme.titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        color: kDarkGreen1,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),

                                      Text(
                                        '${countryResultController.correctAnswers}',
                                        style: context.textTheme.displaySmall
                                            ?.copyWith(
                                              color: kDarkGreen1,
                                              fontSize: 28,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Correct Answers',
                                    style: context.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        color: kRed,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '${countryResultController.wrongAnswers}',
                                        style: context.textTheme.displaySmall
                                            ?.copyWith(
                                              color: kRed,
                                              fontSize: 28,
                                            ),
                                      ),
                                    ],
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Wrong Answers',
                                      style: context.textTheme.titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //Buttons
            Positioned(
              top: mobileHeight * 0.75,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(kBodyHp),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          RoundedButton(
                            width: mobileWidth * 0.15,
                            height: mobileWidth * 0.15,
                            onTap: () {
                              Get.delete<CountryQuizController>();
                              int count = 0;

                              Get.until((_) => count++ == 2);

                              Get.toNamed(
                                RoutesName.countryQuizScreen,
                                arguments: {
                                  'topic': topic,
                                  'topicIndex': topicIndex,
                                  'categoryIndex': categoryIndex,
                                },
                              );
                            },
                            backgroundColor: kSkyBlueColor,
                            child: Icon(Icons.replay, color: kWhite),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Retake Quiz',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          RoundedButton(
                            width: mobileWidth * 0.15,
                            height: mobileWidth * 0.15,
                            onTap: () {
                              final selectedAnswers =
                                  arguments['selectedAnswers']
                                      as Map<int, String>? ??
                                  {};
                              final questionsList =
                                  arguments['questionsList']
                                      as List<QuestionsModel>? ??
                                  [];
                              Get.toNamed(
                                RoutesName.countryReviewScreen,
                                arguments: {
                                  'questionsList': questionsList,
                                  'selectedAnswers': selectedAnswers,
                                  'topic': topic,
                                },
                              );
                            },
                            backgroundColor: skyColor,
                            child: Icon(Icons.remove_red_eye, color: kWhite),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'View Answers',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          RoundedButton(
                            width: mobileWidth * 0.15,
                            height: mobileWidth * 0.15,
                            onTap: () async {
                              Get.until(
                                (route) =>
                                    route.settings.name ==
                                    RoutesName.countryLevelsScreen,
                              );
                            },
                            backgroundColor: kRed,
                            child: Icon(Icons.exit_to_app, color: kWhite),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Exit',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            interstitialAd.isAdReady
                ? SizedBox()
                : Obx(() {
                  return bannerAdController.getBannerAdWidget('ad7');
                }),
      ),
    );
  }
}
