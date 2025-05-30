import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class CountryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  final double imageWidth = 1000;
  final RxDouble shift = 0.0.obs;
  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    animation = Tween<double>(begin: 0, end: 1).animate(animationController)
      ..addListener(() {
        shift.value = (animation.value * imageWidth) % imageWidth;
      });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
