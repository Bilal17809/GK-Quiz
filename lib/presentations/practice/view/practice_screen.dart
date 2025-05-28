import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/practice/controller/practice_controller.dart';
import 'package:template/presentations/quiz/controller/quiz_controller.dart';
import 'package:template/presentations/result/controller/result_controller.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller initialization
    final quizController = Get.put(QuizController());
    final resultController = Get.put(QuizResultController1());
    final practiceController = Get.put(PracticeController());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz',
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
          itemCount: practiceController.gridItemCount,
          itemBuilder: (context, index) {
            final color = practiceController.getGridItemColor(index);
            final icon = practiceController.getGridItemIcon(index);
            final topic = practiceController.getGridItemText(index);

            return InkWell(
              onTap: () {
                // Navigate to categories screen
                Get.toNamed(
                  RoutesName.quizLevelsScreen,
                  arguments: {'topic': topic, 'index': index},
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
                              child: Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Ques: ${quizController.topicCounts[topic] ?? 0}',
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                        color: kWhite,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Column(
                          children: [
                            Container(
                              decoration: roundedDecorationWithShadow.copyWith(
                                color: kWhite.withAlpha(50),
                              ),
                              padding: const EdgeInsets.all(8),
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
                                topic,
                                style: Get.textTheme.titleSmall?.copyWith(
                                  color: textWhiteColor,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
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
                            final starRating = practiceController.getStarRating(
                              percentage,
                            );

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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children:
                                          starRating.asMap().entries.map((
                                            entry,
                                          ) {
                                            final isActive = entry.value;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                          }).toList(),
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
