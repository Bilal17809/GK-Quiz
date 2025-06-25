import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/common_widgets/long_icon_text_button.dart';
import '../../../core/constant/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../controller/country_qna_controller.dart';

class CountryQnaScreen extends StatefulWidget {
  const CountryQnaScreen({super.key});

  @override
  State<CountryQnaScreen> createState() => _CountryQnaScreenState();
}

class _CountryQnaScreenState extends State<CountryQnaScreen> {
  final InterstitialAdController interstitialAd=Get.put(InterstitialAdController());
  final BannerAdController bannerAdController=Get.put(BannerAdController());

  @override
  void initState() {
    super.initState();
    interstitialAd.checkAndShowAd();
  }
  @override
  Widget build(BuildContext context) {
    final countryQnaController = Get.put(CountryQnaController());
    final topic = (Get.arguments as Map<String, dynamic>)['topic'] ?? '';

    return Scaffold(
      appBar: CustomAppBar(subtitle: 'Topic - $topic'),
      body: Obx(() {
        if (countryQnaController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: countryQnaController.questionsList.length,
          padding: const EdgeInsets.all(kBodyHp),
          itemBuilder: (context, index) {
            final question = countryQnaController.questionsList[index];
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
                            color: kRed.withValues(alpha: 0.7),
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
                      final isAnswerRevealed = countryQnaController
                          .isAnswerRevealed(index);

                      if (isAnswerRevealed) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          decoration: roundedDecorationWithShadow.copyWith(
                            color: kRed.withValues(alpha: 0.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Answer:',
                                style: context.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kRed.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                countryQnaController.getCorrectOptionText(
                                  question,
                                ),
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
                                  () => countryQnaController.revealAnswer(
                                index,
                              ),
                              text: 'Answer',
                              icon: Icon(Icons.remove_red_eye, size: 16),
                              color: kRed.withValues(alpha: 0.7),
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
      bottomNavigationBar:interstitialAd.isAdReady?SizedBox(): Obx(() {
          return bannerAdController.getBannerAdWidget('ad5');
      }),
    );
  }
}
