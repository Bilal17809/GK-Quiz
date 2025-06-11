import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/common_widgets/custom_text_button.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';

class TakeTestScreen extends StatelessWidget {
  const TakeTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(subtitle: 'Take a Test'),
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
                      Get.toNamed(RoutesName.quizSelectionScreen);
                    },
                    text: 'Take a Test',
                    icon: Container(
                      decoration: BoxDecoration(
                        color: kBlue,

                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/images/take-test.png',
                          color: kWhite,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    style: Get.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 12),
                  IconTextButton(
                    onPressed: () {},
                    text: 'Old Online Test',
                    icon: Container(
                      decoration: BoxDecoration(
                        color: kCoral,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/images/old-test.png',
                          color: kWhite,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    style: Get.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 12),
                  IconTextButton(
                    onPressed: () {},
                    text: 'Morning Daily Test',
                    icon: Container(
                      decoration: BoxDecoration(
                        color: skyColor,

                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/images/morning-test.png',
                          color: kWhite,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    style: Get.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 12),
                  IconTextButton(
                    onPressed: () {},
                    text: 'Evening Daily Test',
                    icon: Container(
                      decoration: BoxDecoration(
                        color: kViolet.withValues(alpha: 0.64),

                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/images/evening-test.png',
                          color: kWhite,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    style: Get.textTheme.headlineSmall,
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
