import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/presentations/quiz_selection/view/quiz_selection_dialog.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/grid_data.dart';
import '../../../core/common_widgets/round_image.dart';
import '../controller/quiz_selection_controller.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/constant/constant.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';

class QuizSelectionScreen extends StatefulWidget {
  const QuizSelectionScreen({super.key});

  @override
  State<QuizSelectionScreen> createState() => _QuizSelectionScreenState();
}

class _QuizSelectionScreenState extends State<QuizSelectionScreen> {


  final InterstitialAdController interstitialAd=Get.put(InterstitialAdController());
  final BannerAdController bannerAdController=Get.put(BannerAdController());


  @override
  void initState() {
    super.initState();
    interstitialAd.checkAndShowAd();
  }

  @override
  Widget build(BuildContext context) {
    final quizSelectionController = Get.put(QuizSelectionController());

    return Scaffold(
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
      bottomNavigationBar:interstitialAd.isAdReady?SizedBox(): Obx(() {
        return bannerAdController.getBannerAdWidget('ad16');
      }),
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
