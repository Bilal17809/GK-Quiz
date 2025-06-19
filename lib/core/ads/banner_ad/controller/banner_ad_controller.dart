import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../../helper/ad_helper.dart';

class BannerAdController extends GetxController {
  final Rx<BannerAd?> bannerAd = Rx<BannerAd?>(null);
  final RxBool isLoaded = false.obs;
  final String uniqueId;
  String bannerAdUnitId = AdHelper.bannerAdUnitId;

  BannerAdController({required this.uniqueId});

  @override
  void onInit() {
    super.onInit();
    remoteConfig();
    loadAds();
  }

  Future<void> remoteConfig() async {
    try {
      final config = FirebaseRemoteConfig.instance;
      await config.fetchAndActivate().timeout(
        const Duration(seconds: 10),
        onTimeout: () => false,
      );
      final remoteBannerAdId = config.getString('banner_ad_id');
      if (remoteBannerAdId.isNotEmpty) {
        bannerAdUnitId = remoteBannerAdId;
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> loadAds() async {
    if (bannerAd.value != null) return;

    bannerAd.value?.dispose();
    isLoaded.value = false;

    try {
      final ad = BannerAd(
        adUnitId: bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isLoaded.value = true;
            bannerAd.value = ad as BannerAd;
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            isLoaded.value = false;
            bannerAd.value = null;
            Future.delayed(const Duration(seconds: 30), loadAds);
          },
        ),
      );

      await ad.load();
    } catch (e) {
      debugPrint('Error: $e');
      isLoaded.value = false;
      bannerAd.value = null;
    }
  }

  void reloadAd() {
    bannerAd.value?.dispose();
    bannerAd.value = null;
    isLoaded.value = false;
    loadAds();
  }

  @override
  void onClose() {
    bannerAd.value?.dispose();
    super.onClose();
  }
}
