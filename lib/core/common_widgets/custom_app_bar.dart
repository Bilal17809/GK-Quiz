import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/common_widgets/round_image.dart';
import '../theme/app_colors.dart';
import 'icon_buttons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String subtitle;
  final bool useBackButton;
  final bool hideTitle;
  final VoidCallback? onBackTap;

  const CustomAppBar({
    super.key,
    required this.subtitle,
    this.useBackButton = true,
    this.hideTitle = true,
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Icon(Icons.menu, color: kWhite, size: 30),
                    ),
                  );
                },
              ),
      title:
          hideTitle
              ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  subtitle,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: kWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'GK Quiz',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: kWhite,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      subtitle,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: kWhite,
                      ),
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
