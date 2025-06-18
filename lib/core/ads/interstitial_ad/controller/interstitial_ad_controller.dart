import 'dart:ui';
import 'package:get/get.dart';
import '../../global_ads_manager.dart';

class InterstitialAdController extends GetxController {
  final String uniqueId;
  final String route;
  final RxInt _counter = 0.obs;
  static const int _threshold = 3;
  bool _isShowing = false;

  InterstitialAdController({required this.uniqueId, required this.route});

  @override
  void onInit() {
    super.onInit();
    print('🔄 [DEBUG] InterstitialAdController initialized for route: $route');
    print('🔄 [DEBUG] Current counter value: ${_counter.value}');
    GlobalAdManager.instance.preloadAdForRoute(route);
    _ensureAdAvailability();
  }

  void _ensureAdAvailability() {
    if (!GlobalAdManager.instance.isAdReadyForRoute(route)) {
      print('🔄 [DEBUG] Ensuring ad availability for route: $route');
      GlobalAdManager.instance.preloadAdForRoute(route);
      Future.delayed(const Duration(milliseconds: 500), _ensureAdAvailability);
    }
  }

  void maybeShowAd({VoidCallback? onClosed}) {
    if (_isShowing) {
      print('⚠️ [DEBUG] Ad already showing, skipping...');
      onClosed?.call();
      return;
    }

    _counter.value++;
    print('📈 [DEBUG] Counter incremented to: ${_counter.value}');

    final isAdReady = GlobalAdManager.instance.isAdReadyForRoute(route);

    print(
      '📊 [DEBUG] [$uniqueId] Counter: ${_counter.value}, Threshold: $_threshold, Ad Ready: $isAdReady',
    );

    if (_counter.value >= _threshold) {
      if (isAdReady) {
        print('✅ [DEBUG] [$uniqueId] Showing ad now!');
        _isShowing = true;
        _counter.value = 0;

        GlobalAdManager.instance.showAdForRoute(
          route,
          onClosed: () {
            _isShowing = false;
            print('👋 [DEBUG] Ad closed, counter reset to: ${_counter.value}');
            onClosed?.call();
            Future.delayed(const Duration(milliseconds: 100), () {
              GlobalAdManager.instance.preloadAdForRoute(route);
              _ensureAdAvailability();
            });
          },
        );
      } else {
        print('❌ [DEBUG] [$uniqueId] Threshold reached but ad not ready!');
        GlobalAdManager.instance.preloadAdForRoute(route);
        _ensureAdAvailability();
        onClosed?.call();
      }
    } else {
      print(
        '⏳ [DEBUG] [$uniqueId] Threshold not reached (${_counter.value}/$_threshold)',
      );

      if (_counter.value >= _threshold - 1 &&
          !GlobalAdManager.instance.isAdReadyForRoute(route)) {
        print('🚀 [DEBUG] Proactively preloading ad (approaching threshold)');
        GlobalAdManager.instance.preloadAdForRoute(route);
        _ensureAdAvailability();
      }

      onClosed?.call();
    }
  }

  void resetCounter() {
    print('🔄 [DEBUG] Resetting counter for route: $route');
    _counter.value = 0;
  }

  bool get isAdReady => GlobalAdManager.instance.isAdReadyForRoute(route);

  int get currentCount => _counter.value;
}
