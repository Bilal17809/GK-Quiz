import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget icon;
  final TextStyle? style;
  final double? width;
  final double? height;

  const IconTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.style,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final mobileHeight = MediaQuery.of(context).size.height;
    final mobileWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        child: SizedBox(
          width: mobileWidth * 1,
          height: mobileHeight * 0.065,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [icon, const SizedBox(width: 8), Text(text)],
          ),
        ),
      ),
    );
  }
}
