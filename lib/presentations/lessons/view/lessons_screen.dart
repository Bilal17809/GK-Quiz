import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/common_widgets.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import '../../../core/models/grid_data.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

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
            Text('Lesson to Study', style: Get.textTheme.bodyLarge),
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
            childAspectRatio: 1,
          ),
          itemCount: gridTexts.length,
          itemBuilder: (context, index) {
            final color = gridColors[index % gridColors.length].withValues(
              alpha: 0.75,
            );
            final icon = gridIcons[index % gridIcons.length];
            final text = gridTexts[index % gridTexts.length];
            return Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  const SizedBox(height: 8),
                  Text(
                    text,
                    style: Get.textTheme.titleSmall!.copyWith(
                      color: textWhiteColor,
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
