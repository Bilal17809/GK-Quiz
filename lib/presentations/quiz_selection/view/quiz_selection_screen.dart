import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:template/core/ads/interstitial_ad/view/interstitial_ad.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/presentations/quiz_selection/view/quiz_selection_dialog.dart';

import '../../../core/ads/banner_ad/view/banner_ad.dart';
import '../../../core/common_widgets/grid_data.dart';
import '../../../core/common_widgets/round_image.dart';
import '../controller/quiz_selection_controller.dart';

class QuizSelectionScreen extends StatelessWidget {
  const QuizSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizSelectionController = Get.put(QuizSelectionController());

    return InterstitialAdWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: bgColor,
        appBar: CustomAppBar(subtitle: 'Quiz Builder'),
        body: Obx(() {
          if (quizSelectionController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: quizSelectionController.topics.length,
            itemBuilder: (context, index) {
              final topic = quizSelectionController.topics[index];
              final questionCount = quizSelectionController.getQuestionCount(
                topic,
              );
              final topicIndex = gridTexts.indexOf(topic);
              final cardColor = gridColors[topicIndex % gridColors.length]
                  .withValues(alpha: 0.64);
              final iconPath = gridIcons[topicIndex % gridIcons.length];
              return Card(
                margin: kCardMargin,
                elevation: 2,
                color: kWhite,
                child: InkWell(
                  onTap:
                      () => _showQuizSelectionDialog(
                        context,
                        topic,
                        questionCount,
                      ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: cardColor,
                      child: Image.asset(
                        iconPath,
                        height: 28,
                        width: 28,
                        color: kWhite,
                      ),
                    ),
                    title: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(topic, style: context.textTheme.titleSmall),
                    ),
                    subtitle: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Total Questions: $questionCount',
                        style: context.textTheme.bodySmall,
                      ),
                    ),
                    trailing: RoundedButton(
                      backgroundColor: skyColor,
                      width: 24,
                      child: Icon(Icons.chevron_right, color: kWhite, size: 18),
                    ),
                  ),
                ),
              );
            },
          );
        }),
        bottomNavigationBar: const Padding(
          padding: kBottomNav,
          child: BannerAdWidget(adSize: AdSize.banner),
        ),
      ),
    );
  }

  void _showQuizSelectionDialog(
    BuildContext context,
    String topic,
    int maxQuestions,
  ) {
    Get.dialog(
      QuizSelectionDialog(
        topic: topic,
        maxQuestions: maxQuestions,
        onStartQuiz: (selectedCount) {
          Get.toNamed(
            RoutesName.customizedQuizScreen,
            arguments: {'topic': topic, 'questionCount': selectedCount},
          );
        },
      ),
    );
  }
}
