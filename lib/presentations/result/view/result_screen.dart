import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:template/core/constant/constant.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/text_icon_button.dart';
import '../../customized_quiz/controller/cutomized_quiz_controller.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../quiz/controller/quiz_controller.dart';
import '../../quiz_levels/controller/quiz_result_controller.dart';
import '../controller/result_controller.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final InterstitialAdController interstitialAd = Get.put(
    InterstitialAdController(),
  );
  final BannerAdController bannerAdController = Get.put(BannerAdController());
  final QuizResultController result = Get.put(QuizResultController());

  @override
  void initState() {
    super.initState();
    interstitialAd.checkAndShowAd();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobileHeight = constraints.maxHeight;
        final mobileWidth = constraints.maxWidth;
        final isTall = constraints.maxHeight > 675;

        // Responsive values
        final titleTopSpacing =
            isTall ? mobileHeight * 0.07 : mobileHeight * 0.03;
        final curvedContainerTop =
            isTall ? mobileHeight * 0.15 : mobileHeight * 0.16;
        final progressCircleTop =
            isTall ? mobileHeight * 0.05 : mobileHeight * 0.03;
        final progressCircleSize = mobileWidth * 0.5;
        final stepSize = mobileWidth * 0.030;
        final selectedStepSize = mobileWidth * 0.040;
        final buttonHeight = isTall ? mobileHeight * 0.07 : 50.0;
        final cardPadding = isTall ? 12.0 : 8.0;
        final horizontalPadding = kBodyHp * 2;
        final topPadding = isTall ? 55.0 : 24.0;

        bool isCustomizedQuiz = Get.isRegistered<CustomizedQuizController>();
        final arguments = Get.arguments as Map<String, dynamic>?;
        final bool fromCustomQuiz =
            arguments?['fromCustomQuiz'] as bool? ?? false;

        if (arguments == null) {
          debugPrint('ERROR: No arguments passed to ResultScreen');
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: No quiz data found'),
                  ElevatedButton(
                    onPressed: () => Get.offAllNamed(RoutesName.homeScreen),
                    child: Text('Go Home'),
                  ),
                ],
              ),
            ),
          );
        }

        final int topicIndex = arguments['topicIndex'] as int? ?? 1;
        final int categoryIndex = arguments['categoryIndex'] as int? ?? 1;
        final String topic = arguments['topic'] as String? ?? '';

        debugPrint("Arguments received: $arguments");
        debugPrint(
          "Topic Index: $topicIndex, Category Index: $categoryIndex, Topic: $topic",
        );

        final ResultController resultController = Get.put(ResultController());

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!resultController.isInitialized.value) {
            resultController.calculateResults(topicIndex, categoryIndex);
            resultController.isInitialized.value = true;
            PanaraInfoDialog.show(
              context,
              title: 'Congratulations!',
              message:
                  "You've completed the quiz with ${resultController.currentStep.value}% correct answers!",
              buttonText: "Okay",
              onTapDismiss: () {
                Get.back();
              },
              panaraDialogType: PanaraDialogType.custom,
              color: skyColor,
            );
          }
        });

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop) {
              if (isCustomizedQuiz) {
                Get.until(
                  (route) =>
                      route.settings.name == RoutesName.quizSelectionScreen,
                );
              } else {
                Get.until(
                  (route) => route.settings.name == RoutesName.quizLevelsScreen,
                );
              }
            }
          },
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [skyColor, skyColor.withValues(alpha: 0.75)],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: titleTopSpacing),
                    Text(
                      'QUIZ RESULT',
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
                    Expanded(
                      child: Stack(
                        children: [
                          // Curved white container
                          Positioned(
                            top: curvedContainerTop,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.elliptical(mobileWidth, 150),
                                  topRight: Radius.elliptical(mobileWidth, 150),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: topPadding,
                                  left: horizontalPadding,
                                  right: horizontalPadding,
                                  bottom: 16,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          isTall
                                              ? mobileHeight * 0.1
                                              : mobileHeight * 0.12,
                                    ),
                                    //result card
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Card(
                                          color: kWhite,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                  cardPadding,
                                                ),
                                                child: Container(
                                                  decoration: roundedDecoration
                                                      .copyWith(color: kWhite),
                                                  child: ListTile(
                                                    leading: Container(
                                                      decoration:
                                                          roundedDecorationWithShadow
                                                              .copyWith(
                                                                color: skyColor
                                                                    .withValues(
                                                                      alpha:
                                                                          0.2,
                                                                    ),
                                                              ),
                                                      padding: EdgeInsets.all(
                                                        6,
                                                      ),
                                                      child: Icon(
                                                        Icons.quiz,
                                                        color: skyColor,
                                                      ),
                                                    ),
                                                    title: Text(
                                                      'Total Questions',
                                                      style: Get
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            color: skyColor,
                                                          ),
                                                    ),
                                                    trailing: Obx(
                                                      () => Text(
                                                        resultController
                                                            .totalQuestions
                                                            .toString(),
                                                        style: Get
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                              color: skyColor,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                  cardPadding,
                                                ),
                                                child: Container(
                                                  decoration: roundedDecoration
                                                      .copyWith(color: kWhite),
                                                  child: ListTile(
                                                    leading: Container(
                                                      decoration:
                                                          roundedDecorationWithShadow
                                                              .copyWith(
                                                                color: skyColor
                                                                    .withValues(
                                                                      alpha:
                                                                          0.2,
                                                                    ),
                                                              ),
                                                      padding: EdgeInsets.all(
                                                        6,
                                                      ),
                                                      child: Icon(
                                                        Icons.done,
                                                        color: skyColor,
                                                      ),
                                                    ),
                                                    title: Text(
                                                      'Correct Answers',
                                                      style: Get
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            color: skyColor,
                                                          ),
                                                    ),
                                                    trailing: Obx(
                                                      () => Text(
                                                        resultController
                                                            .correctAnswers
                                                            .value
                                                            .toString(),
                                                        style: Get
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                              color: skyColor,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                  cardPadding,
                                                ),
                                                child: Container(
                                                  decoration: roundedDecoration
                                                      .copyWith(color: kWhite),
                                                  child: ListTile(
                                                    leading: Container(
                                                      decoration:
                                                          roundedDecorationWithShadow
                                                              .copyWith(
                                                                color: skyColor
                                                                    .withValues(
                                                                      alpha:
                                                                          0.2,
                                                                    ),
                                                              ),
                                                      padding: EdgeInsets.all(
                                                        6,
                                                      ),
                                                      child: Icon(
                                                        Icons.close,
                                                        color: skyColor,
                                                      ),
                                                    ),
                                                    title: Text(
                                                      'Wrong Answers',
                                                      style: Get
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            color: skyColor,
                                                          ),
                                                    ),
                                                    trailing: Obx(
                                                      () => Text(
                                                        resultController
                                                            .wrongAnswers
                                                            .value
                                                            .toString(),
                                                        style: Get
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                              color: skyColor,
                                                            ),
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
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextIconButton(
                                            onPressed: () {
                                              resultController.resetQuiz();
                                              if (fromCustomQuiz) {
                                                Get.toNamed(
                                                  RoutesName
                                                      .customizedQuizScreen,
                                                  arguments: {
                                                    'topic': topic,
                                                    'topicIndex': topicIndex,
                                                    'categoryIndex':
                                                        categoryIndex,
                                                    'fromCustomQuiz': true,
                                                  },
                                                );
                                              } else {
                                                Get.delete<QuizController>();
                                                Get.toNamed(
                                                  RoutesName.quizScreen,
                                                  arguments: {
                                                    'topic': topic,
                                                    'topicIndex': topicIndex,
                                                    'categoryIndex':
                                                        categoryIndex,
                                                    'fromCustomQuiz': false,
                                                  },
                                                );
                                              }
                                            },
                                            text: 'Retake Quiz',
                                            icon: Icon(Icons.refresh, size: 20),
                                            style: context.textTheme.titleSmall,
                                            height: buttonHeight,
                                            color: skyColor,
                                            foregroundColor: kWhite,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: TextIconButton(
                                            onPressed: () {
                                              if (isCustomizedQuiz) {
                                                Get.until(
                                                  (route) =>
                                                      route.settings.name ==
                                                      RoutesName
                                                          .quizSelectionScreen,
                                                );
                                              } else {
                                                Get.until(
                                                  (route) =>
                                                      route.settings.name ==
                                                      RoutesName
                                                          .quizLevelsScreen,
                                                );
                                              }
                                            },
                                            text: 'Exit',
                                            icon: Icon(
                                              Icons.exit_to_app,
                                              size: 20,
                                            ),
                                            style: context.textTheme.titleSmall,
                                            height: buttonHeight,
                                            color: kRed.withValues(alpha: 0.6),
                                            foregroundColor: kWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Progress circle
                          Positioned(
                            top: progressCircleTop,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: progressCircleSize,
                                height: progressCircleSize,
                                decoration: BoxDecoration(
                                  color: kWhite,
                                  shape: BoxShape.circle,
                                ),
                                child: Stack(
                                  children: [
                                    // Progress circular bar
                                    Positioned.fill(
                                      child: Obx(
                                        () => CircularStepProgressIndicator(
                                          totalSteps: 100,
                                          currentStep:
                                              resultController
                                                  .currentStep
                                                  .value,
                                          stepSize: stepSize,
                                          selectedColor: skyColor,
                                          unselectedColor: greyBorderColor
                                              .withAlpha(25),
                                          padding: 0,
                                          selectedStepSize: selectedStepSize,
                                          roundedCap: (_, __) => true,
                                        ),
                                      ),
                                    ),
                                    // Percentage text in the center
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Obx(
                                            () => Text(
                                              '${resultController.currentStep.value}%',
                                              style: context
                                                  .textTheme
                                                  .displayMedium
                                                  ?.copyWith(
                                                    color: skyColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            'Correct Answers',
                                            style: context.textTheme.titleSmall
                                                ?.copyWith(
                                                  color: textGreyColor,
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar:
                interstitialAd.isAdReady
                    ? SizedBox()
                    : Obx(() {
                      return bannerAdController.getBannerAdWidget('ad17');
                    }),
          ),
        );
      },
    );
  }
}
