import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../controller/progress_controller.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    final ProgressController progressController =
        Get.find<ProgressController>();

    return Obx(() {
      Map<String, double> dailyData = progressController.dailyPerformance;
      List<String> days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      List<String> dayLabels = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      ];

      List<double> values = days.map((day) => dailyData[day] ?? 0.0).toList();
      List<String> percentages =
          values.map((value) => '${value.toInt()}%').toList();
      List<int> yAxisValues = [100, 80, 60, 40, 20, 0];

      return SizedBox(
        height: 180,
        child: Column(
          children: [
            // Percentage labels
            SizedBox(
              height: 20,
              child: Row(
                children: [
                  SizedBox(width: 40),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          percentages
                              .map(
                                (percent) => Text(
                                  percent,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
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
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),

                  // Chart bars
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
                              color: greyBorderColor.withValues(alpha: 0.25),
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
                                // Calculate height based on percentage
                                double maxHeight = 120;
                                double barHeight =
                                    values[index] == 0
                                        ? 2
                                        : (values[index] / 100.0) * maxHeight;

                                if (barHeight > 0 && barHeight < 5) {
                                  barHeight = 5;
                                }
                                Color barColor;
                                if (values[index] <= 40) {
                                  barColor = kRed.withValues(alpha: 0.9);
                                } else if (values[index] <= 70) {
                                  barColor = kOrange.withValues(alpha: 0.9);
                                } else if (values[index] > 0) {
                                  barColor = kMediumGreen1.withValues(
                                    alpha: 0.9,
                                  );
                                } else {
                                  barColor = greyColor.withValues(alpha: 0.5);
                                }

                                return Container(
                                  width: 16,
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: barColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                    boxShadow:
                                        values[index] > 0
                                            ? [
                                              BoxShadow(
                                                color: barColor.withValues(
                                                  alpha: 0.25,
                                                ),
                                                blurRadius: 2,
                                                offset: Offset(0, 1),
                                              ),
                                            ]
                                            : null,
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
                SizedBox(width: 40),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        dayLabels
                            .map(
                              (label) => Text(
                                label,
                                style: context.textTheme.bodySmall,
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
