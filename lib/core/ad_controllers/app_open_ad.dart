import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  DateTime? _appOpenLoadTime;

  static final AppOpenAdManager _instance = AppOpenAdManager._internal();
  factory AppOpenAdManager() => _instance;
  AppOpenAdManager._internal();

  /// Load an app open ad.
  void loadAd() {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/9257395921', // Test ID
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('App open ad loaded');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('App open ad failed to load: $error');
          // Handle the error.
        },
      ),
    );
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  /// Shows the app open ad.
  void showAdIfAvailable() {
    if (!isAdAvailable) {
      print('Tried to show app open ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      print('Tried to show app open ad while already showing an ad.');
      return;
    }

    // Check if ad is still fresh (less than 4 hours old)
    if (DateTime.now()
        .subtract(const Duration(hours: 4))
        .isAfter(_appOpenLoadTime!)) {
      print('App open ad expired. Loading a new ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }

    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('App open ad showed fullscreen content.');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('App open ad failed to show fullscreen content: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        print('App open ad dismissed fullscreen content.');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }

  void dispose() {
    _appOpenAd?.dispose();
  }
}
