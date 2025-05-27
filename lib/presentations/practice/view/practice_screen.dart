import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/core/models/grid_data.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';
import 'package:template/presentations/result/controller/result_controller.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizController());
    final QuizResultController1 resultController = Get.put(
      QuizResultController1(),
    );
    controller.loadAllTopicCounts(gridTexts);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz ############ ',
              style: Get.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text('Practice ', style: Get.textTheme.bodyLarge),
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
        child: GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 10,
            childAspectRatio: 3.2 / 4,
          ),
          itemCount: gridIcons.length,
          itemBuilder: (context, index) {
            final color = gridColors[index % gridColors.length].withValues(
              alpha: 0.75,
            );
            final icon = gridIcons[index % gridIcons.length];
            final text = gridTexts[index % gridTexts.length];

            return InkWell(
              onTap: () {
                // Navigate to categories screen
                Get.toNamed(
                  RoutesName.quizLevelsScreen,
                  arguments: {'topic': text, 'index': index},
                );
              },
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Container(
                    decoration: roundedDecoration.copyWith(color: color),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6, top: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Obx(
                                    () => Text(
                                      'Ques: ${controller.topicCounts[text] ?? 0}',
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                        color: kWhite,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Column(
                          children: [
                            Container(
                              decoration: roundedDecorationWithShadow.copyWith(
                                color: kWhite.withAlpha(50),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Image.asset(
                                icon,
                                color: kWhite,
                                width: 40,
                                height: 40,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                text,
                                style: Get.textTheme.titleSmall?.copyWith(
                                  color: textWhiteColor,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        // Real data section using FutureBuilder
                        FutureBuilder<Map<String, dynamic>>(
                          future: resultController.getOverallResult(index),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                padding: const EdgeInsets.all(8),
                                child: const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }

                            final data = snapshot.data!;
                            final percentage = data['percentage'] ?? 0.0;

                            return Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 2,
                                        ),
                                        decoration: roundedDecoration.copyWith(
                                          color: kWhite.withValues(alpha: 0.25),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${data['correct'] ?? 0}',
                                                  style: Get.textTheme.bodySmall
                                                      ?.copyWith(
                                                        color: kDarkGreen1,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),

                                                Icon(
                                                  Icons.done_all,
                                                  color: kDarkGreen1,
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  '${data['wrong'] ?? 0}',
                                                  style: Get.textTheme.bodySmall
                                                      ?.copyWith(
                                                        color: kRed.withValues(
                                                          alpha: 0.7,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),

                                                Icon(
                                                  Icons.close,
                                                  color: kRed.withValues(
                                                    alpha: 0.7,
                                                  ),
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Star rating based on percentage
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(4, (starIndex) {
                                        double starThreshold;
                                        if (starIndex == 0) {
                                          starThreshold = 10.0;
                                        } else {
                                          // Other 3 stars equally divide remaining 90%
                                          starThreshold =
                                              10.0 + ((starIndex) * 30.0);
                                        }

                                        bool isActive =
                                            percentage >= starThreshold;

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 1,
                                          ),
                                          child: Icon(
                                            Icons.star,
                                            color:
                                                isActive
                                                    ? kCoral
                                                    : kWhite.withValues(
                                                      alpha: 0.3,
                                                    ),
                                            size: 14,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
