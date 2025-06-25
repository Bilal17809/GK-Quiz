import 'package:get/get.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class PurchaseController extends GetxController {
  var selectedPlanIndex = 0.obs;
  var isLoading = false.obs;

  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }

  Future<bool> checkFreeTrialEnabled() async {
    try {
      final config = FirebaseRemoteConfig.instance;

      await config.fetchAndActivate().timeout(
        const Duration(seconds: 10),
        onTimeout: () => false,
      );

      // Check for the free trial key
      final freeTrialEnabled = config.getBool('free_trial_enabled');

      debugPrint('Free trial enabled from remote config: $freeTrialEnabled');
      return freeTrialEnabled;
    } catch (e) {
      debugPrint('Error checking remote config for free trial: $e');
      return false;
    }
  }

  Future<bool> startFreeTrial() async {
    isLoading.value = true;

    try {
      final freeTrialEnabled = await checkFreeTrialEnabled();

      if (!freeTrialEnabled) {
        isLoading.value = false;
        return false;
      }

      await Future.delayed(const Duration(seconds: 2));

      isLoading.value = false;
      return true;
    } catch (e) {
      debugPrint('Error starting free trial: $e');
      isLoading.value = false;
      return false;
    }
  }
}
