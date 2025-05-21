import 'package:flutter/material.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/extension/extension.dart';
import 'package:template/core/models/grid_data.dart';
import 'package:template/presentations/questions/view/questions_screen.dart';

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
              style: context.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text('Practice', style: context.textTheme.bodyLarge),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: RoundedButton(
            backgroundColor: kRed,
            onTap: () {
              Navigator.pop(context);
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => QuestionsScreen(topic: gridTexts[index]),
                  ),
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
                                style: context.textTheme.bodyMedium?.copyWith(
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
                          style: context.textTheme.titleSmall!.copyWith(
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
                            style: context.textTheme.bodySmall?.copyWith(
                              color: kWhite,
                            ),
                          ),
                          Text(
                            'Wrong: 0',
                            style: context.textTheme.bodySmall?.copyWith(
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
                            style: context.textTheme.bodySmall?.copyWith(
                              color: kWhite,
                            ),
                          ),
                          Text(
                            'Not Attempt: 247',
                            style: context.textTheme.bodySmall?.copyWith(
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
