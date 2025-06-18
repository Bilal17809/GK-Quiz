import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/theme/app_colors.dart';
import '../../../core/ad_controllers/interstitial_ad_controller.dart';
import '../../../core/common_widgets/grid_data.dart';
import '../../../core/constant/constant.dart';
import '../../../core/routes/routes_name.dart';

class LearningHubScreen extends StatelessWidget {
  const LearningHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adManager = Get.find<InterstitialAdController>();
    adManager.maybeShowAdForScreen('LearningHubScreen');
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
    );
  }
}
