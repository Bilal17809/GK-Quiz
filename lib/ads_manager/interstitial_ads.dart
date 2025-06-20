import 'dart:ui';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'appOpen_ads.dart';


class InterstitialAdController extends GetxController {
  InterstitialAd? _interstitialAd;
  bool isAdReady = false;
  int screenVisitCount = 0;
  int adTriggerCount = 3;

  @override
  void onInit() {
    super.onInit();
    initializeRemoteConfig();
    loadInterstitialAd();
  }

  Future<void> initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 1),
      ));

      await remoteConfig.fetchAndActivate();

      if (remoteConfig.getValue('InterstitialAd').source != ValueSource.valueStatic) {
        adTriggerCount = remoteConfig.getInt('InterstitialAd');
        print("### Remote Config: Ad Trigger Count = $adTriggerCount");
      } else {
        print("### Remote Config: Using default value.");
      }
      update();
    } catch (e) {
      print('Error fetching Remote Config: $e');
      adTriggerCount = 3; // Default fallback value
    }
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3118392277684870/8883344644',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isAdReady = true;
          update();
        },
        onAdFailedToLoad: (error) {
          print("Interstitial Ad failed to load: $error");
          isAdReady = false;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print("### Ad Dismissed, resetting visit count.");
          ad.dispose();
          isAdReady = false;
          screenVisitCount = 0; // Reset count after showing the ad
          loadInterstitialAd();
          update();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print("### Ad failed to show: $error");
          ad.dispose();
          isAdReady = false;
          loadInterstitialAd();
          update();
        },
      );

      print("### Showing Interstitial Ad.");
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print("### Interstitial Ad not ready.");
    }
  }

  void checkAndShowAd() {
    screenVisitCount++;
    print("### Screen Visit Count: $screenVisitCount");

    if (screenVisitCount >= adTriggerCount) {
      print("### OK");
      if (isAdReady) {
        showInterstitialAd();
      } else {
        print("### Interstitial Ad not ready yet.");
        screenVisitCount = 0; // Reset even if ad is not ready
      }
    }
  }

  @override
  void onClose() {
    _interstitialAd?.dispose();
    super.onClose();
  }
}
