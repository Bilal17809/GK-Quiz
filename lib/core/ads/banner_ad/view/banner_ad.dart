import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import 'package:template/core/theme/app_colors.dart';
import '../controller/banner_ad_controller.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = Get.currentRoute;
    final String uniqueId = '${currentRoute}_banner';

    final BannerAdController controller = Get.put(
      BannerAdController(uniqueId: uniqueId),
      tag: uniqueId,
      permanent: false,
    );

    return Obx(() {
      if (controller.isLoaded.value && controller.bannerAd.value != null) {
        return SizedBox(
          width: AdSize.banner.width.toDouble(),
          height: AdSize.banner.height.toDouble(),
          child: AdWidget(ad: controller.bannerAd.value!),
        );
      } else {
        return Shimmer.fromColors(
          baseColor: greyColor..withValues(alpha: 0.03),
          highlightColor: Colors.white.withValues(alpha: 0.06),
          child: Container(
            width: AdSize.banner.width.toDouble(),
            height: AdSize.banner.height.toDouble(),
            color: greyColor.withValues(alpha: 0.2),
          ),
        );
      }
    });
  }
}
