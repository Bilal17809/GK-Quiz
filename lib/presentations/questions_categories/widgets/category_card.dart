import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/models/category_model.dart';
import 'package:template/core/models/grid_data.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/questions_categories/controller/quiz_result_controller.dart'; // Import your controller

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  final String topic;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    // Get an instance of QuizResultController
    final QuizResultController quizResultController =
        Get.find<QuizResultController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: roundedDecoration.copyWith(
            color: gridColors[gridTexts.indexOf(topic) % gridColors.length]
                .withValues(alpha: 0.5),
            border: Border.all(color: kBlack.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              // Category Icon
              Container(
                height: 40,
                width: 40,
                decoration: roundedDecoration.copyWith(
                  color: kCoral,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    '${category.categoryIndex}',
                    style: Get.textTheme.titleSmall?.copyWith(
                      color: kWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Category Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level: ${category.categoryIndex}',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total: ${category.totalQuestions} Questions',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: textGreyColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Display quiz results
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: kDarkGreen1,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${quizResultController.lastCorrectAnswers.value} Correct',
                                style: Get.textTheme.bodySmall?.copyWith(
                                  color: kDarkGreen1,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.cancel, color: kRed, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '${quizResultController.lastWrongAnswers.value} Wrong',
                                style: Get.textTheme.bodySmall?.copyWith(
                                  color: kRed,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(3, (index) {
                              final percentage =
                                  quizResultController.lastPercentage.value;
                              IconData starIcon;
                              if (percentage >= (index + 1) * 33.33 ||
                                  (index == 2 && percentage > 66.66)) {
                                starIcon = Icons.star;
                              } else {
                                starIcon = Icons.star_border;
                              }
                              return Icon(
                                starIcon,
                                color: Colors.amber,
                                size: 18,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow Icon
              Container(
                height: 30,
                width: 30,
                decoration: roundedDecoration.copyWith(
                  color: kCoral,
                  borderRadius: BorderRadius.circular(17.5),
                ),
                child: Icon(Icons.arrow_forward_ios, color: kWhite, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
