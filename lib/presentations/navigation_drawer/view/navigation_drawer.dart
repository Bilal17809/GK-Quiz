import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/theme/app_colors.dart';

import '../../../core/common_widgets/custom_app_bar.dart';
import '../../../core/common_widgets/round_image.dart';
import '../../../core/constant/constant.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        subtitle: 'Enrich your knowledge',
        useBackButton: false,
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
                decoration: const BoxDecoration(color: skyColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                icon: Icons.favorite_rounded,
                title: 'Bookmarks',
                onTap: () {},
              ),
              DrawerTile(
                icon: Icons.notifications_rounded,
                title: 'Notifications',
                onTap: () {},
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
              DrawerTile(
                icon: Icons.message_rounded,
                title: 'Feedback',
                onTap: () {},
              ),
              DrawerTile(
                icon: Icons.privacy_tip_rounded,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              DrawerTile(
                icon: Icons.share_rounded,
                title: 'Share App',
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
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}
