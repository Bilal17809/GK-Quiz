import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/category_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

import '../controller/country_levels_controller.dart';

class CountryLevelsCard extends StatefulWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  final String topic;
  final int topicIndex;
  final int categoryIndex;

  const CountryLevelsCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.topic,
    required this.topicIndex,
    required this.categoryIndex,
  });

  @override
  State<CountryLevelsCard> createState() => _CountryLevelsCardState();
}

class _CountryLevelsCardState extends State<CountryLevelsCard> {
  @override
  Widget build(BuildContext context) {
    final CountryLevelsController countryResultController =
        Get.find<CountryLevelsController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: roundedDecoration.copyWith(
            color: kTealGreen1.withValues(alpha: 0.7),
            border: Border.all(color: kBlack.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Category Icon
                  Container(
                    height: 40,
                    width: 40,
                    decoration: roundedDecoration.copyWith(
                      color: kTealGreen1.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.category.categoryIndex}',
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
                          'Level: ${widget.category.categoryIndex}',
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: kWhite,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total: ${widget.category.totalQuestions} Questions',
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
                    height: 30,
                    width: 30,
                    decoration: roundedDecoration.copyWith(
                      color: kTealGreen1.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(17.5),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: kWhite,
                      size: 16,
                    ),
                  ),
                ],
              ),
              // Quiz Results Section
              const SizedBox(height: 12),

              Obx(() {
                countryResultController.refreshAllResults();
                return FutureBuilder<Map<String, dynamic>>(
                  future: countryResultController.getQuizResult(
                    widget.topicIndex,
                    widget.categoryIndex + 1,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        child: const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    // Results section
                    final data = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: kWhite.withValues(alpha: 0.75),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: kDarkGreen1,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${data['correct'] ?? 0}',
                                        style: Get.textTheme.bodySmall
                                            ?.copyWith(
                                              color: kDarkGreen1,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.cancel,
                                        color: kRed.withValues(alpha: 0.7),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${data['wrong'] ?? 0}',
                                        style: Get.textTheme.bodySmall
                                            ?.copyWith(
                                              color: kRed.withValues(
                                                alpha: 0.7,
                                              ),
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.radio_button_checked,
                                        color: kTealGreen1.withValues(
                                          alpha: 0.9,
                                        ),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${data['percentage']?.toStringAsFixed(0) ?? '0'} %',
                                        style: Get.textTheme.bodySmall
                                            ?.copyWith(
                                              color: kTealGreen1.withValues(
                                                alpha: 0.9,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
