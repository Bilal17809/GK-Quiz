// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/foundation.dart';
//
// class Config {
//   static final _config = FirebaseRemoteConfig.instance;
//
//   static const _defaultValues = {
//     "banner_ad_id": "ca-app-pub-3940256099942544/6300978111",
//     "interstitial_ad_id": "ca-app-pub-3940256099942544/1033173712",
//     "show_ads": true,
//   };
//   static Future<void> initConfig() async {
//     await _config.setConfigSettings(
//       RemoteConfigSettings(
//         fetchTimeout: const Duration(minutes: 1),
//         minimumFetchInterval: const Duration(minutes: 30),
//       ),
//     );
//     await _config.setDefaults(_defaultValues);
//     await _config.fetchAndActivate();
//
//     debugPrint("Remote Config Data:${_config.getBool("show_ads")} ");
//
//     _config.onConfigUpdated.listen((event) async {
//       await _config.activate();
//
//       debugPrint("Updated:${_config.getAll()} ");
//     });
//   }
//
//   static bool get showAd => _config.getBool("show_ads");
//
//   //ad ids
//   static String get interstitialAdId => _config.getString("interstitial_ad_id");
//   static String get bannerAdId => _config.getString("banner_ad_id");
// }
