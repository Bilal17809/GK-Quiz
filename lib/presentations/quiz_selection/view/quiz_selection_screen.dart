import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/common_text_button.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';

import '../../../core/common_widgets/grid_data.dart';
import '../controller/quiz_selection_controller.dart';

class QuizSelectionScreen extends StatelessWidget {
  const QuizSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizSelectionController = Get.put(QuizSelectionController());
    final mobileSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(subtitle: 'Take a Test'),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Obx(() {
                if (quizSelectionController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: quizSelectionController.topics.length,
                  itemBuilder: (context, index) {
                    final topic = quizSelectionController.topics[index];
                    final questionCount = quizSelectionController
                        .getQuestionCount(topic);

                    // Get topic metadata
                    final topicIndex = gridTexts.indexOf(topic);
                    final cardColor = gridColors[topicIndex % gridColors.length]
                        .withValues(alpha: 0.64);
                    final iconPath = gridIcons[topicIndex % gridIcons.length];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 2,
                      color: kWhite,
                      child: InkWell(
                        onTap: () => quizSelectionController.selectTopic(topic),
                        child: SizedBox(
                          height: mobileSize.height * 0.1,

                          child: Row(
                            children: [
                              Container(
                                width: mobileSize.width * 0.2,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    iconPath,
                                    height: mobileSize.height * 0.05,
                                    color: kWhite,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      topic,
                                      style: Get.textTheme.titleSmall,
                                    ),
                                  ),
                                  subtitle: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Total Questions: $questionCount',
                                      style: Get.textTheme.bodySmall,
                                    ),
                                  ),
                                  trailing: Obx(
                                    () => Checkbox(
                                      value: quizSelectionController.isSelected(
                                        topic,
                                      ),
                                      onChanged:
                                          (_) => quizSelectionController
                                              .selectTopic(topic),
                                      activeColor: skyColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          Container(
            height: mobileSize.height * 0.07,
            color: skyColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
              child: Obx(() {
                final min = 1;
                final max = quizSelectionController.maxQuestions.value;
                final current = quizSelectionController
                    .selectedQuestionCount
                    .value
                    .clamp(min, max);

                return Row(
                  children: [
                    Text(
                      current.toString(),
                      style: Get.textTheme.bodyLarge?.copyWith(color: kWhite),
                    ),
                    Expanded(
                      child: Slider(
                        activeColor: kWhite,
                        value: current.toDouble(),
                        min: min.toDouble(),
                        max: max.toDouble(),
                        divisions: (max - min),
                        onChanged: quizSelectionController.updateQuestionCount,
                      ),
                    ),

                    Text(
                      max.toString(),
                      style: Get.textTheme.bodyLarge?.copyWith(color: kWhite),
                    ),
                    const SizedBox(width: 16),
                    SimpleTextButton(
                      onPressed:
                          quizSelectionController.canStart()
                              ? () => Get.toNamed(
                                RoutesName.customizedQuizScreen,
                                arguments:
                                    quizSelectionController.getQuizData(),
                              )
                              : () => Get.snackbar(
                                'Error',
                                'Please select a topic',
                              ),
                      text: 'Start',
                      style: Get.textTheme.titleMedium,
                      foregroundColor: kWhite,
                      color:
                          quizSelectionController.canStart()
                              ? kIndigo
                              : greyBorderColor,
                      width: mobileSize.width * 0.17,
                      height: mobileSize.height * 0.05,
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
