import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';

class AiExplainTopicsController extends GetxController {
  final interstitialAd = Get.put(InterstitialAdController());
  final bannerAdController = Get.put(BannerAdController());

  @override
  void onInit() {
    super.onInit();
    interstitialAd.checkAndShowAd();
  }

  bool get isInterstitialReady => interstitialAd.isAdReady;

  Widget getBannerAdWidget(String adId) {
    return bannerAdController.getBannerAdWidget(adId);
  }
}
