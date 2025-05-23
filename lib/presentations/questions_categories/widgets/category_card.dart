import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/models/category_model.dart';
import 'package:template/core/models/grid_data.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';

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
                      category.title,
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Questions ${category.questionsRange}',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: greyColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total: ${category.totalQuestions} Questions',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: kWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Container(
                height: 35,
                width: 35,
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
