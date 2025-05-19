import 'package:flutter/material.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/extension/extension.dart';

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
                child: Image.asset('assets/menu.png', color: kRed),
              );
            },
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GK Quiz',
              style: context.textTheme.titleMedium?.copyWith(color: kRed),
            ),
            Text('Enrich your knowledge', style: context.textTheme.bodyLarge),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset('assets/bell.png', width: 26, height: 26),
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
                decoration: const BoxDecoration(color: Colors.blue),
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
              _buildDrawerTile(
                icon: Icons.favorite_rounded,
                title: 'Bookmarks',
                onTap: () {},
              ),
              _buildDrawerTile(
                icon: Icons.notifications_rounded,
                title: 'Notifications',
                onTap: () {},
              ),
              _buildDrawerTile(
                icon: Icons.settings_rounded,
                title: 'Settings',
                onTap: () {},
              ),
              _buildDrawerTile(
                icon: Icons.star_rounded,
                title: 'Rate Us',
                onTap: () {},
              ),
              _buildDrawerTile(
                icon: Icons.message_rounded,
                title: 'Feedback',
                onTap: () {},
              ),
              _buildDrawerTile(
                icon: Icons.privacy_tip_rounded,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              _buildDrawerTile(
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

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}
