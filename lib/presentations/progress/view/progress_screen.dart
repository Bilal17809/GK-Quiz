import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/bottom_nav_bar.dart';
import 'package:template/core/common_widgets/progress_circle.dart';
import 'package:template/core/common_widgets/section_card.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/presentations/progress/controller/progress_controller.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';

import '../../../core/common_widgets/circular_progress.dart';
import '../../../core/common_widgets/round_image.dart';
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
      if (_hasDataLoaded()) {
        timer.cancel();
      }
    });
  }

  bool _hasDataLoaded() {
    return progressController.totalAvailable.value > 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobileWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz',
              style: Get.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text('Progress', style: Get.textTheme.bodyLarge),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: RoundedButton(
            backgroundColor: kRed,
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/back.png', color: kWhite),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kBodyHp),
          child: Column(
            children: [
              //Learn Progress
              SectionCard(
                image: AssetImage('assets/images/progress_meter.png'),
                title: 'Learn Progress',
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    ProgressCircle(
                      icon: Icons.file_copy_rounded,
                      label: 'Learn/Total',
                      value: 1,
                      totalValue: 157,
                    ),
                    SizedBox(height: 6),
                    Divider(),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressWidget(
                          label: 'Weak',
                          percentage: 10,
                          progressColor: kRed,
                        ),
                        SizedBox(width: mobileWidth * 0.05),
                        CircularProgressWidget(
                          label: 'Good',
                          percentage: 40,
                          progressColor: kTealGreen1,
                        ),
                        SizedBox(width: mobileWidth * 0.05),
                        CircularProgressWidget(
                          label: 'Excellent',
                          percentage: 24,
                          progressColor: kMediumGreen2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              //Overall Test
              SectionCard(
                image: AssetImage('assets/images/progress_result.png'),
                title: 'Overall Test',
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
                            totalValue: progressController.totalAvailable.value,
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
                            percentage: progressController.weakPercentage.value,
                            progressColor: kRed,
                          ),
                        ),
                        SizedBox(width: mobileWidth * 0.05),
                        Obx(
                          () => CircularProgressWidget(
                            label: 'Good',
                            percentage: progressController.goodPercentage.value,
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
              //Bottom Bar
              // Container(
              //   height: mobileHeight * 0.07,
              //   color: skyColor,
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
              //     child: Row(
              //       children: [
              //         const SizedBox(width: 16),
              //         SimpleTextButton(
              //           onPressed: () {},
              //           text: 'Home',
              //           foregroundColor: kWhite,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileHeight = MediaQuery.of(context).size.height;
    final mobileWidth = MediaQuery.of(context).size.width;
    List<String> percentages = ['100%', '0%', '3%', '0%', '15%', '0%', '0%'];
    List<int> values = [100, 0, 3, 0, 15, 0, 0]; // Actual percentage values
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<int> yAxisValues = [100, 80, 60, 40, 20, 0];

    return SizedBox(
      height: 180,
      child: Column(
        children: [
          // Percentage labels above bars
          SizedBox(
            height: 20,
            child: Row(
              children: [
                SizedBox(width: 40), // Space for Y-axis
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        percentages
                            .map(
                              (percent) =>
                                  Text(percent, style: Get.textTheme.bodySmall),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Chart area with Y-axis and bars
          Expanded(
            child: Row(
              children: [
                // Y-axis labels
                SizedBox(
                  width: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:
                        yAxisValues
                            .map(
                              (value) => Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text(
                                  value.toString(),
                                  style: Get.textTheme.bodySmall,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                // Chart bars with grid lines
                Expanded(
                  child: Stack(
                    children: [
                      // Grid lines
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => Container(
                            height: 1,
                            color: greyBorderColor.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                      // Bars
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(7, (index) {
                              // Calculate height based on percentage (3% of total height)
                              double maxHeight =
                                  120; // Available height for bars
                              double barHeight =
                                  values[index] == 0
                                      ? 2
                                      : (values[index] / 100.0) * maxHeight;

                              return Container(
                                width: 16,
                                height: barHeight,
                                decoration: BoxDecoration(
                                  color:
                                      values[index] > 0
                                          ? skyColor.withValues(alpha: 0.9)
                                          : greyBorderColor.withValues(
                                            alpha: 0.2,
                                          ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Day labels at bottom
          Row(
            children: [
              SizedBox(width: 40), // Space for Y-axis
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      days
                          .map(
                            (day) => Text(day, style: Get.textTheme.bodySmall),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
