import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../presentations/remove_ads_contrl/remove_ads_contrl.dart';

class InterstitialAdController extends GetxController {
  InterstitialAd? _interstitialAd;
  bool isAdReady = false;
  int screenVisitCount = 0;
  int adTriggerCount = 3;

  final RemoveAds removeAds = Get.put(RemoveAds());


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

      String interstitialKey;
      if (Platform.isAndroid) {
        interstitialKey = 'InterstitialAd';
      } else if (Platform.isIOS) {
        interstitialKey = 'InterstitialAd';
      } else {
        throw UnsupportedError('Unsupported platform');
      }

      if (remoteConfig.getValue(interstitialKey).source != ValueSource.valueStatic) {
        adTriggerCount = remoteConfig.getInt(interstitialKey);
        print("### Remote Config: Ad Trigger Count = $adTriggerCount");
      } else {
        print("### Remote Config: Using default value.");
      }
      update();
    } catch (e) {
      print('Error fetching Remote Config: $e');
      adTriggerCount = 3;
    }
  }

  String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3118392277684870/8883344644';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5405847310750111/7502684487';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void loadInterstitialAd() {
    if (removeAds.isSubscribedGet.value) {
      return;
    }
    InterstitialAd.load(
      adUnitId:interstitialAdUnitId,
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
          screenVisitCount = 0;
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
    if (removeAds.isSubscribedGet.value) {
      return;
    }
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