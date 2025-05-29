import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/common_text_button.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/models/grid_data.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';

class QuizSelectionScreen extends StatelessWidget {
  const QuizSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileHeight = MediaQuery.of(context).size.height;
    final mobileWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz',
              style: Get.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text('Take a Test', style: Get.textTheme.bodyLarge),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: RoundedButton(
            backgroundColor: kRed,
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/back.png', color: kWhite),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                  itemCount: gridColors.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: mobileWidth * 1,
                      height: mobileHeight * 0.10,
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        color: kWhite,
                        child: InkWell(
                          onTap:
                              () => Get.toNamed(
                                RoutesName.customizedQuizScreen,
                                arguments: {'topic': gridTexts[index]},
                              ),
                          child: Row(
                            children: [
                              Container(
                                width: mobileWidth * 0.20,
                                height: mobileHeight * 0.10,
                                decoration: BoxDecoration(
                                  color: gridColors[index].withValues(
                                    alpha: 0.64,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),

                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(gridIcons[index]),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    gridTexts[index],
                                    style: Get.textTheme.titleMedium,
                                  ),
                                  subtitle: Text(
                                    'Total Questions: 248',
                                    style: Get.textTheme.bodySmall,
                                  ),
                                  trailing: Icon(Icons.check_box),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Container(
              height: 50,
              width: double.infinity,
              color: skyColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '110',
                      style: Get.textTheme.bodyLarge?.copyWith(color: kWhite),
                    ),
                    Slider(
                      activeColor: kWhite,
                      //    trackHeight: 10,
                      value: 220,
                      min: 110,
                      max: 220,
                      label: 150.toString(),
                      onChanged: (double value) {},
                    ),

                    Text(
                      '220',
                      style: Get.textTheme.bodyLarge?.copyWith(color: kWhite),
                    ),
                    SimpleTextButton(
                      onPressed: () {},
                      text: 'Start',
                      foregroundColor: kWhite,
                      color: kIndigo,
                      width: 60,
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
