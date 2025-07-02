import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/big_icon_text_button.dart';
import '../../../core/common_widgets/bottom_nav_bar.dart';
import '../../../core/common_widgets/long_icon_text_button.dart';
import '../../../core/common_widgets/round_image.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/constant/constant.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

import '../../navigation_drawer/view/navigation_drawer.dart';
import '../contrl/home_contrl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TrackingController tracking = Get.put(TrackingController());

  @override
  void initState() {
    super.initState();
    tracking.requestTrackingPermission();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTall = constraints.maxHeight > 675;
        final buttonHeight = isTall ? 140.0 : 120.0;
        final iconSize = isTall ? 36.0 : 30.0;

        return Scaffold(
          drawer: const NavigationDrawerWidget(),
          appBar: CustomAppBar(
            subtitle: 'Level Up Your Learning',
            hideTitle: false,
            useBackButton: false,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
                child: RoundedButton(
                  onTap: () {
                    Get.toNamed(RoutesName.purchaseScreen);
                  },
                  child: Image.asset(
                    'assets/images/no-ads.png',
                    color: kWhite,
                    width: 26,
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
                          height: buttonHeight,
                          width: double.infinity,
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
                              width: iconSize,
                              height: iconSize,
                            ),
                          ),
                          style: context.textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BigIconTextButton(
                          height: buttonHeight,
                          width: double.infinity,
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
                              width: iconSize,
                              height: iconSize,
                            ),
                          ),
                          style: context.textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LongIconTextButton(
                    height: buttonHeight - 20,
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
                        width: iconSize,
                        height: iconSize,
                      ),
                    ),
                    style: context.textTheme.titleMedium?.copyWith(
                      color: kWhite,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: BigIconTextButton(
                          height: buttonHeight,
                          width: double.infinity,
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
                              width: iconSize,
                              height: iconSize,
                            ),
                          ),
                          style: context.textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BigIconTextButton(
                          height: buttonHeight,
                          width: double.infinity,
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
                              width: iconSize,
                              height: iconSize,
                            ),
                          ),
                          style: context.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LongIconTextButton(
                    height: buttonHeight - 20,
                    color: kMediumGreen2.withValues(alpha: 0.9),
                    onPressed: () {
                      Get.toNamed(RoutesName.contextSelectionScreen);
                    },
                    text: 'Smart AI',
                    icon: Container(
                      decoration: roundedDecoration.copyWith(
                        color: kWhite.withValues(alpha: 0.2),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/ai-quiz.png',
                        color: kWhite,
                        width: iconSize,
                        height: iconSize,
                      ),
                    ),
                    style: context.textTheme.titleMedium?.copyWith(
                      color: kWhite,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LongIconTextButton(
                    height: buttonHeight - 20,
                    color: kSkyBlueColor.withValues(alpha: 0.9),
                    onPressed: () {
                      Get.toNamed(RoutesName.aiExplainTopics);
                    },
                    text: 'Smart Explanation',
                    icon: Container(
                      decoration: roundedDecoration.copyWith(
                        color: kWhite.withValues(alpha: 0.2),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/ai-quiz.png',
                        color: kWhite,
                        width: iconSize,
                        height: iconSize,
                      ),
                    ),
                    style: context.textTheme.titleMedium?.copyWith(
                      color: kWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const BottomNavBar(currentIndex: 0),
        );
      },
    );
  }
}
