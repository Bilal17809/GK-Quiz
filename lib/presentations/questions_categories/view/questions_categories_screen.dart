import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/models/grid_data.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/presentations/questions/controller/questions_controller.dart';
import 'package:template/presentations/questions_categories/widgets/category_card.dart';

class QuestionsCategoriesScreen extends StatelessWidget {
  const QuestionsCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String topic = Get.arguments?['topic'] ?? '';
    final QuestionsController controller = Get.put(QuestionsController());

    // Load categories for the current topic
    if (topic.isNotEmpty) {
      controller.loadCategoriesForTopic(topic);
    } else {
      Get.snackbar(
        'AN UNEXPECTED ERROR OCCURRED',
        'Unable to fetch categories from the database at the moment, please try later',
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz',
              style: Get.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text('Categories', style: Get.textTheme.bodyLarge),
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
        child: Column(
          children: [
            // Topic Header
            if (topic.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(kBodyHp),
                padding: const EdgeInsets.all(kBodyHp),
                decoration: roundedDecoration.copyWith(
                  color: gridColors[gridTexts.indexOf(topic) %
                          gridColors.length]
                      .withValues(alpha: 0.7),
                  border: Border.all(color: greyBorderColor),
                ),
                child: Column(
                  children: [
                    Text(
                      topic,
                      style: Get.textTheme.titleLarge?.copyWith(
                        color: kWhite,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Text(
                        'Total Questions: ${controller.topicCounts[topic] ?? 0}',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: kWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Categories List
            Expanded(
              child: Obx(() {
                if (controller.isLoadingCategories.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.questionCategories.length,
                  itemBuilder: (context, index) {
                    final category = controller.questionCategories[index];
                    return CategoryCard(
                      category: category,
                      onTap: () {
                        // Reset quiz state before starting new category
                        controller.resetQuizState();

                        // Navigate to questions screen
                        Get.toNamed(
                          RoutesName.questionsScreen,
                          arguments: {
                            'topic': category.topic,
                            'categoryIndex': category.categoryIndex,
                            'isCategory': true,
                          },
                        );
                      },
                      topic: topic,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
