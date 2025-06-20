
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class BannerAdController extends GetxController {
  final Map<String, BannerAd> _ads = {};
  final Map<String, RxBool> _adLoaded = {};
  RxBool isAdEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRemoteConfig();
    // loadBannerAd('large2');
  }

  Future<void> fetchRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 1),
      ));
      await remoteConfig.fetchAndActivate();

      bool bannerAdsEnabled = remoteConfig.getBool('BannerAd');
      isAdEnabled.value = bannerAdsEnabled;

      if (bannerAdsEnabled) {
        // Preload ads for multiple locations
        loadBannerAd('ad1');
        loadBannerAd('ad2');
        loadBannerAd('ad3'); // Add more as needed
        loadBannerAd('ad4');
        loadBannerAd('ad5');
        loadBannerAd('large'); // Add more as needed
        loadBannerAd('large1'); // Add more as needed
        loadBannerAd('large2');
      }
    } catch (e) {
      print('Error fetching Remote Config: $e');
    }
  }


  // Load a banner ad for a specific key
  void loadBannerAd(String key) async {
    if (_ads.containsKey(key)) {
      _ads[key]!.dispose();
    }

    final bannerAd = BannerAd(
      adUnitId: ' ca-app-pub-5405847310750111/3760827160', // tested
      // adUnitId: 'ca-app-pub-3118392277684870/8864383563', // Your actual ad unit ID
      // Use an appropriate size for full width
      size: AdSize.banner, // Standard banner size
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _adLoaded[key] = true.obs;
          print("Banner Ad Loaded for key: $key");
        },
        onAdFailedToLoad: (ad, error) {
          _adLoaded[key] = false.obs;
          print("Ad failed to load for key $key: ${error.message}");
        },
      ),
    );

    bannerAd.load();
    _ads[key] = bannerAd;
  }
  Widget getBannerAdWidget(String key) {
    if (isAdEnabled.value && _ads.containsKey(key) && _adLoaded[key]?.value == true) {
      return Container(
        height: 100, // Height to match banner size
        width: double.infinity, // Full width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
        ),
        child: AdWidget(ad: _ads[key]!),
      );
    } else {
      return Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.grey.shade900,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            width: double.infinity, // Will also take full width during loading
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      );
    }
  }

  @override
  void onClose() {
    for (final ad in _ads.values) {
      ad.dispose();
    }
    super.onClose();
  }



}

