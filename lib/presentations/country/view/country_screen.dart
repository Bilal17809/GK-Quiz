import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:template/presentations/country/controller/country_controller.dart';

import '../../../core/common_widgets/round_image.dart';
import '../../../core/theme/app_colors.dart';

class CountryScreen extends StatelessWidget {
  const CountryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CountryController countryController = Get.put(CountryController());
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz',
              style: Get.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text('Country Quiz', style: Get.textTheme.bodyLarge),
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
        child: Stack(
          children: [
            //Animated BG
            Obx(() {
              return Stack(
                children: [
                  Positioned(
                    left: -countryController.shift.value,
                    child: Image.asset(
                      'assets/images/world_map.png',
                      color: kCoral,
                      width: countryController.imageWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left:
                        countryController.imageWidth -
                        countryController.shift.value,
                    child: Image.asset(
                      'assets/images/world_map.png',
                      color: kCoral,
                      width: countryController.imageWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            }),
            //Grid
            GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 9,
                childAspectRatio: 1 / 1,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: roundedDecoration.copyWith(
                          color: kTealGreen1.withValues(alpha: 0.95),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 50),
                            Container(
                              decoration: roundedDecorationWithShadow.copyWith(
                                color: kWhite.withAlpha(50),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Image.asset(
                                'assets/images/capital.png',
                                color: kWhite,
                                width: 40,
                                height: 40,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Grid # ${index + 1}',
                                style: Get.textTheme.titleSmall?.copyWith(
                                  color: textWhiteColor,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
