import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_styles.dart';
import '../../quiz/controller/quiz_controller.dart';
import '../../quiz_levels/controller/quiz_result_controller.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/constant/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/practice_controller.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final resultController = Get.put(QuizResultController());
  final practiceController = Get.put(PracticeController());
  final quizController = Get.put(QuizController());

  Timer? _refreshTimer;

  final InterstitialAdController interstitialAd = Get.put(
    InterstitialAdController(),
  );
  final BannerAdController bannerAdController = Get.put(BannerAdController());

  @override
  void initState() {
    super.initState();
    interstitialAd.checkAndShowAd();
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      practiceController.loadAllQuestions();
      practiceController.refreshResults();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(subtitle: 'Quiz'),
      body: SafeArea(
        child: ListView.builder(
          itemCount: practiceController.gridItemCount,
          itemBuilder: (context, index) {
            final color = practiceController.getGridItemColor(index);
            final icon = practiceController.getGridItemIcon(index);
            final topic = practiceController.getGridItemText(index);

            return Card(
              margin: kCardMargin,
              elevation: 2,
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                onTap: () {
                  Get.toNamed(
                    RoutesName.quizLevelsScreen,
                    arguments: {'topic': topic, 'index': index},
                  );
                  _refreshTimer?.cancel();
                },
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: kWhite.withAlpha(50),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      icon,
                      color: kWhite,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                title: Text(
                  topic,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: textWhiteColor,
                    fontSize: 14,
                  ),
                ),
                subtitle: Obx(() {
                  final data = resultController.getOverallResultSync(index);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: roundedDecoration.copyWith(
                            color: kWhite.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${data['correct'] ?? 0}',
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: kDarkGreen1,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Icon(
                                    Icons.done_all,
                                    color: kDarkGreen1,
                                    size: 16,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 5),
                              Row(
                                children: [
                                  Text(
                                    '${data['wrong'] ?? 0}',
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: kRed.withValues(alpha: 0.7),
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Icon(
                                    Icons.close,
                                    color: kRed.withValues(alpha: 0.7),
                                    size: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() {
                      final data = resultController.getOverallResultSync(index);
                      final starRating = practiceController.getStarRating(
                        data['percentage'] ?? 0.0,
                      );
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            starRating.asMap().entries.map((entry) {
                              final isActive = entry.value;
                              return Icon(
                                Icons.star,
                                color:
                                    isActive
                                        ? kYellow
                                        : kWhite.withValues(alpha: 0.3),
                                size: 12,
                              );
                            }).toList(),
                      );
                    }),
                    Obx(
                      () => Text(
                        'Ques: ${(practiceController.topicCounts[topic] ?? 0) - ((practiceController.topicCounts[topic] ?? 0) % 20)}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: kWhite,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
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
      bottomNavigationBar:
          interstitialAd.isAdReady
              ? SizedBox()
              : Obx(() {
                return bannerAdController.getBannerAdWidget('ad12');
              }),
    );
  }
}
