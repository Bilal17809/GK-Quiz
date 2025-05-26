import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/core/models/grid_data.dart';
import 'package:template/presentations/questions/controller/questions_controller.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionsController());
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
                  RoutesName.questionsCategoriesScreen,
                  arguments: {
                    'topic': text,
                    'index': index,
                  },
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
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Correct: 0',
                                style: Get.textTheme.bodySmall?.copyWith(
                                  color: kWhite,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Wrong: 0',
                                style: Get.textTheme.bodySmall?.copyWith(
                                  color: kWhite,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Skipped: 1',
                                style: Get.textTheme.bodySmall?.copyWith(
                                  color: kWhite,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Not Attempt: 247',
                                style: Get.textTheme.bodySmall?.copyWith(
                                  color: kWhite,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
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
