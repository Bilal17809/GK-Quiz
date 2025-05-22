import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/core/models/grid_data.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

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
            Text('Practice', style: Get.textTheme.bodyLarge),
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
            childAspectRatio: 3.5 / 4,
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
                Get.toNamed(
                  RoutesName.questionsScreen,
                  arguments: {'topic': gridTexts[index]},
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Ques: 248',
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: kWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
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
                        const SizedBox(height: 12),
                        Text(
                          text,
                          style: Get.textTheme.titleSmall!.copyWith(
                            color: textWhiteColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Correct: 0',
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: kWhite,
                            ),
                          ),
                          Text(
                            'Wrong: 0',
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: kWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 4,
                        bottom: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Skipped: 1',
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: kWhite,
                            ),
                          ),
                          Text(
                            'Not Attempt: 247',
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: kWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
