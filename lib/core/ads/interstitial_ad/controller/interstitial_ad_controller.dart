import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';

class InterstitialAdController extends GetxController {
  final String uniqueId;
  final String route;
  final RxInt _counter = 0.obs;
  int screenCount = 3;
  bool _isShowing = false;
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;

  InterstitialAdController({required this.uniqueId, required this.route});

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
      final remoteScreenCount = config.getInt('screen_count');
      if (remoteScreenCount > 0) {
        screenCount = remoteScreenCount;
      }
    } catch (e) {
      debugPrint('Error fetching remote config: $e');
    }
  }

  Future<void> loadAds() async {
    if (_isLoading || _interstitialAd != null) return;

    _isLoading = true;

    try {
      await InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isLoading = false;

            _interstitialAd!
                .fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                _interstitialAd = null;
                Future.delayed(const Duration(milliseconds: 500), loadAds);
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                _interstitialAd = null;
                _isShowing = false;
                Future.delayed(const Duration(milliseconds: 500), loadAds);
              },
              onAdShowedFullScreenContent: (ad) {},
            );
          },
          onAdFailedToLoad: (error) {
            _isLoading = false;
            Future.delayed(const Duration(seconds: 5), loadAds);
          },
        ),
      );
    } catch (e) {
      debugPrint('Error loading interstitial ad: $e');
      _isLoading = false;
    }
  }

  void showAds({VoidCallback? onClosed}) {
    if (_isShowing) {
      onClosed?.call();
      return;
    }

    _counter.value++;

    if (_counter.value >= screenCount) {
      if (_interstitialAd != null) {
        _isShowing = true;
        _counter.value = 0;

        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _interstitialAd = null;
            _isShowing = false;
            onClosed?.call();
            Future.delayed(const Duration(milliseconds: 500), loadAds);
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _interstitialAd = null;
            _isShowing = false;
            onClosed?.call();
            Future.delayed(const Duration(milliseconds: 500), loadAds);
          },
          onAdShowedFullScreenContent: (ad) {},
        );

        _interstitialAd!.show();
      } else {
        if (!_isLoading) {
          loadAds();
        }
        onClosed?.call();
      }
    } else {
      if (_counter.value >= screenCount - 1 &&
          _interstitialAd == null &&
          !_isLoading) {
        loadAds();
      }
      onClosed?.call();
    }
  }

  void resetCounter() {
    _counter.value = 0;
  }

  bool get isAdReady => _interstitialAd != null;
  int get currentCount => _counter.value;

  @override
  void onClose() {
    _interstitialAd?.dispose();
    super.onClose();
  }
}
