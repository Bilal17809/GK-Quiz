import 'dart:ui';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import 'package:template/core/helper/ad_helper.dart';

class GlobalAdManager extends GetxController {
  static GlobalAdManager get instance => Get.find<GlobalAdManager>();

  final Map<String, InterstitialAd> _interstitialAds = {};
  final Map<String, bool> _isLoading = {};
  final Map<String, DateTime> _lastLoadAttempt = {};
  final Map<String, int> _loadAttempts = {};

  // Constants for retry logic
  static const int _maxRetryAttempts = 3;
  static const Duration _retryDelay = Duration(seconds: 10);
  static const Duration _minTimeBetweenLoads = Duration(seconds: 2);

  void debugCurrentState() {
    print('🔍 [DEBUG] Current ads loaded: ${_interstitialAds.keys.toList()}');
    print(
      '🔍 [DEBUG] Currently loading: ${_isLoading.entries.where((e) => e.value).map((e) => e.key).toList()}',
    );
    print('🔍 [DEBUG] Load attempts: $_loadAttempts');
    print('🔍 [DEBUG] Ad Unit ID: ${AdHelper.interstitialAdUnitId}');
  }

  static const List<String> _preloadRoutes = [
    '/practice_screen',
    '/quiz_screen',
    '/qna_screen',
    '/customized_quiz_screen',
    '/country_quiz_screen',
    '/result_screen',
    '/country_result_screen',
    '/learning_hub_screen',
    '/quiz_levels_screen',
    '/country_levels_screen',
    '/ai-quiz-screen',
    '/country_qna_screen',
  ];

  @override
  void onInit() {
    super.onInit();
    print('🚀 [DEBUG] GlobalAdManager initialized');
    debugCurrentState();
    _preloadAllAds();
  }

  void _preloadAllAds() {
    print('📥 [DEBUG] Preloading ads for ${_preloadRoutes.length} routes');
    for (String route in _preloadRoutes) {
      _preloadAdForRoute(route);
    }
  }

  void _preloadAdForRoute(String route) {
    final now = DateTime.now();

    // Check if already loading or loaded
    if (_isLoading[route] == true) {
      print('⚠️ [DEBUG] Already loading ad for $route');
      return;
    }

    if (_interstitialAds.containsKey(route)) {
      print('⚠️ [DEBUG] Ad already loaded for $route');
      return;
    }

    // Check minimum time between load attempts
    final lastAttempt = _lastLoadAttempt[route];
    if (lastAttempt != null &&
        now.difference(lastAttempt) < _minTimeBetweenLoads) {
      print('⚠️ [DEBUG] Too soon to retry loading for $route');
      return;
    }

    // Check retry attempts
    final attempts = _loadAttempts[route] ?? 0;
    if (attempts >= _maxRetryAttempts) {
      print('⚠️ [DEBUG] Max retry attempts reached for $route');
      // Reset attempts after a longer delay
      Future.delayed(const Duration(minutes: 5), () {
        _loadAttempts[route] = 0;
      });
      return;
    }

    _isLoading[route] = true;
    _lastLoadAttempt[route] = now;
    _loadAttempts[route] = attempts + 1;

    print(
      '📥 [DEBUG] Starting to preload ad for route: $route (attempt ${attempts + 1})',
    );
    print('🔧 [DEBUG] Using ad unit ID: ${AdHelper.interstitialAdUnitId}');

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print('✅ [DEBUG] Ad preloaded successfully for route: $route');
          _interstitialAds[route] = ad;
          _isLoading[route] = false;
          _loadAttempts[route] = 0; // Reset attempts on success

          debugCurrentState();

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print('👋 [DEBUG] Ad dismissed for route: $route');
              ad.dispose();
              _interstitialAds.remove(route);

              // Shorter delay for faster reloading
              Future.delayed(const Duration(milliseconds: 100), () {
                _preloadAdForRoute(route);
              });
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print(
                '❌ [DEBUG] Ad failed to show for route: $route, error: ${error.message}',
              );
              ad.dispose();
              _interstitialAds.remove(route);

              // Immediate reload attempt
              Future.delayed(const Duration(milliseconds: 100), () {
                _preloadAdForRoute(route);
              });
            },
            onAdWillDismissFullScreenContent: (ad) {
              print('⏳ [DEBUG] Ad will dismiss for route: $route');
            },
            onAdShowedFullScreenContent: (ad) {
              print('👁️ [DEBUG] Ad showed full screen for route: $route');
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('❌ [DEBUG] Failed to preload ad for route: $route');
          print('❌ [DEBUG] Error code: ${error.code}');
          print('❌ [DEBUG] Error message: ${error.message}');
          print('❌ [DEBUG] Error domain: ${error.domain}');

          _isLoading[route] = false;

          // Retry with exponential backoff
          final retryDelay = Duration(
            seconds: _retryDelay.inSeconds * attempts,
          );
          print(
            '🔄 [DEBUG] Retrying ad load for route: $route in ${retryDelay.inSeconds}s',
          );

          Future.delayed(retryDelay, () {
            _preloadAdForRoute(route);
          });
        },
      ),
    );
  }

  bool isAdReadyForRoute(String route) {
    final isReady = _interstitialAds.containsKey(route);
    print('❓ [DEBUG] Is ad ready for $route? $isReady');

    // If not ready and not loading, try to load
    if (!isReady && _isLoading[route] != true) {
      print(
        '🔄 [DEBUG] Ad not ready and not loading, attempting to load for $route',
      );
      _preloadAdForRoute(route);
    }

    return isReady;
  }

  void showAdForRoute(String route, {VoidCallback? onClosed}) {
    final ad = _interstitialAds[route];
    print('🎬 [DEBUG] Attempting to show ad for route: $route');

    if (ad != null) {
      print('✅ [DEBUG] Ad found, showing now for route: $route');

      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print('👋 [DEBUG] Ad dismissed for route: $route');
          ad.dispose();
          _interstitialAds.remove(route);
          onClosed?.call();

          // Immediate reload for next time
          Future.delayed(const Duration(milliseconds: 100), () {
            _preloadAdForRoute(route);
          });
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print(
            '❌ [DEBUG] Ad failed to show for route: $route, error: ${error.message}',
          );
          ad.dispose();
          _interstitialAds.remove(route);
          onClosed?.call();

          // Immediate reload attempt
          Future.delayed(const Duration(milliseconds: 100), () {
            _preloadAdForRoute(route);
          });
        },
        onAdShowedFullScreenContent: (ad) {
          print('🎉 [DEBUG] Ad successfully shown for route: $route');
        },
      );

      ad.show();
    } else {
      print('❌ [DEBUG] No ad available for route: $route');
      debugCurrentState();
      onClosed?.call();

      // Try to load immediately
      _preloadAdForRoute(route);
    }
  }

  void preloadAdForRoute(String route) {
    print('🔄 [DEBUG] Manual preload requested for route: $route');
    _preloadAdForRoute(route);
  }

  // Add method to force reload (clears retry attempts)
  void forceReloadAdForRoute(String route) {
    print('🔄 [DEBUG] Force reload requested for route: $route');
    _loadAttempts[route] = 0;
    _lastLoadAttempt.remove(route);
    _preloadAdForRoute(route);
  }

  @override
  void onClose() {
    print(
      '🛑 [DEBUG] GlobalAdManager closing, disposing ${_interstitialAds.length} ads',
    );

    for (var ad in _interstitialAds.values) {
      ad.dispose();
    }

    _interstitialAds.clear();
    _isLoading.clear();
    _lastLoadAttempt.clear();
    _loadAttempts.clear();

    super.onClose();
  }
}
