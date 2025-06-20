import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/presentations/home/view/home_screen.dart';

import '../../../ads_manager/splash_interstitial.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.put(SplashController());
  final SplashInterstitialAdController splashAd=Get.put(SplashInterstitialAdController());

  void _goToHome() {
    Get.offAll(() => const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  const Text(
                    'Boost Your Knowledge\nwith the Ultimate\nGK Quiz',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  const Text(
                    'Sharpen Your\nMind with Fun GK\nChallenges!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),

                  // Show progress indicator if not completed
                  Obx(() {
                    return controller.showButton.isFalse
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: controller.progressAnimation.value,
                          backgroundColor: Colors.white30,
                          color: Colors.white,
                          minHeight: 10,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${(controller.progressAnimation.value * 100).toInt()}%',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                        : ElevatedButton(
                      onPressed:(){
                        splashAd.showSplashAd;
                        _goToHome();
                      } ,
                      child: const Text('Enter App'),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashController extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController animationController;
  late Animation<double> progressAnimation;

  var showButton = false.obs;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    progressAnimation = Tween<double>(begin: 0, end: 1).animate(animationController)
      ..addListener(update)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          showButton.value = true;
        }
      });

    animationController.forward();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
