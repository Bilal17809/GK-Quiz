import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import 'package:template/core/theme/app_colors.dart';
import '../controller/banner_ad_controller.dart';

class BannerAdWidget extends StatelessWidget {
  final AdSize adSize;

  const BannerAdWidget({super.key, this.adSize = AdSize.banner});

  @override
  Widget build(BuildContext context) {
    // Inject controller with passed adSize
    final BannerAdController controller = Get.put(
      BannerAdController(adSize: adSize),
      tag: adSize.toString(), // ensures multiple sizes don't conflict
      permanent: false,
    );

    return Obx(() {
      if (controller.isLoaded.value && controller.bannerAd.value != null) {
        return SizedBox(
          width: adSize.width.toDouble(),
          height: adSize.height.toDouble(),
          child: AdWidget(ad: controller.bannerAd.value!),
        );
      } else {
        return Shimmer.fromColors(
          baseColor: greyColor.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.6),
          child: Container(
            width: adSize.width.toDouble(),
            height: adSize.height.toDouble(),
            color: greyColor.withOpacity(0.4),
          ),
        );
      }
    });
  }
}
