import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/practice/controller/practice_controller.dart';

import '../../quiz/controller/quiz_controller.dart';
import '../../quiz_levels/controller/quiz_result_controller.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  // Initialize controllers
  final resultController = Get.put(QuizResultController());
  final practiceController = Get.put(PracticeController());
  final quizController = Get.put(QuizController());

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      practiceController.loadAllQuestions();
      // Refresh cached results periodically
      practiceController.refreshResults();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                _refreshTimer?.cancel();
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: roundedDecoration.copyWith(color: color),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
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
                        const Spacer(),
                        // Replace FutureBuilder with Obx for reactive stats
                        Obx(() {
                          final data = resultController.getOverallResultSync(
                            index,
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
                                const SizedBox(height: 12),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  // Replace FutureBuilder with Obx for reactive stars
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Obx(() {
                      final data = resultController.getOverallResultSync(index);
                      final starRating = practiceController.getStarRating(
                        data['percentage'] ?? 0.0,
                      );
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            starRating.asMap().entries.map((entry) {
                              final isActive = entry.value;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 1,
                                ),
                                child: Icon(
                                  Icons.star,
                                  color:
                                      isActive
                                          ? kCoral
                                          : kWhite.withValues(alpha: 0.3),
                                  size: 14,
                                ),
                              );
                            }).toList(),
                      );
                    }),
                  ),
                  // Positioned Ques text at top right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Obx(
                      () => Text(
                        'Ques: ${practiceController.topicCounts[topic] ?? 0}',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: kWhite,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
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
    );
  }
}
