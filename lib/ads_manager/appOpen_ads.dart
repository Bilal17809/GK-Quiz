import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import '../presentations/remove_ads_contrl/remove_ads_contrl.dart';
import 'dart:ui';

class AppOpenAdController extends GetxController with WidgetsBindingObserver {
  final RemoveAds removeAds = Get.put(RemoveAds());
  final RxBool isShowingOpenAd = false.obs;
  AppOpenAd? _appOpenAd;
  bool _isAdAvailable = false;
  bool shouldShowAppOpenAd = true;
  bool _isFromBackground = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _isFromBackground = true;
    } else if (state == AppLifecycleState.resumed) {
      if (_isFromBackground && !isCooldownActive) {
        _isFromBackground = false;
        if (shouldShowAppOpenAd) {
          showAdIfAvailable();
        } else {
          print('App Open Ad disabled via Remote Config.');
        }
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    initializeRemoteConfig(); // Fetch Firebase Remote Config
  }

  Future<void> initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.fetchAndActivate();
      shouldShowAppOpenAd = remoteConfig.getBool('AppOpenAD');
      print('Remote Config: appOpen = $shouldShowAppOpenAd');
      loadAd(); // Load ad after fetching config
    } catch (e) {
      print('Error fetching Remote Config: $e');
    }
  }

  bool isCooldownActive = false;

  /// Show the App Open Ad if it's available
  void showAdIfAvailable() {
    if (removeAds.isSubscribedGet.value) {
      return;
    } else if (_isAdAvailable && _appOpenAd != null) {
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          print('App Open Ad is showing.');
          isShowingOpenAd.value = true;
        },
        onAdDismissedFullScreenContent: (ad) {
          print('App Open Ad dismissed.');
          _appOpenAd = null;
          _isAdAvailable = false;
          isShowingOpenAd.value = false;
          loadAd();
          activateCooldown();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Failed to show App Open Ad: $error');
          _appOpenAd = null;
          _isAdAvailable = false;
          isShowingOpenAd.value = false;
          loadAd();
        },
      );

      _appOpenAd!.show();
      _appOpenAd = null;
      _isAdAvailable = false;
    } else {
      print('No App Open Ad available to show.');
      loadAd(); // Attempt to load a new ad
    }
  }

  /// Activate cooldown to prevent showing ads too frequently
  void activateCooldown() {
    isCooldownActive = true;
    Future.delayed(const Duration(seconds: 5), () {
      isCooldownActive = false;
    });
  }

  void loadAd() {
    if (!shouldShowAppOpenAd) return;
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-3118392277684870/4944099636',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdAvailable = true;
          print('App Open Ad loaded.');
        },
        onAdFailedToLoad: (error) {
          print('Failed to load App Open Ad: $error');
          _isAdAvailable = false;
        },
      ),
    );
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _appOpenAd?.dispose();
    super.onClose();
  }
}
