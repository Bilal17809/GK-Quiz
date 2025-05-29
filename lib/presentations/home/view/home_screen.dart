import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/custom_text_button.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/presentations/navigation_drawer/view/navigation_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileHeight = MediaQuery.of(context).size.height;
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/bell.png',
                width: 26,
                height: 26,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
          child: Column(
            children: [
              const SizedBox(height: 12),
              IconTextButton(
                onPressed: () {
                  Get.toNamed(RoutesName.lessonsScreen);
                },
                text: 'Lesson to Study',
                icon: Container(
                  decoration: BoxDecoration(
                    color: kBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/images/reading-book.png',
                      color: kWhite,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                style: Get.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              IconTextButton(
                onPressed: () {
                  Get.toNamed(RoutesName.practiceScreen);
                },
                text: 'Practice',
                icon: Container(
                  decoration: BoxDecoration(
                    color: kCoral,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/images/checklist.png',
                      color: kWhite,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                style: Get.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconTextButton(
                    width: mobileWidth / 2 - 25,
                    onPressed: () {
                      Get.toNamed(RoutesName.testScreen);
                    },
                    text: 'Take a\nTest',
                    icon: Container(
                      decoration: BoxDecoration(
                        color: kTealGreen1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/images/test.png',
                          color: kWhite,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    style: Get.textTheme.titleMedium,
                  ),
                  const SizedBox(width: 12),
                  IconTextButton(
                    width: mobileWidth / 2 - 25,
                    onPressed: () {},
                    text: 'Country\nQuiz',
                    icon: Container(
                      decoration: BoxDecoration(
                        color: kViolet,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/images/reading-book.png',
                          color: kWhite,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    style: Get.textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: mobileWidth,
                height: mobileHeight * 0.12,
                child: Card(
                  color: kWhite,
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: kOrange,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.asset(
                                      'assets/images/share.png',
                                      color: kBlack,
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Share App',
                                  style: Get.textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: skyColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.asset(
                                      'assets/images/no-ads.png',
                                      color: kWhite,
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Remove Ads',
                                  style: Get.textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
