import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/country_grid.dart';
import 'package:template/core/common_widgets/custom_app_bar.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/routes/routes_name.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../country/controller/country_controller.dart';

class CountryLessonsScreen extends StatefulWidget {
  const CountryLessonsScreen({super.key});

  @override
  State<CountryLessonsScreen> createState() => _CountryLessonsScreenState();
}

class _CountryLessonsScreenState extends State<CountryLessonsScreen> {
  final InterstitialAdController interstitialAd=Get.put(InterstitialAdController());
  final CountryController countryController = Get.put(CountryController());
  @override
  void initState() {
    super.initState();
    interstitialAd.checkAndShowAd();
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: CustomAppBar(subtitle: 'World Facts'),
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              return Stack(
                children: [
                  Positioned(
                    top: 5,
                    left: -countryController.shift.value,
                    child: Image.asset(
                      'assets/images/world_map.png',
                      color: kRed.withValues(alpha: 0.5),
                      width: countryController.imageWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left:
                    countryController.imageWidth -
                        countryController.shift.value,
                    child: Image.asset(
                      'assets/images/world_map.png',
                      color: kRed.withValues(alpha: 0.5),
                      width: countryController.imageWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            }),

            GridView.builder(
              padding: kGridPadding,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1 / 1,
              ),
              itemCount: countryIcons.length,
              itemBuilder: (context, index) {
                final icon = countryIcons[index % countryIcons.length];
                final topic = countryTexts[index % countryTexts.length];

                return InkWell(
                  onTap: () {
                    Get.toNamed(
                      RoutesName.countryQnaScreen,
                      arguments: {'topic': topic, 'index': index},
                    );
                  },
                  child: Container(
                    decoration: roundedDecoration.copyWith(
                      color: kRed.withValues(alpha: 0.7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: roundedDecorationWithShadow.copyWith(
                            color: kWhite.withAlpha(50),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            icon,
                            color: kWhite,
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              topic,
                              style: context.textTheme.titleSmall?.copyWith(
                                color: textWhiteColor,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const Padding(
      //   padding: kBottomNav,
      //   child: BannerAdWidget(),
      // ),
    );
  }
}
