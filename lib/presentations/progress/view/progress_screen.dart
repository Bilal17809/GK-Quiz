import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/bottom_nav_bar.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/common_widgets/progress_circle.dart';
import 'package:template/core/common_widgets/section_card.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/presentations/progress/controller/progress_controller.dart';
import 'package:template/presentations/progress/view/progress_chart.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';

import '../../../core/common_widgets/circular_progress.dart';
import '../../../core/theme/app_colors.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Timer? _timer;
  late ProgressController progressController;

  @override
  void initState() {
    super.initState();
    progressController = Get.put(ProgressController());
    Get.put(QuizController());
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (progressController.totalAvailable.value > 0) timer.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobileWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(subtitle: 'Progress'),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(kBodyHp),
            child: Column(
              children: [
                // Your Learning Journey
                SectionCard(
                  image: AssetImage('assets/images/progress_meter.png'),
                  title: 'Your Learning Journey',
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      Obx(
                        () => ProgressCircle(
                          icon: Icons.file_copy_rounded,
                          label: 'Learn/Total',
                          value: progressController.totalLearnProgress.value,
                          totalValue:
                              progressController.totalLearnAvailable.value,
                        ),
                      ),
                      SizedBox(height: 6),
                      Divider(),
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => CircularProgressWidget(
                              label: 'Weak',
                              percentage:
                                  progressController.learnWeakPercentage.value,
                              progressColor: kRed,
                            ),
                          ),
                          SizedBox(width: mobileWidth * 0.05),
                          Obx(
                            () => CircularProgressWidget(
                              label: 'Good',
                              percentage:
                                  progressController.learnGoodPercentage.value,
                              progressColor: kTealGreen1,
                            ),
                          ),
                          SizedBox(width: mobileWidth * 0.05),
                          Obx(
                            () => CircularProgressWidget(
                              label: 'Excellent',
                              percentage:
                                  progressController
                                      .learnExcellentPercentage
                                      .value,
                              progressColor: kMediumGreen2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                //Quiz Insights
                SectionCard(
                  image: AssetImage('assets/images/progress_result.png'),
                  title: 'Quiz Insights',
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => ProgressCircle(
                              icon: Icons.file_copy_rounded,
                              label: 'Attempt/Total',
                              value: progressController.totalAttempted.value,
                              totalValue:
                                  progressController.totalAvailable.value,
                            ),
                          ),
                          SizedBox(width: mobileWidth * 0.1),
                          Obx(
                            () => ProgressCircle(
                              icon: Icons.star,
                              label: 'Correct/Wrong',
                              value: progressController.totalCorrect.value,
                              totalValue: progressController.totalWrong.value,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Divider(),
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => CircularProgressWidget(
                              label: 'Weak',
                              percentage:
                                  progressController.weakPercentage.value,
                              progressColor: kRed,
                            ),
                          ),
                          SizedBox(width: mobileWidth * 0.05),
                          Obx(
                            () => CircularProgressWidget(
                              label: 'Good',
                              percentage:
                                  progressController.goodPercentage.value,
                              progressColor: kTealGreen1,
                            ),
                          ),
                          SizedBox(width: mobileWidth * 0.05),
                          Obx(
                            () => CircularProgressWidget(
                              label: 'Excellent',
                              percentage:
                                  progressController.excellentPercentage.value,
                              progressColor: kMediumGreen2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                //Chart
                SectionCard(
                  image: AssetImage('assets/images/progress_chart.png'),
                  title: 'Days Performance',
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      ProgressChart(),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: 1),
      ),
    );
  }
}
