import 'package:flutter/material.dart';
import 'package:template/core/common_widgets/custom_text_button.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/extension/extension.dart';
import 'package:template/presentations/take_a_test_list/view/take_a_test_list.dart';

class TakeTestScreen extends StatefulWidget {
  const TakeTestScreen({super.key});

  @override
  State<TakeTestScreen> createState() => _TakeTestScreenState();
}

class _TakeTestScreenState extends State<TakeTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz',
              style: context.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text('Take a Test', style: context.textTheme.bodyLarge),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: RoundedButton(
            backgroundColor: kRed,
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/back.png', color: kWhite),
            ),
          ),
        ),
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
                          builder: (context) => const TakeATestList(),
                        ),
                      );
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
                    style: context.textTheme.headlineSmall,
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
                    style: context.textTheme.headlineSmall,
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
                    style: context.textTheme.headlineSmall,
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
                    style: context.textTheme.headlineSmall,
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
