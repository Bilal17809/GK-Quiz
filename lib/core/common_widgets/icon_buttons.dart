import 'package:flutter/material.dart';

import '../constant/constant.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class BackIconButton extends StatelessWidget {
  const BackIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Transform.translate(
        offset: const Offset(6, 0),
        child: Padding(
          padding: kAppBarPadding,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kWhite,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.arrow_circle_left_outlined, color: skyColor, size:20),
          ),
        ),
      ),
    );
  }
}


class IconActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  final double size;
  final EdgeInsetsGeometry padding;

  const IconActionButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.color,
    this.size = 24,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const SendButton({super.key, required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLoading ? greyColor.withValues(alpha: 0.3) : kSkyBlueColor,
          shape: BoxShape.circle,
        ),
        child:
            isLoading
                ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(kWhite),
                  ),
                )
                : const Icon(Icons.send, color: kWhite, size: 20),
      ),
    );
  }
}
