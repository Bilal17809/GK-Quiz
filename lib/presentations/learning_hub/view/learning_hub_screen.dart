import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/grid_data.dart';
import '../../../core/constant/constant.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/theme/app_colors.dart';

class LearningHubScreen extends StatefulWidget {
  const LearningHubScreen({super.key});

  @override
  State<LearningHubScreen> createState() => _LearningHubScreenState();
}

class _LearningHubScreenState extends State<LearningHubScreen> {
  final InterstitialAdController interstitialAd=Get.put(InterstitialAdController());
  final BannerAdController bannerAdController=Get.put(BannerAdController());

  @override
  void initState() {
    super.initState();
    interstitialAd.checkAndShowAd();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(subtitle: 'Learning Hub'),
      body: SafeArea(
        child: ListView.builder(
          itemCount: gridTexts.length,
          itemBuilder: (context, index) {
            final color = gridColors[index % gridColors.length].withValues(
              alpha: 0.75,
            );
            final icon = gridIcons[index % gridIcons.length];
            final text = gridTexts[index % gridTexts.length];

            return Card(
              margin: kCardMargin,
              elevation: 2,
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  Get.toNamed(
                    RoutesName.qnaScreen,
                    arguments: {'topic': gridTexts[index]},
                  );
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                    text,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: textWhiteColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar:interstitialAd.isAdReady?SizedBox():Obx(() {
          return bannerAdController.getBannerAdWidget('ad11');
      }),
    );
  }
}

