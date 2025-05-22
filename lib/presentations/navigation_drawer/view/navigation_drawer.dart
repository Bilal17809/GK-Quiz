import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/theme/app_colors.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: Builder(
            builder: (context) {
              return RoundedButton(
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                },
                child: Image.asset('assets/images/menu.png', color: kRed),
              );
            },
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz',
              style: Get.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text('Enrich your knowledge', style: Get.textTheme.bodyLarge),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/bell.png',
                width: 26,
                height: 26,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(child: DrawerContent()),
    );
  }
}

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  style: Get.textTheme.headlineLarge?.copyWith(color: kWhite),
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
          DrawerTile(icon: Icons.star_rounded, title: 'Rate Us', onTap: () {}),
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
