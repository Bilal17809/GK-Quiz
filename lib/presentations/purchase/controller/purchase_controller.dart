import 'package:get/get.dart';

class PurchaseController extends GetxController {
  var selectedPlanIndex = 0.obs;
  var isLoading = false.obs;

  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }

  Future<void> startFreeTrial() async {
    isLoading.value = true;
    // Add your subscription logic here
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    // Return success/failure status instead of showing snackbar
  }
}
