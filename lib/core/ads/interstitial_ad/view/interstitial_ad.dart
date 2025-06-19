import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/interstitial_ad_controller.dart';

class InterstitialAdWidget extends StatefulWidget {
  final VoidCallback? onAdClosed;
  final Widget child;

  const InterstitialAdWidget({super.key, required this.child, this.onAdClosed});

  @override
  State<InterstitialAdWidget> createState() => _InterstitialAdWidgetState();
}

class _InterstitialAdWidgetState extends State<InterstitialAdWidget> {
  @override
  void initState() {
    super.initState();
    final String currentRoute = Get.currentRoute;
    final String uniqueId = '${currentRoute}_interstitial';

    final InterstitialAdController controller = Get.put(
      InterstitialAdController(uniqueId: uniqueId, route: currentRoute),
      tag: uniqueId,
      permanent: true,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.showAds(onClosed: widget.onAdClosed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
