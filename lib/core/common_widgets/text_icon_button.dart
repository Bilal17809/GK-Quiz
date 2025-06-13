import 'package:flutter/material.dart';

class TextIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget icon;
  final TextStyle? style;
  final double? width;
  final double? height;
  final Color? color;
  final Color foregroundColor;

  const TextIconButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.style,
    this.width,
    this.height,
    this.color,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          foregroundColor: foregroundColor,
        ),
        onPressed: onPressed,
        child: SizedBox(
          width: width,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [Text(text), const SizedBox(width: 8), icon],
          ),
        ),
      ),
    );
  }
}
