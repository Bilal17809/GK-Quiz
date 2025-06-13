import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/common_widgets.dart';

import '../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String subtitle;
  final bool useBackButton;
  final VoidCallback? onBackTap;

  const CustomAppBar({
    super.key,
    required this.subtitle,
    this.useBackButton = true,
    this.actions,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [skyColor, kBlue],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading:
          useBackButton
              ? BackIconButton()
              : Builder(
                builder: (context) {
                  return RoundedButton(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Icon(Icons.menu, color: kWhite, size: 30),
                  );
                },
              ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'GK Quiz',
            style: Get.textTheme.titleMedium?.copyWith(color: kWhite),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              subtitle,
              style: Get.textTheme.bodyLarge?.copyWith(color: kWhite),
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
