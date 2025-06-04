import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/big_icon_text_button.dart';
import 'package:template/core/common_widgets/long_icon_text_button.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/navigation_drawer/view/navigation_drawer.dart';

import '../../../core/common_widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: Builder(
            builder: (context) {
              return RoundedButton(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Image.asset('assets/images/menu.png', color: kRed),
              );
            },
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz',
              style: Get.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text('Enrich your knowledge', style: Get.textTheme.bodyLarge),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
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
                        Get.toNamed(RoutesName.lessonsScreen);
                      },
                      text: 'Lesson to Study',
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
                      style: Get.textTheme.headlineSmall,
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
                      text: 'Practice',
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
                      style: Get.textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              LongIconTextButton(
                height: mobileWidth * 0.30,

                color: kYellow,
                onPressed: () {
                  Get.toNamed(RoutesName.testScreen);
                },
                text: 'Take a Test',
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
                style: Get.textTheme.titleMedium,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: BigIconTextButton(
                      height: mobileWidth * 0.40,
                      width: mobileWidth * 0.40,
                      color: kTealGreen1.withValues(alpha: 0.9),
                      onPressed: () {
                        Get.toNamed(RoutesName.countryScreen);
                      },
                      text: 'Country Quiz',
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
                      style: Get.textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(width: mobileWidth * 0.03),
                  Expanded(
                    child: BigIconTextButton(
                      height: mobileWidth * 0.40,
                      width: mobileWidth * 0.40,
                      color: kMediumGreen2.withValues(alpha: 0.9),
                      onPressed: () {},
                      text: 'Remove Ads',
                      icon: Container(
                        decoration: roundedDecoration.copyWith(
                          color: kWhite.withValues(alpha: 0.2),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/no-ads.png',
                          color: kWhite,
                          width: mobileWidth * 0.1,
                          height: mobileWidth * 0.1,
                        ),
                      ),
                      style: Get.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              LongIconTextButton(
                height: mobileWidth * 0.3,

                color: skyColor.withValues(alpha: 0.9),
                onPressed: () {
                  Get.toNamed(RoutesName.progressScreen);
                },
                text: 'Progress',
                icon: Container(
                  decoration: roundedDecoration.copyWith(
                    color: kWhite.withValues(alpha: 0.2),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.bar_chart,
                    color: kWhite,
                    size: mobileWidth * 0.1,
                  ),
                ),
                style: Get.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
