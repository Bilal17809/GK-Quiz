import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:template/core/helper/ad_helper.dart';

class OpenAppAdController extends GetxController {
  static OpenAppAdController get instance => Get.find<OpenAppAdController>();

  AppOpenAd? _appOpenAd;
  final RxBool _isLoading = false.obs;
  final RxBool _isShowing = false.obs;
  final RxBool _isFirstLaunch = true.obs;
  DateTime? _appOpenLoadTime;
  String appOpenAdUnitId = AdHelper.openAppAdUnitId;

  static const Duration _adExpirationDuration = Duration(hours: 4);

  bool get isAdAvailable =>
      _appOpenAd != null && !_isAdExpired() && !_isShowing.value;
  bool get isLoading => _isLoading.value;
  bool get isShowing => _isShowing.value;
  bool get isFirstLaunch => _isFirstLaunch.value;

  @override
  void onInit() {
    super.onInit();
    remoteConfig();
    loadAd();
  }

  Future<void> remoteConfig() async {
    try {
      final config = FirebaseRemoteConfig.instance;
      await config.fetchAndActivate().timeout(
        const Duration(milliseconds: 200),
        onTimeout: () => false,
      );
      final remoteAdId = config.getString('app_open_ad_id');
      if (remoteAdId.isNotEmpty) {
        appOpenAdUnitId = remoteAdId;
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (kDebugMode) print('Error fetching remote config: $e');
    }
  }

  Future<void> loadAd() async {
    if (_isLoading.value || _appOpenAd != null) return;

    _isLoading.value = true;

    try {
      await AppOpenAd.load(
        adUnitId: appOpenAdUnitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenAd = ad;
            _appOpenLoadTime = DateTime.now();
            _isLoading.value = false;

            if (_isFirstLaunch.value) {
              _showAdForFirstLaunch();
            }
          },
          onAdFailedToLoad: (error) {
            _isLoading.value = false;
            Future.delayed(const Duration(seconds: 10), loadAd);
          },
        ),
      );
    } catch (e) {
      debugPrint('Error: $e');
      _isLoading.value = false;
    }
  }

  void _showAdForFirstLaunch() {
    if (!_isFirstLaunch.value || _isShowing.value || _appOpenAd == null) return;

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (_isFirstLaunch.value && _appOpenAd != null) {
        showAd(
          onAdShowed: () => _isFirstLaunch.value = false,
          onAdDismissed: () => _isFirstLaunch.value = false,
          onAdFailedToShow: (error) => _isFirstLaunch.value = false,
        );
      }
    });
  }

  Future<void> showAd({
    VoidCallback? onAdShowed,
    VoidCallback? onAdDismissed,
    Function(String)? onAdFailedToShow,
  }) async {
    if (_isShowing.value) {
      onAdFailedToShow?.call('Ad already showing');
      return;
    }

    if (_appOpenAd == null) {
      onAdFailedToShow?.call('Ad not available');
      if (!_isLoading.value) loadAd();
      return;
    }

    if (_isAdExpired()) {
      _disposeCurrentAd();
      await loadAd();
      onAdFailedToShow?.call('Ad expired');
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowing.value = true;
        onAdShowed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowing.value = false;
        _disposeCurrentAd();
        onAdFailedToShow?.call(error.message);
        Future.delayed(const Duration(milliseconds: 500), loadAd);
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowing.value = false;
        _disposeCurrentAd();
        onAdDismissed?.call();
        Future.delayed(const Duration(milliseconds: 500), loadAd);
      },
    );

    _appOpenAd!.show();
  }

  bool _isAdExpired() {
    if (_appOpenLoadTime == null) return true;
    return DateTime.now().difference(_appOpenLoadTime!) >=
        _adExpirationDuration;
  }

  void _disposeCurrentAd() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _appOpenLoadTime = null;
  }

  void forceReloadAd() {
    _disposeCurrentAd();
    _isLoading.value = false;
    _isShowing.value = false;
    loadAd();
  }

  @override
  void onClose() {
    _disposeCurrentAd();
    super.onClose();
  }
}
