import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:template/core/ad_controllers/interstitial_ad_controller.dart';
import 'package:template/core/common_widgets/text_icon_button.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';
import 'package:template/presentations/result/controller/result_controller.dart';

import '../../customized_quiz/controller/cutomized_quiz_controller.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileHeight = MediaQuery.of(context).size.height;
    final mobileWidth = MediaQuery.of(context).size.width;
    bool isCustomizedQuiz = Get.isRegistered<CustomizedQuizController>();
    final adManager = Get.find<InterstitialAdController>();
    adManager.maybeShowAdForScreen('Res');
    final arguments = Get.arguments as Map<String, dynamic>?;
    final bool fromCustomQuiz = arguments?['fromCustomQuiz'] as bool? ?? false;

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
              (route) => route.settings.name == RoutesName.quizSelectionScreen,
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
                SizedBox(height: mobileHeight * 0.07),
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
                        top: mobileHeight * 0.15,
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
                              top: 75,
                              left: 32,
                              right: 32,
                              bottom: 16,
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: mobileHeight * 0.1),
                                //result card
                                Expanded(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: 1,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        color: kWhite,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                12.0,
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
                                                                    alpha: 0.2,
                                                                  ),
                                                            ),
                                                    padding: EdgeInsets.all(6),
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
                                              padding: const EdgeInsets.all(
                                                12.0,
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
                                                                    alpha: 0.2,
                                                                  ),
                                                            ),
                                                    padding: EdgeInsets.all(6),
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
                                              padding: const EdgeInsets.all(
                                                12.0,
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
                                                                    alpha: 0.2,
                                                                  ),
                                                            ),
                                                    padding: EdgeInsets.all(6),
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
                                      );
                                    },
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextIconButton(
                                        onPressed: () {
                                          resultController.resetQuiz();
                                          if (fromCustomQuiz) {
                                            Get.toNamed(
                                              RoutesName.customizedQuizScreen,
                                              arguments: {
                                                'topic': topic,
                                                'topicIndex': topicIndex,
                                                'categoryIndex': categoryIndex,
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
                                                'categoryIndex': categoryIndex,
                                                'fromCustomQuiz': false,
                                              },
                                            );
                                          }
                                        },
                                        text: 'Retake Quiz',
                                        icon: Icon(Icons.refresh, size: 20),
                                        style: context.textTheme.titleSmall,
                                        height: mobileHeight * 0.07,
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
                                                  RoutesName.quizLevelsScreen,
                                            );
                                          }
                                        },
                                        text: 'Exit',
                                        icon: Icon(Icons.exit_to_app, size: 20),
                                        style: context.textTheme.titleSmall,
                                        height: mobileHeight * 0.07,
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
                        top: mobileHeight * 0.05,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: mobileWidth * 0.55,
                            height: mobileWidth * 0.55,
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
                                          resultController.currentStep.value,
                                      stepSize: mobileWidth * 0.030,
                                      selectedColor: skyColor,
                                      unselectedColor: greyBorderColor
                                          .withAlpha(25),
                                      padding: 0,
                                      width: mobileWidth * 0.60,
                                      height: mobileWidth * 0.60,
                                      selectedStepSize: mobileWidth * 0.040,
                                      roundedCap: (_, __) => true,
                                    ),
                                  ),
                                ),
                                // Percentage text in the center
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(
                                        () => Text(
                                          '${resultController.currentStep.value}%',
                                          style: context.textTheme.displayMedium
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
      ),
    );
  }
}
