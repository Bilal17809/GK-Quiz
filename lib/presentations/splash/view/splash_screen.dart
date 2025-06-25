import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../ads_manager/splash_interstitial.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/view/home_screen.dart';
import '../../purchase/view/purchase_screen.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final SplashController controller = Get.put(SplashController());
  final SplashInterstitialAdController splashAd = Get.put(SplashInterstitialAdController());

  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  final RemoveAds removeAds = Get.put(RemoveAds());


  @override
  void initState() {
    super.initState();
    splashAd.loadInterstitialAd();

    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.01, end: 1.0).animate(_animationController)
      ..addListener(() {
        controller.percent.value = (_progressAnimation.value * 100).clamp(1, 100).toInt();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.showButton.value = true;
        }
      });

    _animationController.forward();
  }
  Future<void> showSubscriptionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PurchaseScreen(),
    );
  }

  void _goToHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenDialog = prefs.getBool('hasSubscriptionSeen') ?? false;

    if (!hasSeenDialog) {
      await showSubscriptionDialog(context);
      await prefs.setBool('hasSubscriptionSeen', true);
    }

    if (!removeAds.isSubscribedGet.value) {
      if (splashAd.isAdReady) {
        await splashAd.showInterstitialAd();
      }
    }

    Get.offAll(() => const HomeScreen());
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/new_splash.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.blueGrey,
                child: const Center(
                  child: Text(
                    'Error: Image "assets/images/splash.png" not found.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  const Text(
                    'Sharpen Your\nMind with Fun GK\nChallenges!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                  Obx(() {
                    return controller.showButton.isFalse
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: LinearProgressIndicator(
                            value: _progressAnimation.value,
                            backgroundColor: Colors.white30,
                            color: kMediumGreen1,
                            minHeight: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${controller.percent.value}%',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                        : SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            onPressed: () {
                              // splashAd.showInterstitialAd();
                              _goToHome();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kGold,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: const Text(
                              'Lets Start',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
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

class SplashController extends GetxController {
  var showButton = false.obs;
  var percent = 0.obs;

  @override
  void onInit() {
    super.onInit();
    percent.value = 1;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
