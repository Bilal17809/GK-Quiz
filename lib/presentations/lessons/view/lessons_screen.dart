import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';

import '../../../core/common_widgets/grid_data.dart';
import '../../../core/constant/constant.dart';
import '../../../core/routes/routes_name.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(subtitle: 'Lesson to Study'),
      body: SafeArea(
        child: GridView.builder(
          padding: kGridPadding,
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
            return InkWell(
              onTap: () {
                Get.toNamed(
                  RoutesName.qnaScreen,
                  arguments: {'topic': gridTexts[index]},
                );
              },
              child: Container(
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
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          text,
                          style: context.textTheme.titleSmall!.copyWith(
                            color: textWhiteColor,
                          ),
                        ),
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
