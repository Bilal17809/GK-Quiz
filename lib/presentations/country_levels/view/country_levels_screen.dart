import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/presentations/country_levels/widgets/country_levels_card.dart';

import '../../../core/common_widgets/round_image.dart';
import '../../../core/constant/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../quiz/controller/quiz_controller.dart';
import '../controller/country_result_controller.dart';

class CountryLevelsScreen extends StatelessWidget {
  const CountryLevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final topic = arguments['topic'];
    final topicIndex =
        arguments['index']; // This is the grid index from country screen
    final QuizController quizController = Get.put(QuizController());
    Get.put(CountryResultController());

    if (topic.isNotEmpty) {
      quizController.loadCategoriesForTopic(topic);
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
            Text('Country Levels', style: Get.textTheme.bodyLarge),
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
                  color: kTealGreen1.withValues(alpha: 0.7),
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
                        'Total Questions: ${quizController.topicCounts[topic] ?? 0}',
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
                if (quizController.isLoadingCategories.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: quizController.questionCategories.length,
                  itemBuilder: (context, categoryIndex) {
                    final category =
                        quizController.questionCategories[categoryIndex];
                    return CountryLevelsCard(
                      category: category,
                      topicIndex: topicIndex,
                      categoryIndex: categoryIndex,
                      onTap: () {
                        quizController.resetQuizState();
                        Get.toNamed(
                          RoutesName.countryQuizScreen,
                          arguments: {
                            'topic': category.topic,
                            'categoryIndex': category.categoryIndex,
                            'isCategory': true,
                            'topicIndex':
                                topicIndex, // Pass the topic grid index
                            'categoryIndexForResult':
                                categoryIndex, // Pass the category index for result
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
