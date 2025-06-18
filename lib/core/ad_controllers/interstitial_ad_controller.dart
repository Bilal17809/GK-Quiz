import 'dart:ui';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import 'package:template/core/helper/ad_helper.dart';

class InterstitialAdController extends GetxController {
  InterstitialAd? _interstitialAd;
  final RxBool _isReady = false.obs;
  final RxBool _isLoading = false.obs;
  final Map<String, int> _screenCounters = {};
  static const int _threshold = 3;

  bool get isReady => _isReady.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadAd();
  }

  void _loadAd() {
    if (_isLoading.value) return;

    _isLoading.value = true;

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isReady.value = true;
          _isLoading.value = false;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) {
              _isReady.value = false;
              ad.dispose();
              _interstitialAd = null;
              Future.delayed(const Duration(milliseconds: 500), _loadAd);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isReady.value = false;
              ad.dispose();
              _interstitialAd = null;
              Future.delayed(const Duration(seconds: 5), _loadAd);
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isReady.value = false;
          _isLoading.value = false;
          _interstitialAd = null;

          Future.delayed(const Duration(seconds: 30), _loadAd);
          print('Interstitial ad failed to load: ${error.message}');
        },
      ),
    );
  }

  void _showAd(VoidCallback? onClosed) {
    if (_isReady.value && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (_) {
          _interstitialAd!.dispose();
          _interstitialAd = null;
          _isReady.value = false;
          Future.delayed(const Duration(milliseconds: 500), _loadAd);
          onClosed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          _isReady.value = false;
          Future.delayed(const Duration(seconds: 5), _loadAd);
          onClosed?.call();
        },
      );

      _interstitialAd!.show();
    } else {
      onClosed?.call();
    }
  }

  void maybeShowAdForScreen(String screenName, {VoidCallback? onClosed}) {
    _screenCounters[screenName] = (_screenCounters[screenName] ?? 0) + 1;
    print('[$screenName] Counter: ${_screenCounters[screenName]}');
    if (_screenCounters[screenName]! >= _threshold) {
      _screenCounters[screenName] = 0;
      _showAd(onClosed);
    } else {
      onClosed?.call();
    }
  }

  void showAdNow({VoidCallback? onClosed}) {
    _showAd(onClosed);
  }

  void resetCounterForScreen(String screenName) {
    _screenCounters[screenName] = 0;
  }

  @override
  void onClose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    super.onClose();
  }
}
