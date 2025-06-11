import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:template/core/common_widgets/common_widgets.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/presentations/country_result/controller/country_result_controller.dart';

import '../../../core/theme/app_styles.dart';

class CountryResultScreen extends StatelessWidget {
  const CountryResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileHeight = MediaQuery.of(context).size.height;
    final mobileWidth = MediaQuery.of(context).size.width;

    // Safely get arguments with null checks and default values
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments == null) {
      debugPrint('ERROR: No arguments passed to Country Result Screen');

      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Extract values using topicIndex and categoryIndex
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
        color: kTealGreen1,
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          //Teal Container
          Container(
            height: mobileHeight * 0.55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: kTealGreen1,
            ),
          ),
          //Title
          Positioned(
            top: mobileHeight * 0.1,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'COUNTRY QUIZ\nRESULT',
                textAlign: TextAlign.center,
                style: Get.textTheme.titleLarge?.copyWith(
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
            top: mobileHeight * 0.2,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: mobileWidth * 0.38,
                height: mobileWidth * 0.38,
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
                        currentStep: countryResultController.currentStep.value,
                        stepSize: mobileWidth * 0.02,
                        selectedColor: kTealGreen1.withValues(alpha: 0.9),
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
                            style: Get.textTheme.displayMedium?.copyWith(
                              color: kTealGreen1.withValues(alpha: 0.9),
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
                child: Expanded(
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
                                        style: Get.textTheme.displaySmall
                                            ?.copyWith(
                                              color: kTealGreen1,
                                              fontSize: 28,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Percentage',
                                    style: Get.textTheme.titleSmall,
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
                                        color: kCoral,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '${countryResultController.totalQuestions}',
                                        style: Get.textTheme.displaySmall
                                            ?.copyWith(
                                              color: kCoral,
                                              fontSize: 28,
                                            ),
                                      ),
                                    ],
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Total Questions',
                                      style: Get.textTheme.titleSmall,
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
                                        style: Get.textTheme.displaySmall
                                            ?.copyWith(
                                              color: kDarkGreen1,
                                              fontSize: 28,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Correct Answers',
                                    style: Get.textTheme.titleSmall,
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
                                        style: Get.textTheme.displaySmall
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
                                      style: Get.textTheme.titleSmall,
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
                            Get.toNamed(
                              RoutesName.countryScreen,
                              // arguments: {
                              //   'topic': topic,
                              //   'topicIndex': topicIndex,
                              //   'categoryIndex': categoryIndex,
                              // },
                            );
                          },
                          backgroundColor: kTealGreen1,
                          child: Icon(Icons.replay, color: kWhite),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Retake Quiz',
                          style: Get.textTheme.bodyMedium?.copyWith(
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
                            Get.toNamed(RoutesName.countryQuizScreen);
                          },
                          backgroundColor: kCoral,
                          child: Icon(Icons.remove_red_eye, color: kWhite),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'View Answers',
                          style: Get.textTheme.bodyMedium?.copyWith(
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
                            Get.offAllNamed(RoutesName.homeScreen);
                          },
                          backgroundColor: kRed,
                          child: Icon(Icons.home, color: kWhite),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Exit',
                          style: Get.textTheme.bodyMedium?.copyWith(
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
    );
  }
}
