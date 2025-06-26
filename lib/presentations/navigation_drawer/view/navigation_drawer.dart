import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../progress/controller/progress_controller.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  void _showResetConfirmation() {
    PanaraConfirmDialog.show(
      Get.context!,
      title: "Reset App",
      message:
          "Are you sure you want to reset the app? This will clear all your progress and data.",
      confirmButtonText: "Reset",
      cancelButtonText: "Cancel",
      onTapCancel: () {
        Get.back();
      },
      onTapConfirm: () {
        _resetApp();
      },
      panaraDialogType: PanaraDialogType.custom,
      color: kSkyBlueColor,
      barrierDismissible: false,
    );
  }

  // void _resetApp() async {
  //   await SharedPreferencesService.to.clear();
  //   Get.offAllNamed(RoutesName.homeScreen);
  //   toastification.show(
  //     type: ToastificationType.custom(
  //       'Reset App',
  //       kSkyBlueColor,
  //       Icons.restart_alt,
  //     ),
  //     title: const Text('Reset App'),
  //     description: const Text('App has been reset successfully'),
  //     style: ToastificationStyle.minimal,
  //     autoCloseDuration: const Duration(seconds: 2),
  //     primaryColor: skyColor,
  //     margin: const EdgeInsets.all(8),
  //     closeOnClick: true,
  //     alignment: Alignment.bottomCenter,
  //   );
  // }
  void _resetApp() async {
    final prefs = await SharedPreferences.getInstance();

    // Store subscription values before clearing
    final isSubscribed = prefs.getBool('SubscribedGk') ?? false;
    final subscriptionId = prefs.getString('subscriptionId');
    final hasSeenSubscription = prefs.getBool('hasSubscriptionSeen') ?? false;

    // Clear all preferences
    await prefs.clear();

    _notifyProgressController();

    // Restore subscription values
    await prefs.setBool('SubscribedGk', isSubscribed);
    if (subscriptionId != null) {
      await prefs.setString('subscriptionId', subscriptionId);
    }
    await prefs.setBool('hasSubscriptionSeen', hasSeenSubscription);

    // Navigate and show toast
    Get.offAllNamed(RoutesName.homeScreen);
    toastification.show(
      type: ToastificationType.custom(
        'Reset App',
        kSkyBlueColor,
        Icons.restart_alt,
      ),
      title: const Text('Reset App'),
      description: const Text('App has been reset successfully'),
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 2),
      primaryColor: skyColor,
      margin: const EdgeInsets.all(8),
      closeOnClick: true,
      alignment: Alignment.bottomCenter,
    );
  }

  void _notifyProgressController() {
    try {
      final progressController = Get.find<ProgressController>();
      Future.delayed(Duration(milliseconds: 50), () {
        progressController.refreshStats();
        progressController.loadDailyPerformance();
      });
    } catch (e) {
      debugPrint('ProgressController not found: $e');
    }
  }

  void privacy() async {
    const url = 'https://privacypolicymuslimapplications.blogspot.com/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void rateUs() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.ma.gkquiz.generalknowledge';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void moreApp() async {
    const url =
        'https://play.google.com/store/apps/developer?id=Muslim+Applications';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [skyColor, kBlue],
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Image.asset('assets/icon.png', height: 80),
                ),
                Text(
                  'GK Quiz',
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: kWhite,
                  ),
                ),
              ],
            ),
          ),
          DrawerTile(
            icon: Icons.restart_alt,
            title: 'Reset App',
            onTap: _showResetConfirmation,
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/no-ads.png',
              color: textGreyColor,
              width: 24,
            ),
            title: Text('Remove Ads'),
            onTap: () {
              Get.toNamed(RoutesName.purchaseScreen);
            },
          ),
          DrawerTile(
            icon: Icons.star_rounded,
            title: 'Rate Us',
            onTap: () {
              rateUs();
            },
          ),
          DrawerTile(
            icon: Icons.privacy_tip_rounded,
            title: 'Privacy Policy',
            onTap: () {
              privacy();
            },
          ),
          DrawerTile(
            icon: Icons.more,
            title: 'More App',
            onTap: () {
              moreApp();
            },
          ),
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 24, color: textGreyColor),
      title: Text(title),
      onTap: onTap,
    );
  }
}
