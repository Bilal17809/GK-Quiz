import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:template/presentations/progress/view/progress_chart.dart';
import '../../../core/common_widgets/bottom_nav_bar.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/common_widgets/progress_circle.dart';
import '../../../core/common_widgets/section_card.dart';
import '../../../core/constant/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/common_widgets/circular_progress.dart';
import '../../quiz/controller/quiz_controller.dart';
import '../controller/progress_controller.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileWidth = MediaQuery.of(context).size.width;

    final ProgressController progressController =
        Get.find<ProgressController>();
    final QuizController quizController = Get.find<QuizController>();

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
          child: Obx(() {
            // Show loading spinner while data is being loaded
            if (progressController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
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
                                    progressController
                                        .learnWeakPercentage
                                        .value,
                                progressColor: kRed,
                              ),
                            ),
                            SizedBox(width: mobileWidth * 0.05),
                            Obx(
                              () => CircularProgressWidget(
                                label: 'Good',
                                percentage:
                                    progressController
                                        .learnGoodPercentage
                                        .value,
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
                                    progressController
                                        .excellentPercentage
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
            );
          }),
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: 1),
      ),
    );
  }
}
