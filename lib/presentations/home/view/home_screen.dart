import 'package:flutter/material.dart';
import 'package:template/core/common_widgets/custom_text_button.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/extension/extension.dart';
import 'package:template/presentations/lessons/view/lessons_screen.dart';
import 'package:template/presentations/navigation_drawer/view/navigation_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
                child: Image.asset('assets/menu.png', color: kRed),
              );
            },
          ),
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz',
              style: context.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text('Enrich your knowledge', style: context.textTheme.bodyLarge),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset('assets/bell.png', width: 26, height: 26),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(height: 12),
                  IconTextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LessonsScreen(),
                        ),
                      );
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
                          'assets/reading-book.png',
                          color: kWhite,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    style: context.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 12),
                  IconTextButton(
                    onPressed: () {},
                    text: 'Practice',
                    icon: Container(
                      decoration: BoxDecoration(
                        color: kCoral,
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/checklist.png',
                          color: kWhite,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    style: context.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconTextButton(
                        width: MediaQuery.of(context).size.width / 2 - 25,
                        onPressed: () {},
                        text: 'Take a\nTest',
                        icon: Container(
                          decoration: BoxDecoration(
                            color: kTealGreen1,
                            borderRadius: BorderRadius.circular(8),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/test.png',
                              color: kWhite,
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        style: context.textTheme.titleMedium,
                      ),
                      SizedBox(width: 12),
                      IconTextButton(
                        width: MediaQuery.of(context).size.width / 2 - 25,
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
                              'assets/reading-book.png',
                              color: kWhite,
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        style: context.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  TextButton(
                    onPressed: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: kOrange,
                                borderRadius: BorderRadius.circular(8),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  'assets/share.png',
                                  color: kBlack,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),

                            Container(
                              decoration: BoxDecoration(
                                color: skyColor,
                                borderRadius: BorderRadius.circular(8),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  'assets/no-ads.png',
                                  color: kWhite,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Share App',
                              style: context.textTheme.titleSmall,
                            ),
                            Text(
                              'Remove Ads',
                              style: context.textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
