import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart'; // Add this import
import 'package:template/core/local_storage/shared_preferences_storage.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:toastification/toastification.dart';
import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/common_widgets/round_image.dart';
import '../../../core/constant/constant.dart';

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

  void _resetApp() async {
    await SharedPreferencesService.to.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        subtitle: 'Enrich your knowledge',
        useBackButton: false,
        hideTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
            child: RoundedButton(
              onTap: () {},
              child: Image.asset(
                'assets/images/no-ads.png',
                color: kWhite,
                width: 24,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: kSkyBlueColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/icon.png', height: 60),
                    Text(
                      'GK Quiz',
                      style: context.textTheme.headlineLarge?.copyWith(
                        color: kWhite,
                      ),
                    ),
                  ],
                ),
              ),
              DrawerTile(
                icon: Icons.restart_alt,
                title: 'Reset App',
                onTap: _showResetConfirmation, // Changed to show dialog first
              ),
              DrawerTile(
                icon: Icons.settings_rounded,
                title: 'Settings',
                onTap: () {},
              ),
              DrawerTile(
                icon: Icons.star_rounded,
                title: 'Rate Us',
                onTap: () {},
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/no-ads.png',
                  color: textGreyColor,
                  width: 24,
                ),
                title: Text('Remove Ads'),
                onTap: () {},
              ),
              DrawerTile(
                icon: Icons.privacy_tip_rounded,
                title: 'Privacy Policy',
                onTap: () {},
              ),
            ],
          ),
        ),
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
