import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:template/core/common_widgets/big_icon_text_button.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/common_widgets/long_icon_text_button.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/navigation_drawer/view/navigation_drawer.dart';
import '../../../core/ad_controllers/banner_ad/view/banner_ad.dart';
import '../../../core/common_widgets/bottom_nav_bar.dart';
import '../../../core/common_widgets/round_image.dart';
import '../../example_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        drawer: const NavigationDrawerWidget(),
        appBar: CustomAppBar(
          subtitle: 'Level Up Your Learning',
          useBackButton: false,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
              child: RoundedButton(
                onTap: () {},
                child: Image.asset(
                  'assets/images/no-ads.png',
                  color: kWhite,
                  width: 24,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kBodyHp),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: BigIconTextButton(
                        height: mobileWidth * 0.40,
                        width: mobileWidth * 0.40,
                        color: kBlue.withValues(alpha: 0.9),
                        onPressed: () {
                          Get.toNamed(RoutesName.learningHubScreen);
                        },
                        text: 'Learning Hub',
                        icon: Container(
                          decoration: roundedDecoration.copyWith(
                            color: kWhite.withValues(alpha: 0.2),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/reading-book.png',
                            color: kWhite,
                            width: mobileWidth * 0.1,
                            height: mobileWidth * 0.1,
                          ),
                        ),
                        style: context.textTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(width: mobileWidth * 0.03),
                    Expanded(
                      child: BigIconTextButton(
                        height: mobileWidth * 0.40,
                        width: mobileWidth * 0.40,
                        color: kCoral.withValues(alpha: 0.9),
                        onPressed: () {
                          Get.toNamed(RoutesName.practiceScreen);
                        },
                        text: 'Quiz',
                        icon: Container(
                          decoration: roundedDecoration.copyWith(
                            color: kWhite.withValues(alpha: 0.2),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/checklist.png',
                            color: kWhite,
                            width: mobileWidth * 0.1,
                            height: mobileWidth * 0.1,
                          ),
                        ),
                        style: context.textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                LongIconTextButton(
                  height: mobileWidth * 0.30,
                  color: kYellow,
                  onPressed: () {
                    Get.toNamed(RoutesName.quizSelectionScreen);
                  },
                  text: 'Quiz Builder',
                  icon: Container(
                    decoration: roundedDecoration.copyWith(
                      color: kWhite.withValues(alpha: 0.2),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/test.png',
                      color: kWhite,
                      width: mobileWidth * 0.1,
                      height: mobileWidth * 0.1,
                    ),
                  ),
                  style: context.textTheme.titleMedium?.copyWith(color: kWhite),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: BigIconTextButton(
                        height: mobileWidth * 0.40,
                        width: mobileWidth * 0.40,
                        color: kRed.withValues(alpha: 0.7),
                        onPressed: () {
                          Get.toNamed(RoutesName.countryLessonsScreen);
                        },
                        text: 'World Facts',
                        icon: Container(
                          decoration: roundedDecoration.copyWith(
                            color: kWhite.withValues(alpha: 0.2),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/globe.png',
                            color: kWhite,
                            width: mobileWidth * 0.1,
                            height: mobileWidth * 0.1,
                          ),
                        ),
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(width: mobileWidth * 0.03),
                    Expanded(
                      child: BigIconTextButton(
                        height: mobileWidth * 0.40,
                        width: mobileWidth * 0.40,
                        color: kTealGreen1.withValues(alpha: 0.9),
                        onPressed: () {
                          Get.toNamed(RoutesName.countryScreen);
                        },
                        text: 'Global Challenge',
                        icon: Container(
                          decoration: roundedDecoration.copyWith(
                            color: kWhite.withValues(alpha: 0.2),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/world_map.png',
                            color: kWhite,
                            width: mobileWidth * 0.1,
                            height: mobileWidth * 0.1,
                          ),
                        ),
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                LongIconTextButton(
                  height: mobileWidth * 0.3,
                  color: kMediumGreen2.withValues(alpha: 0.9),
                  onPressed: () {
                    Get.toNamed(RoutesName.contextSelectionScreen);
                  },
                  text: 'Smart Quiz',
                  icon: Container(
                    decoration: roundedDecoration.copyWith(
                      color: kWhite.withValues(alpha: 0.2),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/ai-quiz.png',
                      color: kWhite,
                      width: mobileWidth * 0.1,
                      height: mobileWidth * 0.1,
                    ),
                  ),
                  style: context.textTheme.titleMedium?.copyWith(color: kWhite),
                ),
                const SizedBox(height: 12),
                ElevatedButton(onPressed:(){
                  Get.to(SpeechInputScreen());
                }, child:Text("Gooogle dialog")),
                const SizedBox(height: 12),
                const BannerAdWidget(adSize: AdSize.banner),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      ),
    );
  }
}
