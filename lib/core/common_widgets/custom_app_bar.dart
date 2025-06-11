import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/round_image.dart';
import 'package:template/core/constant/constant.dart';

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
      leading: Padding(
        padding: kAppBarPadding,
        child:
            useBackButton
                ? RoundedButton(
                  backgroundColor: kRed,
                  onTap: onBackTap ?? () => Get.back(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/back.png', color: kWhite),
                  ),
                )
                : Builder(
                  builder: (context) {
                    return RoundedButton(
                      onTap: () => Scaffold.of(context).openDrawer(),
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
          Text(subtitle, style: Get.textTheme.bodyLarge),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
