import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/theme/app_colors.dart';

class BigIconTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget icon;
  final TextStyle? style;
  final double? width;
  final double? height;
  final Color? color;

  const BigIconTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.style,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: color),
        onPressed: onPressed,
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              icon,
              const SizedBox(height: 8),
              Text(
                textAlign: TextAlign.center,
                text,
                style: Get.textTheme.titleMedium?.copyWith(color: kWhite),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
