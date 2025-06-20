import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/common_widgets/long_icon_text_button.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/constant/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../controller/qna_controller.dart';

class QnaScreen extends StatefulWidget {
  const QnaScreen({super.key});

  @override
  State<QnaScreen> createState() => _QnaScreenState();
}

class _QnaScreenState extends State<QnaScreen> {

  final InterstitialAdController interstitialAd=Get.put(InterstitialAdController());


  @override
  void initState() {
    super.initState();
    interstitialAd.checkAndShowAd();
  }

  @override
  Widget build(BuildContext context) {
    final qnaController = Get.put(QnaController());
    final topic = (Get.arguments as Map<String, dynamic>)['topic'] ?? '';

    return Scaffold(
      appBar: CustomAppBar(subtitle: 'Topic - $topic'),
      body: Obx(() {
        if (qnaController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: qnaController.questionsList.length,
          padding: const EdgeInsets.all(kBodyHp),
          itemBuilder: (context, index) {
            final question = qnaController.questionsList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: kWhite,
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          padding: EdgeInsets.all(2),
                          decoration: roundedDecoration.copyWith(
                            color: skyColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${index + 1}',
                                style: context.textTheme.titleLarge?.copyWith(
                                  color: kWhite,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                question.question,
                                style: context.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Obx(() {
                      final isAnswerRevealed = qnaController.isAnswerRevealed(
                        index,
                      );

                      if (isAnswerRevealed) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          decoration: roundedDecorationWithShadow.copyWith(
                            color: skyColor.withValues(alpha: 0.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Answer:',
                                style: context.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: skyColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                qnaController.getCorrectOptionText(question),
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: kBlack,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      30,
                                    ), // more circular
                                  ),
                                ),
                              ),
                            ),
                            child: LongIconTextButton(
                              width: 120,
                              height: 40,
                              style: context.textTheme.titleSmall?.copyWith(
                                color: kWhite,
                              ),
                              onPressed:
                                  () => qnaController.revealAnswer(index),
                              text: 'Answer',
                              icon: Icon(Icons.remove_red_eye, size: 16),
                              color: skyColor,
                            ),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            );
          },
        );
      }),
      // bottomNavigationBar: const Padding(
      //   padding: kBottomNav,
      //   child: BannerAdWidget(),
      // ),
    );
  }
}
