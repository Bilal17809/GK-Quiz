import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/theme/app_colors.dart';

class LongIconTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget icon;
  final TextStyle? style;
  final double? width;
  final double? height;
  final Color? color;
  final Color? iconColor;

  const LongIconTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.style,
    this.width,
    this.height,
    this.color,
    this.iconColor,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              IconTheme(
                data: IconThemeData(color: iconColor ?? kWhite),
                child: icon,
              ),
              const SizedBox(width: 8),
              Text(
                textAlign: TextAlign.center,
                text,
                style:
                    style ?? Get.textTheme.titleMedium?.copyWith(color: kWhite),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
